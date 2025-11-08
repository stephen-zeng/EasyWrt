import 'package:easywrt/database/app.dart';
import 'package:easywrt/model/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:easywrt/bean/setting/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../middleware/base/base_left.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 顶层Container保持不变，为macOS标题栏区域提供背景色
    final appBarBackgroundColor = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).scaffoldBackgroundColor;
    return Container(
      color: appBarBackgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > constraints.maxHeight) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: const BaseLeft(),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                // 右半部分：下一级界面
                Expanded(
                  flex: 1,
                  child: Container(
                    // 使用Scaffold的背景色
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(
                      child: Text(
                        '下一级界面\n("/dev/page")',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const BaseLeft();
          }
        }
      )
    );
  }
}