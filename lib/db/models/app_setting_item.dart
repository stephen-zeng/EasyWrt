import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_setting_item.g.dart';

/// ThemeModeEnum
/// 
/// Function: Enum for application theme modes.
@HiveType(typeId: 1)
enum ThemeModeEnum {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
  @HiveField(3)
  oled,
}

/// AppSettingItem
/// 
/// Function: Entity representing global application settings.
/// Inputs: 
///   - [themeMode], [themeColor], [language]: Setting values.
/// Outputs: 
///   - [AppSettingItem]: The entity instance.
@HiveType(typeId: 2)
@JsonSerializable()
class AppSettingItem extends HiveObject {
  @HiveField(0)
  final ThemeModeEnum themeMode;

  @HiveField(1)
  final int themeColor;

  @HiveField(2)
  final String language;

  AppSettingItem({
    required this.themeMode,
    required this.themeColor,
    required this.language,
  });

  factory AppSettingItem.fromJson(Map<String, dynamic> json) =>
      _$AppSettingItemFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingItemToJson(this);
}
