import 'package:dio/dio.dart';
import 'http_client.dart';

/// SystemInfoService
/// 
/// Function: Fetches system information from OpenWRT via uBus.
/// Inputs: Connection details and session ID.
/// Outputs: 
///   - [Future<Map<String, dynamic>?>]: System info or board info map.
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
}
