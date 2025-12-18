import 'package:freezed_annotation/freezed_annotation.dart';
import 'router_item.dart';
import 'hierarchy_items.dart';

part 'transient_models.freezed.dart';
part 'transient_models.g.dart';

/// CurrentRouter
/// CurrentRouter
/// 
/// Function: Transient model for currently selected router state.
/// Function: 当前选定路由器状态的临时模型。
@freezed
abstract class CurrentRouter with _$CurrentRouter {
  const factory CurrentRouter({
    required RouterItem routerItem,
    String? token,
  }) = _CurrentRouter;

  factory CurrentRouter.fromJson(Map<String, dynamic> json) =>
      _$CurrentRouterFromJson(json);
}

/// CurrentMiddleware
/// CurrentMiddleware
/// 
/// Function: Transient model for currently active middleware state with history.
/// Function: 带有历史记录的当前活动中间件状态的临时模型。
@freezed
abstract class CurrentMiddleware with _$CurrentMiddleware {
  const factory CurrentMiddleware({
    required MiddlewareItem middlewareItem,
    required List<String> historyMiddlewareIDs,
    required String slideMiddlewareID,
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
abstract class CurrentPage with _$CurrentPage {
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
