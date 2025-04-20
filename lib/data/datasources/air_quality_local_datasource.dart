import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/air_quality.dart';
import '../models/air_quality_hive_models.dart';
import '../../core/utils/logger.dart';

@injectable
class AirQualityLocalDataSource {
  static const String _boxName = 'air_quality_box';
  static const String _metadataBoxName = 'air_quality_metadata_box';

  static const Duration cacheValidDuration = Duration(minutes: 10);

  Future<void> saveAirQualityData({
    required String sidoName,
    required AirQualityResponse data,
    String? dataVersion,
  }) async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);
    final currentMetadata = metadataBox.get(cacheKey);
    final timestamp = DateTime.now();

    // 데이터 버전 계산 (dataTime 필드를 활용)
    String calculatedVersion = '';
    if (data.response.body.items.isNotEmpty) {
      calculatedVersion = data.response.body.items.first.dataTime;
    }

    final versionToSave = dataVersion ?? calculatedVersion;

    // 이미 저장된 데이터가 있고, 저장하려는 데이터가 더 최신이 아니라면 덮어쓰지 않음
    if (currentMetadata != null &&
        currentMetadata.dataVersion.isNotEmpty &&
        versionToSave.isNotEmpty &&
        currentMetadata.dataVersion.compareTo(versionToSave) >= 0) {
      AppLogger.debug('이미 더 최신 버전의 데이터가 저장되어 있습니다. 덮어쓰기 취소: $sidoName');
      AppLogger.debug(
          '기존 버전: ${currentMetadata.dataVersion}, 새 버전: $versionToSave');
      return;
    }

    // 데이터 저장 시 트랜잭션 처리
    try {
      // 원본 데이터를 JSON 문자열로 변환하여 저장
      final jsonString = jsonEncode(data.toJson());
      await box.put(cacheKey, jsonString);

      // 메타데이터 업데이트
      await metadataBox.put(
          cacheKey,
          AirQualityCacheMetadata(
            sidoName: sidoName,
            lastUpdated: timestamp,
            cacheKey: cacheKey,
            dataVersion: versionToSave,
            dataHash: _calculateDataHash(jsonString),
          ));

      AppLogger.debug('데이터 저장 완료: $sidoName, 버전: $versionToSave');
    } catch (e) {
      AppLogger.error('데이터 저장 실패: $e');
      // 저장 실패 시 롤백 - 기존 데이터 유지
      if (currentMetadata != null) {
        await metadataBox.put(cacheKey, currentMetadata);
      } else {
        await box.delete(cacheKey);
        await metadataBox.delete(cacheKey);
      }
      throw Exception('로컬 데이터 저장 중 오류가 발생했습니다: $e');
    }
  }

  Future<AirQualityResponse?> getAirQualityData(String sidoName) async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);
    final jsonString = box.get(cacheKey);

    if (jsonString == null) {
      return null;
    }

    final metadata = metadataBox.get(cacheKey);
    if (metadata == null || _isCacheExpired(metadata.lastUpdated)) {
      return null;
    }

    try {
      // 데이터 무결성 검증
      if (metadata.dataHash.isNotEmpty &&
          metadata.dataHash != _calculateDataHash(jsonString)) {
        AppLogger.error('데이터 해시 불일치: $sidoName');
        return null;
      }

      final jsonMap = jsonDecode(jsonString);
      return AirQualityResponse.fromJson(jsonMap);
    } catch (e) {
      AppLogger.error('캐시 데이터 파싱 오류: $e');
      // 손상된 데이터 정리
      await deleteAirQualityData(sidoName);
      return null;
    }
  }

  Future<DateTime?> getLastUpdatedTime(String sidoName) async {
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);
    final metadata = metadataBox.get(cacheKey);

    return metadata?.lastUpdated;
  }

  // 캐시된 데이터의 버전 조회
  Future<String?> getDataVersion(String sidoName) async {
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);
    final metadata = metadataBox.get(cacheKey);

    return metadata?.dataVersion;
  }

  bool _isCacheExpired(DateTime lastUpdated) {
    final now = DateTime.now();
    return now.difference(lastUpdated) > cacheValidDuration;
  }

  String _generateCacheKey(String sidoName) {
    return 'air_quality_$sidoName';
  }

  // 데이터 해시 계산
  String _calculateDataHash(String jsonString) {
    // 간단한 체크섬으로 데이터 무결성 확인
    int hash = 0;
    for (int i = 0; i < jsonString.length; i++) {
      hash = (hash + jsonString.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash.toString();
  }

  Future<void> deleteAirQualityData(String sidoName) async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);

    await box.delete(cacheKey);
    await metadataBox.delete(cacheKey);
  }

  Future<void> clearAllCache() async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    await box.clear();
    await metadataBox.clear();
  }

  Future<bool> isAirQualityDataCached(String sidoName) async {
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);
    final metadata = metadataBox.get(cacheKey);

    if (metadata == null) {
      return false;
    }

    return !_isCacheExpired(metadata.lastUpdated);
  }
}
