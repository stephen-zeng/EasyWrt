import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/router_item.dart';
import 'package:easywrt/db/hive/router_repository.dart';
import 'package:easywrt/modules/router/controllers/current_router_controller.dart';
import 'package:easywrt/modules/router/controllers/connection_controller.dart';

class RouterListNotifier extends StateNotifier<List<RouterItem>> {
  final RouterRepository _repository;
  final Ref _ref;

  RouterListNotifier(this._repository, this._ref) : super([]) {
    _loadRouters();
  }

  void _loadRouters() {
    state = _repository.getAllRouters();
  }

  Future<void> addRouter(RouterItem router) async {
    await _repository.addRouter(router);
    _loadRouters();
  }

  Future<void> updateRouter(RouterItem router) async {
    await _repository.updateRouter(router);
    _loadRouters();
    
    // Sync with CurrentRouter if it matches
    final currentRouter = _ref.read(currentRouterProvider);
    if (currentRouter != null && currentRouter.routerItem.id == router.id) {
       _ref.read(currentRouterProvider.notifier).updateRouterItem(router);
    }
  }

  Future<void> deleteRouter(String id) async {
    await _repository.deleteRouter(id);
    _loadRouters();
    
    // If current router is deleted, clear selection
    final currentRouter = _ref.read(currentRouterProvider);
    if (currentRouter != null && currentRouter.routerItem.id == id) {
       _ref.read(currentRouterProvider.notifier).clear();
       _ref.read(currentSessionProvider.notifier).state = null;
       _ref.read(connectionStatusProvider.notifier).state = false;
    }
  }
}

final routerListProvider = StateNotifierProvider<RouterListNotifier, List<RouterItem>>((ref) {
  final repository = ref.watch(routerRepositoryProvider);
  return RouterListNotifier(repository, ref);
});
