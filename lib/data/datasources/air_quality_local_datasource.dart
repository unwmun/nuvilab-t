import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/air_quality.dart';
import '../models/air_quality_hive_models.dart';

@injectable
class AirQualityLocalDataSource {
  static const String _boxName = 'air_quality_box';
  static const String _metadataBoxName = 'air_quality_metadata_box';

  static const Duration cacheValidDuration = Duration(minutes: 10);

  Future<void> saveAirQualityData({
    required String sidoName,
    required AirQualityResponse data,
  }) async {
    final box = await Hive.openBox(_boxName);
    final metadataBox =
        await Hive.openBox<AirQualityCacheMetadata>(_metadataBoxName);

    final cacheKey = _generateCacheKey(sidoName);

    await box.put(cacheKey, jsonEncode(data.toJson()));

    await metadataBox.put(
        cacheKey,
        AirQualityCacheMetadata(
          sidoName: sidoName,
          lastUpdated: DateTime.now(),
          cacheKey: cacheKey,
        ));
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
      final jsonMap = jsonDecode(jsonString);
      return AirQualityResponse.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  bool _isCacheExpired(DateTime lastUpdated) {
    final now = DateTime.now();
    return now.difference(lastUpdated) > cacheValidDuration;
  }

  String _generateCacheKey(String sidoName) {
    return 'air_quality_$sidoName';
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
