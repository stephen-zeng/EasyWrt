import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'db/hive/hive_init.dart';
import 'router.dart';
import 'utils/theme.dart';

import 'utils/hierarchy_seeder.dart';

import 'modules/setting/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.init();
  await HierarchySeeder.seedDefaultHierarchy();
  runApp(const ProviderScope(child: MyApp()));
}

/// MyApp
/// 
/// Function: The root widget of the application.
/// Inputs: 
///   - [key]: Optional key for the widget.
/// Outputs: 
///   - [Widget]: The configured MaterialApp.
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