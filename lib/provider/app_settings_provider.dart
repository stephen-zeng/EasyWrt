import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:easywrt/model/app_settings.dart';
import 'package:easywrt/database/storage.dart'; // Assuming HiveDB handles AppSettings box

class AppSettingsProvider extends ChangeNotifier {
  late Box<AppSettings> _appSettingsBox;
  late AppSettings _settings;

  AppSettings get settings => _settings;

  AppSettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    // Assuming HiveDB.init() registers the adapter and opens the box
    // Need to open a specific box for AppSettings if HiveDB doesn't manage it globally
    _appSettingsBox = await Hive.openBox<AppSettings>('appSettingsBox'); // Use a dedicated box name

    if (_appSettingsBox.isEmpty) {
      _settings = AppSettings();
      await _appSettingsBox.add(_settings); // Add initial settings
    } else {
      _settings = _appSettingsBox.getAt(0)!; // Retrieve the single settings object
    }
    notifyListeners();
  }

  void setBioAuthEnabled(bool value) {
    _settings.bioAuthEnabled = value;
    _settings.save(); // Persist change to Hive
    notifyListeners();
  }

  void setMcpEnabled(bool value) {
    _settings.mcpEnabled = value;
    _settings.save();
    notifyListeners();
  }

  void setMcpPort(int value) {
    _settings.mcpPort = value;
    _settings.save();
    notifyListeners();
  }
}
