import 'package:injectable/injectable.dart';

import '../../core/network/network_info.dart';
import '../../domain/repositories/air_quality_repository.dart';
import '../datasources/air_quality_api.dart';
import '../datasources/air_quality_local_datasource.dart';
import '../models/air_quality.dart';

@Injectable(as: AirQualityRepository)
class AirQualityRepositoryImpl implements AirQualityRepository {
  final AirQualityApi _airQualityApi;
  final AirQualityLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AirQualityRepositoryImpl(
    this._airQualityApi,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<AirQualityResponse> getAirQualityBySido({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
  }) async {
    // 로컬 캐시된 데이터 확인
    final cachedData = await _localDataSource.getAirQualityData(sidoName);

    // 네트워크 연결 확인
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        // 네트워크 연결이 있으면 API 호출
        final remoteData = await _airQualityApi.getCtprvnRltmMesureDnsty(
          sidoName: sidoName,
          pageNo: pageNo,
          numOfRows: numOfRows,
        );

        // 받아온 데이터를 로컬에 저장
        await _localDataSource.saveAirQualityData(
          sidoName: sidoName,
          data: remoteData,
        );

        return remoteData;
      } catch (e) {
        // API 호출 실패 시 캐시된 데이터가 있으면 반환
        if (cachedData != null) {
          return cachedData;
        }
        // 캐시된 데이터도 없으면 예외 발생
        rethrow;
      }
    } else {
      // 네트워크 연결이 없지만 캐시된 데이터가 있으면 반환
      if (cachedData != null) {
        return cachedData;
      }
      // 오프라인이고 캐시된 데이터도 없으면 예외 발생
      throw Exception('네트워크 연결이 없으며 저장된 데이터가 없습니다.');
    }
  }
}
