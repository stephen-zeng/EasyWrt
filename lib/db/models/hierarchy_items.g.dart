// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hierarchy_items.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiddlewareItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      isEditable: fields[4] == null ? false : fields[4] as bool,
      stripes: (fields[5] as List?)?.cast<StripeItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, PageItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.widgetChildren)
      ..writeByte(4)
      ..write(obj.isEditable)
      ..writeByte(5)
      ..write(obj.stripes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StripeItemAdapter extends TypeAdapter<StripeItem> {
  @override
  final int typeId = 5;

  @override
  StripeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StripeItem(
      id: fields[0] as String,
      widgets: (fields[1] as List).cast<WidgetInstance>(),
    );
  }

  @override
  void write(BinaryWriter writer, StripeItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.widgets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StripeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WidgetInstanceAdapter extends TypeAdapter<WidgetInstance> {
  @override
  final int typeId = 6;

  @override
  WidgetInstance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WidgetInstance(
      id: fields[0] as String,
      widgetTypeKey: fields[1] as String,
      x: fields[2] as int,
      y: fields[3] as int,
      width: fields[4] as int,
      height: fields[5] as int,
      configuration: (fields[6] as Map?)?.cast<String, dynamic>(),
      supportedSizes:
          fields[7] == null ? [] : (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WidgetInstance obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.widgetTypeKey)
      ..writeByte(2)
      ..write(obj.x)
      ..writeByte(3)
      ..write(obj.y)
      ..writeByte(4)
      ..write(obj.width)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.configuration)
      ..writeByte(7)
      ..write(obj.supportedSizes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetInstanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiddlewareItem _$MiddlewareItemFromJson(Map<String, dynamic> json) =>
    MiddlewareItem(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      middlewareChildren: (json['middlewareChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      pageChildren: (json['pageChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MiddlewareItemToJson(MiddlewareItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'middlewareChildren': instance.middlewareChildren,
      'pageChildren': instance.pageChildren,
      'children': instance.children,
    };

PageItem _$PageItemFromJson(Map<String, dynamic> json) => PageItem(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      widgetChildren: (json['widgetChildren'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isEditable: json['isEditable'] as bool? ?? false,
      stripes: (json['stripes'] as List<dynamic>?)
          ?.map((e) => StripeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PageItemToJson(PageItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'widgetChildren': instance.widgetChildren,
      'isEditable': instance.isEditable,
      'stripes': instance.stripes,
    };

StripeItem _$StripeItemFromJson(Map<String, dynamic> json) => StripeItem(
      id: json['id'] as String,
      widgets: (json['widgets'] as List<dynamic>)
          .map((e) => WidgetInstance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StripeItemToJson(StripeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'widgets': instance.widgets,
    };

WidgetInstance _$WidgetInstanceFromJson(Map<String, dynamic> json) =>
    WidgetInstance(
      id: json['id'] as String,
      widgetTypeKey: json['widgetTypeKey'] as String,
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      configuration: json['configuration'] as Map<String, dynamic>?,
      supportedSizes: (json['supportedSizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WidgetInstanceToJson(WidgetInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'widgetTypeKey': instance.widgetTypeKey,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'configuration': instance.configuration,
      'supportedSizes': instance.supportedSizes,
    };
