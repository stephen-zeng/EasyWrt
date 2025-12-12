import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'router_item.g.dart';

/// RouterItem
/// 
/// Function: Entity representing a stored router configuration.
/// Inputs: 
///   - [id], [name], [host], [port], [username], [password], [isHttps]: Router details.
/// Outputs: 
///   - [RouterItem]: The entity instance.
@HiveType(typeId: 0)
@JsonSerializable()
class RouterItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String host;

  @HiveField(3)
  final int port;

  @HiveField(4)
  final String username;

  @HiveField(5)
  final String password;

  @HiveField(6)
  final bool isHttps;

  RouterItem({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.isHttps,
  });

  factory RouterItem.fromJson(Map<String, dynamic> json) =>
      _$RouterItemFromJson(json);

  Map<String, dynamic> toJson() => _$RouterItemToJson(this);
}
