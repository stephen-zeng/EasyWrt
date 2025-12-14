import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// SettingRootMiddleware
/// SettingRootMiddleware
/// 
/// Function: The root navigation menu for the Settings module.
/// Function: 设置模块的根导航菜单。
/// Inputs: None
/// Inputs: 无
/// Outputs: 
/// Outputs: 
///   - [Widget]: List of setting options.
///   - [Widget]: 设置选项列表。
class SettingRootMiddleware extends StatelessWidget {
  const SettingRootMiddleware({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.router),
            title: const Text('Router Manager'),
            onTap: () {
              context.go('/setting/router_manager');
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Theme'),
            onTap: () {
              context.go('/setting/theme');
            },
          ),
        ],
      ),
    );
  }
}
