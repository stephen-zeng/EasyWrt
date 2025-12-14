import 'package:dio/dio.dart';
import 'http_client.dart';

/// SystemInfoService
/// SystemInfoService
/// 
/// Function: Fetches system information from OpenWRT via uBus.
/// Function: 通过 uBus 从 OpenWRT 获取系统信息。
/// Inputs: Connection details and session ID.
/// Inputs: 连接详情和会话 ID。
/// Outputs: 
/// Outputs: 
///   - [Future<Map<String, dynamic>?>]: System info or board info map.
///   - [Future<Map<String, dynamic>?>]: 系统信息或主板信息映射。
class SystemInfoService {
  final Dio _dio = HttpClient().dio;

  Future<Map<String, dynamic>?> getSystemInfo(
      String host, int port, String session, bool isHttps) async {
    final scheme = isHttps ? 'https' : 'http';
    final url = '$scheme://$host:$port/ubus';

    try {
      final response = await _dio.post(
        url,
        data: {
          "jsonrpc": "2.0",
          "id": 1,
          "method": "call",
          "params": [
            session,
            "system",
            "info",
            {}
          ]
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['result'] != null &&
            data['result'] is List &&
            (data['result'] as List).isNotEmpty &&
            data['result'][0] == 0) {
          return data['result'][1] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('System Info error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBoardInfo(
      String host, int port, String session, bool isHttps) async {
    final scheme = isHttps ? 'https' : 'http';
    final url = '$scheme://$host:$port/ubus';

    try {
      final response = await _dio.post(
        url,
        data: {
          "jsonrpc": "2.0",
          "id": 1,
          "method": "call",
          "params": [
            session,
            "system",
            "board",
            {}
          ]
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['result'] != null &&
            data['result'] is List &&
            (data['result'] as List).isNotEmpty &&
            data['result'][0] == 0) {
          return data['result'][1] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Board Info error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getNetworkStats(
      String host, int port, String session, bool isHttps) async {
    final scheme = isHttps ? 'https' : 'http';
    final url = '$scheme://$host:$port/ubus';

    try {
      final response = await _dio.post(
        url,
        data: {
          "jsonrpc": "2.0",
          "id": 1,
          "method": "call",
          "params": [
            session,
            "network.device",
            "status",
            {}
          ]
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['result'] != null &&
            data['result'] is List &&
            (data['result'] as List).isNotEmpty &&
            data['result'][0] == 0) {
          return data['result'][1] as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Network Stats error: $e');
      return null;
    }
  }

  Future<dynamic> call(
      String host, int port, String session, bool isHttps, String namespace, String method,
      [Map<String, dynamic>? params]) async {
    final scheme = isHttps ? 'https' : 'http';
    final url = '$scheme://$host:$port/ubus';

    try {
      final response = await _dio.post(
        url,
        data: {
          "jsonrpc": "2.0",
          "id": 1, // ID could be dynamic but 1 is fine for stateless
          "method": "call",
          "params": [
            session,
            namespace,
            method,
            params ?? {}
          ]
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['result'] != null &&
            data['result'] is List &&
            (data['result'] as List).isNotEmpty &&
            data['result'][0] == 0) {
          return data['result'][1];
        }
      }
      return null;
    } catch (e) {
      print('RPC Call error ($namespace.$method): $e');
      return null;
    }
  }
}
