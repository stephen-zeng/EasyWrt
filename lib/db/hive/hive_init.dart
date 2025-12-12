import 'package:hive_flutter/hive_flutter.dart';

import '../models/app_setting_item.dart';
import '../models/hierarchy_items.dart';
import '../models/router_item.dart';
import 'manual_adapters.dart';

/// HiveInit
/// 
/// Function: Initializes Hive, registers adapters, and opens boxes.
/// Inputs: None
/// Outputs: None (Side effect: Hive setup)
class HiveInit {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(RouterItemAdapter());
    Hive.registerAdapter(ThemeModeEnumAdapter());
    Hive.registerAdapter(AppSettingItemAdapter());
    Hive.registerAdapter(MiddlewareItemAdapter());
    Hive.registerAdapter(PageItemAdapter());

    // Open Boxes
    await Hive.openBox<RouterItem>('routers');
    await Hive.openBox<AppSettingItem>('app_settings');
    await Hive.openBox<MiddlewareItem>('middlewares');
    await Hive.openBox<PageItem>('pages');
  }
}
