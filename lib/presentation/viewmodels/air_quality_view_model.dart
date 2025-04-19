import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/sido_list.dart';
import '../../core/di/dependency_injection.dart' as di;
import '../../core/network/network_info.dart';
import '../../core/utils/logger.dart';
import '../../data/datasources/air_quality_local_datasource.dart';
import '../../data/models/air_quality.dart';
import '../../domain/usecases/get_air_quality_usecase.dart';

class AirQualityState {
  final AsyncValue<AirQualityResponse> airQuality;
  final String selectedSido;
  final DateTime? lastUpdated;
  final bool isRefreshing;

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

  Future<void> _initializeData() async {
    await _loadLocalData();
    await fetchAirQuality(state.selectedSido);
  }

  Future<void> _loadLocalData() async {
    final cachedData =
        await _localDataSource.getAirQualityData(state.selectedSido);

    if (cachedData != null) {
      state = state.copyWith(
        airQuality: AsyncValue.data(cachedData),
        lastUpdated: DateTime.now(),
        isRefreshing: true,
      );
    }
  }

  Future<void> _fetchAirQuality() async {
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      final localData =
          await _localDataSource.getAirQualityData(state.selectedSido);

      if (localData == null) {
        state = state.copyWith(
          airQuality: AsyncValue.error(
            '네트워크 연결이 없으며 저장된 데이터가 없습니다.',
            StackTrace.current,
          ),
          isRefreshing: false,
        );
        return;
      } else {
        state = state.copyWith(
          airQuality: AsyncValue.data(localData),
          lastUpdated: DateTime.now(),
          isRefreshing: false,
        );
        return;
      }
    }

    try {
      if (!state.airQuality.hasValue) {
        state = state.copyWith(airQuality: const AsyncValue.loading());
      } else {
        state = state.copyWith(isRefreshing: true);
      }

      final result = await _getAirQualityUseCase.execute(
          sidoName: state.selectedSido, pageNo: 1, numOfRows: 100);

      state = state.copyWith(
        airQuality: AsyncValue.data(result),
        lastUpdated: DateTime.now(),
        isRefreshing: false,
      );
    } catch (error, stackTrace) {
      if (state.airQuality.hasValue) {
        state = state.copyWith(isRefreshing: false);
        AppLogger.error('백그라운드 갱신 오류: $error');
      } else {
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
      state = state.copyWith(selectedSido: sidoName);
      await _loadLocalData();
    }

    await _fetchAirQuality();
  }

  void updateSido(String sidoName) {
    if (state.selectedSido != sidoName) {
      state = state.copyWith(selectedSido: sidoName);
    }
  }
}
