import 'package:hive/hive.dart';
import 'package:easywrt/database/storage.dart';
import '../config/setting.dart';

part 'app.g.dart';

@HiveType(typeId: HiveDB.appBoxTypeId)
class App {
  @HiveField(0)
  AppSecurity appSecurity;
  @HiveField(1)
  AppPreferences appPreferences;
  App({
    AppSecurity? appSecurity,
    AppPreferences? appPreferences,
  })  : appSecurity = appSecurity ?? AppSecurity(),
        appPreferences = appPreferences ?? AppPreferences();
}

@HiveType(typeId: HiveDB.appBoxTypeId + 1)
class AppSecurity {
  @HiveField(0)
  bool securityEnabled;
  @HiveField(1)
  String PINHash;
  @HiveField(2)
  bool biometricsEnabled;
  @HiveField(3)
  String PasskeyHash;
  AppSecurity({
    this.securityEnabled = false,
    this.PINHash = '',
    this.biometricsEnabled = false,
    this.PasskeyHash = '',
  });
}

@HiveType(typeId: HiveDB.appBoxTypeId + 2)
class AppPreferences {
  @HiveField(0)
  int darkMode;
  @HiveField(1)
  String color;
  AppPreferences({
    this.darkMode = AppDBCode.darkModeSystem,
    this.color = 'green', // Refers to AppColor default
  });
}