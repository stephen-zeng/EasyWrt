import 'package:flutter/material.dart';

/// ResponsiveLayout
/// ResponsiveLayout
/// 
/// Function: Builds different widgets based on screen width (Portrait vs Landscape).
/// Function: 根据屏幕宽度构建不同的组件（纵向 vs 横向）。
/// Inputs: 
/// Inputs: 
///   - [portrait]: Widget to show in portrait mode (<872px).
///   - [portrait]: 在纵向模式 (<872px) 下显示的组件。
///   - [landscape]: Widget to show in landscape mode (>872px).
///   - [landscape]: 在横向模式 (>872px) 下显示的组件。
/// Outputs: 
/// Outputs: 
///   - [Widget]: The selected layout widget.
///   - [Widget]: 选定的布局组件。
class ResponsiveLayout extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;

  const ResponsiveLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).size.width > 772;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 772) {
          return landscape;
        } else {
          return portrait;
        }
      },
    );
  }
}
