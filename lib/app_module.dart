import 'package:flutter_modular/flutter_modular.dart';
import 'package:easywrt/page/dashboard/dashboard_page.dart';
import 'package:easywrt/page/device/device_list_page.dart';
import 'package:easywrt/page/device/device_edit_page.dart';
import 'package:easywrt/page/dashboard/middleware_page.dart';
import 'package:easywrt/page/dashboard/function_page.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const DashboardPage());
    r.child('/device-list', child: (context) => const DeviceListPage());
    r.child('/device-edit', child: (context) => DeviceEditPage(device: Modular.args.data));
    r.child('/dashboard-single-middleware', child: (context) => MiddlewarePage(onItemSelected: Modular.args.data));
    r.child('/dashboard-single-function', child: (context) => FunctionPage(selectedIndex: Modular.args.data ?? 0));
  }
}
