import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/sido_list.dart';
import '../../core/di/dependency_injection.dart' as di;
import '../../core/network/network_info.dart';
import '../../core/utils/logger.dart';
import '../../data/datasources/air_quality_local_datasource.dart';
import '../../data/models/air_quality.dart';
import '../../domain/usecases/get_air_quality_usecase.dart';

enum ConnectionChangeType {
  online,
  offline,
}

class ConnectionStatusChange {
  final ConnectionChangeType type;
  final String message;

  ConnectionStatusChange({
    required this.type,
    required this.message,
  });
}

class AirQualityState {
  final AsyncValue<AirQualityResponse> airQuality;
  final String selectedSido;
  final DateTime? lastUpdated;
  final bool isRefreshing;
  final bool isOffline;
  final bool isUsingCachedData;
  final ConnectionStatusChange? connectionStatusChange;

  AirQualityState({
    required this.airQuality,
    required this.selectedSido,
    this.lastUpdated,
    this.isRefreshing = false,
    this.isOffline = false,
    this.isUsingCachedData = false,
    this.connectionStatusChange,
  });

  AirQualityState copyWith({
    AsyncValue<AirQualityResponse>? airQuality,
    String? selectedSido,
    DateTime? lastUpdated,
    bool? isRefreshing,
    bool? isOffline,
    bool? isUsingCachedData,
    ConnectionStatusChange? connectionStatusChange,
  }) {
    return AirQualityState(
      airQuality: airQuality ?? this.airQuality,
      selectedSido: selectedSido ?? this.selectedSido,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      connectionStatusChange: connectionStatusChange,
    );
  }

  AirQualityState clearConnectionStatusChange() {
    return copyWith(connectionStatusChange: null);
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
  StreamSubscription? _connectivitySubscription;
  bool _previousConnectionState = true;

  AirQualityViewModel(
    this._getAirQualityUseCase,
    this._localDataSource,
    this._networkInfo,
  ) : super(AirQualityState(
          airQuality: const AsyncValue.loading(),
          selectedSido: SidoList.sidoNames.first,
        )) {
    _checkInitialConnectivity();
    _initializeConnectivityMonitoring();
    _initializeData();
    _startPeriodicUpdate();
    _startLastUpdatedTimer();
  }

  String get selectedSido => state.selectedSido;

  @override
  void dispose() {
    _updateTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  DateTime? get lastUpdated => state.lastUpdated;

  String get lastUpdatedText {
    if (state.lastUpdated == null) return '갱신 중...';

    if (state.isOffline && state.isUsingCachedData) {
      return '오프라인 모드 (캐시 데이터)';
    }

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

  Future<void> _checkInitialConnectivity() async {
    _previousConnectionState = await _networkInfo.isConnected;
    state = state.copyWith(isOffline: !_previousConnectionState);
  }

  void _initializeConnectivityMonitoring() {
    _connectivitySubscription =
        _networkInfo.connectivityStream.listen((isConnected) {
      AppLogger.debug('네트워크 연결 상태 변경: ${isConnected ? "연결됨" : "오프라인"}');

      if (_previousConnectionState != isConnected) {
        _previousConnectionState = isConnected;

        if (isConnected) {
          state = state.copyWith(
            isOffline: false,
            connectionStatusChange: ConnectionStatusChange(
              type: ConnectionChangeType.online,
              message: '네트워크 연결이 복구되었습니다. 최신 데이터를 가져옵니다.',
            ),
          );
          fetchAirQuality(state.selectedSido);
        } else {
          state = state.copyWith(
            isOffline: true,
            connectionStatusChange: ConnectionStatusChange(
              type: ConnectionChangeType.offline,
              message: '네트워크 연결이 끊겼습니다. 저장된 데이터를 사용합니다.',
            ),
          );
        }
      } else {
        state = state.copyWith(isOffline: !isConnected);
      }
    });
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
        lastUpdated:
            await _localDataSource.getLastUpdatedTime(state.selectedSido),
        isRefreshing: true,
      );
    }
  }

  Future<void> _fetchAirQuality() async {
    final isConnected = await _networkInfo.isConnected;
    state = state.copyWith(isOffline: !isConnected);

    if (!isConnected) {
      final localData =
          await _localDataSource.getAirQualityData(state.selectedSido);
      final lastUpdatedTime =
          await _localDataSource.getLastUpdatedTime(state.selectedSido);

      if (localData == null) {
        state = state.copyWith(
          airQuality: AsyncValue.error(
            '네트워크 연결이 없으며 저장된 데이터가 없습니다.\n와이파이나 모바일 데이터 연결을 확인해주세요.',
            StackTrace.current,
          ),
          isRefreshing: false,
          isUsingCachedData: false,
        );
        return;
      } else {
        state = state.copyWith(
          airQuality: AsyncValue.data(localData),
          lastUpdated: lastUpdatedTime,
          isRefreshing: false,
          isUsingCachedData: true,
        );

        AppLogger.info('오프라인 모드: 캐시된 데이터 사용 (${state.selectedSido})');
        return;
      }
    }

    try {
      if (!state.airQuality.hasValue) {
        state = state.copyWith(
          airQuality: const AsyncValue.loading(),
          isUsingCachedData: false,
        );
      } else {
        state = state.copyWith(
          isRefreshing: true,
          isUsingCachedData: false,
        );
      }

      final result = await _getAirQualityUseCase.execute(
          sidoName: state.selectedSido, pageNo: 1, numOfRows: 100);

      state = state.copyWith(
        airQuality: AsyncValue.data(result),
        lastUpdated: DateTime.now(),
        isRefreshing: false,
        isUsingCachedData: false,
      );
    } catch (error, stackTrace) {
      if (state.airQuality.hasValue) {
        state = state.copyWith(isRefreshing: false);
        AppLogger.error('백그라운드 갱신 오류: $error');
      } else {
        final localData =
            await _localDataSource.getAirQualityData(state.selectedSido);
        final lastUpdatedTime =
            await _localDataSource.getLastUpdatedTime(state.selectedSido);

        if (localData != null) {
          AppLogger.info('네트워크 오류 발생, 캐시된 데이터 사용: $error');
          state = state.copyWith(
            airQuality: AsyncValue.data(localData),
            lastUpdated: lastUpdatedTime,
            isRefreshing: false,
            isUsingCachedData: true,
          );
        } else {
          state = state.copyWith(
            airQuality: AsyncValue.error(error, stackTrace),
            isRefreshing: false,
            isUsingCachedData: false,
          );
        }
      }
    }
  }

  void _startPeriodicUpdate() {
    Future.delayed(const Duration(minutes: 10), () async {
      final isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        await _fetchAirQuality();
      }
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

  void consumeConnectionStatusChange() {
    state = state.clearConnectionStatusChange();
  }
}
