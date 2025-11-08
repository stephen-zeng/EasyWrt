import 'package:easywrt/page/middleware/dev/dev_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BaseRouteItem {
  final Module module;
  final String path;
  final String name;
  final IconData icon; // 增加一个Icon属性

  const BaseRouteItem({
    required this.module,
    required this.path,
    required this.name,
    required this.icon, // 增加Icon
  });
}

class BaseRoute {
  final List<BaseRouteItem> menuList;
  List<ListTile> get listTileList {
    return menuList.map((item) {
      return ListTile(
        leading: Icon(item.icon),
        title: Text(item.name),
        onTap: () {
          Modular.to.navigate(item.path);
        },
      );
    }).toList();
  }

  const BaseRoute(this.menuList);

  int get length => menuList.length;

  List<ModuleRoute> get routes {
    return menuList.map((item) => ModuleRoute(item.path, module: item.module)).toList();
  }

  String getPath(int index) {
    return menuList[index].path;
  }
}

final BaseRoute baseRoute = BaseRoute([
  BaseRouteItem(
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