import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../beam/responsive_layout.dart';
import 'middleware/middleware_view.dart';
import 'page/page_view.dart';

/// RouterSplitWrapper
/// RouterSplitWrapper
/// 
/// Function: Handles split-view layout logic using Query Parameters.
/// Function: 使用查询参数处理拆分视图布局逻辑。
/// Inputs: 
/// Inputs: 
///   - [state]: GoRouter state to extract 'mid' and 'pid'.
///   - [state]: 提取 'mid' 和 'pid' 的 GoRouter 状态。
/// Outputs: 
/// Outputs: 
///   - [Widget]: Split view (Landscape) or Single view (Portrait).
///   - [Widget]: 拆分视图（横向）或单视图（纵向）。
class RouterSplitWrapper extends StatelessWidget {
  final GoRouterState state;

  const RouterSplitWrapper({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final mid = state.uri.queryParameters['mid'] ?? 'router_root';
    final pid = state.uri.queryParameters['pid'];

    // Slide Transition Builder
    // 滑动过渡构建器
    Widget slideTransition(Widget child, Animation<double> animation) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.2, 0.0), // Slight slide from right
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: FadeTransition(opacity: animation, child: child),
      );
    }

    // Portrait Mode
    // 纵向模式
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
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: slideTransition,
        child: KeyedSubtree(
          key: ValueKey(keyName),
          child: child,
        ),
      );
    }

    // Landscape Mode
    // 横向模式
    return Row(
      children: [
        SizedBox(
          width: 400,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: slideTransition, // Slide for Left Pane too
            child: KeyedSubtree(
              key: ValueKey('left_$mid'),
              child: MiddlewareView(middlewareId: mid),
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
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
  }
}
