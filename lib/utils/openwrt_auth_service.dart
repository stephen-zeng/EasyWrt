import 'package:dio/dio.dart';
import 'http_client.dart';

/// OpenWrtAuthService
/// 
/// Function: Handles authentication with OpenWRT uBus API.
/// Inputs: 
///   - [host]: Router hostname/IP.
///   - [port]: Router port.
///   - [username]: Login username.
///   - [password]: Login password.
///   - [isHttps]: Whether to use HTTPS.
/// Outputs: 
///   - [Future<String?>]: Session ID if successful, null otherwise.
class OpenWrtAuthService {
  final Dio _dio = HttpClient().dio;

  Future<String?> login(
      String host, int port, String username, String password, bool isHttps) async {
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
            "00000000000000000000000000000000",
            "session",
            "login",
            {"username": username, "password": password}
          ]
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['result'] != null &&
            data['result'] is List &&
            (data['result'] as List).isNotEmpty &&
            data['result'][0] == 0) {
          final resultObj = data['result'][1];
          if (resultObj != null && resultObj['ubus_rpc_session'] != null) {
            return resultObj['ubus_rpc_session'] as String;
          }
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }
}
