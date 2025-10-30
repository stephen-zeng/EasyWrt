import 'package:flutter/material.dart';
import '../model/custom.dart';
import 'page.dart';

Middleware middlewareSoftware = Middleware(
  fatherPath: '/status',
  path: '/software',
  name: 'Software',
  icon: 'apple',
  pages: [pageSystemStatus, pageLogView],
  middlewares: [],
);

Middleware middlewareHardware = Middleware(
  fatherPath: '/status',
  path: '/hardware',
  name: 'Hardware',
  icon: 'memory',
  pages: [pageInternalDeviceStatus, pageExternalDeviceStatus],
);

Middleware middlewareNetworkStatus = Middleware(
  fatherPath: '/status',
  path: '/network_status',
  name: 'Network Status',
  icon: 'network_wifi',
  pages: [pageChannelScan, pageSpeedStatus, pageWirelessStatus],
);

Middleware middlewareStatus = Middleware(
  fatherPath: '/',
    path: '/status',
    name: 'Status',
    icon: 'signal_cellular_alt',
    pages: [pageOverview],
    middlewares: [middlewareSoftware, middlewareHardware, middlewareNetwork,],
);

Middleware middlewareGeneralSettings = Middleware(
  fatherPath: '/system',
  path: '/general_settings',
  name: 'General Settings',
  icon: 'settings',
  pages: [pageInfoSettings, pageTimeSettings, pageTimeSettings, pageLogSettings, pagePerformanceSettings],
);

Middleware middlwareSecuritySettings = Middleware(
  fatherPath: '/system',
    path: '/security_settings',
    name: 'Security Settings',
    icon: 'security',
    pages: [pageLuciSettings, pageSSHSettings],
);

Middleware middlewareSystem = Middleware(
  fatherPath: '/',
  path: '/system',
  name: 'System',
  icon: 'computer',
  middlewares: [middlewareGeneralSettings, middlwareSecuritySettings,],
);

Middleware middlewareLuciApplications = Middleware(
  fatherPath: '/',
  path: '/luci_applications',
  name: 'LuCI Applications',
  icon: 'apps',
  pages: [pageLuciAppManager],
);

Middleware middlewareNetwork = Middleware(
  fatherPath: '/',
    path: '/network',
    name: 'Network',
    icon: 'router',
    pages: [pageNetworkInterface, pageWirelessNetworks, pageRouter, pageDHCP, pageDNS, pageFirewall, pageDialog],
);

Middleware middlewareRoot = Middleware(
  fatherPath: '',
  path: '/',
  name: 'Root',
  icon: 'dashboard',
  middlewares: [middlewareStatus, middlewareSystem, middlewareLuciApplications, middlewareNetwork],
);