import 'package:flutter/material.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  // 用于存储用户选择的日期，初始值为 null
  DateTime? _selectedDate;

  // 异步方法，用于显示日期选择器并处理结果
  Future<void> _presentDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // 初始日期为当前已选日期或今天
      firstDate: DateTime(2000), // 可选的最早日期
      lastDate: DateTime(2101),  // 可选的最晚日期
    );

    // 如果用户确实选择了一个日期（而不是点击取消）
    // 并且新选择的日期与之前不同，则更新状态
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // 使用 Column 垂直排列按钮和文本
        child: Column(
          // 将子组件垂直居中
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 添加一个按钮
            ElevatedButton(
              onPressed: _presentDatePicker, // 点击时调用日期选择器方法
              child: const Text('选择日期'),
            ),
            // 在按钮和文本之间添加一些间距
            const SizedBox(height: 20),
            // 显示选择的日期
            Text(
              _selectedDate == null
                  ? '尚未选择日期' // 如果没有选择日期，显示此文本
                  : '选择的日期是: ${_selectedDate!.toLocal().toString().split(' ')[0]}', // 格式化并显示已选日期
            ),
          ],
        ),
      ),
    );
  }
}