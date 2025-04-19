import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/constants/app_constants.dart';

@lazySingleton
class ThemeService {
  late Box<ThemeMode> _themeBox;

  Future<void> init() async {
    if (!Hive.isBoxOpen(AppConstants.settingsBoxName)) {
      _themeBox = await Hive.openBox<ThemeMode>(AppConstants.settingsBoxName);
    } else {
      _themeBox = Hive.box<ThemeMode>(AppConstants.settingsBoxName);
    }
  }

  ThemeMode getThemeMode() {
    final themeMode = _themeBox.get(AppConstants.themeSettingsKey);
    return themeMode ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _themeBox.put(AppConstants.themeSettingsKey, themeMode);
  }
}
