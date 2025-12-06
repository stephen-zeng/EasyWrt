import 'package:easywrt/model/device_profile.dart';
import 'package:easywrt/provider/device_provider.dart';
import 'package:easywrt/utils/wrt.dart'; // To interact with OpenWrt

class McpTools {
  static List<Map<String, dynamic>> listDevices(DeviceProvider deviceProvider) {
    return deviceProvider.devices.map((device) => {
      'uuid': device.uuid,
      'name': device.name,
      'hostname': device.hostname,
      // 'status': 'connected' // Placeholder, actual status would require ping/API call
    }).toList();
  }

  static Future<Map<String, dynamic>> getDeviceInfo(String deviceUuid, DeviceProvider deviceProvider) async {
    final device = deviceProvider.devices.firstWhere((d) => d.uuid == deviceUuid, orElse: () => throw Exception('Device not found'));

    try {
      // Example of calling OpenWrt API
      final result = await Wrt.call(device.uuid, [
        ['system', 'board']
      ]);
      return {'device': device.name, 'info': result.first};
    } catch (e) {
      return {'error': 'Failed to get device info: $e'};
    }
  }

  static Future<Map<String, dynamic>> rebootDevice(String deviceUuid, DeviceProvider deviceProvider) async {
    final device = deviceProvider.devices.firstWhere((d) => d.uuid == deviceUuid, orElse: () => throw Exception('Device not found'));

    try {
      // Example of calling OpenWrt API to reboot
      await Wrt.call(device.uuid, [
        ['system', 'reboot']
      ]);
      return {'device': device.name, 'status': 'reboot initiated'};
    } catch (e) {
      return {'error': 'Failed to reboot device: $e'};
    }
  }
}
