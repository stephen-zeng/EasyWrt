import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_scaffold.dart';

import 'modules/router/router_split_wrapper.dart';
import 'modules/setting/middlewares/setting_root_middleware.dart';
import 'modules/setting/pages/router_management_page.dart';
import 'modules/setting/pages/theme_page.dart';

/// routerProvider
/// 
/// Function: Provides the GoRouter configuration for the application.
/// Inputs: 
///   - [ref]: Riverpod ref to watch providers.
/// Outputs: 
///   - [GoRouter]: Configured router.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/setting', // Start at setting for MVP as per plan
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // Router Module using Query Parameters for independent pane state
          // Path: /router?mid=...&pid=...
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
