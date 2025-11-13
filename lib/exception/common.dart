class AppException implements Exception {
  final Exceptions exceptions;
  final String? message;
  final dynamic data;

  AppException(this.exceptions, {this.message, this.data});
  int get code => exceptions.code;

  @override
  String toString() {
    return 'AppException(code: $code, message: ${message ?? exceptions.message}, data: $data)';
  }
}

enum Exceptions {
  otherError(100, "Other general error"),

  // 2xx: wrt登录相关错误
  wrtOtherLoginError(200, "Other login error"),
  wrtInvalidLoginCredentials(201, "Invalid username or password"),
  wrtInvalidLoginCookie(202, "Empty cookie"),

  // 3xx: 设备相关错误
  deviceNotFound(300, "Device not found");

  final int code;
  final String message;
  const Exceptions(this.code, this.message);
}