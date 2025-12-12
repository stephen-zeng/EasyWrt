import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'beam/responsive_layout.dart';

/// MainScaffold
/// 
/// Function: Provides the main layout structure with responsive navigation (BottomBar/Rail).
/// Inputs: 
///   - [child]: The content widget to display within the scaffold.
/// Outputs: 
///   - [Widget]: The scaffold layout.
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine current index based on route
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
    final animatedChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: KeyedSubtree(
        key: ValueKey(selectedIndex), // Animate when module index changes
        child: child,
      ),
    );

    return ResponsiveLayout(
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
    );
  }
}
