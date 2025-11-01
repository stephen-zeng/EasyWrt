import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp storageErrorApp() {
  return MaterialApp(
    title: 'Initialization Error',
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [
      Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans", countryCode: "CN"),
    ],
    locale: const Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans", countryCode: "CN"),
    builder: (context, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('初始化错误'),
        ),
        body: const Center(
          child: Text('应用初始化失败，请重启应用或检查存储权限。'),
        ),
      );
    },
  );
}

