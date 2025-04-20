import 'package:injectable/injectable.dart';

import '../../core/network/network_info.dart';
import '../../core/utils/logger.dart';
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
    bool forceRefresh = false,
  }) async {
    // 캐시된 데이터 조회
    final cachedData = await _localDataSource.getAirQualityData(sidoName);
    final currentVersion = await _localDataSource.getDataVersion(sidoName);

    // 네트워크 연결 확인
    final isConnected = await _networkInfo.isConnected;

    // 1. 네트워크 연결이 있고, 강제 새로고침이 요청되었거나 캐시가 없는 경우
    if (isConnected && (forceRefresh || cachedData == null)) {
      try {
        AppLogger.debug('API에서 대기질 데이터 요청: $sidoName');
        final remoteData = await _airQualityApi.getCtprvnRltmMesureDnsty(
          sidoName: sidoName,
          pageNo: pageNo,
          numOfRows: numOfRows,
        );

        // 데이터 버전 확인 (첫 번째 아이템의 dataTime을 버전으로 사용)
        String apiDataVersion = '';
        if (remoteData.response.body.items.isNotEmpty) {
          apiDataVersion = remoteData.response.body.items.first.dataTime;
        }

        // 캐시된 데이터가 없거나, API 데이터가 더 최신인 경우에만 저장
        if (cachedData == null ||
            currentVersion == null ||
            currentVersion.isEmpty ||
            apiDataVersion.compareTo(currentVersion) > 0) {
          AppLogger.debug('새로운 데이터 저장: $sidoName, 버전: $apiDataVersion');
          await _localDataSource.saveAirQualityData(
            sidoName: sidoName,
            data: remoteData,
            dataVersion: apiDataVersion,
          );
        } else {
          AppLogger.debug('API 데이터가 캐시보다 최신이 아닙니다. 캐시 유지: $sidoName');
          AppLogger.debug('API 버전: $apiDataVersion, 캐시 버전: $currentVersion');
        }

        return remoteData;
      } catch (e) {
        AppLogger.error('API 요청 오류: $e');
        // API 오류 발생 시 캐시된 데이터가 있으면 반환
        if (cachedData != null) {
          AppLogger.debug('API 오류, 캐시된 데이터 사용: $sidoName');
          return cachedData;
        }
        rethrow;
      }
    }
    // 2. 네트워크 연결이 없지만 캐시된 데이터가 있는 경우
    else if (cachedData != null) {
      AppLogger.debug('오프라인 모드 또는 캐시 사용: $sidoName');
      return cachedData;
    }
    // 3. 네트워크도 없고 캐시도 없는 경우
    else {
      throw Exception('네트워크 연결이 없으며 저장된 데이터가 없습니다.');
    }
  }

  // 캐시와 API 데이터 동기화 명시적 요청 메소드
  Future<bool> syncAirQualityData(String sidoName) async {
    try {
      // 현재 캐시된 데이터의 버전 확인
      final currentVersion = await _localDataSource.getDataVersion(sidoName);

      // API에서 최신 데이터 조회
      final remoteData = await _airQualityApi.getCtprvnRltmMesureDnsty(
        sidoName: sidoName,
      );

      // 데이터 버전 추출
      String apiDataVersion = '';
      if (remoteData.response.body.items.isNotEmpty) {
        apiDataVersion = remoteData.response.body.items.first.dataTime;
      }

      // 캐시 데이터가 없거나 API 데이터가 더 최신인 경우에만 저장
      if (currentVersion == null ||
          currentVersion.isEmpty ||
          apiDataVersion.compareTo(currentVersion) > 0) {
        await _localDataSource.saveAirQualityData(
          sidoName: sidoName,
          data: remoteData,
          dataVersion: apiDataVersion,
        );
        return true; // 동기화 성공 (새 데이터 저장됨)
      }

      return false; // 동기화 필요 없음 (캐시가 이미 최신)
    } catch (e) {
      AppLogger.error('데이터 동기화 오류: $e');
      return false; // 동기화 실패
    }
  }
}
