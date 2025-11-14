import 'package:easywrt/database/storage.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import '../model/app.dart';

class AppController {
  static final Box<App> appBox = HiveDB.apps;

  @observable
  static App? app;

  static void init() {
    app = appBox.get('default');
    if (app == null) {
      app = App();
      appBox.put('default', app!);
    }
  }

  static void updateAppSecurity(AppSecurity appSecurity) {
    if (app != null) {
      app = App(
        appSecurity: appSecurity,
        appPreferences: app!.appPreferences,
      );
      appBox.put('default', app!);
    }
  }

  static void updateAppPreferences(AppPreferences appPreferences) {
    if (app != null) {
      app = App(
        appSecurity: app!.appSecurity,
        appPreferences: appPreferences,
      );
      appBox.put('default', app!);
    }
  }

  static void updateAppStatus(AppStatus appStatus) {
    if (app != null) {
      app = App(
        appSecurity: app!.appSecurity,
        appPreferences: app!.appPreferences,
        appStatus: appStatus,
      );
      appBox.put('default', app!);
    }
  }

  static AppSecurity getAppSecurity() {
    return app?.appSecurity ?? AppSecurity();
  }

  static AppPreferences getAppPreferences() {
    return app?.appPreferences ?? AppPreferences();
  }

  static AppStatus getAppStatus() {
    return app?.appStatus ?? AppStatus();
  }
}