import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 2) // Assuming typeId 0 and 1 are taken by App and DeviceProfile
class AppSettings extends HiveObject {
  @HiveField(0)
  bool bioAuthEnabled;

  @HiveField(1)
  bool mcpEnabled;

  @HiveField(2)
  int mcpPort;

  // Constructor
  AppSettings({
    this.bioAuthEnabled = false,
    this.mcpEnabled = false,
    this.mcpPort = 3000,
  });
}
