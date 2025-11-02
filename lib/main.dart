import 'dart:io';

import 'package:easywrt/bean/setting/theme.dart';
import 'package:easywrt/database/storage.dart';
import 'package:easywrt/error/storage.dart';
import 'package:easywrt/utils/utils.dart';
import 'package:easywrt/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'database/app.dart';
import 'module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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