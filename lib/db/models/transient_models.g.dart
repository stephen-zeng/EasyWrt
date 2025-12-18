// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transient_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CurrentRouter _$CurrentRouterFromJson(Map<String, dynamic> json) =>
    _CurrentRouter(
      routerItem: RouterItem.fromJson(
        json['routerItem'] as Map<String, dynamic>,
      ),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$CurrentRouterToJson(_CurrentRouter instance) =>
    <String, dynamic>{
      'routerItem': instance.routerItem,
      'token': instance.token,
    };

_CurrentMiddleware _$CurrentMiddlewareFromJson(Map<String, dynamic> json) =>
    _CurrentMiddleware(
      id: json['id'] as String,
      path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      middlewareChildren: (json['middlewareChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pageChildren: (json['pageChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CurrentMiddlewareToJson(_CurrentMiddleware instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'name': instance.name,
      'icon': instance.icon,
      'middlewareChildren': instance.middlewareChildren,
      'pageChildren': instance.pageChildren,
    };

_CurrentPage _$CurrentPageFromJson(Map<String, dynamic> json) => _CurrentPage(
  id: json['id'] as String,
  path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
  name: json['name'] as String,
  icon: json['icon'] as String,
  widgetChildren: (json['widgetChildren'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CurrentPageToJson(_CurrentPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'name': instance.name,
      'icon': instance.icon,
      'widgetChildren': instance.widgetChildren,
    };
