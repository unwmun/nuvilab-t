// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_retry_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiRetryTaskAdapter extends TypeAdapter<ApiRetryTask> {
  @override
  final int typeId = 1;

  @override
  ApiRetryTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiRetryTask(
      id: fields[0] as String,
      endpoint: fields[1] as String,
      parameters: (fields[2] as Map).cast<String, dynamic>(),
      createdAt: fields[3] as DateTime,
      retryCount: fields[4] as int,
      taskType: fields[5] as String,
      nextRetryTime: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ApiRetryTask obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.endpoint)
      ..writeByte(2)
      ..write(obj.parameters)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.retryCount)
      ..writeByte(5)
      ..write(obj.taskType)
      ..writeByte(6)
      ..write(obj.nextRetryTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiRetryTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
