import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';
import 'package:easywrt/modules/setting/theme/theme_provider.dart';

/// ThemePage
/// ThemePage
/// 
/// Function: A page for selecting the application theme.
/// Function: 选择应用程序主题的页面。
/// Inputs: None
/// Inputs: 无
/// Outputs: 
/// Outputs: 
///   - [Widget]: Radio list of theme options.
///   - [Widget]: 主题选项的单选列表。
class ThemePage extends ConsumerWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isLandscape = ResponsiveLayout.isLandscape(context);

    return Scaffold(
      appBar: AppBar(
        // Automatically implies leading back button in Portrait (Nested Navigator)
        // In Landscape, no leading is shown (Root Navigator can't pop this specific page in split view)
        title: const Text('Theme Settings'),
      ),
      body: ListView(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) ref.read(themeModeProvider.notifier).setThemeMode(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) ref.read(themeModeProvider.notifier).setThemeMode(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) ref.read(themeModeProvider.notifier).setThemeMode(value);
            },
          ),
        ],
      ),
    );
  }
}
