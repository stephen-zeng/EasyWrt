import 'package:hive/hive.dart';
import '../../db/models/app_setting_item.dart';

/// ThemeRepository
/// ThemeRepository
/// 
/// Function: Handles persistence of theme settings using Hive.
/// Function: 使用 Hive 处理主题设置的持久化。
/// Inputs: 
/// Inputs: 
///   - [saveSettings]: AppSettingItem to save.
///   - [saveSettings]: 要保存的 AppSettingItem。
///   - [updateThemeMode]: New ThemeModeEnum to persist.
///   - [updateThemeMode]: 要持久化的新 ThemeModeEnum。
/// Outputs: 
/// Outputs: 
///   - [getSettings]: Returns persisted AppSettingItem or null.
///   - [getSettings]: 返回持久化的 AppSettingItem 或 null。
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
    
    final newSettings = AppSettingItem(
      themeMode: mode,
      themeColor: current.themeColor,
      language: current.language,
    );
    
    await saveSettings(newSettings);
  }

  Future<void> updateLastConnectedRouter(String? routerId) async {
    final current = getSettings() ?? AppSettingItem(
      themeMode: ThemeModeEnum.system,
      themeColor: 0xFF4CAF50,
      language: 'en',
    );

    final newSettings = AppSettingItem(
      themeMode: current.themeMode,
      themeColor: current.themeColor,
      language: current.language,
      lastConnectedRouterId: routerId,
    );

    await saveSettings(newSettings);
  }
}
