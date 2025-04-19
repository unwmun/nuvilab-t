import 'package:nubilab/data/models/air_quality.dart';

abstract class AirQualityRepository {
  Future<AirQualityResponse> getAirQualityBySido({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
  });
}
