import 'package:hive/hive.dart';

part 'menu_config.g.dart';

@HiveType(typeId: 3) // Assuming typeId 2 is AppSettings
class MenuConfig extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String label;

  @HiveField(2)
  String type; // "group", "middleware", "function"

  @HiveField(3)
  String? targetId;

  @HiveField(4)
  String? icon;

  @HiveField(5)
  List<MenuConfig> children;

  MenuConfig({
    required this.id,
    required this.label,
    required this.type,
    this.targetId,
    this.icon,
    this.children = const [],
  });
}
