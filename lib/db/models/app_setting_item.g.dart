// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_setting_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingItem _$AppSettingItemFromJson(Map<String, dynamic> json) =>
    AppSettingItem(
      themeMode: $enumDecode(_$ThemeModeEnumEnumMap, json['themeMode']),
      themeColor: (json['themeColor'] as num).toInt(),
      language: json['language'] as String,
    );

Map<String, dynamic> _$AppSettingItemToJson(AppSettingItem instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumEnumMap[instance.themeMode]!,
      'themeColor': instance.themeColor,
      'language': instance.language,
    };

const _$ThemeModeEnumEnumMap = {
  ThemeModeEnum.system: 'system',
  ThemeModeEnum.light: 'light',
  ThemeModeEnum.dark: 'dark',
  ThemeModeEnum.oled: 'oled',
};
