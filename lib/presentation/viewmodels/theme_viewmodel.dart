import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/services/theme_service.dart';
import 'package:nubilab/core/di/dependency_injection.dart';

final themeProvider = StateNotifierProvider<ThemeViewModel, ThemeMode>((ref) {
  return ThemeViewModel(getIt<ThemeService>());
});

class ThemeViewModel extends StateNotifier<ThemeMode> {
  final ThemeService _themeService;

  ThemeViewModel(this._themeService) : super(ThemeMode.system) {
    _init();
  }

  Future<void> _init() async {
    await _themeService.init();
    state = _themeService.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _themeService.setThemeMode(themeMode);
    state = themeMode;
  }

  String getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '시스템 설정';
      case ThemeMode.light:
        return '라이트 모드';
      case ThemeMode.dark:
        return '다크 모드';
    }
  }
}
