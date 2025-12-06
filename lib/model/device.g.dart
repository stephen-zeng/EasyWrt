// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceAdapter extends TypeAdapter<Device> {
  @override
  final int typeId = 1;

  @override
  Device read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Device(
      uuid: fields[0] as String,
      rootMiddleware: fields[8] as Middleware,
      name: fields[1] as String,
      luciUsername: fields[2] as String,
      luciPassword: fields[3] as String,
      luciBaseURL: fields[4] as String,
      token: fields[9] as String,
      luciUnsafe: fields[5] as bool,
      SSHUsername: fields[6] as String,
      SSHPassword: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Device obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.luciUsername)
      ..writeByte(3)
      ..write(obj.luciPassword)
      ..writeByte(4)
      ..write(obj.luciBaseURL)
      ..writeByte(5)
      ..write(obj.luciUnsafe)
      ..writeByte(6)
      ..write(obj.SSHUsername)
      ..writeByte(7)
      ..write(obj.SSHPassword)
      ..writeByte(8)
      ..write(obj.rootMiddleware)
      ..writeByte(9)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
