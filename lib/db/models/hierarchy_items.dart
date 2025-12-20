import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hierarchy_items.g.dart';

/// MiddlewareItem
/// MiddlewareItem
/// 
/// Function: Entity representing a navigation node (Middleware) in the router hierarchy.
/// Function: 代表路由器层级中的导航节点（Middleware）的实体。
/// Inputs: 
/// Inputs: 
///   - [id], [name], [icon]: Basic info.
///   - [id], [name], [icon]: 基本信息。
///   - [middlewareChildren], [pageChildren], [children]: Child node IDs.
///   - [middlewareChildren], [pageChildren], [children]: 子节点 ID。
/// Outputs: 
/// Outputs: 
///   - [MiddlewareItem]: The entity instance.
///   - [MiddlewareItem]: 实体实例。
@HiveType(typeId: 3)
@JsonSerializable()
class MiddlewareItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final List<String>? middlewareChildren;

  @HiveField(4)
  final List<String>? pageChildren;

  @HiveField(5)
  final List<String>? children;

  MiddlewareItem({
    required this.id,
    required this.name,
    required this.icon,
    this.middlewareChildren,
    this.pageChildren,
    this.children,
  });

  factory MiddlewareItem.fromJson(Map<String, dynamic> json) =>
      _$MiddlewareItemFromJson(json);

  Map<String, dynamic> toJson() => _$MiddlewareItemToJson(this);
}

/// PageItem
/// PageItem
/// 
/// Function: Entity representing a leaf node (Page) in the router hierarchy.
/// Function: 代表路由器层级中的叶节点（Page）的实体。
/// Inputs: 
/// Inputs: 
///   - [id], [name], [icon]: Basic info.
///   - [id], [name], [icon]: 基本信息。
///   - [widgetChildren]: List of widget IDs to display.
///   - [widgetChildren]: 要显示的组件 ID 列表。
/// Outputs: 
/// Outputs: 
///   - [PageItem]: The entity instance.
///   - [PageItem]: 实体实例。
@HiveType(typeId: 4)
@JsonSerializable()
class PageItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final List<String>? widgetChildren;

  PageItem({
    required this.id,
    required this.name,
    required this.icon,
    this.widgetChildren,
  });

  factory PageItem.fromJson(Map<String, dynamic> json) =>
      _$PageItemFromJson(json);

  Map<String, dynamic> toJson() => _$PageItemToJson(this);
}
