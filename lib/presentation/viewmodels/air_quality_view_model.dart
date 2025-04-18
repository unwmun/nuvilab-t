import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/constants/sido_list.dart';
import 'package:nubilab/core/di/dependency_injection.dart' as di;
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';

class AirQualityState {
  final AsyncValue<AirQualityResponse> airQuality;
  final String selectedSido;
  final DateTime? lastUpdated;

  AirQualityState({
    required this.airQuality,
    required this.selectedSido,
    this.lastUpdated,
  });

  AirQualityState copyWith({
    AsyncValue<AirQualityResponse>? airQuality,
    String? selectedSido,
    DateTime? lastUpdated,
  }) {
    return AirQualityState(
      airQuality: airQuality ?? this.airQuality,
      selectedSido: selectedSido ?? this.selectedSido,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

final airQualityViewModelProvider =
    StateNotifierProvider<AirQualityViewModel, AirQualityState>((ref) =>
        AirQualityViewModel(ref.watch(di.getAirQualityUseCaseProvider)));

// 저장소 프로바이더는 실제 의존성 주입 설정에서 제공되어야 합니다.
final airQualityRepositoryProvider =
    Provider((ref) => throw UnimplementedError());

class AirQualityViewModel extends StateNotifier<AirQualityState> {
  final GetAirQualityUseCase _getAirQualityUseCase;
  Timer? _updateTimer;

  AirQualityViewModel(this._getAirQualityUseCase)
      : super(AirQualityState(
          airQuality: const AsyncValue.loading(),
          selectedSido: SidoList.sidoNames.first,
        )) {
    _fetchAirQuality();
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

  Future<void> _fetchAirQuality() async {
    try {
      state = state.copyWith(airQuality: const AsyncValue.loading());
      final result =
          await _getAirQualityUseCase.execute(sidoName: state.selectedSido);
      state = state.copyWith(
        airQuality: AsyncValue.data(result),
        lastUpdated: DateTime.now(),
      );
    } catch (error, stackTrace) {
      state = state.copyWith(
        airQuality: AsyncValue.error(error, stackTrace),
      );
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
      await _fetchAirQuality();
    }
  }
}
