import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_setting_item.g.dart';

/// ThemeModeEnum
/// ThemeModeEnum
/// 
/// Function: Enum for application theme modes.
/// Function: 应用程序主题模式的枚举。
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
/// AppSettingItem
/// 
/// Function: Entity representing global application settings.
/// Function: 代表全局应用程序设置的实体。
/// Inputs: 
/// Inputs: 
///   - [themeMode], [themeColor], [language]: Setting values.
///   - [themeMode], [themeColor], [language]: 设置值。
/// Outputs: 
/// Outputs: 
///   - [AppSettingItem]: The entity instance.
///   - [AppSettingItem]: 实体实例。
@HiveType(typeId: 2)
@JsonSerializable()
class AppSettingItem extends HiveObject {
  @HiveField(0)
  final ThemeModeEnum themeMode;

  @HiveField(1)
  final int themeColor;

  @HiveField(2)
  final String language;

  @HiveField(3)
  final String? lastConnectedRouterId;

  AppSettingItem({
    required this.themeMode,
    required this.themeColor,
    required this.language,
    this.lastConnectedRouterId,
  });

  factory AppSettingItem.fromJson(Map<String, dynamic> json) =>
      _$AppSettingItemFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingItemToJson(this);

  AppSettingItem copyWith({
    ThemeModeEnum? themeMode,
    int? themeColor,
    String? language,
    String? lastConnectedRouterId,
  }) {
    return AppSettingItem(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
      language: language ?? this.language,
      lastConnectedRouterId: lastConnectedRouterId ?? this.lastConnectedRouterId,
    );
  }
}
