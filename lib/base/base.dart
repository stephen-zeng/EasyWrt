import 'dart:math'; // 1. 导入 dart:math 库以使用 min() 函数

import 'package:easywrt/database/app.dart';
import 'package:easywrt/model/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:easywrt/bean/setting/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../page/middleware/frame/frame.dart';

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
    final appBarBackgroundColor = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).scaffoldBackgroundColor;
    return Container(
        color: appBarBackgroundColor,
        child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > constraints.maxHeight) {
                final double leftPanelWidth = min(constraints.maxWidth / 2, 400.0);
                return Row(
                  children: [
                    SizedBox(
                      width: leftPanelWidth,
                      child: const MiddlewareFrame(),
                    ), // left
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(
                      child: Container(
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
                return const MiddlewareFrame();
              }
            }
        )
    );
  }
}