import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/beam/responsive_layout.dart';
import 'package:easywrt/beam/macos_safe.dart'; // Import the macos_safe.dart
import 'package:easywrt/modules/router/controllers/current_router_controller.dart';
import 'package:easywrt/modules/router/controllers/connection_controller.dart';

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
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  @override
  void initState() {
    super.initState();
    // Handle startup logic (e.g. auto-connect)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appStartup();
    });
  }

  Future<void> _appStartup() async {
    final currentRouter = ref.read(currentRouterProvider);
    if (currentRouter != null) {
      debugPrint("App startup: Auto-connecting to last router ${currentRouter.routerItem.host}");
      await ref.read(routerConnectionProvider).connect(currentRouter.routerItem);
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Set background color to match app theme
      child: ResponsiveLayout(
        portrait: EmbeddedNativeControlAreaMoveDown(
          child: Scaffold(
            body: widget.child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: destinations,
            ),
          ),
        ),
        landscape: Scaffold(
          body: Row(
            children: [
              EmbeddedNativeControlAreaMoveDown(
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: railDestinations,
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}