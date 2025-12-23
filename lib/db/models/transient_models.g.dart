// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transient_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CurrentRouterImpl _$$CurrentRouterImplFromJson(Map<String, dynamic> json) =>
    _$CurrentRouterImpl(
      routerItem:
          RouterItem.fromJson(json['routerItem'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$CurrentRouterImplToJson(_$CurrentRouterImpl instance) =>
    <String, dynamic>{
      'routerItem': instance.routerItem,
      'token': instance.token,
    };

_$CurrentMiddlewareImpl _$$CurrentMiddlewareImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrentMiddlewareImpl(
      middlewareItem: MiddlewareItem.fromJson(
          json['middlewareItem'] as Map<String, dynamic>),
      historyMiddlewareIDs: (json['historyMiddlewareIDs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      slideMiddlewareID: json['slideMiddlewareID'] as String,
    );

Map<String, dynamic> _$$CurrentMiddlewareImplToJson(
        _$CurrentMiddlewareImpl instance) =>
    <String, dynamic>{
      'middlewareItem': instance.middlewareItem,
      'historyMiddlewareIDs': instance.historyMiddlewareIDs,
      'slideMiddlewareID': instance.slideMiddlewareID,
    };

_$CurrentPageImpl _$$CurrentPageImplFromJson(Map<String, dynamic> json) =>
    _$CurrentPageImpl(
      id: json['id'] as String,
      path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String,
      icon: json['icon'] as String,
      isEditMode: json['isEditMode'] as bool? ?? false,
      widgetChildren: (json['widgetChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CurrentPageImplToJson(_$CurrentPageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'name': instance.name,
      'icon': instance.icon,
      'isEditMode': instance.isEditMode,
      'widgetChildren': instance.widgetChildren,
    };
