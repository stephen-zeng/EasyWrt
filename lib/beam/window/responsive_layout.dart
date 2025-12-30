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
    return MediaQuery.of(context).size.width >= (2 * 21 * AppMeta.rem + 72);
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('Width: ${MediaQuery.of(context).size.width}, Height: ${MediaQuery.of(context).size.height}');
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape &&
            MediaQuery.of(context).size.width >= 28 * AppMeta.rem) {
          return landscape;
        } else {
          return portrait;
        }
      },
    );
  }
}