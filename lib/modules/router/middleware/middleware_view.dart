import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/modules/router/controllers/current_middleware_controller.dart';
import 'package:easywrt/utils/init/meta.dart';

/// MiddlewareView
/// MiddlewareView
/// 
/// Function: Renders a middleware (menu list) and its children.
/// Function: 渲染中间件（菜单列表）及其子项。
class MiddlewareView extends ConsumerWidget {
  final String middlewareId;

  const MiddlewareView({super.key, required this.middlewareId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MiddlewareItem>('middlewares').listenable(),
      builder: (context, Box<MiddlewareItem> box, _) {
        final middleware = box.get(middlewareId);
        if (middleware == null) {
          return const Center(child: Text('Middleware not found'));
        }

        // Sync Provider with current URL/ID
        // Attention: sync currentMw with middlewareID from URL, is it optimized?
        final currentMw = ref.watch(currentMiddlewareProvider);
        if (currentMw == null || currentMw.middlewareItem.id != middlewareId) {
             Future.microtask(() {
                 ref.read(currentMiddlewareProvider.notifier).init(middleware);
             });
        }
        
        // Check History for AppBar visibility
        final hasHistory = currentMw != null && currentMw.historyMiddlewareIDs.isNotEmpty;

        return Scaffold(
          appBar:  AppBar(
            leading: hasHistory ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                 // History Back Logic: Jump to the last middleware in history
                 // This corresponds to returning to the previous level (parent)
                 final notifier = ref.read(currentMiddlewareProvider.notifier);
                 final prevId = notifier.pop();
                 if (prevId != null) {
                     final prevItem = box.get(prevId);
                     if (prevItem != null) {
                         notifier.replaceCurrent(prevItem);
                         notifier.saveSlideMiddlewareID(middlewareId);
                         _go(context, mid: prevId);
                     }
                 }
              },
            ): null,
            title: Text(middleware.name),
          ), // Hide AppBar if no history
          body: ListView(
            children: [
              if (middleware.children != null)
                for (final childId in middleware.children!)
                  Builder(
                    builder: (context) {
                      final childMiddleware = Hive.box<MiddlewareItem>('middlewares').get(childId);
                      if (childMiddleware != null) {
                        return ListTile(
                          leading: Icon(AppMeta.getIconData(childMiddleware.icon)),
                          title: Text(childMiddleware.name),
                          onTap: () {
                            // Push History and Navigate
                            ref.read(currentMiddlewareProvider.notifier).push(childMiddleware);
                            ref.read(currentMiddlewareProvider.notifier).saveSlideMiddlewareID(childMiddleware.id);
                            _go(context, mid: childId);
                          },
                        );
                      }

                      final childPage = Hive.box<PageItem>('pages').get(childId);
                      if (childPage != null) {
                        return ListTile(
                          leading: Icon(AppMeta.getIconData(childPage.icon)),
                          title: Text(childPage.name),
                          onTap: () {
                            _go(context, pid: childId);
                            ref.read(currentMiddlewareProvider.notifier).saveSlideMiddlewareID('');
                          },
                        );
                      }
                      return const SizedBox.shrink(); 
                    },
                  ),
            ],
          ),
        );
      },
    );
  }

  void _go(BuildContext context, {String? mid, String? pid}) {
    final state = GoRouterState.of(context);
    final currentMid = state.uri.queryParameters['mid'] ?? 'router_root';
    final currentPid = state.uri.queryParameters['pid'];

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
}