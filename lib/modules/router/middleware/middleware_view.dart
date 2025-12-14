import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../db/models/hierarchy_items.dart';
import '../../../beam/history_menu.dart'; // Keep if needed, or replace with standard back

/// MiddlewareView
/// MiddlewareView
/// 
/// Function: Renders a middleware (menu list) and its children.
/// Function: 渲染中间件（菜单列表）及其子项。
/// Inputs: 
/// Inputs: 
///   - [middlewareId]: ID of the middleware to display.
///   - [middlewareId]: 要显示的中间件 ID。
/// Outputs: 
/// Outputs: 
///   - [Widget]: List view of children.
///   - [Widget]: 子项的列表视图。
class MiddlewareView extends StatelessWidget {
  final String middlewareId;

  const MiddlewareView({super.key, required this.middlewareId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MiddlewareItem>('middlewares').listenable(),
      builder: (context, Box<MiddlewareItem> box, _) {
        final middleware = box.get(middlewareId);

        if (middleware == null) {
          return const Center(child: Text('Middleware not found'));
        }

        // Calculate Parent for Back Button
        final parentId = _findParentMiddlewareId(middlewareId);

        return Scaffold(
          appBar: AppBar(
            leading: parentId != null 
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _navigate(context, mid: parentId);
                    },
                  ) 
                : null, // No back button at root
            title: Text(middleware.name),
          ),
          body: ListView(
            children: [
              if (middleware.children != null)
                for (final childId in middleware.children!)
                  Builder(
                    builder: (context) {
                      final childMiddleware = Hive.box<MiddlewareItem>('middlewares').get(childId);
                      if (childMiddleware != null) {
                        return ListTile(
                          leading: Icon(getIconData(childMiddleware.icon)),
                          title: Text(childMiddleware.name),
                          onTap: () {
                            _navigate(context, mid: childId);
                          },
                        );
                      }

                      final childPage = Hive.box<PageItem>('pages').get(childId);
                      if (childPage != null) {
                        return ListTile(
                          leading: Icon(getIconData(childPage.icon)),
                          title: Text(childPage.name),
                          onTap: () {
                            _navigate(context, pid: childId);
                          },
                        );
                      }

                      return const SizedBox.shrink(); 
                    }
                  ),
            ],
          ),
        );
      },
    );
  }

  void _navigate(BuildContext context, {String? mid, String? pid}) {
    final state = GoRouterState.of(context);
    final currentMid = state.uri.queryParameters['mid'] ?? 'router_root';
    final currentPid = state.uri.queryParameters['pid'];

    // If mid is provided, update mid. If not provided, keep current mid.
    // If pid is provided, update pid. If not provided, keep current pid UNLESS mid changed?
    // User requirement: "Right pane stay still" on Back.
    // Standard behavior on "Forward" (Drill down): usually clears selection.
    // Let's adopt: 
    // - Change MID: Keep PID (Independence).
    // - Change PID: Keep MID.
    
    final targetMid = mid ?? currentMid;
    final targetPid = pid ?? currentPid;

    context.go(Uri(
      path: '/router',
      queryParameters: {
        'mid': targetMid,
        if (targetPid != null) 'pid': targetPid,
      },
    ).toString());
  }

  String? _findParentMiddlewareId(String childId) {
    final box = Hive.box<MiddlewareItem>('middlewares');
    for (final middleware in box.values) {
      if (middleware.middlewareChildren != null && middleware.middlewareChildren!.contains(childId)) {
        return middleware.id;
      }
    }
    return null;
  }

  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'router': return Icons.router;
      case 'bar_chart': return Icons.bar_chart;
      case 'hardware': return Icons.hardware;
      case 'hard_drive': return Icons.storage;
      case 'settings': return Icons.settings;
      case 'colors': return Icons.color_lens;
      default: return Icons.help_outline;
    }
  }
}