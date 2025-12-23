// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouterItemAdapter extends TypeAdapter<RouterItem> {
  @override
  final int typeId = 0;

  @override
  RouterItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouterItem(
      id: fields[0] as String,
      name: fields[1] as String,
      host: fields[2] as String,
      port: fields[3] as int,
      username: fields[4] as String,
      password: fields[5] as String,
      isHttps: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RouterItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.host)
      ..writeByte(3)
      ..write(obj.port)
      ..writeByte(4)
      ..write(obj.username)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.isHttps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouterItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
