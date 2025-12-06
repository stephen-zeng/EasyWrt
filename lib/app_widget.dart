import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:easywrt/bean/theme/theme.dart';
import 'package:easywrt/bean/setting/theme.dart'; // ThemeProvider
import 'package:easywrt/provider/app_settings_provider.dart'; // AppSettingsProvider
import 'package:easywrt/provider/device_provider.dart';     // DeviceProvider
import 'package:easywrt/services/mcp/mcp_server.dart';      // McpServer
import 'package:easywrt/utils/logger.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  McpServer? _mcpServer;
  late AppSettingsProvider _appSettingsProvider;
  late DeviceProvider _deviceProvider;

  @override
  void initState() {
    super.initState();
    // Cannot access providers directly in initState without context.
    // Will initialize McpServer in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appSettingsProvider = Provider.of<AppSettingsProvider>(context);
    _deviceProvider = Provider.of<DeviceProvider>(context);

    // Initialize MCP server once
    if (_mcpServer == null) {
      _mcpServer = McpServer(
        port: _appSettingsProvider.settings.mcpPort,
        deviceProvider: _deviceProvider,
      );
      _appSettingsProvider.addListener(_handleMcpSettingsChange);
      _handleMcpSettingsChange(); // Initial check
    }
  }

  void _handleMcpSettingsChange() {
    if (_appSettingsProvider.settings.mcpEnabled) {
      if (!(_mcpServer?.isRunning ?? false)) {
        _mcpServer?.port = _appSettingsProvider.settings.mcpPort; // Update port if changed
        _mcpServer?.start().catchError((e) {
          SZLogger().e("Failed to start MCP Server: $e");
          // Optionally disable MCP if it fails to start
          _appSettingsProvider.setMcpEnabled(false);
        });
      }
    } else {
      if (_mcpServer?.isRunning ?? false) {
        _mcpServer?.stop();
      }
    }
  }

  @override
  void dispose() {
    _mcpServer?.stop();
    _appSettingsProvider.removeListener(_handleMcpSettingsChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      title: 'EasyWRT',
      theme: ThemeGetter.getLightTheme(themeProvider.themeColor),
      darkTheme: ThemeGetter.getDarkTheme(themeProvider.themeColor),
      themeMode: themeProvider.themeMode,
      routerConfig: Modular.routerConfig,
      debugShowCheckedModeBanner: false,
    );
  }
}
