import 'package:hive/hive.dart';
import 'package:easywrt/db/models/router_item.dart';

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
