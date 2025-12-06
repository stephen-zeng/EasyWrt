import 'package:easywrt/database/storage.dart';
import 'package:easywrt/model/device_profile.dart'; // Changed from device.dart
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'device.g.dart';

class DeviceController = _DeviceControllerBase with _$DeviceController;
abstract class _DeviceControllerBase with Store {
  Box<DeviceProfile> deviceBox = HiveDB.devices; // Changed to DeviceProfile

  @observable
  ObservableList<DeviceProfile> devices = ObservableList<DeviceProfile>(); // Changed to DeviceProfile

  void init() {
    var temp = deviceBox.values.toList();
    temp.sort((a, b) => a.name.compareTo(b.name));
    devices.clear();
    devices.addAll(temp);
  }

  String newDevice({
    required String name,
    required String luciUsername,
    required String luciPassword,
    required String luciBaseURL,
    required String token,
  }){
    final Uri uri = Uri.parse(luciBaseURL);
    DeviceProfile device = DeviceProfile(
      uuid: const Uuid().v4(),
      name: name,
      token: token,
      username: luciUsername, // Changed from luciUsername
      password: luciPassword, // Changed from luciPassword
      hostname: uri.host, // Parsed from luciBaseURL
      protocol: uri.scheme, // Parsed from luciBaseURL
      port: uri.port, // Parsed from luciBaseURL
      // rootPath: DefaultMiddleware.middlewareRoot, // Removed as not in DeviceProfile
    );
    deviceBox.put(device.uuid, device);
    debugPrint('New Device: ${device.name} (${device.uuid}, ${device.token})');
    init();
    return device.uuid;
  }

  void editDevice(DeviceProfile device){ // Changed to DeviceProfile
    deviceBox.put(device.uuid, device);
    init();
  }

  void deleteDevice(String uuid){
    deviceBox.delete(uuid);
    init();
  }

  DeviceProfile? getDeviceByUUID(String uuid){ // Changed to DeviceProfile
    return deviceBox.get(uuid);
  }

  DeviceProfile? getDeviceByName(String name){ // Changed to DeviceProfile
    try {
      return deviceBox.values.firstWhere((device) => device.name == name);
    } catch (_) {
      return null;
    }
  }
}