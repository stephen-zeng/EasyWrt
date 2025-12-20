// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hierarchy_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiddlewareItem _$MiddlewareItemFromJson(Map<String, dynamic> json) =>
    MiddlewareItem(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      middlewareChildren: (json['middlewareChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pageChildren: (json['pageChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MiddlewareItemToJson(MiddlewareItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'middlewareChildren': instance.middlewareChildren,
      'pageChildren': instance.pageChildren,
      'children': instance.children,
    };

PageItem _$PageItemFromJson(Map<String, dynamic> json) => PageItem(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String,
  widgetChildren: (json['widgetChildren'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PageItemToJson(PageItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'widgetChildren': instance.widgetChildren,
};
