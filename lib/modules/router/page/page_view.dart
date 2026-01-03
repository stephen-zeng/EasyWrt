import 'package:flutter/material.dart' hide PageView;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/modules/router/controllers/current_page_controller.dart';
import 'package:easywrt/beam/widget/grid_size_scope.dart';
import 'package:easywrt/modules/router/controllers/widget_catalog_controller.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';
import 'package:easywrt/beam/widget/stripe_widget.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/modules/router/page/add_widget_dialog.dart';

class PageView extends ConsumerWidget {
  final String pageId;

  const PageView({
    super.key,
    required this.pageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pageId.startsWith('widget_')) {
      return _buildWidgetPage(context, ref);
    } else {
      return _buildRouterPage(context, ref);
    }
  }

  Widget _buildWidgetPage(BuildContext context, WidgetRef ref) {
    final typeKey = pageId.replaceFirst('widget_', '');
    final catalog = ref.watch(widgetCatalogProvider);
    
    BaseWidget? widgetInstance;
    try {
      widgetInstance = catalog.firstWhere((w) => w.typeKey == typeKey);
    } catch (_) {
      widgetInstance = null;
    }

    if (widgetInstance == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: Center(child: Text('Widget type "$typeKey" not found in catalog')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widgetInstance.name),
      ),
      body: GridSizeScope(
        width: 0,
        height: 0,
        child: widgetInstance,
      ),
    );
  }

  Widget _buildRouterPage(BuildContext context, WidgetRef ref) {
    final isLandscape = ResponsiveLayout.isLandscape(context);
    final editState = ref.watch(editManagerProvider);
    final isEditing = editState.isEditing && editState.editingPageId == pageId;
    final editController = ref.read(editManagerProvider.notifier);

    return ValueListenableBuilder(
      valueListenable: Hive.box<PageItem>('pages').listenable(),
      builder: (context, Box<PageItem> box, _) {
        // Use working copy if editing, otherwise hive data
        PageItem? page = box.get(pageId);
        if (isEditing && editState.workingPage != null) {
          page = editState.workingPage;
        }

        if (page == null) {
          return const Center(child: Text('Page not found'));
        }

        return Scaffold(
          appBar: AppBar(
            leading: _buildLeading(context, ref, isLandscape, isEditing, editController),
            title: Text(page.name),
            actions: _buildActions(context, page, isEditing, editController),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final stripes = page!.stripes ?? [];
              
              // Responsive Logic
              final minWidth = AppMeta.minStripeWidthPx;
              final maxStripeWidth = AppMeta.maxStripeWidthPx;
              
              final contentPaddingValue = isEditing ? AppMeta.rem : AppMeta.rem / 2;
              final gap = isEditing ? AppMeta.rem : 0.0;
              final horizontalPadding = contentPaddingValue * 2;
              final availW = constraints.maxWidth - horizontalPadding;
              
              final int itemCount = stripes.length + (isEditing ? 1 : 0);

              int cols = ((availW + gap) / (minWidth + gap)).floor();
              
              if (itemCount > 0 && cols > itemCount) {
                cols = itemCount;
              }
              if (cols < 1) cols = 1;

              double stripeWidth = (availW - (cols - 1) * gap) / cols;
              bool scrollHorizontal = false;

              // Apply constraints
              if (stripeWidth < minWidth) {
                stripeWidth = minWidth;
                scrollHorizontal = true;
              } else if (stripeWidth > maxStripeWidth) {
                stripeWidth = maxStripeWidth;
              }

              final List<Widget> children = [
                ...stripes.map((s) => StripeWidget(
                      key: ValueKey(s.id),
                      stripe: s,
                      isEditing: isEditing,
                      width: stripeWidth,
                    )),
                if (isEditing)
                  _buildEmptyStripePlaceholder(context, stripeWidth, ref),
              ];

              Widget content = SingleChildScrollView(
                padding: EdgeInsets.all(contentPaddingValue),
                child: Center(
                  child: Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    alignment: WrapAlignment.start,
                    children: children,
                  ),
                ),
              );

              if (scrollHorizontal) {
                content = SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: minWidth + horizontalPadding),
                    child: content,
                  ),
                );
              }

              return content;
            },
          ),
          floatingActionButton: isEditing
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => AddWidgetDialog(
                        onAdd: (widgetKey) {
                           ref.read(editManagerProvider.notifier).addWidget(widgetKey);
                        },
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Widget? _buildLeading(BuildContext context, WidgetRef ref, bool isLandscape, bool isEditing, EditController controller) {
    if (isEditing) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          // Confirm discard?
          controller.discard();
        },
      );
    }
    return null; 
  }

  List<Widget> _buildActions(BuildContext context, PageItem page, bool isEditing, EditController controller) {
    if (isEditing) {
      return [
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            controller.save();
          },
        ),
      ];
    } else {
      // Menu
      return [
        IconButton(
            onPressed: () {
              controller.enterEditMode(page);
            },
            icon: const Icon(Icons.edit)
        )
      ];
    }
  }

  Widget _buildEmptyStripePlaceholder(BuildContext context, double width, WidgetRef ref) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
         final data = details.data;
         final parts = data.split('/');
         if (parts.length >= 2) {
           final sourceStripeId = parts[0];
           final widgetId = parts[1];
           ref.read(editManagerProvider.notifier).moveWidgetToNewStripe(sourceStripeId, widgetId);
         }
      },
      builder: (context, candidateData, rejectedData) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final baseColor = isDark ? Colors.white54 : Colors.grey;
        
        return Container(
          height: 100,
          width: width,
          decoration: BoxDecoration(
            border: Border.all(
              color: candidateData.isNotEmpty ? Theme.of(context).primaryColor : baseColor.withValues(alpha: 0.5), 
              style: BorderStyle.solid
            ),
            borderRadius: BorderRadius.circular(8),
            color: candidateData.isNotEmpty ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : null,
          ),
          child: Center(
            child: Text(
              'Drag widget here to create new stripe', 
              style: TextStyle(color: baseColor)
            ),
          ),
        );
      },
    );
  }
}
