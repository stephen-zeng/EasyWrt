import 'package:flutter/material.dart' hide Page;
import '../model/custom.dart';

class DefaultPage {
  static final Page pageOverview = Page(
    fatherPath: '/status',
    name: 'Overview',
    icon: Icons.dashboard,
    path: '/overview',
  );

  static final Page pageSystemStatus = Page(
    fatherPath: '/software',
    name: 'System Status',
    icon: Icons.info,
    path: "/system_status",
  );

  static final Page pageLogView = Page(
    fatherPath: '/software',
    name: 'Log View',
    icon: Icons.view_list,
    path: '/log_view',
  );

  static final Page pageInternalDeviceStatus = Page(
    fatherPath: '/hardware',
    name: 'Internal Device Status',
    icon: Icons.devices,
    path: '/internal_device_status',
  );

  static final Page pageExternalDeviceStatus = Page(
    fatherPath: '/hardware',
    name: 'External Device Status',
    icon: Icons.usb,
    path: '/external_device_status',
  );

  static final Page pageChannelScan = Page(
    fatherPath: '/network',
    name: 'Channel Scan',
    icon: Icons.wifi_tethering,
    path: '/channel_scan',
  );

  static final Page pageSpeedStatus = Page(
    fatherPath: '/network',
    name: 'Speed Status',
    icon: Icons.speed,
    path: '/speed_status',
  );

  static final Page pageWirelessStatus = Page(
    fatherPath: '/network',
    name: 'Wireless Status',
    icon: Icons.wifi,
    path: '/wireless_status',
  );

  static final Page pageInfoSettings = Page(
    fatherPath: '/settings',
    name: 'Info Settings',
    icon: Icons.info_outline,
    path: '/info_settings',
  );

  static final Page pageLanguageSettings = Page(
    fatherPath: '/settings',
    name: 'Language Settings',
    icon: Icons.language,
    path: '/language_settings',
  );

  static final Page pageTimeSettings = Page(
    fatherPath: '/settings',
    name: 'Time Settings',
    icon: Icons.access_time,
    path: '/time_settings',
  );

  static final Page pageLogSettings = Page(
    fatherPath: '/settings',
    name: 'Log Settings',
    icon: Icons.list,
    path: '/log_settings',
  );

  static final Page pagePerformanceSettings = Page(
    fatherPath: '/settings',
    name: 'Performance Settings',
    icon: Icons.settings_applications,
    path: '/performance_settings',
  );

  static final Page pageSSHSettings = Page(
    fatherPath: '/settings',
    name: 'SSH Settings',
    icon: Icons.code,
    path: '/ssh_settings',
  );

  static final Page pageLuciSettings = Page(
    fatherPath: '/settings',
    name: 'Luci Settings',
    icon: Icons.web,
    path: '/luci_settings',
  );

  static final Page pageLuciAppManager = Page(
    fatherPath: '/apps',
    name: 'App Manager',
    icon: Icons.apps,
    path: '/luci_app_manager',
  );

  static final Page pageNetworkInterface = Page(
    fatherPath: '/network',
    name: 'Network Interface',
    icon: Icons.network_check,
    path: '/network_interface',
  );

  static final Page pageWirelessNetworks = Page(
    fatherPath: '/network',
    name: 'Wireless Networks',
    icon: Icons.wifi_lock,
    path: '/wireless_networks',
  );

  static final Page pageRouter = Page(
    fatherPath: '/network',
    name: 'Router',
    icon: Icons.router,
    path: '/router',
  );

  static final Page pageDHCP = Page(
    fatherPath: '/network',
    name: 'DHCP',
    icon: Icons.public,
    path: '/dhcp',
  );

  static final Page pageDNS = Page(
    fatherPath: '/network',
    name: 'DNS',
    icon: Icons.dns,
    path: '/dns',
  );

  static final Page pageFirewall = Page(
    fatherPath: '/network',
    name: 'Firewall',
    icon: Icons.security,
    path: '/firewall',
  );

  static final Page pageDialog = Page(
    fatherPath: '/apps',
    name: 'Dialog',
    icon: Icons.chat,
    path: '/dialog',
  );
}
