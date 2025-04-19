import 'package:hive/hive.dart';

part 'air_quality_hive_models.g.dart';

@HiveType(typeId: 0)
class AirQualityCacheMetadata {
  @HiveField(0)
  final String sidoName;

  @HiveField(1)
  final DateTime lastUpdated;

  @HiveField(2)
  final String cacheKey;

  AirQualityCacheMetadata({
    required this.sidoName,
    required this.lastUpdated,
    required this.cacheKey,
  });
}
