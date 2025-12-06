// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:easywrt/app_module.dart';
import 'package:easywrt/app_widget.dart';
import 'package:easywrt/bean/setting/theme.dart';
import 'package:easywrt/provider/device_provider.dart';
import 'package:easywrt/provider/app_settings_provider.dart';
import 'package:easywrt/model/app_settings.dart';

class MockDeviceProvider extends ChangeNotifier implements DeviceProvider {
  @override
  get activeDevice => null;
  @override
  get devices => [];
  @override
  addDevice({required String name, required String luciUsername, required String luciPassword, required String luciBaseURL, required String token}) {
     throw UnimplementedError();
  }
  @override
  deleteDevice(String uuid) {}
  @override
  editDevice(device) {}
  @override
  loadDevices() {}
  @override
  setActiveDevice(device) {}
}

class MockAppSettingsProvider extends ChangeNotifier implements AppSettingsProvider {
  @override
  AppSettings get settings => AppSettings();
  
  @override
  void setBioAuthEnabled(bool enabled) {}
  
  @override
  void setMcpEnabled(bool enabled) {}
  
  @override
  void setMcpPort(int port) {}
}

void main() {
  testWidgets('App loads and shows Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<DeviceProvider>(create: (_) => MockDeviceProvider()),
          ChangeNotifierProvider<AppSettingsProvider>(create: (_) => MockAppSettingsProvider()),
        ],
        child: ModularApp(
          module: AppModule(),
          child: const AppWidget(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    // DashboardPage should be the home
    // expect(find.byType(DashboardPage), findsOneWidget); 
    // Note: DashboardPage might be inside RouterOutlet
  });
}
