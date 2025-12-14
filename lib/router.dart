import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_scaffold.dart';

import 'modules/router/router_split_wrapper.dart';
import 'modules/setting/middlewares/setting_root_middleware.dart';
import 'modules/setting/pages/router_management_page.dart';
import 'modules/setting/pages/theme_page.dart';

/// routerProvider
/// routerProvider
/// 
/// Function: Provides the GoRouter configuration for the application.
/// Function: 为应用程序提供 GoRouter 配置。
/// Inputs: 
/// Inputs: 
///   - [ref]: Riverpod ref to watch providers.
///   - [ref]: 用于监听 provider 的 Riverpod ref。
/// Outputs: 
/// Outputs: 
///   - [GoRouter]: Configured router.
///   - [GoRouter]: 配置好的路由器。
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/router', // Start at router module to show status immediately
                                 // 从 Router 模块开始以立即显示状态
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // Router Module using Query Parameters for independent pane state
          // Router 模块使用查询参数来实现独立的面板状态
          // Path: /router?mid=...&pid=...
          // 路径: /router?mid=...&pid=...
          GoRoute(
            path: '/router',
            builder: (context, state) {
              return RouterSplitWrapper(state: state);
            },
          ),
          GoRoute(
            path: '/setting',
            builder: (context, state) => const SettingRootMiddleware(),
            routes: [
              GoRoute(
                path: 'router_manager',
                builder: (context, state) => const RouterManagementPage(),
              ),
              GoRoute(
                path: 'theme',
                builder: (context, state) => const ThemePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
