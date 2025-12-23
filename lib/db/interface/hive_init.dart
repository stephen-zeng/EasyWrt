import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/db/models/app_setting_item.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/db/models/router_item.dart';

/// HiveInit
/// HiveInit
/// 
/// Function: Initializes Hive, registers adapters, and opens boxes.
/// Function: 初始化 Hive，注册适配器，并打开 boxes。
/// Inputs: None
/// Inputs: 无
/// Outputs: None (Side effect: Hive setup)
/// Outputs: 无 (副作用: Hive 设置)
class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    // 注册适配器
    Hive.registerAdapter(RouterItemAdapter());
    Hive.registerAdapter(ThemeModeEnumAdapter());
    Hive.registerAdapter(AppSettingItemAdapter());
    Hive.registerAdapter(MiddlewareItemAdapter());
    Hive.registerAdapter(PageItemAdapter());
    Hive.registerAdapter(StripeItemAdapter());
    Hive.registerAdapter(WidgetInstanceAdapter());

    // Open Boxes
    // 打开 Boxes
    await Hive.openBox<RouterItem>('routers');
    await Hive.openBox<AppSettingItem>('app_settings');
    await Hive.openBox<MiddlewareItem>('middlewares');
    await Hive.openBox<PageItem>('pages');
  }
}
