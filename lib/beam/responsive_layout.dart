import 'package:easywrt/utils/init/meta.dart';
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

  /// Helper to check if context is landscape.
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).size.width >= (2 * 21 * AppMeta.rem + 70);
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