import 'package:hive/hive.dart';
import '../../db/models/router_item.dart';

/// RouterRepository
/// 
/// Function: Handles persistence of router profiles using Hive.
/// Inputs: 
///   - [addRouter], [updateRouter], [deleteRouter]: CRUD operations.
/// Outputs: 
///   - [getAllRouters]: List of stored routers.
class RouterRepository {
  final Box<RouterItem> _box = Hive.box<RouterItem>('routers');

  List<RouterItem> getAllRouters() {
    return _box.values.toList();
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
