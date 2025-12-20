import 'package:hive/hive.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';

/// HierarchySeeder
/// HierarchySeeder
/// 
/// Function: Seeds the default middleware and page hierarchy into Hive if empty or for development.
/// Function: 如果为空或为了开发目的，将默认的中间件和页面层级播种到 Hive 中。
/// Inputs: None
/// Inputs: 无
/// Outputs: None (Side effect: Updates Hive boxes)
/// Outputs: 无 (副作用: 更新 Hive boxes)
class HierarchySeeder {
  static Future<void> seedDefaultHierarchy() async {
    final middlewareBox = Hive.box<MiddlewareItem>('middlewares');
    final pageBox = Hive.box<PageItem>('pages');

    // Force clear for development to apply structure changes
    // 强制清除以便开发时应用结构更改
    await middlewareBox.clear();
    await pageBox.clear();

    // Create Page: Internal Device
    // 创建页面: Internal Device
    final internalDevicePage = PageItem(
      id: 'internal_device_page',
      name: 'Internal Device',
      icon: 'hard_drive',
      widgetChildren: ['CpuUsageWidget', 'MemoryUsageWidget'],
    );
    await pageBox.put(internalDevicePage.id, internalDevicePage);

    // Create Middleware: Hardware
    // 创建中间件: Hardware
    final hardwareMiddleware = MiddlewareItem(
      id: 'hardware_middleware',
      name: 'Hardware',
      icon: 'hardware',
      pageChildren: [internalDevicePage.id],
      children: [internalDevicePage.id], // Ordered list
    );
    await middlewareBox.put(hardwareMiddleware.id, hardwareMiddleware);

    // Create Middleware: Status
    // 创建中间件: Status
    final statusMiddleware = MiddlewareItem(
      id: 'status_middleware',
      name: 'Status',
      icon: 'bar_chart',
      middlewareChildren: [hardwareMiddleware.id],
      children: [hardwareMiddleware.id], // Ordered list
    );
    await middlewareBox.put(statusMiddleware.id, statusMiddleware);

    // Create Root Middleware: Router
    // 创建根中间件: Router
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