import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/data/repositories/air_quality_repository_impl.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider((ref) => Dio());

final airQualityApiProvider =
    Provider((ref) => AirQualityApi(ref.watch(dioProvider)));

final airQualityRepositoryProvider = Provider(
    (ref) => AirQualityRepositoryImpl(ref.watch(airQualityApiProvider)));

final getAirQualityUseCaseProvider = Provider(
    (ref) => GetAirQualityUseCase(ref.watch(airQualityRepositoryProvider)));

final airQualityViewModelProvider =
    StateNotifierProvider<AirQualityViewModel, AsyncValue<AirQualityResponse>>(
  (ref) => AirQualityViewModel(ref.watch(getAirQualityUseCaseProvider)),
);

class AirQualityViewModel
    extends StateNotifier<AsyncValue<AirQualityResponse>> {
  final GetAirQualityUseCase _getAirQualityUseCase;
  DateTime? _lastUpdated;

  AirQualityViewModel(this._getAirQualityUseCase)
      : super(const AsyncValue.loading()) {
    _fetchAirQuality();
    _startPeriodicUpdate();
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

  Future<void> _fetchAirQuality() async {
    try {
      state = const AsyncValue.loading();
      final result = await _getAirQualityUseCase.execute(sidoName: '서울');
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

  Future<void> refresh() async {
    await _fetchAirQuality();
  }
}
