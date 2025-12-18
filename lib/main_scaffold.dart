import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'beam/responsive_layout.dart';
import 'beam/macos_safe.dart'; // Import the macos_safe.dart
import 'modules/router/router_controller.dart';

/// MainScaffold
/// MainScaffold
/// 
/// Function: Provides the main layout structure with responsive navigation (BottomBar/Rail).
/// Function: 提供带有响应式导航（底部栏/侧边栏）的主布局结构。
/// Inputs: 
/// Inputs: 
///   - [child]: The content widget to display within the scaffold.
///   - [child]: 要在脚手架中显示的内容组件。
/// Outputs: 
/// Outputs: 
///   - [Widget]: The scaffold layout.
///   - [Widget]: 配置好的 MaterialApp。
class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle startup logic (e.g. auto-connect)
    ref.watch(appStartupProvider);

    // Determine current index based on route
    // 根据路由确定当前索引
    final String location = GoRouterState.of(context).uri.toString();
    int selectedIndex = 0;
    if (location.startsWith('/router')) {
      selectedIndex = 0;
    } else if (location.startsWith('/setting')) {
      selectedIndex = 1;
    }

    void onDestinationSelected(int index) {
      if (index == 0) {
        context.go('/router');
      } else {
        context.go('/setting');
      }
    }

    final destinations = const [
      NavigationDestination(
        icon: Icon(Icons.router_outlined),
        selectedIcon: Icon(Icons.router),
        label: 'Router',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    final railDestinations = const [
      NavigationRailDestination(
        icon: Icon(Icons.router_outlined),
        selectedIcon: Icon(Icons.router),
        label: Text('Router'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: Text('Settings'),
      ),
    ];

    // Fade-in transition for Module switching
    // 模块切换的淡入过渡效果
    final animatedChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: KeyedSubtree(
        key: ValueKey(selectedIndex), // Animate when module index changes
                                      // 当模块索引变化时进行动画
        child: child,
      ),
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Set background color to match app theme
      child: EmbeddedNativeControlArea(
        child: ResponsiveLayout(
          portrait: Scaffold(
            body: animatedChild,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations,
            ),
          ),
          landscape: Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: railDestinations,
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: animatedChild),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
