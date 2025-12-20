/// App Meta Constants
/// App Meta Constants
///
/// Contains all hardcoded values used across the application.
/// 包含了应用程序中使用的所有硬编码值。

class AppMeta {
  // Network & Polling
  static const int defaultPollingIntervalSeconds = 1;
  static const int rpcTimeoutSeconds = 10;
  static const int connectionTimeoutSeconds = 5;
  static const int receiveTimeoutSeconds = 3;
  
  // Data Conversions
  static const double cpuLoadDivisor = 65535.0;
  static const int bytesPerKilobyte = 1024;
  static const int bytesPerMegabyte = 1024 * 1024;

  // UI Layout
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double tinyPadding = 4.0;
  static const double cardBorderRadius = 12.0;
  
  // UI Animation
  static const int defaultAnimationDurationMs = 300;
  
  // Layout Breakpoints
  static const double desktopBreakpoint = 872.0;

  // Private constructor to prevent instantiation
  AppMeta._();
}
