import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../db/models/router_item.dart';
import '../../utils/openwrt_auth_service.dart';
import 'router_repository.dart';

// Repository Provider
/// routerRepositoryProvider
/// 
/// Function: Provides RouterRepository instance.
final routerRepositoryProvider = Provider<RouterRepository>((ref) {
  return RouterRepository();
});

// Router List State
/// RouterListNotifier
/// 
/// Function: Manages the list of routers.
/// Inputs: CRUD methods.
/// Outputs: 
///   - [state]: List<RouterItem>.
class RouterListNotifier extends StateNotifier<List<RouterItem>> {
  final RouterRepository _repository;

  RouterListNotifier(this._repository) : super([]) {
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
  }

  Future<void> deleteRouter(String id) async {
    await _repository.deleteRouter(id);
    _loadRouters();
  }
}

/// routerListProvider
/// 
/// Function: Provides the router list state.
final routerListProvider = StateNotifierProvider<RouterListNotifier, List<RouterItem>>((ref) {
  final repository = ref.watch(routerRepositoryProvider);
  return RouterListNotifier(repository);
});

// Connection State
final currentSessionProvider = StateProvider<String?>((ref) => null);
final connectionStatusProvider = StateProvider<bool>((ref) => false);
final connectionLoadingProvider = StateProvider<bool>((ref) => false);
final currentRouterProvider = StateProvider<RouterItem?>((ref) => null);
final editModeProvider = StateProvider<bool>((ref) => false);

final openWrtAuthProvider = Provider<OpenWrtAuthService>((ref) {
  return OpenWrtAuthService();
});

/// RouterConnectionNotifier
/// 
/// Function: Manages connection logic to a router.
/// Inputs: 
///   - [connect]: Initiates connection.
/// Outputs: 
///   - [Future<bool>]: Connection success status.
class RouterConnectionNotifier {
  final Ref ref;

  RouterConnectionNotifier(this.ref);

  Future<bool> connect(RouterItem router) async {
    ref.read(connectionLoadingProvider.notifier).state = true;
    try {
      final authService = ref.read(openWrtAuthProvider);
      final session = await authService.login(
        router.host,
        router.port,
        router.username,
        router.password,
        router.isHttps,
      );

      if (session != null) {
        ref.read(currentSessionProvider.notifier).state = session;
        ref.read(connectionStatusProvider.notifier).state = true;
        ref.read(currentRouterProvider.notifier).state = router;
        return true;
      } else {
        ref.read(connectionStatusProvider.notifier).state = false;
        return false;
      }
    } catch (e) {
      ref.read(connectionStatusProvider.notifier).state = false;
      return false;
    } finally {
      ref.read(connectionLoadingProvider.notifier).state = false;
    }
  }
}

/// routerConnectionProvider
/// 
/// Function: Provides the connection notifier.
final routerConnectionProvider = Provider<RouterConnectionNotifier>((ref) {
  return RouterConnectionNotifier(ref);
});