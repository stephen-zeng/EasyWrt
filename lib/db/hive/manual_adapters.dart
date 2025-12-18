import 'package:hive/hive.dart';
import '../models/app_setting_item.dart';
import '../models/hierarchy_items.dart';
import '../models/router_item.dart';

/// RouterItemAdapter
/// RouterItemAdapter
/// 
/// Function: Hive TypeAdapter for RouterItem.
/// Function: RouterItem 的 Hive 类型适配器。
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
}

/// AppSettingItemAdapter
/// AppSettingItemAdapter
/// 
/// Function: Hive TypeAdapter for AppSettingItem.
/// Function: AppSettingItem 的 Hive 类型适配器。
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
}

/// ThemeModeEnumAdapter
/// ThemeModeEnumAdapter
/// 
/// Function: Hive TypeAdapter for ThemeModeEnum.
/// Function: ThemeModeEnum 的 Hive 类型适配器。
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
}

/// MiddlewareItemAdapter
/// MiddlewareItemAdapter
/// 
/// Function: Hive TypeAdapter for MiddlewareItem.
/// Function: MiddlewareItem 的 Hive 类型适配器。
class MiddlewareItemAdapter extends TypeAdapter<MiddlewareItem> {
  @override
  final int typeId = 3;

  @override
  MiddlewareItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MiddlewareItem(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String,
      middlewareChildren: (fields[3] as List?)?.cast<String>(),
      pageChildren: (fields[4] as List?)?.cast<String>(),
      children: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MiddlewareItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.middlewareChildren)
      ..writeByte(4)
      ..write(obj.pageChildren)
      ..writeByte(5)
      ..write(obj.children);
  }
}

/// PageItemAdapter
/// PageItemAdapter
/// 
/// Function: Hive TypeAdapter for PageItem.
/// Function: PageItem 的 Hive 类型适配器。
class PageItemAdapter extends TypeAdapter<PageItem> {
  @override
  final int typeId = 4;

  @override
  PageItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageItem(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String,
      widgetChildren: (fields[3] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PageItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.widgetChildren);
  }
}
