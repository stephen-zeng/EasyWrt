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

  // Local History Stacks
  List<String> _middlewareStack = [];
  List<String> _pageStack = [];

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

  void _updateState(String mid, String? pid) {
    // Update Middleware State
    if (Hive.isBoxOpen('middlewares')) {
        final box = Hive.box<MiddlewareItem>('middlewares');
        final item = box.get(mid);
        if (item != null) {
            Future.microtask(() {
                ref.read(currentMiddlewareProvider.notifier).replaceCurrent(item);
            });
        }
    }

    // Update Page State
    if (pid != null) {
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
       Future.microtask(() {
          ref.read(currentPageProvider.notifier).setPage(
              id: pid,
              name: name,
              icon: icon,
              widgetChildren: children
          );
       });
    } else {
        Future.microtask(() => ref.read(currentPageProvider.notifier).clear());
    }
  }

  void _syncStack(List<String> stack, String? current) {
    if (current == null) {
      stack.clear();
      return;
    }

    if (stack.isEmpty) {
      stack.add(current);
      return;
    }

    // If no change, return
    if (stack.last == current) return;

    // Check if current is already in stack (Back/Up navigation)
    final index = stack.indexOf(current);
    if (index != -1) {
      // Truncate to existing instance
      stack.length = index + 1;
    } else {
      // Push new
      stack.add(current);
    }

  }

  void _syncMiddlewareStack(String mid) {
      // Ensure root is always first if empty or reset
      if (_middlewareStack.isEmpty && mid != 'router_root') {
          _middlewareStack.add('router_root');
      }
      _syncStack(_middlewareStack, mid);
  }

  void _syncPageStack(String? pid) {
      _syncStack(_pageStack, pid);
  }

  List<Page> _buildMiddlewarePages() {
    return _middlewareStack.map((mid) => CupertinoPage(
      key: ValueKey('mid_$mid'),
      name: mid,
      child: MiddlewareView(middlewareId: mid),
    )).toList();
  }

  List<Page> _buildPagePages() {
    final List<Page> pages = [
       const CupertinoPage(
          key: ValueKey('empty_page'),
          child: Scaffold(
            body: Center(child: Text('Select a page')),
          ),
       )
    ];

    for (final pid in _pageStack) {
       pages.add(CupertinoPage(
         key: ValueKey('page_$pid'),
         name: pid,
         child: custom_page.PageView(pageId: pid),
       ));
    }
    return pages;
  }
  
  void _handleRemoval(Page page, String currentMid, String? currentPid) {
     final key = page.key;
     if (key is ValueKey<String>) {
        final val = key.value;
        
        // Handle Middleware Removal
        if (val.startsWith('mid_')) {
            if (_middlewareStack.length >= 2) {
                final prevId = _middlewareStack[_middlewareStack.length - 2];
                _go(context, mid: prevId, pid: currentPid);
            }
        }
        
        // Handle Page Removal
        if (val.startsWith('page_')) {
            String? nextPid;
            if (_pageStack.length >= 2) {
                nextPid = _pageStack[_pageStack.length - 2];
            } else {
                nextPid = null;
            }
            _go(context, mid: currentMid, pid: nextPid);
        }
     }
  }

  @override
  Widget build(BuildContext context) {
    final mid = widget.state.uri.queryParameters['mid'] ?? 'router_root';
    final pid = widget.state.uri.queryParameters['pid'];

    _updateState(mid, pid);
    _syncMiddlewareStack(mid);
    _syncPageStack(pid);

    final middlewarePages = _buildMiddlewarePages();
    final pagePages = _buildPagePages();

    // Portrait Mode
    if (!ResponsiveLayout.isLandscape(context)) {
       // Combine stacks: Middleware Stack + Page Stack
       final List<Page> combinedPages = [...middlewarePages];
       
       if (pid != null) {
           final validPagePages = pagePages.where((p) => p.key != const ValueKey('empty_page')).toList();
           combinedPages.addAll(validPagePages);
       }

       return Navigator(
          key: _portraitNavigatorKey,
          pages: combinedPages,
          onDidRemovePage: (page) => _handleRemoval(page, mid, pid),
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
                 onDidRemovePage: (page) => _handleRemoval(page, mid, pid),
              ),
            ),
            const VerticalDivider(width: dividerWidth),
            Expanded(
              child: Navigator(
                 key: _rightNavigatorKey,
                 pages: pagePages,
                 onDidRemovePage: (page) => _handleRemoval(page, mid, pid),
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