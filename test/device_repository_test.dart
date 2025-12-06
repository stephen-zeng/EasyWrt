import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:easywrt/database/device.dart';
import 'package:easywrt/database/storage.dart';
import 'package:easywrt/model/device_profile.dart';
import 'package:uuid/uuid.dart';

import 'device_repository_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<Box<DeviceProfile>>(as: #MockDeviceProfileBox, onMissingStub: OnMissingStub.returnDefault)])
void main() {
  group('DeviceController', () {
    late DeviceController deviceController;
    late MockDeviceProfileBox mockDeviceProfileBox;

    setUp(() {
      mockDeviceProfileBox = MockDeviceProfileBox();
      // Initialize HiveDB.devices with our mock box
      HiveDB.devices = mockDeviceProfileBox;
      deviceController = DeviceController();

      // Mock init behavior
      when(mockDeviceProfileBox.values).thenReturn(
          <DeviceProfile>[].toSet().toList()); // Ensure it returns an empty list initially
      deviceController.init();
    });

    test('newDevice adds a device and initializes the list', () {
      final uuid = const Uuid().v4();
      final testDevice = DeviceProfile(
        uuid: uuid,
        name: 'Test Device',
        hostname: '192.168.1.1',
        password: 'password',
        token: 'test_token',
      );

      when(mockDeviceProfileBox.put(any, any)).thenAnswer((_) async {});
      when(mockDeviceProfileBox.values).thenReturn(<DeviceProfile>[testDevice].toSet().toList());

      final returnedUuid = deviceController.newDevice(
        name: testDevice.name,
        luciUsername: testDevice.username,
        luciPassword: testDevice.password,
        luciBaseURL: '${testDevice.protocol}://${testDevice.hostname}:${testDevice.port}/',
        token: testDevice.token,
      );

      expect(returnedUuid, isA<String>());
      verify(mockDeviceProfileBox.put(argThat(isA<String>()), argThat(isA<DeviceProfile>())))
          .called(1);
      expect(deviceController.devices.length, 1);
      expect(deviceController.devices.first.name, 'Test Device');
    });

    test('editDevice updates a device and reinitializes the list', () {
      final uuid = const Uuid().v4();
      final initialDevice = DeviceProfile(
        uuid: uuid,
        name: 'Initial Device',
        hostname: '192.168.1.1',
        password: 'password',
        token: 'initial_token',
      );
      final updatedDevice = DeviceProfile(
        uuid: uuid,
        name: 'Updated Device',
        hostname: '192.168.1.2',
        password: 'new_password',
        token: 'updated_token',
      );

      when(mockDeviceProfileBox.put(any, any)).thenAnswer((_) async {});
      var callCount = 0;
      when(mockDeviceProfileBox.values).thenAnswer((_) {
        if (callCount == 0) {
          callCount++;
          return <DeviceProfile>[initialDevice].toSet().toList();
        }
        return <DeviceProfile>[updatedDevice].toSet().toList();
      });

      // Simulate adding the initial device
      deviceController.newDevice(
        name: initialDevice.name,
        luciUsername: initialDevice.username,
        luciPassword: initialDevice.password,
        luciBaseURL: '${initialDevice.protocol}://${initialDevice.hostname}:${initialDevice.port}/',
        token: initialDevice.token,
      );
      expect(deviceController.devices.first.name, 'Initial Device');

      deviceController.editDevice(updatedDevice);

      verify(mockDeviceProfileBox.put(uuid, updatedDevice)).called(1);
      expect(deviceController.devices.length, 1);
      expect(deviceController.devices.first.name, 'Updated Device');
    });

    test('deleteDevice removes a device and reinitializes the list', () {
      final uuid = const Uuid().v4();
      final testDevice = DeviceProfile(
        uuid: uuid,
        name: 'Test Device',
        hostname: '192.168.1.1',
        password: 'password',
        token: 'test_token',
      );

      when(mockDeviceProfileBox.put(any, any)).thenAnswer((_) async {});
      when(mockDeviceProfileBox.delete(any)).thenAnswer((_) async {});
      var callCount = 0;
      when(mockDeviceProfileBox.values).thenAnswer((_) {
        if (callCount == 0) {
          callCount++;
          return <DeviceProfile>[testDevice].toSet().toList();
        }
        return <DeviceProfile>[].toSet().toList();
      });

      // Simulate adding the device
      deviceController.newDevice(
        name: testDevice.name,
        luciUsername: testDevice.username,
        luciPassword: testDevice.password,
        luciBaseURL: '${testDevice.protocol}://${testDevice.hostname}:${testDevice.port}/',
        token: testDevice.token,
      );
      expect(deviceController.devices.length, 1);

      deviceController.deleteDevice(uuid);

      verify(mockDeviceProfileBox.delete(uuid)).called(1);
      expect(deviceController.devices.isEmpty, true);
    });

    test('getDeviceByUUID returns the correct device', () {
      final uuid1 = const Uuid().v4();
      final uuid2 = const Uuid().v4();
      final device1 = DeviceProfile(uuid: uuid1, name: 'Device 1', hostname: '1.1.1.1', password: 'p1', token: 't1');
      final device2 = DeviceProfile(uuid: uuid2, name: 'Device 2', hostname: '2.2.2.2', password: 'p2', token: 't2');

      // Use anyNamed('defaultValue') to match the optional argument
      when(mockDeviceProfileBox.get(uuid1, defaultValue: anyNamed('defaultValue'))).thenReturn(device1);
      when(mockDeviceProfileBox.get(uuid2, defaultValue: anyNamed('defaultValue'))).thenReturn(device2);

      final result1 = deviceController.getDeviceByUUID(uuid1);
      final result2 = deviceController.getDeviceByUUID(uuid2);
      final result3 = deviceController.getDeviceByUUID(const Uuid().v4()); // Non-existent

      expect(result1?.name, 'Device 1');
      expect(result2?.name, 'Device 2');
      expect(result3, isNull);
    });

    test('getDeviceByName returns the correct device', () {
      final uuid1 = const Uuid().v4();
      final uuid2 = const Uuid().v4();
      final device1 = DeviceProfile(uuid: uuid1, name: 'Device A', hostname: '1.1.1.1', password: 'p1', token: 't1');
      final device2 = DeviceProfile(uuid: uuid2, name: 'Device B', hostname: '2.2.2.2', password: 'p2', token: 't2');

      when(mockDeviceProfileBox.values)
          .thenReturn(<DeviceProfile>[device1, device2].toSet().toList());

      // Simulate init to populate deviceController.devices
      deviceController.init();

      final result1 = deviceController.getDeviceByName('Device A');
      final result2 = deviceController.getDeviceByName('Device B');
      final result3 = deviceController.getDeviceByName('Non Existent');

      expect(result1?.name, 'Device A');
      expect(result2?.name, 'Device B');
      expect(result3, isNull);
    });
  });
}
