import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;

class _UnsafeClient extends http.BaseClient {
  final HttpClient _inner = HttpClient()
    ..badCertificateCallback = (cert, host, port) => true;
  final http.IOClient _ioClient;

  _UnsafeClient() : _ioClient = http.IOClient(HttpClient()
    ..badCertificateCallback = (cert, host, port) => true);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _ioClient.send(request);
  }

  @override
  void close() {
    _ioClient.close();
    _inner.close();
  }
}


class GlobalClient {
  static http.Client? _client;
  static _UnsafeClient? _unsafeClient;

  factory GlobalClient() {
    _client ??= http.Client();
    return GlobalClient._internal();
  }
  GlobalClient._internal();

  static http.Client get client {
    _client ??= http.Client();
    return _client!;
  }

  static http.Client get unsafeClient {
    _unsafeClient ??= _UnsafeClient();
    return _unsafeClient!;
  }

  static void close() {
    _client?.close();
    _unsafeClient?.close();
    _client = null;
    _unsafeClient = null;
  }
}