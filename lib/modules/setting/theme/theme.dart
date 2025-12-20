import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AppTheme
/// AppTheme
/// 
/// Function: Defines the light and dark themes for the application.
/// Function: 定义应用程序的明亮和黑暗主题。
/// Inputs: None
/// Inputs: 无
/// Outputs: 
/// Outputs: 
///   - [ThemeData]: The configured theme data.
///   - [ThemeData]: 配置好的主题数据。
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
    );
  }
}

final themeProvider = Provider<ThemeData>((ref) {
  return AppTheme.lightTheme; // Default to light for now
});
