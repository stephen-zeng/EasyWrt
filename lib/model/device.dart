import 'package:hive/hive.dart';
import 'package:easywrt/database/storage.dart';
import 'custom.dart';

part 'device.g.dart';

@HiveType(typeId: HiveDB.deviceBoxTypeId)
class Device {
  @HiveField(0)
  String uuid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String luciUsername;
  @HiveField(3)
  String luciPassword;
  @HiveField(4)
  String luciBaseURL;
  @HiveField(5)
  bool luciUnsafe;
  @HiveField(6)
  String SSHUsername;
  @HiveField(7)
  String SSHPassword;
  @HiveField(8)
  Middleware rootMiddleware;
  @HiveField(9)
  String token;

  Device({
    required this.uuid,
    required this.rootMiddleware,
    required this.name,
    required this.luciUsername,
    required this.luciPassword,
    required this.luciBaseURL,
    required this.token,
    this.luciUnsafe = false,
    this.SSHUsername = '',
    this.SSHPassword = '',
  });
}