import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';
import 'package:easywrt/beam/widget/stripe_widget.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/modules/router/page/add_widget_dialog.dart';
class RouterPageView extends ConsumerStatefulWidget {
  final String pageId;

  const RouterPageView({super.key, required this.pageId});

  @override
  ConsumerState<RouterPageView> createState() => _RouterPageViewState();
}

class _RouterPageViewState extends ConsumerState<RouterPageView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageId = widget.pageId;

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

        // Init/Sync CurrentPage (Legacy support if needed)
        // ref.read(currentPageProvider.notifier).init(page);

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !isLandscape && !isEditing,
            leading: _buildLeading(context, isLandscape, isEditing, editController),
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

              // Note: When !isEditing, gap is 0, so calculation needs to be careful not to divide by zero if minWidth is small (it's not).
              // Actually the formula (availW + gap) / (minWidth + gap) handles gap=0 fine.
              
              int cols = ((availW + gap) / (minWidth + gap)).floor();
              // If we have fewer items than space allows, limit cols to itemCount
              // to prevent items from being too narrow/aligned left unnecessarily.
              // They will expand up to maxStripeWidth and be centered.
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
                  _buildEmptyStripePlaceholder(context, stripeWidth),
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

  Widget? _buildLeading(BuildContext context, bool isLandscape, bool isEditing, EditController controller) {
    if (isEditing) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          // Confirm discard?
          controller.discard();
        },
      );
    }
    if (!isLandscape) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          final state = GoRouterState.of(context);
          final currentMid = state.uri.queryParameters['mid'] ?? 'router_root';
          context.go(Uri(
            path: '/router',
            queryParameters: {
              'mid': currentMid,
              'animateType': 'fromLeft',
            },
          ).toString());
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

  Widget _buildEmptyStripePlaceholder(BuildContext context, double width) {
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
