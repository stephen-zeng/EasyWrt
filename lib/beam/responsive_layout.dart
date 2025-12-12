import 'package:flutter/material.dart';

/// ResponsiveLayout
/// 
/// Function: Builds different widgets based on screen width (Portrait vs Landscape).
/// Inputs: 
///   - [portrait]: Widget to show in portrait mode (<872px).
///   - [landscape]: Widget to show in landscape mode (>872px).
/// Outputs: 
///   - [Widget]: The selected layout widget.
class ResponsiveLayout extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;

  const ResponsiveLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).size.width > 872;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 872) {
          return landscape;
        } else {
          return portrait;
        }
      },
    );
  }
}
