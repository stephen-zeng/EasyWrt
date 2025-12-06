import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:easywrt/provider/device_provider.dart';
import 'package:easywrt/model/device_profile.dart';
import 'package:easywrt/services/mcp/mcp_tools.dart';
import 'package:easywrt/utils/logger.dart'; // For logging

class McpServer {
  HttpServer? _server;
  int port; // Removed final
  final DeviceProvider deviceProvider;

  McpServer({required this.port, required this.deviceProvider});

  Future<void> start() async {
    final _router = Router();

    // SSE endpoint for event streaming (optional, for future)
    _router.get('/sse', (Request request) {
      final controller = StreamController<String>();
      // Send initial data or keep connection alive
      controller.sink.add('data: Welcome to EasyWRT MCP\n\n');
      // In a real app, you might push device status updates here
      // For now, it's just a placeholder for event streaming

      // Respond with SSE headers
      return Response.ok(controller.stream.map((e) => e.toString()), headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      });
    });

    // MCP JSON-RPC style endpoint for tool calls
    _router.post('/mcp', (Request request) async {
      try {
        final requestBody = await request.readAsString();
        final Map<String, dynamic> jsonBody = jsonDecode(requestBody);

        final String methodName = jsonBody['method'];
        final Map<String, dynamic> params = jsonBody['params'] ?? {};

        dynamic result;
        switch (methodName) {
          case 'list_devices':
            result = McpTools.listDevices(deviceProvider);
            break;
          case 'get_device_info':
            final deviceUuid = params['device_uuid'] as String?;
            if (deviceUuid == null) {
              return Response.badRequest(body: jsonEncode({'error': 'device_uuid is required'}));
            }
            result = await McpTools.getDeviceInfo(deviceUuid, deviceProvider); // Pass deviceProvider
            break;
          case 'reboot_device':
            final deviceUuid = params['device_uuid'] as String?;
            if (deviceUuid == null) {
              return Response.badRequest(body: jsonEncode({'error': 'device_uuid is required'}));
            }
            result = await McpTools.rebootDevice(deviceUuid, deviceProvider); // Pass deviceProvider
          default:
            return Response.notFound(jsonEncode({'error': 'Method not found: $methodName'}), headers: {'Content-Type': 'application/json'});
        }

        return Response.ok(jsonEncode({'result': result}), headers: {'Content-Type': 'application/json'});
      } catch (e) {
        SZLogger().e('MCP Server Error: $e');
        return Response.internalServerError(body: jsonEncode({'error': 'Internal server error: $e'}), headers: {'Content-Type': 'application/json'});
      }
    });

    _server = await io.serve(_router, InternetAddress.loopbackIPv4, port);
    SZLogger().i('MCP Server listening on http://${_server!.address.host}:${_server!.port}');
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    SZLogger().i('MCP Server stopped.');
    _server = null;
  }

  bool get isRunning => _server != null;
}
