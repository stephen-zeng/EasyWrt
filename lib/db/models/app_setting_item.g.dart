// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingItemAdapter extends TypeAdapter<AppSettingItem> {
  @override
  final int typeId = 2;

  @override
  AppSettingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingItem(
      themeMode: fields[0] as ThemeModeEnum,
      themeColor: fields[1] as int,
      language: fields[2] as String,
      lastConnectedRouterId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.themeColor)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.lastConnectedRouterId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeModeEnumAdapter extends TypeAdapter<ThemeModeEnum> {
  @override
  final int typeId = 1;

  @override
  ThemeModeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeModeEnum.system;
      case 1:
        return ThemeModeEnum.light;
      case 2:
        return ThemeModeEnum.dark;
      case 3:
        return ThemeModeEnum.oled;
      default:
        return ThemeModeEnum.system;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeModeEnum obj) {
    switch (obj) {
      case ThemeModeEnum.system:
        writer.writeByte(0);
        break;
      case ThemeModeEnum.light:
        writer.writeByte(1);
        break;
      case ThemeModeEnum.dark:
        writer.writeByte(2);
        break;
      case ThemeModeEnum.oled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingItem _$AppSettingItemFromJson(Map<String, dynamic> json) =>
    AppSettingItem(
      themeMode: $enumDecode(_$ThemeModeEnumEnumMap, json['themeMode']),
      themeColor: (json['themeColor'] as num).toInt(),
      language: json['language'] as String,
      lastConnectedRouterId: json['lastConnectedRouterId'] as String?,
    );

Map<String, dynamic> _$AppSettingItemToJson(AppSettingItem instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumEnumMap[instance.themeMode]!,
      'themeColor': instance.themeColor,
      'language': instance.language,
      'lastConnectedRouterId': instance.lastConnectedRouterId,
    };

const _$ThemeModeEnumEnumMap = {
  ThemeModeEnum.system: 'system',
  ThemeModeEnum.light: 'light',
  ThemeModeEnum.dark: 'dark',
  ThemeModeEnum.oled: 'oled',
};
