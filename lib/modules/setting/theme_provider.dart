import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../db/models/app_setting_item.dart';
import 'theme_repository.dart';

/// themeRepositoryProvider
/// 
/// Function: Provides the ThemeRepository instance.
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepository();
});

/// ThemeNotifier
/// 
/// Function: Manages the application theme state.
/// Inputs: 
///   - [setThemeMode]: Updates the theme mode.
/// Outputs: 
///   - [state]: Current ThemeMode.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeRepository _repository;

  ThemeNotifier(this._repository) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final settings = _repository.getSettings();
    if (settings != null) {
      state = _mapToThemeMode(settings.themeMode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _repository.updateThemeMode(_mapToEnum(mode));
  }

  ThemeMode _mapToThemeMode(ThemeModeEnum mode) {
    switch (mode) {
      case ThemeModeEnum.system: return ThemeMode.system;
      case ThemeModeEnum.light: return ThemeMode.light;
      case ThemeModeEnum.dark: return ThemeMode.dark;
      case ThemeModeEnum.oled: return ThemeMode.dark; // Treat OLED as dark for now
    }
  }

  ThemeModeEnum _mapToEnum(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system: return ThemeModeEnum.system;
      case ThemeMode.light: return ThemeModeEnum.light;
      case ThemeMode.dark: return ThemeModeEnum.dark;
    }
  }
}

/// themeModeProvider
/// 
/// Function: Provides the current ThemeMode state.
final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(themeRepositoryProvider);
  return ThemeNotifier(repository);
});
