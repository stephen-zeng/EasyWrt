import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// SettingRootMiddleware
/// 
/// Function: The root navigation menu for the Settings module.
/// Inputs: None
/// Outputs: 
///   - [Widget]: List of setting options.
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
