import 'package:dio/dio.dart';

/// HttpClient
/// HttpClient
/// 
/// Function: A singleton wrapper around Dio to provide a configured HTTP client.
/// Function: 一个 Dio 的单例包装器，用于提供配置好的 HTTP 客户端。
/// Inputs: None (Singleton)
/// Inputs: 无 (单例)
/// Outputs: 
/// Outputs: 
///   - [dio]: The configured Dio instance.
///   - [dio]: 配置好的 Dio 实例。
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final Dio _dio;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add global headers or auth tokens here if needed
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Global error handling
          print('Dio Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
