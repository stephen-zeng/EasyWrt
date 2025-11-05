import 'package:easywrt/database/app.dart';
import 'package:easywrt/model/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:easywrt/bean/setting/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final AppPreferences appPreferences = AppController.getAppPreferences();
  late final ThemeProvider themeProvider;

  @override
  void initState() {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.setDynamic(appPreferences.useDynamicColor);
    Modular.to.navigate("/dev");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('初始化页面'),
      ),
      child: Center(
        child: Text('这里是初始化页面的内容'),
      ),
    );
  }
}