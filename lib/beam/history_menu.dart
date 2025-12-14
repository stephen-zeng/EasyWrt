import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// HistoryMenu
/// HistoryMenu
/// 
/// Function: A back button that shows navigation history on long press.
/// Function: 一个在长按时显示导航历史记录的后退按钮。
/// Inputs: None
/// Inputs: 无
/// Outputs: 
/// Outputs: 
///   - [Widget]: Icon button with gesture detector.
///   - [Widget]: 带有手势检测器的图标按钮。
class HistoryMenu extends StatelessWidget {
  const HistoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy,
          ),
          items: [
             const PopupMenuItem(
              value: 'home',
              child: Text('Home'),
            ),
             const PopupMenuItem(
              value: 'root',
              child: Text('Root Middleware'),
            ),
          ],
        ).then((value) {
          if (value == 'home') {
             // context.go('/'); // Example navigation
             // context.go('/'); // 导航示例
          }
        });
      },
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
    );
  }
}