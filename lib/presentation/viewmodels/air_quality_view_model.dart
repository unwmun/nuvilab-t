import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';

final airQualityViewModelProvider =
    StateNotifierProvider<AirQualityViewModel, AsyncValue<AirQualityResponse>>(
        (ref) {
  final getAirQualityUseCase = ref.read(getAirQualityUseCaseProvider);
  return AirQualityViewModel(getAirQualityUseCase);
});

// 저장소 프로바이더는 실제 의존성 주입 설정에서 제공되어야 합니다.
final airQualityRepositoryProvider =
    Provider((ref) => throw UnimplementedError());

class AirQualityViewModel
    extends StateNotifier<AsyncValue<AirQualityResponse>> {
  final GetAirQualityUseCase _getAirQualityUseCase;

  AirQualityViewModel(this._getAirQualityUseCase)
      : super(const AsyncValue.loading()) {
    fetchAirQuality('서울');
  }

  Future<void> fetchAirQuality(String sidoName) async {
    state = const AsyncValue.loading();
    try {
      final result = await _getAirQualityUseCase.execute(sidoName: sidoName);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
