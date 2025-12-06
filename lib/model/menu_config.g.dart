// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuConfigAdapter extends TypeAdapter<MenuConfig> {
  @override
  final int typeId = 3;

  @override
  MenuConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuConfig(
      id: fields[0] as String,
      label: fields[1] as String,
      type: fields[2] as String,
      targetId: fields[3] as String?,
      icon: fields[4] as String?,
      children: (fields[5] as List).cast<MenuConfig>(),
    );
  }

  @override
  void write(BinaryWriter writer, MenuConfig obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.targetId)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
