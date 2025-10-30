import 'package:easywrt/config/meta.dart';
import 'package:easywrt/exception/common.dart';
import 'package:http/http.dart' as http;
import 'package:easywrt/utils/client.dart';

class WRTUser {
  static Future<String?> login({
    String scheme = "http",
    String? baseURL,
    String? username,
    String? password,
  }) async {
    if (baseURL == null || username == null || password == null) {
      throw ArgumentError('BaseURL, username, and password cannot be null');
    }

    final loginURL = Uri.parse(baseURL).resolve(Meta.luciLoginPath);

    final request = http.Request('POST', loginURL);

    // 设置请求头和请求体
    request.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
    });
    request.bodyFields = {
      'luci_username': username,
      'luci_password': password,
    };

    request.followRedirects = false;
    final http.Client httpClient = true ? GlobalClient.unsafeClient : GlobalClient.client;

    try {
      final streamedResponse = await httpClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      switch (response.statusCode) {
        case 403:
          throw AppException(Exceptions.wrtInvalidLoginCredentials);
        case 302:
          final cookies = response.headers['set-cookie'];
          if (cookies == null || cookies.isEmpty) {
            throw AppException(Exceptions.wrtInvalidLoginCookie);
          }
          return cookies.split(';').first.split('=').last;
        default:
          throw AppException(Exceptions.wrtOtherLoginError);
      }
    } catch (e) {
      rethrow;
    }
  }
}