import 'package:freezed_annotation/freezed_annotation.dart';

part 'transient_models.freezed.dart';
part 'transient_models.g.dart';

/// CurrentRouter
/// CurrentRouter
/// 
/// Function: Transient model for currently selected router state.
/// Function: 当前选定路由器状态的临时模型。
@freezed
class CurrentRouter with _$CurrentRouter {
  const factory CurrentRouter({
    required String id,
    required String name,
    required String host,
    required int port,
    required String username,
    required String password,
    required bool isHttps,
  }) = _CurrentRouter;

  factory CurrentRouter.fromJson(Map<String, dynamic> json) =>
      _$CurrentRouterFromJson(json);
}

/// CurrentMiddleware
/// CurrentMiddleware
/// 
/// Function: Transient model for currently active middleware state.
/// Function: 当前活动中间件状态的临时模型。
@freezed
class CurrentMiddleware with _$CurrentMiddleware {
  const factory CurrentMiddleware({
    required String id,
    required List<String> path,
    required String name,
    required String icon,
    List<String>? middlewareChildren,
    List<String>? pageChildren,
  }) = _CurrentMiddleware;

  factory CurrentMiddleware.fromJson(Map<String, dynamic> json) =>
      _$CurrentMiddlewareFromJson(json);
}

/// CurrentPage
/// CurrentPage
/// 
/// Function: Transient model for currently active page state.
/// Function: 当前活动页面状态的临时模型。
@freezed
class CurrentPage with _$CurrentPage {
  const factory CurrentPage({
    required String id,
    required List<String> path,
    required String name,
    required String icon,
    List<String>? widgetChildren,
  }) = _CurrentPage;

  factory CurrentPage.fromJson(Map<String, dynamic> json) =>
      _$CurrentPageFromJson(json);
}
