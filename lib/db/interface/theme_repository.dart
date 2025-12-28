import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:easywrt/db/models/app_setting_item.dart';

class ThemeRepository {
  final Box<AppSettingItem> _box = Hive.box<AppSettingItem>('app_settings');

  AppSettingItem? getSettings() {
    return _box.get('default');
  }

  Future<void> saveSettings(AppSettingItem settings) async {
    await _box.put('default', settings);
  }

  Future<void> updateThemeMode(ThemeModeEnum mode) async {
    final current = getSettings() ?? AppSettingItem(
      themeMode: ThemeModeEnum.system,
      themeColor: 0xFF4CAF50, // Default Green
      language: 'en',
    );
    
    final newSettings = current.copyWith(themeMode: mode);
    
    await saveSettings(newSettings);
  }

  Future<void> updateLastConnectedRouter(String? routerId) async {
    final current = getSettings() ?? AppSettingItem(
      themeMode: ThemeModeEnum.system,
      themeColor: 0xFF4CAF50,
      language: 'en',
    );

    // Manually construct to allow setting lastConnectedRouterId to null
    final newSettings = AppSettingItem(
      themeMode: current.themeMode,
      themeColor: current.themeColor,
      language: current.language,
      lastConnectedRouterId: routerId,
    );
    // debugPrint('Updating lastConnectedRouterId to: $routerId');

    await saveSettings(newSettings);
  }
}
