import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hierarchy_items.g.dart';

/// MiddlewareItem
/// 
/// Function: Entity representing a navigation node (Middleware) in the router hierarchy.
/// Inputs: 
///   - [id], [name], [icon]: Basic info.
///   - [middlewareChildren], [pageChildren], [children]: Child node IDs.
/// Outputs: 
///   - [MiddlewareItem]: The entity instance.
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
/// 
/// Function: Entity representing a leaf node (Page) in the router hierarchy.
/// Inputs: 
///   - [id], [name], [icon]: Basic info.
///   - [widgetChildren]: List of widget IDs to display.
/// Outputs: 
///   - [PageItem]: The entity instance.
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
