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
    final cachedData = await _localDataSource.getAirQualityData(sidoName);

    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteData = await _airQualityApi.getCtprvnRltmMesureDnsty(
          sidoName: sidoName,
          pageNo: pageNo,
          numOfRows: numOfRows,
        );

        await _localDataSource.saveAirQualityData(
          sidoName: sidoName,
          data: remoteData,
        );

        return remoteData;
      } catch (e) {
        if (cachedData != null) {
          return cachedData;
        }
        rethrow;
      }
    } else {
      if (cachedData != null) {
        return cachedData;
      }
      throw Exception('네트워크 연결이 없으며 저장된 데이터가 없습니다.');
    }
  }
}
