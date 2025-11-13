import 'package:easywrt/database/app.dart';
import 'package:easywrt/database/device.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../model/app.dart';
import '../model/custom.dart';
import '../model/device.dart';

class HiveDB {
  static const int deviceBoxTypeId = 0;
  static const int appBoxTypeId = 10;
  static const int customBoxTypeId = 20;

  static late Box<App> apps; // feature for multi users
  static late Box<Device> devices;

  static Future init() async {
    Hive.registerAdapter(DeviceAdapter());
    Hive.registerAdapter(AppAdapter());
    Hive.registerAdapter(AppSecurityAdapter());
    Hive.registerAdapter(AppPreferencesAdapter());
    Hive.registerAdapter(MiddlewareAdapter());
    Hive.registerAdapter(PageAdapter());
    apps = await Hive.openBox<App>('apps');
    devices = await Hive.openBox<Device>('devices');

    AppController.init();
  }
}