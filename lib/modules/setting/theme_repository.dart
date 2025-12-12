import 'package:hive/hive.dart';
import '../../db/models/app_setting_item.dart';

/// ThemeRepository
/// 
/// Function: Handles persistence of theme settings using Hive.
/// Inputs: 
///   - [saveSettings]: AppSettingItem to save.
///   - [updateThemeMode]: New ThemeModeEnum to persist.
/// Outputs: 
///   - [getSettings]: Returns persisted AppSettingItem or null.
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
}
