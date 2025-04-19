import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/data/models/air_quality_hive_models.dart';

@injectable
class AirQualityLocalDataSource {
  static const String _boxName = 'air_quality_box';
  static const String _metadataBoxName = 'air_quality_metadata_box';

  // 캐시 유효 시간 (10분)
  static const Duration cacheValidDuration = Duration(minutes: 10);

  // 로컬 데이터 저장
  Future<void> saveAirQualityData({
    required String sidoName,
    required AirQualityResponse data,
  }) async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);

    // JSON으로 변환하여 저장 (Freezed 모델 직접 저장 불가)
    await box.put(cacheKey, jsonEncode(data.toJson()));

    // 메타데이터 저장
    await metadataBox.put(
        cacheKey,
        AirQualityCacheMetadata(
          sidoName: sidoName,
          lastUpdated: DateTime.now(),
          cacheKey: cacheKey,
        ));
  }

  // 로컬 데이터 조회
  Future<AirQualityResponse?> getAirQualityData(String sidoName) async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);
    final jsonString = box.get(cacheKey);

    if (jsonString == null) {
      return null;
    }

    // 캐시 유효성 검사
    final metadata = metadataBox.get(cacheKey);
    if (metadata == null || _isCacheExpired(metadata.lastUpdated)) {
      return null;
    }

    try {
      final jsonMap = jsonDecode(jsonString);
      return AirQualityResponse.fromJson(jsonMap);
    } catch (e) {
      // 잘못된 JSON 형식이거나 파싱 오류 발생 시 null 반환
      return null;
    }
  }

  // 캐시 만료 확인
  bool _isCacheExpired(DateTime lastUpdated) {
    final now = DateTime.now();
    return now.difference(lastUpdated) > cacheValidDuration;
  }

  // 캐시 키 생성
  String _generateCacheKey(String sidoName) {
    return 'air_quality_$sidoName';
  }

  // 특정 지역 데이터 삭제
  Future<void> deleteAirQualityData(String sidoName) async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);

    await box.delete(cacheKey);
    await metadataBox.delete(cacheKey);
  }

  // 모든 캐시 데이터 삭제
  Future<void> clearAllCache() async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    await box.clear();
    await metadataBox.clear();
  }

  // 캐시 유효성 확인
  Future<bool> isAirQualityDataCached(String sidoName) async {
    final box = await Hive.openBox(_boxName);
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
