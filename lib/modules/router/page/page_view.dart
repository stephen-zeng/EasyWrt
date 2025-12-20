import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/beam/responsive_layout.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/modules/router/controllers/current_page_controller.dart';
import 'package:easywrt/modules/router/widgets/cpu_usage/cpu_usage_widget.dart';
import 'package:easywrt/modules/router/widgets/add_widget_dialog.dart';
import 'package:easywrt/modules/router/widgets/memory_usage/memory_usage_widget.dart';
import 'package:easywrt/modules/router/widgets/network_traffic/network_traffic_widget.dart';

/// RouterPageView
/// RouterPageView
/// 
/// Function: Renders a page and its configured widgets. Supports edit mode for layout customization.
/// Function: 渲染页面及其配置的组件。支持用于自定义布局的编辑模式。
/// Inputs: 
/// Inputs: 
///   - [pageId]: ID of the page to display.
///   - [pageId]: 要显示的页面 ID。
/// Outputs: 
/// Outputs: 
///   - [Widget]: List/Reorderable list of widgets.
///   - [Widget]: 组件的列表/可重新排序列表。
class RouterPageView extends ConsumerWidget {
  final String pageId;

  const RouterPageView({super.key, required this.pageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape = ResponsiveLayout.isLandscape(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<PageItem>('pages').listenable(),
      builder: (context, Box<PageItem> box, _) {
        final page = box.get(pageId);

        if (page == null) {
          return const Center(child: Text('Page not found'));
        }

        // Init/Sync CurrentPage
        final currentPage = ref.watch(currentPageProvider);
        if (currentPage == null || currentPage.id != pageId) {
             Future.microtask(() {
                 ref.read(currentPageProvider.notifier).init(page);
             });
        }
        
        final isEditMode = currentPage?.isEditMode ?? false;

        final widgets = page.widgetChildren ?? [];

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !isLandscape, // Hide back button in landscape
            leading: !isLandscape 
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // In Portrait, back clears the PID selection to return to Middleware
                  final state = GoRouterState.of(context);
                  final currentMid = state.uri.queryParameters['mid'] ?? 'router_root';
                  context.go(Uri(
                    path: '/router',
                    queryParameters: {
                      'mid': currentMid,
                      'animateType': 'fromLeft',
                    }, // Clear PID
                  ).toString());
                },
              )
              : null,
            title: Text(page.name),
            actions: [
              IconButton(
                icon: Icon(isEditMode ? Icons.done : Icons.edit),
                onPressed: () {
                  ref.read(currentPageProvider.notifier).toggleEditMode();
                },
              ),
              if (isEditMode)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => AddWidgetDialog(
                        onAdd: (widgetName) async {
                          final newWidgets = List<String>.from(widgets)..add(widgetName);
                          final newPage = PageItem(
                            id: page.id,
                            name: page.name,
                            icon: page.icon,
                            widgetChildren: newWidgets,
                          );
                          await box.put(page.id, newPage);
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
          body: isEditMode
              ? ReorderableListView(
                  padding: const EdgeInsets.all(16),
                  onReorder: (oldIndex, newIndex) async {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final newWidgets = List<String>.from(widgets);
                    final item = newWidgets.removeAt(oldIndex);
                    newWidgets.insert(newIndex, item);

                     final newPage = PageItem(
                            id: page.id,
                            name: page.name,
                            icon: page.icon,
                            widgetChildren: newWidgets,
                          );
                    await box.put(page.id, newPage);
                  },
                  children: [
                    for (int i = 0; i < widgets.length; i++)
                      KeyedSubtree(
                        key: ValueKey('${widgets[i]}_$i'),
                        child: Padding(
                           padding: const EdgeInsets.only(bottom: 16),
                           child: _buildWidget(widgets[i]),
                        ),
                      ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final widgetName in widgets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildWidget(widgetName),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildWidget(String widgetName) {
    switch (widgetName) {
      case 'CpuUsageWidget':
        return const CpuUsageWidget();
      case 'MemoryUsageWidget':
        return const MemoryUsageWidget();
      case 'NetworkTrafficWidget':
        return const NetworkTrafficWidget();
      default:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Unknown Widget: $widgetName'),
          ),
        );
    }
  }
}
