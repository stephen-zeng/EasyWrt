import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/modules/router/controllers/current_middleware_controller.dart';
import 'package:easywrt/modules/router/controllers/widget_catalog_controller.dart';
import 'package:easywrt/modules/router/middleware/add_middleware_item_dialog.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';

/// MiddlewareView
/// MiddlewareView
/// 
/// Function: Renders a middleware (menu list) and its children.
/// Function: 渲染中间件（菜单列表）及其子项。
class MiddlewareView extends ConsumerStatefulWidget {
  final String middlewareId;

  const MiddlewareView({super.key, required this.middlewareId});

  @override
  ConsumerState<MiddlewareView> createState() => _MiddlewareViewState();
}

class _MiddlewareViewState extends ConsumerState<MiddlewareView> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MiddlewareItem>('middlewares').listenable(),
      builder: (context, Box<MiddlewareItem> box, _) {
        final middleware = box.get(widget.middlewareId);
        if (middleware == null) {
          return const Center(child: Text('Middleware not found'));
        }

        // Note: Provider initialization is now handled by RouterSplitWrapper

        final currentMw = ref.watch(currentMiddlewareProvider);
        // Check History for AppBar visibility
        final hasHistory = currentMw != null && currentMw.historyMiddlewareIDs.isNotEmpty;
        final isLandscape = ResponsiveLayout.isLandscape(context);

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !isLandscape && !_isEditing,
            leading: hasHistory && !_isEditing && isLandscape ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _handleBack(context, box),
            ): null,
            title: Text(middleware.name),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit),
                onPressed: () {
                   setState(() {
                     _isEditing = !_isEditing;
                   });
                },
              ),
            ],
          ),
          body: _isEditing
              ? ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    ref.read(currentMiddlewareProvider.notifier).reorderChildren(oldIndex, newIndex);
                    HapticFeedback.mediumImpact();
                  },
                  onReorderStart: (index) {
                    HapticFeedback.mediumImpact();
                  },
                  buildDefaultDragHandles: false,
                  children: [
                    if (middleware.children != null)
                      for (int i=0; i < middleware.children!.length; i++)
                         _buildListItem(context, ref, middleware.children![i], _isEditing, i, Key('${middleware.children![i]}_$i')),
                  ],
                )
              : ListView(
                  children: [
                    if (middleware.children != null)
                      for (final childId in middleware.children!)
                        _buildListItem(context, ref, childId, _isEditing, 0, null),
                  ],
                ),
          floatingActionButton: _isEditing 
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                   showModalBottomSheet<void>(
                      context: context,
                      builder: (_) => AddMiddlewareItemDialog(
                         currentMiddlewareId: widget.middlewareId,
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

  void _handleBack(BuildContext context, Box<MiddlewareItem> box) {
    final notifier = ref.read(currentMiddlewareProvider.notifier);
    final prevId = notifier.pop();
    if (prevId != null) {
      final prevItem = box.get(prevId);
      if (prevItem != null) {
        notifier.replaceCurrent(prevItem);
        notifier.saveSlideMiddlewareID(widget.middlewareId);
        _go(context, mid: prevId);
      }
    }
  }

  Widget _buildListItem(BuildContext context, WidgetRef ref, String childId, bool isEditing, int index, Key? key) {
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
           ReorderableDragStartListener(
             index: index,
             child: const Icon(Icons.drag_handle),
           ),
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_right),
            if (isEditing) trailing!,
          ],
        ),
        onTap: isEditing ? null : () {
          ref.read(currentMiddlewareProvider.notifier).push(childMiddleware);
          ref.read(currentMiddlewareProvider.notifier).saveSlideMiddlewareID(childMiddleware.id);
          _go(context, mid: childId);
        },
      );
    }

    // Check for Widget Item
    if (childId.startsWith('widget_')) {
      final typeKey = childId.replaceFirst('widget_', '');
      final catalog = ref.read(widgetCatalogProvider);
      try {
        final widgetItem = catalog.firstWhere((w) => w.typeKey == typeKey);
        return ListTile(
          key: key,
          leading: Icon(widgetItem.icon),
          title: Text(widgetItem.name),
          trailing: isEditing ? trailing : null,
          onTap: isEditing ? null : () {
            _go(context, pid: childId);
            ref.read(currentMiddlewareProvider.notifier).saveSlideMiddlewareID('');
          },
        );
      } catch (_) {
        return ListTile(
          key: key,
          leading: const Icon(Icons.error),
          title: Text('Unknown Widget: $typeKey'),
          trailing: isEditing ? trailing : null,
        );
      }
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