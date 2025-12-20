import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:easywrt/db/interface/hive_init.dart';
import 'router.dart';
import 'package:easywrt/modules/setting/theme/theme.dart';

import 'package:easywrt/utils/init/hierarchy_seeder.dart';

import 'package:easywrt/modules/setting/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();
  await HierarchySeeder.seedDefaultHierarchy();

  if (Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      minimumSize: Size(400, 300),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden, // Hides title bar, keeps traffic lights
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  debugPrint('App started in main.dart');
  runApp(const ProviderScope(child: MyApp()));
}

/// MyApp
/// MyApp
/// 
/// Function: The root widget of the application.
/// Function: 应用程序的根组件。
/// Inputs: 
/// Inputs: 
///   - [key]: Optional key for the widget.
///   - [key]: 组件的可选键。
/// Outputs: 
/// Outputs: 
///   - [Widget]: The configured MaterialApp.
///   - [Widget]: 配置好的 MaterialApp。
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = AppTheme.lightTheme; 
    final darkTheme = AppTheme.darkTheme;

    return MaterialApp.router(
      title: 'EasyWRT',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}