import 'package:flutter/material.dart';

/// ResponsiveLayout
/// 
/// Function: Switches between portrait and landscape widgets based on orientation.
/// Also provides utilities for the responsive grid system.
class ResponsiveLayout extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;

  const ResponsiveLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  // --- Grid System Utils ---
  static const double rem = 16.0;
  static const double minStripeWidthRem = 19.0;
  static const double maxStripeWidthRem = 35.0;

  static const double minStripeWidthPx = minStripeWidthRem * rem; // 304.0
  static const double maxStripeWidthPx = maxStripeWidthRem * rem; // 560.0

  /// Calculates the width of a single grid cell (1x1) given the stripe width.
  static double calculateCellWidth(double stripeWidthPx) {
    const double gapPx = rem;
    if (stripeWidthPx < (3 * gapPx)) return 0;
    return (stripeWidthPx - (3 * gapPx)) / 4;
  }

  /// Calculates the pixel dimensions for a widget spanning [w] x [h] grid units.
  static Size calculateWidgetSize(double stripeWidthPx, int w, int h) {
    final cellWidth = calculateCellWidth(stripeWidthPx);
    final cellHeight = cellWidth;
    
    final widthPx = (w * cellWidth) + ((w - 1) * rem);
    final heightPx = (h * cellHeight) + ((h - 1) * rem);
    
    return Size(widthPx, heightPx);
  }

  /// Helper to check if context is landscape.
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return landscape;
        } else {
          return portrait;
        }
      },
    );
  }
}