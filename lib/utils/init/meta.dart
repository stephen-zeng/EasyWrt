import 'package:flutter/material.dart';

/// App Meta Constants
/// App Meta Constants
///
/// Contains all hardcoded values used across the application.
/// 包含了应用程序中使用的所有硬编码值。

class AppMeta {
  // Grid System Utils
  static const double rem = 16.0;
  static const double minStripeWidthRem = 19.0;
  static const double maxStripeWidthRem = 35.0;

  static const double minStripeWidthPx = minStripeWidthRem * rem; // 304.0
  static const double maxStripeWidthPx = maxStripeWidthRem * rem; // 560.0

  /// Calculates the width of a single grid cell (1x1) given the stripe width.
  static double calculateCellWidth(double stripeWidthPx) {
    const double gapPx = rem;
    // Account for 1rem padding on each side (total 2rem)
    final gridWidth = stripeWidthPx - (2 * gapPx);
    if (gridWidth < (3 * gapPx)) return 0;
    return (gridWidth - (3 * gapPx)) / 4;
  }

  /// Calculates the pixel dimensions for a widget spanning [w] x [h] grid units.
  static Size calculateWidgetSize(double stripeWidthPx, int w, int h) {
    final cellWidth = calculateCellWidth(stripeWidthPx);
    final cellHeight = cellWidth;
    
    final widthPx = (w * cellWidth) + ((w - 1) * rem);
    final heightPx = (h * cellHeight) + ((h - 1) * rem);
    
    return Size(widthPx, heightPx);
  }

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

  // Icon data getter
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'router': return Icons.router;
      case 'bar_chart': return Icons.bar_chart;
      case 'hardware': return Icons.hardware;
      case 'hard_drive': return Icons.storage;
      case 'settings': return Icons.settings;
      case 'colors': return Icons.color_lens;
      default: return Icons.help_outline;
    }
  }
}
