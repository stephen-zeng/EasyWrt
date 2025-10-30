// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppAdapter extends TypeAdapter<App> {
  @override
  final int typeId = 10;

  @override
  App read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return App(
      appSecurity: fields[0] as AppSecurity?,
      appPreferences: fields[1] as AppPreferences?,
    );
  }

  @override
  void write(BinaryWriter writer, App obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.appSecurity)
      ..writeByte(1)
      ..write(obj.appPreferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppSecurityAdapter extends TypeAdapter<AppSecurity> {
  @override
  final int typeId = 11;

  @override
  AppSecurity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSecurity(
      securityEnabled: fields[0] as bool,
      PINHash: fields[1] as String,
      biometricsEnabled: fields[2] as bool,
      PasskeyHash: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppSecurity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.securityEnabled)
      ..writeByte(1)
      ..write(obj.PINHash)
      ..writeByte(2)
      ..write(obj.biometricsEnabled)
      ..writeByte(3)
      ..write(obj.PasskeyHash);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSecurityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppPreferencesAdapter extends TypeAdapter<AppPreferences> {
  @override
  final int typeId = 12;

  @override
  AppPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppPreferences(
      darkMode: fields[0] as int,
      color: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppPreferences obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.darkMode)
      ..writeByte(1)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
