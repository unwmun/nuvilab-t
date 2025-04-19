// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_quality.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AirQualityCacheMetadataAdapter
    extends TypeAdapter<AirQualityCacheMetadata> {
  @override
  final int typeId = 0;

  @override
  AirQualityCacheMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AirQualityCacheMetadata(
      sidoName: fields[0] as String,
      lastUpdated: fields[1] as DateTime,
      cacheKey: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AirQualityCacheMetadata obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sidoName)
      ..writeByte(1)
      ..write(obj.lastUpdated)
      ..writeByte(2)
      ..write(obj.cacheKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirQualityCacheMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
