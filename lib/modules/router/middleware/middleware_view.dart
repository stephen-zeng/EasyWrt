import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/modules/router/controllers/current_middleware_controller.dart';
import 'package:easywrt/modules/router/middleware/add_middleware_item_dialog.dart';
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
    // Local state for edit mode
    final isEditingProvider = StateProvider.autoDispose<bool>((ref) => false);
    final isEditing = ref.watch(isEditingProvider);

    return ValueListenableBuilder(
      valueListenable: Hive.box<MiddlewareItem>('middlewares').listenable(),
      builder: (context, Box<MiddlewareItem> box, _) {
        final middleware = box.get(middlewareId);
        if (middleware == null) {
          return const Center(child: Text('Middleware not found'));
        }

        // Sync Provider with current URL/ID
        final currentMw = ref.watch(currentMiddlewareProvider);
        if (currentMw == null || currentMw.middlewareItem.id != middlewareId) {
             Future.microtask(() {
                 ref.read(currentMiddlewareProvider.notifier).init(middleware);
             });
        }
        
        // Check History for AppBar visibility
        final hasHistory = currentMw != null && currentMw.historyMiddlewareIDs.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            leading: hasHistory && !isEditing ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
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
            actions: [
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit),
                onPressed: () {
                   ref.read(isEditingProvider.notifier).state = !isEditing;
                },
              ),
            ],
          ),
          body: isEditing
              ? ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    ref.read(currentMiddlewareProvider.notifier).reorderChildren(oldIndex, newIndex);
                  },
                  children: [
                    if (middleware.children != null)
                      for (int i=0; i < middleware.children!.length; i++)
                         _buildListItem(context, ref, middleware.children![i], isEditing, Key('${middleware.children![i]}_$i')),
                  ],
                )
              : ListView(
                  children: [
                    if (middleware.children != null)
                      for (final childId in middleware.children!)
                        _buildListItem(context, ref, childId, isEditing, null),
                  ],
                ),
          floatingActionButton: isEditing 
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                   showModalBottomSheet(
                      context: context,
                      builder: (_) => AddMiddlewareItemDialog(
                         currentMiddlewareId: middlewareId,
                         ancestorIds: currentMw?.historyMiddlewareIDs ?? [],
                         existingChildIds: middleware.children ?? [],
                         onAdd: (childId) {
                            ref.read(currentMiddlewareProvider.notifier).addChild(childId);
                         },
                      ),
                   );
                },
              )
            : null,
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, WidgetRef ref, String childId, bool isEditing, Key? key) {
    // Helper to build Delete action
    Widget? trailing;
    if (isEditing) {
       trailing = Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           IconButton(
             icon: const Icon(Icons.remove_circle, color: Colors.red),
             onPressed: () {
                ref.read(currentMiddlewareProvider.notifier).removeChild(childId);
             },
           ),
           const Icon(Icons.drag_handle),
         ],
       );
    } else {
       trailing = const Icon(Icons.chevron_right);
    }

    final childMiddleware = Hive.box<MiddlewareItem>('middlewares').get(childId);
    if (childMiddleware != null) {
      return ListTile(
        key: key,
        leading: Icon(AppMeta.getIconData(childMiddleware.icon)),
        title: Text(childMiddleware.name),
        trailing: trailing,
        onTap: isEditing ? null : () {
          ref.read(currentMiddlewareProvider.notifier).push(childMiddleware);
          ref.read(currentMiddlewareProvider.notifier).saveSlideMiddlewareID(childMiddleware.id);
          _go(context, mid: childId);
        },
      );
    }

    final childPage = Hive.box<PageItem>('pages').get(childId);
    if (childPage != null) {
      return ListTile(
        key: key,
        leading: Icon(AppMeta.getIconData(childPage.icon)),
        title: Text(childPage.name),
        trailing: isEditing ? trailing : null, // Pages don't have chevron usually unless specifically requested
        onTap: isEditing ? null : () {
          _go(context, pid: childId);
          ref.read(currentMiddlewareProvider.notifier).saveSlideMiddlewareID('');
        },
      );
    }
    return SizedBox.shrink(key: key);
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