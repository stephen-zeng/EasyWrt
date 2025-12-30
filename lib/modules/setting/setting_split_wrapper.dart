import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easywrt/beam/window/responsive_layout.dart';
import 'middlewares/setting_root_middleware.dart';
import 'pages/router_management_page.dart';
import 'pages/theme_page.dart';

/// SettingSplitWrapper
/// SettingSplitWrapper
/// 
/// Function: Handles split-view layout logic for Settings using Query Parameters.
/// Function: 使用查询参数处理设置模块的拆分视图布局逻辑。
/// Inputs: 
/// Inputs: 
///   - [state]: GoRouter state to extract 'page'.
///   - [state]: 提取 'page' 的 GoRouter 状态。
/// Outputs: 
/// Outputs: 
///   - [Widget]: Split view (Landscape) or Single view (Portrait).
///   - [Widget]: 拆分视图（横向）或单视图（纵向）。
class SettingSplitWrapper extends StatelessWidget {
  final GoRouterState state;

  const SettingSplitWrapper({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final page = state.uri.queryParameters['page'];

    Widget getPageWidget(String? pageName) {
      switch (pageName) {
        case 'router_manager':
          return const RouterManagementPage();
        case 'theme':
          return const ThemePage();
        default:
          return const SettingRootMiddleware();
      }
    }

    // Portrait Mode
    if (!ResponsiveLayout.isLandscape(context)) {
       final List<Page> pages = [
         const CupertinoPage(
           key: ValueKey('mid_setting_root'),
           child: SettingRootMiddleware(),
         ),
       ];
      
       if (page != null) {
          pages.add(CupertinoPage(
            key: ValueKey('page_$page'),
            child: getPageWidget(page),
          ));
       }

       return Navigator(
          key: const ValueKey('setting_navigator'),
          pages: pages,
          onPopPage: (route, result) {
             if (!route.didPop(result)) return false;

             if (page != null) {
                // Popped Page -> Go to Root
                context.go('/setting');
             }
             return true; 
          },
       );
    }

    // Landscape Mode
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: const SettingRootMiddleware(),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey('right_${page ?? 'empty'}'),
              child: page != null 
                  ? getPageWidget(page)
                  : const Scaffold(
                      body: Center(
                        child: Text('Select a setting from the left menu'),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
