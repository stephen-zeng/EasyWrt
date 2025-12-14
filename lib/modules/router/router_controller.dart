import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../db/models/router_item.dart';
import '../../utils/system_service.dart';
import 'router_repository.dart';
import '../setting/theme_provider.dart';

// Repository Provider
/// routerRepositoryProvider
/// routerRepositoryProvider
/// 
/// Function: Provides RouterRepository instance.
/// Function: 提供 RouterRepository 实例。
final routerRepositoryProvider = Provider<RouterRepository>((ref) {
  return RouterRepository();
});

// Router List State
/// RouterListNotifier
/// RouterListNotifier
/// 
/// Function: Manages the list of routers.
/// Function: 管理路由器列表。
/// Inputs: CRUD methods.
/// Inputs: CRUD 方法。
/// Outputs: 
/// Outputs: 
///   - [state]: List<RouterItem>.
///   - [state]: List<RouterItem>。
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
/// routerListProvider
/// 
/// Function: Provides the router list state.
/// Function: 提供路由器列表状态。
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

final systemServiceProvider = Provider<SystemInfoService>((ref) {
  return SystemInfoService();
});

/// RouterConnectionNotifier
/// RouterConnectionNotifier
/// 
/// Function: Manages connection logic to a router.
/// Function: 管理到路由器的连接逻辑。
/// Inputs: 
/// Inputs: 
///   - [connect]: Initiates connection.
///   - [connect]: 发起连接。
/// Outputs: 
/// Outputs: 
///   - [Future<bool>]: Connection success status.
///   - [Future<bool>]: 连接成功状态。
class RouterConnectionNotifier {
  final Ref ref;

  RouterConnectionNotifier(this.ref);

  Future<bool> connect(RouterItem router) async {
    ref.read(connectionLoadingProvider.notifier).state = true;
    try {
      final systemService = ref.read(systemServiceProvider);
      // Use 000... for session ID when logging in
      final result = await systemService.call(
        router.host,
        router.port,
        "00000000000000000000000000000000", 
        router.isHttps,
        "session",
        "login",
        {"username": router.username, "password": router.password}
      );

      String? session;
      if (result != null && result is Map && result['ubus_rpc_session'] != null) {
        session = result['ubus_rpc_session'] as String;
      }

      if (session != null) {
        ref.read(currentSessionProvider.notifier).state = session;
        ref.read(connectionStatusProvider.notifier).state = true;
        ref.read(currentRouterProvider.notifier).state = router;
        
        // Save last connected router ID
        final themeRepo = ref.read(themeRepositoryProvider);
        await themeRepo.updateLastConnectedRouter(router.id);
        
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

  Future<bool> testConnection(RouterItem router) async {
    ref.read(connectionLoadingProvider.notifier).state = true;
    try {
      final systemService = ref.read(systemServiceProvider);
      final result = await systemService.call(
        router.host,
        router.port,
        "00000000000000000000000000000000", 
        router.isHttps,
        "session",
        "login",
        {"username": router.username, "password": router.password}
      );
      
      if (result != null && result is Map && result['ubus_rpc_session'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      ref.read(connectionLoadingProvider.notifier).state = false;
    }
  }
}

/// routerConnectionProvider
/// routerConnectionProvider
/// 
/// Function: Provides the connection notifier.
/// Function: 提供连接通知器。
final routerConnectionProvider = Provider<RouterConnectionNotifier>((ref) {
  return RouterConnectionNotifier(ref);
});