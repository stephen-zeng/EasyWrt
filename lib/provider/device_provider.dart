import 'package:flutter/foundation.dart';
import 'package:easywrt/database/device.dart';
import 'package:easywrt/model/device_profile.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceController _deviceController = DeviceController();

  DeviceProfile? _activeDevice;
  List<DeviceProfile> _devices = [];

  DeviceProvider() {
    loadDevices();
    if (_devices.isNotEmpty) {
      _activeDevice = _devices.first; // Set first device as active by default
    }
  }

  DeviceProfile? get activeDevice => _activeDevice;
  List<DeviceProfile> get devices => _devices;

  void setActiveDevice(DeviceProfile device) {
    if (_activeDevice?.uuid != device.uuid) {
      _activeDevice = device;
      notifyListeners();
    }
  }

  void loadDevices() {
    _deviceController.init(); // Re-initialize MobX observable list
    _devices = _deviceController.devices.toList();
    notifyListeners();
  }

  // Method to add a new device
  String addDevice({
    required String name,
    required String luciUsername,
    required String luciPassword,
    required String luciBaseURL,
    required String token,
  }) {
    final uuid = _deviceController.newDevice(
      name: name,
      luciUsername: luciUsername,
      luciPassword: luciPassword,
      luciBaseURL: luciBaseURL,
      token: token,
    );
    loadDevices(); // Reload devices after adding
    final newDevice = _devices.firstWhere((d) => d.uuid == uuid);
    setActiveDevice(newDevice); // Set new device as active
    return uuid;
  }

  // Method to edit an existing device
  void editDevice(DeviceProfile device) {
    _deviceController.editDevice(device);
    loadDevices(); // Reload devices after editing
    if (_activeDevice?.uuid == device.uuid) {
      setActiveDevice(device); // Update active device if it was the edited one
    }
  }

  // Method to delete a device
  void deleteDevice(String uuid) {
    _deviceController.deleteDevice(uuid);
    loadDevices(); // Reload devices after deleting
    if (_activeDevice?.uuid == uuid) {
      _activeDevice = _devices.isNotEmpty ? _devices.first : null; // Set new active or null
    }
    notifyListeners();
  }
}
