import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easywrt/beam/responsive_layout.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'middleware/middleware_view.dart';
import 'page/page_view.dart';
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

  Widget slideTransition(Widget child, Animation<double> animation) {
    final key = child.key;
    final currentMw = ref.read(currentMiddlewareProvider);
    final slideId = currentMw?.slideMiddlewareID;
    // debugPrint("Slide Transition Key: $key, SlideID: $slideId");

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

    // Portrait Mode
    if (!ResponsiveLayout.isLandscape(context)) {
      final Widget child;
      final String keyName;
      if (pid != null) {
        child = RouterPageView(pageId: pid);
        keyName = 'page_$pid';
      } else {
        child = MiddlewareView(middlewareId: mid);
        keyName = 'mid_$mid';
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.linear,
        switchOutCurve: Curves.linear,
        transitionBuilder: (child, animation) => slideTransition(child, animation),
        child: KeyedSubtree(
          key: ValueKey(keyName),
          child: child,
        ),
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
                      ? RouterPageView(pageId: pid)
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