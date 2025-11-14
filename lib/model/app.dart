import 'package:easywrt/bean/theme/color.dart';
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
  @HiveField(2)
  AppStatus appStatus;
  App({
    AppSecurity? appSecurity,
    AppPreferences? appPreferences,
    AppStatus? appStatus,
  })  : appSecurity = appSecurity ?? AppSecurity(),
        appPreferences = appPreferences ?? AppPreferences(),
        appStatus = appStatus ?? AppStatus();
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
  int color;
  @HiveField(2)
  int exitBehavior;
  @HiveField(3)
  bool oledEnabled;
  @HiveField(4)
  bool showWindowButtons;
  @HiveField(5)
  bool useDynamicColor;
  AppPreferences({
    this.darkMode = AppDBCode.themeModeSystem,
    this.color = defaultColorCode, // Refers to AppColor default
    this.exitBehavior = AppDBCode.exitBehaviorAsk,
    this.oledEnabled = false,
    this.showWindowButtons = true,
    this.useDynamicColor = false,
  });
}

@HiveType(typeId: HiveDB.appBoxTypeId + 3)
class AppStatus {
  @HiveField(0)
  String deviceID;
  AppStatus({
    this.deviceID = '',
  });
}