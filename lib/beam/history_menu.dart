import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// HistoryMenu
/// 
/// Function: A back button that shows navigation history on long press.
/// Inputs: None
/// Outputs: 
///   - [Widget]: Icon button with gesture detector.
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