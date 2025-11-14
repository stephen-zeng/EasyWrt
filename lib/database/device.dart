import 'package:easywrt/database/storage.dart';
import 'package:easywrt/default/middleware.dart';
import 'package:easywrt/model/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

part 'device.g.dart';

class DeviceController = _DeviceControllerBase with _$DeviceController;
abstract class _DeviceControllerBase with Store {
  Box<Device> deviceBox = HiveDB.devices;

  @observable
  ObservableList<Device> devices = ObservableList<Device>();

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
    Device device = Device(
      uuid: const Uuid().v4(),
      name: name,
      token: token,
      luciUsername: luciUsername,
      luciPassword: luciPassword,
      luciBaseURL: luciBaseURL,
      rootMiddleware: DefaultMiddleware.middlewareRoot,
    );
    deviceBox.put(device.uuid, device);
    debugPrint('New Device: ${device.name} (${device.uuid}, ${device.token})');
    init();
    return device.uuid;
  }

  void editDevice(Device device){
    deviceBox.put(device.uuid, device);
    init();
  }

  void deleteDevice(String uuid){
    deviceBox.delete(uuid);
    init();
  }

  Device? getDeviceByUUID(String uuid){
    return deviceBox.get(uuid);
  }

  Device? getDeviceByName(String name){
    try {
      return deviceBox.values.firstWhere((device) => device.name == name);
    } catch (_) {
      return null;
    }
  }
}