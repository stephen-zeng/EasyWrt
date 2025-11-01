import '../model/custom.dart';
import 'page.dart';

class DefaultMiddleware {
  static final Middleware middlewareNetwork = Middleware(
    fatherPath: '/',
    path: '/network',
    name: 'Network',
    icon: 'router',
    pages: [
      DefaultPage.pageNetworkInterface,
      DefaultPage.pageWirelessNetworks,
      DefaultPage.pageRouter,
      DefaultPage.pageDHCP,
      DefaultPage.pageDNS,
      DefaultPage.pageFirewall,
      DefaultPage.pageDialog,
    ],
  );

  static final Middleware middlewareSoftware = Middleware(
    fatherPath: '/status',
    path: '/software',
    name: 'Software',
    icon: 'apple',
    pages: [
      DefaultPage.pageSystemStatus,
      DefaultPage.pageLogView,
    ],
    middlewares: [],
  );

  static final Middleware middlewareHardware = Middleware(
    fatherPath: '/status',
    path: '/hardware',
    name: 'Hardware',
    icon: 'memory',
    pages: [
      DefaultPage.pageInternalDeviceStatus,
      DefaultPage.pageExternalDeviceStatus,
    ],
  );

  static final Middleware middlewareNetworkStatus = Middleware(
    fatherPath: '/status',
    path: '/network_status',
    name: 'Network Status',
    icon: 'network_wifi',
    pages: [
      DefaultPage.pageChannelScan,
      DefaultPage.pageSpeedStatus,
      DefaultPage.pageWirelessStatus,
    ],
  );

  static final Middleware middlewareStatus = Middleware(
    fatherPath: '/',
    path: '/status',
    name: 'Status',
    icon: 'signal_cellular_alt',
    pages: [
      DefaultPage.pageOverview,
    ],
    middlewares: [
      middlewareSoftware,
      middlewareHardware,
      middlewareNetwork,
    ],
  );

  static final Middleware middlewareGeneralSettings = Middleware(
    fatherPath: '/system',
    path: '/general_settings',
    name: 'General Settings',
    icon: 'settings',
    pages: [
      DefaultPage.pageInfoSettings,
      DefaultPage.pageTimeSettings,
      DefaultPage.pageTimeSettings, // 注意这里重复了
      DefaultPage.pageLogSettings,
      DefaultPage.pagePerformanceSettings,
    ],
  );

  static final Middleware middlewareSecuritySettings = Middleware(
    fatherPath: '/system',
    path: '/security_settings',
    name: 'Security Settings',
    icon: 'security',
    pages: [
      DefaultPage.pageLuciSettings,
      DefaultPage.pageSSHSettings,
    ],
  );

  static final Middleware middlewareSystem = Middleware(
    fatherPath: '/',
    path: '/system',
    name: 'System',
    icon: 'computer',
    middlewares: [
      middlewareGeneralSettings,
      middlewareSecuritySettings,
    ],
  );

  static final Middleware middlewareLuciApplications = Middleware(
    fatherPath: '/',
    path: '/luci_applications',
    name: 'LuCI Applications',
    icon: 'apps',
    pages: [
      DefaultPage.pageLuciAppManager,
    ],
  );

  static final Middleware middlewareRoot = Middleware(
    fatherPath: '',
    path: '/',
    name: 'Root',
    icon: 'dashboard',
    middlewares: [
      middlewareStatus,
      middlewareSystem,
      middlewareLuciApplications,
      middlewareNetwork,
    ],
  );
}
