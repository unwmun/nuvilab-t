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

  @HiveField(3)
  final String dataVersion;

  @HiveField(4)
  final String dataHash;

  AirQualityCacheMetadata({
    required this.sidoName,
    required this.lastUpdated,
    required this.cacheKey,
    this.dataVersion = '',
    this.dataHash = '',
  });
}
