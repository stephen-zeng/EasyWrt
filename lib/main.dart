import 'dart:io';

import 'package:easywrt/bean/setting/theme.dart';
import 'package:easywrt/database/storage.dart';
import 'package:easywrt/error/storage.dart';
import 'package:easywrt/utils/utils.dart';
import 'package:easywrt/base/widget.dart';
import 'package:easywrt/utils/wrt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'database/app.dart';
import 'app_module.dart';
import 'provider/app_settings_provider.dart';
import 'provider/device_provider.dart';
import 'services/auth/bio_auth_service.dart';
import 'model/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint((await getApplicationSupportDirectory()).path);

  try {
    await Hive.initFlutter('${(await getApplicationSupportDirectory()).path}/hive');
    await HiveDB.init(); // HiveDB.init now registers all adapters and opens boxes
  } catch(_) {
    runApp(storageErrorApp());
    return;
  }

  // Access AppSettings directly from Hive for early bio-auth check
  final AppSettings initialAppSettings = HiveDB.appSettings.isEmpty
      ? AppSettings()
      : HiveDB.appSettings.getAt(0)!;
  if (HiveDB.appSettings.isEmpty) {
    await HiveDB.appSettings.add(initialAppSettings);
  }

  // Bio-Authentication Check
  if (initialAppSettings.bioAuthEnabled) {
    final BioAuthService bioAuthService = BioAuthService();
    bool authenticated = await bioAuthService.authenticate(
      localizedReason: 'Authenticate to access EasyWRT',
    );
    if (!authenticated) {
      exit(0); // Exit app if authentication fails
    }
  }

  final appPreferences = AppController.getAppPreferences();
  if (Utils.isDesktop()) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: const Size(1280, 860),
      center: true,
      skipTaskbar: false,
      titleBarStyle: (Platform.isMacOS || !appPreferences.showWindowButtons)
          ? TitleBarStyle.hidden
          : TitleBarStyle.normal,
      windowButtonVisibility: appPreferences.showWindowButtons,
      title: 'EasyWRT',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Default Device added if empty, using DeviceProvider for consistency
  final DeviceProvider tempDeviceProvider = DeviceProvider();
  if (tempDeviceProvider.devices.isEmpty) {
    try {
      final String? token = await Wrt.login(
        baseURL: "http://192.168.6.1/",
        username: "root",
        password: "Rzhzoot?200681",
      );
      final uuid = tempDeviceProvider.addDevice(
        name: "Default",
        luciUsername: "root",
        luciPassword: "Rzhzoot?200681",
        luciBaseURL: "http://192.168.6.1/",
        token: token ?? '',
      );
      final appStatus = AppController.getAppStatus();
      appStatus.deviceID = uuid;
      debugPrint('Default Device Created: $uuid');
      AppController.updateAppStatus(appStatus);
    } catch (e) {
      debugPrint('Failed to create default device: $e');
      // Optionally add a dummy device without token or just continue
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    ),
  );
}