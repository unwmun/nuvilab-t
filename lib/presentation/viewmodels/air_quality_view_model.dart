import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/constants/sido_list.dart';
import 'package:nubilab/core/di/dependency_injection.dart' as di;
import 'package:nubilab/core/network/network_info.dart';
import 'package:nubilab/data/datasources/air_quality_local_datasource.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';

class AirQualityState {
  final AsyncValue<AirQualityResponse> airQuality;
  final String selectedSido;
  final DateTime? lastUpdated;
  final bool isRefreshing; // 백그라운드에서 새로고침 중인지 여부

  AirQualityState({
    required this.airQuality,
    required this.selectedSido,
    this.lastUpdated,
    this.isRefreshing = false,
  });

  AirQualityState copyWith({
    AsyncValue<AirQualityResponse>? airQuality,
    String? selectedSido,
    DateTime? lastUpdated,
    bool? isRefreshing,
  }) {
    return AirQualityState(
      airQuality: airQuality ?? this.airQuality,
      selectedSido: selectedSido ?? this.selectedSido,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

final airQualityViewModelProvider =
    StateNotifierProvider<AirQualityViewModel, AirQualityState>((ref) {
  return AirQualityViewModel(
    ref.watch(di.getAirQualityUseCaseProvider),
    ref.watch(di.airQualityLocalDataSourceProvider),
    ref.watch(di.networkInfoProvider),
  );
});

class AirQualityViewModel extends StateNotifier<AirQualityState> {
  final GetAirQualityUseCase _getAirQualityUseCase;
  final AirQualityLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  Timer? _updateTimer;

  AirQualityViewModel(
    this._getAirQualityUseCase,
    this._localDataSource,
    this._networkInfo,
  ) : super(AirQualityState(
          airQuality: const AsyncValue.loading(),
          selectedSido: SidoList.sidoNames.first,
        )) {
    _initializeData();
    _startPeriodicUpdate();
    _startLastUpdatedTimer();
  }

  String get selectedSido => state.selectedSido;

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  DateTime? get lastUpdated => state.lastUpdated;

  String get lastUpdatedText {
    if (state.lastUpdated == null) return '갱신 중...';

    final now = DateTime.now();
    final difference = now.difference(state.lastUpdated!);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else {
      return '${difference.inHours}시간 전';
    }
  }

  void _startLastUpdatedTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (state.airQuality.hasValue) {
        state = state.copyWith(
          airQuality: AsyncValue.data(state.airQuality.value!),
        );
      }
    });
  }

  // 초기 데이터 로드 로직
  Future<void> _initializeData() async {
    // 먼저 로컬 데이터를 확인하고 로드
    await _loadLocalData();

    // API에서 최신 데이터 가져오기 (백그라운드에서 업데이트)
    fetchAirQuality(state.selectedSido);
  }

  // 로컬 데이터 로드
  Future<void> _loadLocalData() async {
    final cachedData =
        await _localDataSource.getAirQualityData(state.selectedSido);

    if (cachedData != null) {
      // 캐시된 데이터가 있으면 즉시 표시
      state = state.copyWith(
        airQuality: AsyncValue.data(cachedData),
        lastUpdated: DateTime.now(),
        isRefreshing: true, // 로컬 데이터가 있어도 백그라운드에서 새로고침 진행
      );
    }
  }

  // API에서 데이터 가져오기
  Future<void> _fetchAirQuality() async {
    // 네트워크 연결 확인
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      // 네트워크 연결이 없는 경우 로컬 데이터 로드
      await _loadLocalData();

      // 로컬 데이터가 없으면 오류 표시
      if (!state.airQuality.hasValue) {
        state = state.copyWith(
          airQuality: AsyncValue.error(
            '네트워크 연결이 없으며 저장된 데이터가 없습니다.',
            StackTrace.current,
          ),
          isRefreshing: false,
        );
      }
      return;
    }

    try {
      // 아직 로딩 중이거나 오류 상태면 로딩 상태로 변경
      if (!state.airQuality.hasValue) {
        state = state.copyWith(airQuality: const AsyncValue.loading());
      } else {
        // 이미 데이터가 있으면 백그라운드 새로고침 시작 표시
        state = state.copyWith(isRefreshing: true);
      }

      // API에서 데이터 가져오기
      final result =
          await _getAirQualityUseCase.execute(sidoName: state.selectedSido);

      // 상태 업데이트
      state = state.copyWith(
        airQuality: AsyncValue.data(result),
        lastUpdated: DateTime.now(),
        isRefreshing: false,
      );
    } catch (error, stackTrace) {
      // 이미 로드된 데이터가 있으면 그대로 유지하고 조용히 오류 처리
      if (state.airQuality.hasValue) {
        state = state.copyWith(isRefreshing: false);
        // 오류 로깅 등 추가 작업
        print('백그라운드 갱신 오류: $error');
      } else {
        // 표시할 데이터가 없으면 오류 상태로 변경
        state = state.copyWith(
          airQuality: AsyncValue.error(error, stackTrace),
          isRefreshing: false,
        );
      }
    }
  }

  void _startPeriodicUpdate() {
    Future.delayed(const Duration(minutes: 10), () {
      _fetchAirQuality();
      _startPeriodicUpdate();
    });
  }

  Future<void> fetchAirQuality(String sidoName) async {
    if (state.selectedSido != sidoName) {
      // 지역이 변경된 경우 로컬 데이터를 먼저 로드
      state = state.copyWith(selectedSido: sidoName);
      await _loadLocalData();
    }

    // API에서 데이터 가져오기
    await _fetchAirQuality();
  }

  // 시도 이름만 업데이트하는 메서드 (데이터 로드 없음)
  void updateSido(String sidoName) {
    if (state.selectedSido != sidoName) {
      state = state.copyWith(selectedSido: sidoName);
    }
  }
}
