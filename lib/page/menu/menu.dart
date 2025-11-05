import 'package:flutter/material.dart';

class ScaffoldMenu extends StatefulWidget {
  const ScaffoldMenu({super.key});

  @override
  State<ScaffoldMenu> createState() => _ScaffoldMenu();
}

class _ScaffoldMenu extends State<ScaffoldMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('菜单示例'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 在这里处理按钮点击事件
          },
          child: const Text('点击我'),
        ),
      ),
    );
  }
}