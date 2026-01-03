import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'middleware/middleware_view.dart';
import 'page/page_view.dart' as custom_page;
import 'controllers/current_middleware_controller.dart';
import 'controllers/current_page_controller.dart';
import 'controllers/widget_catalog_controller.dart';

class RouterSplitWrapper extends ConsumerStatefulWidget {
  final GoRouterState state;

  const RouterSplitWrapper({
    super.key,
    required this.state,
  });

  @override
  ConsumerState<RouterSplitWrapper> createState() => _RouterSplitWrapperState();
}

class _RouterSplitWrapperState extends ConsumerState<RouterSplitWrapper> {
  final GlobalKey<NavigatorState> _leftNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _rightNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _portraitNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  void _go(BuildContext context, {required String mid, String? pid}) {
    context.go(Uri(
      path: '/router',
      queryParameters: {
        'mid': mid,
        if (pid != null) 'pid': pid,
      },
    ).toString());
  }

  void _syncMiddlewareHistory(String mid) {
    final mwState = ref.read(currentMiddlewareProvider);
    
    // If state matches MID, do nothing
    if (mwState != null && mwState.middlewareItem.id == mid) return;

    // Fetch and Push
    if (Hive.isBoxOpen('middlewares')) {
        final box = Hive.box<MiddlewareItem>('middlewares');
        final item = box.get(mid);
        if (item != null) {
            Future.microtask(() {
                final notifier = ref.read(currentMiddlewareProvider.notifier);
                notifier.push(item);
                notifier.saveSlideMiddlewareID(item.id);
            });
        }
    }
  }

  void _syncPageHistory(String? pid) {
    final pageState = ref.read(currentPageProvider);
    
    if (pid == null) {
       if (pageState != null) {
          Future.microtask(() => ref.read(currentPageProvider.notifier).clear());
       }
       return;
    }

    // If state matches PID, do nothing (already synced)
    if (pageState != null && pageState.id == pid) return;

    // Push new page to history
    Future.microtask(() {
       _pushPageToHistory(pid);
    });
  }

  void _pushPageToHistory(String pid) {
     String name = 'Page';
     String icon = '';
     List<String>? children;

     if (pid.startsWith('widget_')) {
        final typeKey = pid.replaceFirst('widget_', '');
        final catalog = ref.read(widgetCatalogProvider);
        try {
           final widgetDef = catalog.firstWhere((w) => w.typeKey == typeKey);
           name = widgetDef.name;
        } catch (_) {
           name = 'Unknown Widget';
        }
     } else {
        if (Hive.isBoxOpen('pages')) {
           final page = Hive.box<PageItem>('pages').get(pid);
           if (page != null) {
              name = page.name;
              icon = page.icon;
              children = page.widgetChildren;
           }
        }
     }

     ref.read(currentPageProvider.notifier).push(
        id: pid,
        name: name,
        icon: icon,
        widgetChildren: children
     );
  }

  List<Page> _buildMiddlewarePages(String currentMid) {
    final currentMw = ref.watch(currentMiddlewareProvider);
    final history = currentMw?.historyMiddlewareIDs ?? [];
    
    final mwStack = <String>{...history, currentMid};
    
    return mwStack.map((mid) => CupertinoPage(
      key: ValueKey('mid_$mid'),
      name: mid,
      child: MiddlewareView(middlewareId: mid),
    )).toList();
  }

  List<Page> _buildPagePages(String? currentPid) {
    final pageState = ref.watch(currentPageProvider);
    final uniquePageStack = <String>{};

    if (pageState != null) {
        uniquePageStack.addAll(pageState.historyPageIDs);
        // If transitioning, ensure we capture the current logic
        if (currentPid != null && pageState.id != currentPid) {
            uniquePageStack.add(pageState.id);
        }
    }

    if (currentPid != null) {
       uniquePageStack.add(currentPid);
    }
    
    if (uniquePageStack.isEmpty) {
        return [
           const CupertinoPage(
              key: ValueKey('empty_page'),
              child: Scaffold(
                body: Center(child: Text('Select a page')),
              ),
           )
        ];
    }

    return uniquePageStack.map((pid) => CupertinoPage(
      key: ValueKey('page_$pid'),
      name: pid,
      child: custom_page.PageView(pageId: pid),
    )).toList();
  }
  
  bool _handleMiddlewarePop(String currentMid, String? currentPid) {
      final notifier = ref.read(currentMiddlewareProvider.notifier);
      final prevId = notifier.pop();
      if (prevId != null) {
          if (Hive.isBoxOpen('middlewares')) {
              final box = Hive.box<MiddlewareItem>('middlewares');
              final prevItem = box.get(prevId);
              if (prevItem != null) {
                  notifier.replaceCurrent(prevItem);
                  notifier.saveSlideMiddlewareID(currentMid); // For animation direction if needed
                  _go(context, mid: prevId, pid: currentPid); // Keep current PID? Usually independent
              }
          }
          return true;
      }
      return false;
  }

  bool _handlePagePop(String currentMid, String? currentPid) {
      if (currentPid == null) return false;
      
      final pageNotifier = ref.read(currentPageProvider.notifier);
      final prevPageId = pageNotifier.pop();

      if (prevPageId != null) {
          _go(context, mid: currentMid, pid: prevPageId);
      } else {
          // If no history page, we might be closing the page pane? 
          // But in split view, page pane usually stays. 
          // Or if we are in portrait, this pops back to middleware.
          // In Landscape, maybe we just don't pop the last page?
          // Or we go to a state with no page?
          // Let's assume we go to no page if it was the last one, OR we stay.
          // For now, if we pop the last page, we go to pid=null?
          // Let's stick to the behavior: Pop page -> prevPage. 
          // If no prevPage -> remove pid (pid=null).
          _go(context, mid: currentMid, pid: null);
      }
      return true;
  }

  @override
  Widget build(BuildContext context) {
    final mid = widget.state.uri.queryParameters['mid'] ?? 'router_root';
    final pid = widget.state.uri.queryParameters['pid'];

    _syncMiddlewareHistory(mid);
    _syncPageHistory(pid);

    final middlewarePages = _buildMiddlewarePages(mid);
    final pagePages = _buildPagePages(pid);

    // Portrait Mode
    if (!ResponsiveLayout.isLandscape(context)) {
       // Combine stacks: Middleware Stack + Page Stack
       // Note: Page Stack already includes the empty check? No, _buildPagePages handles empty.
       // In portrait, if pid is null, we just show middleware stack.
       
       final List<Page> combinedPages = [...middlewarePages];
       
       if (pid != null) {
           // Filter out the 'empty_page' placeholder if it exists
           final validPagePages = pagePages.where((p) => p.key != const ValueKey('empty_page')).toList();
           combinedPages.addAll(validPagePages);
       }

       return Navigator(
          key: _portraitNavigatorKey,
          pages: combinedPages,
          onPopPage: (route, result) {
             if (!route.didPop(result)) return false;

             // Determine what we popped
             // If we have pages, we likely popped a page
             if (pid != null) {
                 return _handlePagePop(mid, pid);
             } else {
                 return _handleMiddlewarePop(mid, pid);
             }
          },
       );
    }

    // Landscape Mode
    return LayoutBuilder(
      builder: (context, constraints) {
        const double leftPaneWidth = 300.0;
        const double dividerWidth = 1.0;
        const double rightPanePadding = 32.0;
        final double rightPaneMinWidth = AppMeta.minStripeWidthPx + rightPanePadding;
        final double totalMinWidth = leftPaneWidth + dividerWidth + rightPaneMinWidth;

        final bool overflow = constraints.maxWidth < totalMinWidth;

        Widget body = Row(
          children: [
            SizedBox(
              width: leftPaneWidth,
              child: Navigator(
                 key: _leftNavigatorKey,
                 pages: middlewarePages,
                 onPopPage: (route, result) {
                    if (!route.didPop(result)) return false;
                    return _handleMiddlewarePop(mid, pid);
                 },
              ),
            ),
            const VerticalDivider(width: dividerWidth),
            Expanded(
              child: Navigator(
                 key: _rightNavigatorKey,
                 pages: pagePages,
                 onPopPage: (route, result) {
                    if (!route.didPop(result)) return false;
                    return _handlePagePop(mid, pid);
                 },
              ),
            ),
          ],
        );

        if (overflow) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalMinWidth,
              height: constraints.maxHeight,
              child: body,
            ),
          );
        }
        return body;
      },
    );
  }
}