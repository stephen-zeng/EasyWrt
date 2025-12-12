import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AppTheme
/// 
/// Function: Defines the light and dark themes for the application.
/// Inputs: None
/// Outputs: 
///   - [ThemeData]: The configured theme data.
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
