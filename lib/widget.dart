import 'dart:io';

import 'package:easywrt/database/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:easywrt/database/storage.dart';
import 'package:flutter/material.dart';
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

    void _updateExitBehaviorIfNeeded(bool remember, int newBehavior) {
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
                    _updateExitBehaviorIfNeeded(rememberChoice, AppDBCode.exitBehaviorClose);
                    exit(0);
                  },
                  child: const Text('直接退出'),
                ),
                TextButton(
                  onPressed: () {
                    _updateExitBehaviorIfNeeded(rememberChoice, AppDBCode.exitBehaviorMinimize);
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
        break;
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
      debugPrint("应用进入后台");
    } else if (state == AppLifecycleState.resumed) {
      debugPrint("应用回到前台");
    } else if (state == AppLifecycleState.inactive) {
      debugPrint("应用处于非活动状态");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
