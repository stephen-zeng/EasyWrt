import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:easywrt/bean/setting/theme.dart';
import 'package:easywrt/bean/theme/theme.dart';
import 'package:easywrt/database/app.dart';
import 'package:easywrt/utils/utils.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:easywrt/database/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bean/dialog/dialog.dart';
import 'config/setting.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget>
    with TrayListener, WidgetsBindingObserver, WindowListener {
  Box app = HiveDB.apps;
  final TrayManager trayManager = TrayManager.instance;
  bool showExitDialog = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    windowManager.addListener(this);
    trayManager.addListener(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show':
        await windowManager.show();
        await windowManager.focus();
        break;
      case 'exit':
        exit(0);
      default:
        break;
    }
  }

  @override
  void onWindowClose() async {
    final currentPreferences = AppController.getAppPreferences();

    void _updateExitBehavior(bool remember, int newBehavior) {
      if (remember) {
        currentPreferences.exitBehavior = newBehavior;
        AppController.updateAppPreferences(currentPreferences); // Attention: maybe need deep copy
      }
    }

    switch (currentPreferences.exitBehavior) {
      case AppDBCode.exitBehaviorAsk:
        bool rememberChoice = false;
        SZDialog.show(
          builder: (context) {
            return AlertDialog(
              title: const Text('退出确认'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('您要如何操作？'),
                  const SizedBox(height: 24),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        children: [
                          Checkbox(
                            value: rememberChoice,
                            onChanged: (value) {
                              setState(() {
                                rememberChoice = value ?? false;
                              });
                            },
                          ),
                          const Text('记住我的选择'),
                        ],
                      );
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _updateExitBehavior(rememberChoice, AppDBCode.exitBehaviorClose);
                    exit(0);
                  },
                  child: const Text('直接退出'),
                ),
                TextButton(
                  onPressed: () {
                    _updateExitBehavior(rememberChoice, AppDBCode.exitBehaviorMinimize);
                    SZDialog.dismiss();
                    windowManager.hide();
                  },
                  child: const Text('最小化至托盘'),
                ),
                TextButton(
                  onPressed: SZDialog.dismiss,
                  child: const Text('取消'),
                ),
              ],
            );
          },
        );
        break;
      case AppDBCode.exitBehaviorClose: // case 1
        exit(0);
      case AppDBCode.exitBehaviorMinimize: // case 2
      default:
        windowManager.hide();
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      debugPrint("go to background");
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("back to foreground");
    } else if (state == AppLifecycleState.inactive) {
      debugPrint("inactive");
    }
  }

  Future<void> _handleTray() async {
    if (Platform.isWindows) {
      await trayManager.setIcon('/assets/logo/logo.ico');
    } else {
      await trayManager.setIcon('/assets/logo/logo.png');
    }

    if (!Platform.isLinux) {
      await trayManager.setToolTip('Kazumi');
    }

    Menu trayMenu = Menu(items: [
      MenuItem(key: 'show_window', label: '显示窗口'),
      MenuItem.separator(),
      MenuItem(key: 'exit', label: '退出应用'),
    ]);
    await trayManager.setContextMenu(trayMenu);
  }

  @override
  Widget build(BuildContext context) {
    final appPreferences = AppController.getAppPreferences();
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    if (Utils.isDesktop()) {
      _handleTray();
    }

    switch (appPreferences.darkMode) {
      case AppDBCode.themeModeLight:
        themeProvider.setThemeMode(ThemeMode.light, notify: false);
        break;
      case AppDBCode.themeModeDark:
        themeProvider.setThemeMode(ThemeMode.dark, notify: false);
        break;
      case AppDBCode.themeModeSystem:
      default:
        themeProvider.setThemeMode(ThemeMode.system, notify: false);
        break;
    }

    final dynamic color = Color(appPreferences.color);
    themeProvider.setTheme(
        ThemeGetter.getLightTheme(color),
        appPreferences.oledEnabled ?
        ThemeGetter.getOLEDDarkTheme(color) :
        ThemeGetter.getDarkTheme(color),
        notify: false
    );

    var app = DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      if (themeProvider.useDynamicColor && lightColorScheme != null && darkColorScheme != null) {
        themeProvider.setTheme(
          ThemeGetter.getDynamicLightTheme(lightColorScheme),
          appPreferences.oledEnabled ?
          ThemeGetter.getDynamicOLEDDarkTheme(darkColorScheme) :
          ThemeGetter.getDynamicDarkTheme(darkColorScheme),
        );
      }
      return MaterialApp.router(
        title: 'EasyWRT',
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale.fromSubtags(
              languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN")
        ],
        locale: const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN"),
        theme: themeProvider.light,
        darkTheme: themeProvider.dark,
        themeMode: themeProvider.themeMode,
        routerConfig: Modular.routerConfig,
      );
    });
    Modular.setObservers([SZDialog.observer]);
    return app;
  }
}
