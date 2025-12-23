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
///   - [isEditable]: Whether the user can edit this page.
///   - [isEditable]: 用户是否可以编辑此页面。
///   - [stripes]: Ordered list of stripes (layout configuration).
///   - [stripes]: 条带的有序列表（布局配置）。
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

  @HiveField(4, defaultValue: false)
  final bool isEditable;

  @HiveField(5)
  final List<StripeItem>? stripes;

  PageItem({
    required this.id,
    required this.name,
    required this.icon,
    this.widgetChildren,
    this.isEditable = false,
    this.stripes,
  });

  factory PageItem.fromJson(Map<String, dynamic> json) =>
      _$PageItemFromJson(json);

  Map<String, dynamic> toJson() => _$PageItemToJson(this);
}

/// StripeItem
/// StripeItem
/// 
/// Function: Represents one horizontal section (stripe) within a page.
/// Function: 代表页面中的一个水平部分（stripe）。
@HiveType(typeId: 5)
@JsonSerializable()
class StripeItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<WidgetInstance> widgets;

  StripeItem({
    required this.id,
    required this.widgets,
  });

  factory StripeItem.fromJson(Map<String, dynamic> json) =>
      _$StripeItemFromJson(json);

  Map<String, dynamic> toJson() => _$StripeItemToJson(this);
}

/// WidgetInstance
/// WidgetInstance
/// 
/// Function: Represents a specific instance of a widget placed on the grid.
/// Function: 代表放置在网格上的组件的具体实例。
@HiveType(typeId: 6)
@JsonSerializable()
class WidgetInstance extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String widgetTypeKey;

  @HiveField(2)
  final int x;

  @HiveField(3)
  final int y;

  @HiveField(4)
  final int width;

  @HiveField(5)
  final int height;

  @HiveField(6)
  final Map<String, dynamic>? configuration;

  WidgetInstance({
    required this.id,
    required this.widgetTypeKey,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.configuration,
  });

  factory WidgetInstance.fromJson(Map<String, dynamic> json) =>
      _$WidgetInstanceFromJson(json);

  Map<String, dynamic> toJson() => _$WidgetInstanceToJson(this);
}
