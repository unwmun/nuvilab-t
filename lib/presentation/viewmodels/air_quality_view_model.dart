import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';
import 'dart:async';

final airQualityViewModelProvider =
    StateNotifierProvider<AirQualityViewModel, AsyncValue<AirQualityResponse>>(
        (ref) => AirQualityViewModel(ref.watch(getAirQualityUseCaseProvider)));

// 저장소 프로바이더는 실제 의존성 주입 설정에서 제공되어야 합니다.
final airQualityRepositoryProvider =
    Provider((ref) => throw UnimplementedError());

class AirQualityViewModel
    extends StateNotifier<AsyncValue<AirQualityResponse>> {
  final GetAirQualityUseCase _getAirQualityUseCase;
  DateTime? _lastUpdated;
  Timer? _updateTimer;
  String _selectedSidoName = '서울';

  AirQualityViewModel(this._getAirQualityUseCase)
      : super(const AsyncValue.loading()) {
    _fetchAirQuality();
    _startPeriodicUpdate();
    _startLastUpdatedTimer();
  }

  String get selectedSidoName => _selectedSidoName;

  void setSelectedSidoName(String sidoName) {
    _selectedSidoName = sidoName;
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  DateTime? get lastUpdated => _lastUpdated;

  String get lastUpdatedText {
    if (_lastUpdated == null) return '갱신 중...';

    final now = DateTime.now();
    final difference = now.difference(_lastUpdated!);

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
      if (state.hasValue) {
        state = AsyncValue.data(state.value!);
      }
    });
  }

  Future<void> _fetchAirQuality() async {
    try {
      state = const AsyncValue.loading();
      final result =
          await _getAirQualityUseCase.execute(sidoName: _selectedSidoName);
      state = AsyncValue.data(result);
      _lastUpdated = DateTime.now();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void _startPeriodicUpdate() {
    Future.delayed(const Duration(minutes: 10), () {
      _fetchAirQuality();
      _startPeriodicUpdate();
    });
  }

  Future<void> fetchAirQuality(String sidoName) async {
    _selectedSidoName = sidoName;
    await _fetchAirQuality();
  }
}
