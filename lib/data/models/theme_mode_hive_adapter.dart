import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = 3; // 다른 어댑터와 충돌하지 않는 고유한 ID 사용

  @override
  ThemeMode read(BinaryReader reader) {
    final index = reader.readInt();
    return ThemeMode.values[index];
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeInt(obj.index);
  }
}
