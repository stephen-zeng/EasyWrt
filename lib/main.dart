import 'package:flutter/material.dart';

import 'utils/logger.dart';
import 'wrt/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SZ's Flutter D",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: "SZ's F Demo"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _testResult = '这里将显示测试函数的输出';
  final TextEditingController _endpointTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  void _runTestFunction() async {
    Applogger().devLog("asdfasdfasdf");
    String? cookies;
    try {
      cookies = await WRTUser.login(
        baseURL: _endpointTextController.text,
        username: _usernameTextController.text,
        password: _passwordTextController.text,
      );
    } catch (e) {
      setState(() {
        _testResult = 'Error: $e';
      });
      return;
    }
    setState(() {
      _testResult = 'Cookies: $cookies';
    });
  }

  @override
  void dispose() {
    // 及时清理 controller
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _endpointTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'endpoint',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'username',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runTestFunction,
              child: const Text('执行测试函数'),
            ),
            const SizedBox(height: 20),
            Text(
              _testResult,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
