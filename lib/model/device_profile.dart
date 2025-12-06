import 'package:hive/hive.dart';

part 'device_profile.g.dart';

@HiveType(typeId: 1)
class DeviceProfile extends HiveObject {
  @HiveField(0)
  final String uuid;

  @HiveField(1)
  String name;

  @HiveField(2)
  String hostname;

  @HiveField(3)
  int port;

  @HiveField(4)
  String protocol;

  @HiveField(5)
  String username;

  @HiveField(6)
  String password; // Encrypted

  @HiveField(7)
  String rootPath;

  @HiveField(8)
  String token;

  DeviceProfile({
    required this.uuid,
    required this.name,
    required this.hostname,
    this.port = 80,
    this.protocol = 'http',
    this.username = 'root',
    required this.password,
    this.rootPath = '/cgi-bin/luci/rpc',
    this.token = '',
  });

  String get luciBaseURL => '$protocol://$hostname:$port';
  String get luciUsername => username;
  String get luciPassword => password;
}
