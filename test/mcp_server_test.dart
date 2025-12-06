import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:easywrt/services/mcp/mcp_server.dart';
import 'package:easywrt/services/mcp/mcp_tools.dart';
import 'package:easywrt/provider/device_provider.dart';
import 'package:easywrt/model/device_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'mcp_server_test.mocks.dart';

@GenerateMocks([DeviceProvider])
void main() {
  group('McpTools', () {
    late MockDeviceProvider mockDeviceProvider;

    setUp(() {
      mockDeviceProvider = MockDeviceProvider();
    });

    test('listDevices returns a list of devices', () {
      final uuid1 = const Uuid().v4();
      final device1 = DeviceProfile(
        uuid: uuid1, name: 'Router1', hostname: '192.168.1.1', password: 'p1', token: 't1',
      );
      final uuid2 = const Uuid().v4();
      final device2 = DeviceProfile(
        uuid: uuid2, name: 'Router2', hostname: '192.168.1.2', password: 'p2', token: 't2',
      );

      when(mockDeviceProvider.devices).thenReturn([device1, device2]);

      final result = McpTools.listDevices(mockDeviceProvider);

      expect(result.length, 2);
      expect(result.first['name'], 'Router1');
      expect(result.last['hostname'], '192.168.1.2');
    });
  });

  group('McpServer', () {
    late McpServer mcpServer;
    late MockDeviceProvider mockDeviceProvider;
    const int testPort = 8081; // Use different port to avoid conflict

    setUp(() {
      mockDeviceProvider = MockDeviceProvider();
      mcpServer = McpServer(port: testPort, deviceProvider: mockDeviceProvider);
    });

    tearDown(() async {
      if (mcpServer.isRunning) {
        await mcpServer.stop();
      }
    });

    test('McpServer starts and stops', () async {
      expect(mcpServer.isRunning, false);
      await mcpServer.start();
      expect(mcpServer.isRunning, true);
      await mcpServer.stop();
      expect(mcpServer.isRunning, false);
    });

    test('McpServer handles list_devices method', () async {
      final uuid1 = const Uuid().v4();
      final device1 = DeviceProfile(
        uuid: uuid1, name: 'Router1', hostname: '192.168.1.1', password: 'p1', token: 't1',
      );
      when(mockDeviceProvider.devices).thenReturn([device1]);

      await mcpServer.start();

      final response = await http.post(
        Uri.parse('http://127.0.0.1:$testPort/mcp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'method': 'list_devices', 'params': {}}),
      );

      expect(response.statusCode, 200);
      final body = jsonDecode(response.body);
      expect(body['result'][0]['name'], 'Router1');
    });
  });
}
