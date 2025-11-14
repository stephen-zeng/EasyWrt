import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/meta.dart';
import '../database/storage.dart';
import '../exception/common.dart';
import '../model/device.dart';
import 'client.dart';

class Wrt {
  static int counter = 0;
  static Future<String?> login({
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

    // Attention: Use unsafe client to ignore invalid SSL certificates
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

  static Future<List<dynamic>> call(String deviceID, List<List<String>> segments) async {
    final deviceBox = HiveDB.devices;
    final device = deviceBox.get(deviceID);
    if (device == null) {
      throw AppException(Exceptions.deviceNotFound);
    }
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Attention: Use unsafe client to ignore invalid SSL certificates
    final http.Client httpClient = true ? GlobalClient.unsafeClient : GlobalClient.client;
    final uri = Uri.parse(device.luciBaseURL).resolve('/ubus?${timestamp.toString()}');
    List<dynamic> responseData = [];
    for (int i = 0 ; i < 3; i++) {
      final data = List<Map<String, dynamic>>.empty(growable: true);
      for (final segment in segments) {
        counter++;
        data.add({
          'id': counter,
          'jsonrpc': '2.0',
          'method': "call",
          "params": [device.token, ...segment, {}],
        });
      }
      try {
        final response = await httpClient.post(
          uri,
          headers: Meta.headers,
          body: jsonEncode(data),
        );
        responseData = jsonDecode(response.body) as List<dynamic>;
        final firstData = responseData.first as Map<String, dynamic>;
        if (firstData.containsKey('error')) {
          final errorData = firstData['error'] as Map<String, dynamic>;
          if (errorData['code'] == WrtErrorCode.accessDenied) {
            final newToken = await login(
              baseURL: device.luciBaseURL,
              username: device.luciUsername,
              password: device.luciPassword,
            );
            device.token = newToken ?? '';
            await deviceBox.put(deviceID, device);
            continue;
          }
        } else {
          return responseData;
        }
      } catch (e) {
        rethrow;
      }
    }
    return responseData;
  }
}