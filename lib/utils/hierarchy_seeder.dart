import 'package:hive/hive.dart';
import '../db/models/hierarchy_items.dart';

/// HierarchySeeder
/// 
/// Function: Seeds the default middleware and page hierarchy into Hive if empty or for development.
/// Inputs: None
/// Outputs: None (Side effect: Updates Hive boxes)
class HierarchySeeder {
  static Future<void> seedDefaultHierarchy() async {
    final middlewareBox = Hive.box<MiddlewareItem>('middlewares');
    final pageBox = Hive.box<PageItem>('pages');

    // Force clear for development to apply structure changes
    await middlewareBox.clear();
    await pageBox.clear();

    // Create Page: Internal Device
    final internalDevicePage = PageItem(
      id: 'internal_device_page',
      name: 'Internal Device',
      icon: 'hard_drive',
      widgetChildren: ['CpuUsageWidget', 'MemoryUsageWidget'],
    );
    await pageBox.put(internalDevicePage.id, internalDevicePage);

    // Create Middleware: Hardware
    final hardwareMiddleware = MiddlewareItem(
      id: 'hardware_middleware',
      name: 'Hardware',
      icon: 'hardware',
      pageChildren: [internalDevicePage.id],
      children: [internalDevicePage.id], // Ordered list
    );
    await middlewareBox.put(hardwareMiddleware.id, hardwareMiddleware);

    // Create Middleware: Status
    final statusMiddleware = MiddlewareItem(
      id: 'status_middleware',
      name: 'Status',
      icon: 'bar_chart',
      middlewareChildren: [hardwareMiddleware.id],
      children: [hardwareMiddleware.id], // Ordered list
    );
    await middlewareBox.put(statusMiddleware.id, statusMiddleware);

    // Create Root Middleware: Router
    final routerMiddleware = MiddlewareItem(
      id: 'router_root',
      name: 'Router',
      icon: 'router',
      middlewareChildren: [statusMiddleware.id],
      children: [statusMiddleware.id], // Ordered list
    );
    await middlewareBox.put(routerMiddleware.id, routerMiddleware);
  }
}