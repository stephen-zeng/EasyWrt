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
      middlewareItem: MiddlewareItem.fromJson(
        json['middlewareItem'] as Map<String, dynamic>,
      ),
      historyMiddlewareIDs: (json['historyMiddlewareIDs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      slideMiddlewareID: json['slideMiddlewareID'] as String,
    );

Map<String, dynamic> _$CurrentMiddlewareToJson(_CurrentMiddleware instance) =>
    <String, dynamic>{
      'middlewareItem': instance.middlewareItem,
      'historyMiddlewareIDs': instance.historyMiddlewareIDs,
      'slideMiddlewareID': instance.slideMiddlewareID,
    };

_CurrentPage _$CurrentPageFromJson(Map<String, dynamic> json) => _CurrentPage(
  id: json['id'] as String,
  path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
  name: json['name'] as String,
  icon: json['icon'] as String,
  isEditMode: json['isEditMode'] as bool? ?? false,
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
      'isEditMode': instance.isEditMode,
      'widgetChildren': instance.widgetChildren,
    };
