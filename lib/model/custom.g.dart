// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MiddlewareAdapter extends TypeAdapter<Middleware> {
  @override
  final int typeId = 20;

  @override
  Middleware read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Middleware(
      middlewares: (fields[0] as List).cast<Middleware>(),
      pages: (fields[1] as List).cast<Page>(),
      icon: fields[5] as String,
      fatherPath: fields[2] as String,
      name: fields[3] as String,
      path: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Middleware obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.middlewares)
      ..writeByte(1)
      ..write(obj.pages)
      ..writeByte(2)
      ..write(obj.fatherPath)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.path)
      ..writeByte(5)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiddlewareAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PageAdapter extends TypeAdapter<Page> {
  @override
  final int typeId = 21;

  @override
  Page read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Page(
      name: fields[0] as String,
      path: fields[1] as String,
      fatherPath: fields[2] as String,
      icon: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Page obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.fatherPath)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
