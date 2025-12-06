import 'package:easywrt/database/app.dart';
import 'package:easywrt/database/device.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/app.dart';
import '../model/device_profile.dart'; // Using DeviceProfile
import '../model/app_settings.dart'; // New import for AppSettings

class HiveDB {
  static const int deviceBoxTypeId = 1; // Updated to match DeviceProfile's typeId
  static const int appBoxTypeId = 10;
  static const int customBoxTypeId = 20;
  static const int appSettingsBoxTypeId = 2; // Matching AppSettings typeId

  static late Box<App> apps; // feature for multi users
  static late Box<DeviceProfile> devices; // Changed to DeviceProfile
  static late Box<AppSettings> appSettings; // New AppSettings box

  static Future init() async {
    // Register all adapters
    Hive.registerAdapter(DeviceProfileAdapter());
    Hive.registerAdapter(AppAdapter());
    Hive.registerAdapter(AppSecurityAdapter());
    Hive.registerAdapter(AppPreferencesAdapter());
    Hive.registerAdapter(AppStatusAdapter()); // Register AppStatusAdapter
    Hive.registerAdapter(AppSettingsAdapter()); // Register AppSettingsAdapter

    // Open all boxes
    apps = await Hive.openBox<App>('apps');
    devices = await Hive.openBox<DeviceProfile>('devices');
    appSettings = await Hive.openBox<AppSettings>('appSettingsBox'); // Open AppSettings box

    AppController.init();
  }
}