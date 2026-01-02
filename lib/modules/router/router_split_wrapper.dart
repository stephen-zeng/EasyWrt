import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'middleware/middleware_view.dart';
import 'page/page_view.dart';
import 'page/widget_page.dart';
import 'controllers/current_middleware_controller.dart';

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

  Widget slideTransition(Widget child, Animation<double> animation) {
    final key = child.key;
    final currentMw = ref.read(currentMiddlewareProvider);
    final slideId = currentMw?.slideMiddlewareID;
    debugPrint("Slide Transition Key: $key, SlideID: $slideId");

    if (key is ValueKey<String> &&
        (key.value.startsWith('page_') ||
            key.value == 'mid_$slideId' ||
            key.value == 'left_$slideId')) {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: const AlwaysStoppedAnimation(0.0),
        linearTransition: false,
        child: child,
      );
    }

    return FadeTransition(opacity: animation, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final mid = widget.state.uri.queryParameters['mid'] ?? 'router_root';
    final pid = widget.state.uri.queryParameters['pid'];

    // Sync Provider with current URL/ID
    final currentMw = ref.watch(currentMiddlewareProvider);
    if (currentMw == null || currentMw.middlewareItem.id != mid) {
       // Ensure box is open
       if (Hive.isBoxOpen('middlewares')) {
          final box = Hive.box<MiddlewareItem>('middlewares');
          final item = box.get(mid);
          if (item != null) {
              Future.microtask(() {
                 ref.read(currentMiddlewareProvider.notifier).init(item);
              });
          }
       }
    }

    // Portrait Mode
    if (!ResponsiveLayout.isLandscape(context)) {
       final history = currentMw?.historyMiddlewareIDs ?? [];
       final List<Page> pages = [];

       // Add history items
       for (final hMid in history) {
          pages.add(CupertinoPage(
             key: ValueKey('mid_$hMid'),
             child: MiddlewareView(middlewareId: hMid),
          ));
       }

       // Add current MID
       pages.add(CupertinoPage(
          key: ValueKey('mid_$mid'),
          child: MiddlewareView(middlewareId: mid),
       ));

       // Add current PID if exists
       if (pid != null) {
          pages.add(CupertinoPage(
             key: ValueKey('page_$pid'),
             child: pid.startsWith('widget_')
                 ? WidgetPage(pageId: pid)
                 : RouterPageView(pageId: pid),
          ));
       }

       return Navigator(
          key: const ValueKey('router_navigator'),
          pages: pages,
          onPopPage: (route, result) {
             if (!route.didPop(result)) return false;

             if (pid != null) {
                // Popped Page -> Go to Middleware
                _go(context, mid: mid);
             } else {
                // Popped Middleware -> Go to previous Middleware
                final notifier = ref.read(currentMiddlewareProvider.notifier);
                final prevId = notifier.pop();
                if (prevId != null) {
                   if (Hive.isBoxOpen('middlewares')) {
                      final box = Hive.box<MiddlewareItem>('middlewares');
                      final prevItem = box.get(prevId);
                      if (prevItem != null) {
                         notifier.replaceCurrent(prevItem);
                         notifier.saveSlideMiddlewareID(mid);
                         _go(context, mid: prevId);
                      }
                   }
                }
             }
             return true; 
          },
       );
    }

    // Landscape Mode
    return LayoutBuilder(
      builder: (context, constraints) {
        // Left Pane: 300, Divider: 1
        // Right Pane Min: minStripeWidth (304) + padding (32) = 336
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => slideTransition(child, animation),
                child: KeyedSubtree(
                  key: ValueKey('left_$mid'),
                  child: MiddlewareView(middlewareId: mid),
                ),
              ),
            ),
            const VerticalDivider(width: dividerWidth),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                child: KeyedSubtree(
                  key: ValueKey('right_${pid ?? 'empty'}'),
                  child: pid != null
                      ? (pid.startsWith('widget_')
                          ? WidgetPage(pageId: pid)
                          : RouterPageView(pageId: pid))
                      : const Scaffold(
                          body: Center(
                            child: Text('Select a page from the left menu'),
                          ),
                        ),
                ),
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