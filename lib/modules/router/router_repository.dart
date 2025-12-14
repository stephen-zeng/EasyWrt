import 'package:hive/hive.dart';
import '../../db/models/router_item.dart';

/// RouterRepository
/// RouterRepository
/// 
/// Function: Handles persistence of router profiles using Hive.
/// Function: 使用 Hive 处理路由器配置文件的持久化。
/// Inputs: 
/// Inputs: 
///   - [addRouter], [updateRouter], [deleteRouter]: CRUD operations.
///   - [addRouter], [updateRouter], [deleteRouter]: CRUD 操作。
/// Outputs: 
/// Outputs: 
///   - [getAllRouters]: List of stored routers.
///   - [getAllRouters]: 存储的路由器列表。
class RouterRepository {
  final Box<RouterItem> _box = Hive.box<RouterItem>('routers');

  List<RouterItem> getAllRouters() {
    return _box.values.toList();
  }

  RouterItem? getRouter(String id) {
    return _box.get(id);
  }

  Future<void> addRouter(RouterItem router) async {
    await _box.put(router.id, router);
  }

  Future<void> updateRouter(RouterItem router) async {
    await _box.put(router.id, router);
  }

  Future<void> deleteRouter(String id) async {
    await _box.delete(id);
  }
}
