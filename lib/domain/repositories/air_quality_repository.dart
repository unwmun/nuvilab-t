import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/data/models/air_quality.dart';

abstract class AirQualityRepository {
  Future<AirQualityResponse> getAirQualityBySido({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
  });
}

final airQualityRepositoryProvider = Provider<AirQualityRepository>((ref) {
  throw UnimplementedError('AirQualityRepository는 의존성 주입을 통해 제공되어야 합니다.');
});
