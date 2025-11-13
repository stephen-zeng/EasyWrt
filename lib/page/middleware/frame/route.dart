import 'package:easywrt/page/middleware/dev/dev_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MiddlewareRouteItem {
  final Module module;
  final String path;
  final String name;
  final IconData icon; // 增加一个Icon属性

  const MiddlewareRouteItem({
    required this.module,
    required this.path,
    required this.name,
    required this.icon, // 增加Icon
  });
}

class MiddlewareRoute {
  final List<MiddlewareRouteItem> menuList;

  const MiddlewareRoute(this.menuList);

  int get length => menuList.length;

  List<ModuleRoute> get routes {
    return menuList.map((item) => ModuleRoute(item.path, module: item.module)).toList();
  }

  String getPath(int index) {
    return menuList[index].path;
  }
}

final MiddlewareRoute middlewareRoute = MiddlewareRoute([
  MiddlewareRouteItem(
    module: DevModule(),
    path: "/dev",
    name: "Dev",
    icon: Icons.developer_mode, // 提供Icon
  ),
  // 在这里添加更多路由...
  // BaseRouteItem(
  //   module: SettingsModule(),
  //   path: "/settings",
  //   name: "Settings",
  //   icon: Icons.settings,
  // ),
]);