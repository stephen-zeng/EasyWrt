// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouterItem _$RouterItemFromJson(Map<String, dynamic> json) => RouterItem(
  id: json['id'] as String,
  name: json['name'] as String,
  host: json['host'] as String,
  port: (json['port'] as num).toInt(),
  username: json['username'] as String,
  password: json['password'] as String,
  isHttps: json['isHttps'] as bool,
);

Map<String, dynamic> _$RouterItemToJson(RouterItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'host': instance.host,
      'port': instance.port,
      'username': instance.username,
      'password': instance.password,
      'isHttps': instance.isHttps,
    };
