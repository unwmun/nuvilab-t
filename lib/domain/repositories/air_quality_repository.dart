import '../../data/models/air_quality.dart';

abstract class AirQualityRepository {
  Future<AirQualityResponse> getAirQualityBySido({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
    bool forceRefresh = false,
  });

  // 데이터 명시적 동기화 메소드
  Future<bool> syncAirQualityData(String sidoName);
}
