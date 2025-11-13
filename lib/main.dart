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
import 'base/module.dart';
import 'database/device.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint((await getApplicationSupportDirectory()).path);

  try {
    await Hive.initFlutter('${(await getApplicationSupportDirectory()).path}/hive');
    await HiveDB.init();
  } catch(_) {
    runApp(storageErrorApp());
    return;
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

  // Attention: Default Device added
  // Default Device ID: afc63af0-fcc9-4f00-80d2-b28e5e08e5c0
  final deviceController = DeviceController();
  if (deviceController.devices.isEmpty) {
    deviceController.newDevice(
        name: "Default",
        luciUsername: "root",
        luciPassword: "zhz200681",
        luciBaseURL: "http://192.168.6.1/",
        token: await Wrt.login(
          baseURL: "http://192.168.6.1/",
          username: "root",
          password: "zhz200681",
        ) ?? '',
    );
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    ),
  );
}