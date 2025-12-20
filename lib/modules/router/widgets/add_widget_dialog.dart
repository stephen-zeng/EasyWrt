import 'package:flutter/material.dart';

/// AddWidgetDialog
/// AddWidgetDialog
/// 
/// Function: A dialog to select a widget to add to a page.
/// Function: 选择要添加到页面的组件的对话框。
/// Inputs: 
/// Inputs: 
///   - [onAdd]: Callback with selected widget name.
///   - [onAdd]: 带有选定组件名称的回调。
/// Outputs: 
/// Outputs: 
///   - [Widget]: List of available widgets.
///   - [Widget]: 可用组件列表。
class AddWidgetDialog extends StatelessWidget {
  final Function(String) onAdd;

  const AddWidgetDialog({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    // List of available widgets
    final availableWidgets = ['CpuUsageWidget', 'MemoryUsageWidget', 'NetworkTrafficWidget'];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Widget',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: availableWidgets.length,
              itemBuilder: (context, index) {
                final widgetName = availableWidgets[index];
                return ListTile(
                  title: Text(widgetName),
                  onTap: () {
                    onAdd(widgetName);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
