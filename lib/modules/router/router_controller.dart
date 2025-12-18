import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../db/models/hierarchy_items.dart';
import '../../db/models/router_item.dart';
import '../../db/models/transient_models.dart';
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
       _ref.read(currentRouterProvider.notifier).state = currentRouter.copyWith(
         routerItem: router,
       );
    }
  }

  Future<void> deleteRouter(String id) async {
    await _repository.deleteRouter(id);
    _loadRouters();
    
    // If current router is deleted, clear selection
    final currentRouter = _ref.read(currentRouterProvider);
    if (currentRouter != null && currentRouter.routerItem.id == id) {
       _ref.read(currentRouterProvider.notifier).state = null;
       _ref.read(currentSessionProvider.notifier).state = null;
       _ref.read(connectionStatusProvider.notifier).state = false;
    }
  }
}

/// routerListProvider
/// routerListProvider
/// 
/// Function: Provides the router list state.
/// Function: 提供路由器列表状态。
final routerListProvider = StateNotifierProvider<RouterListNotifier, List<RouterItem>>((ref) {
  final repository = ref.watch(routerRepositoryProvider);
  return RouterListNotifier(repository, ref);
});

/// CurrentMiddlewareNotifier
class CurrentMiddlewareNotifier extends StateNotifier<CurrentMiddleware?> {
  CurrentMiddlewareNotifier() : super(null);

  void init(MiddlewareItem item) {
    if (state == null) {
      state = CurrentMiddleware(
        middlewareItem: item,
        historyMiddlewareIDs: [],
        slideMiddlewareID: '',
      );
    }
  }
  
  void push(MiddlewareItem newItem) {
    if (state == null) {
        init(newItem);
        return;
    }
    // Prevent pushing same item
    if (state!.middlewareItem.id == newItem.id) return;
    
    final newHistory = List<String>.from(state!.historyMiddlewareIDs)..add(state!.middlewareItem.id);
    state = state!.copyWith(
        middlewareItem: newItem,
        historyMiddlewareIDs: newHistory
    );
  }

  String? pop() {
      if (state == null || state!.historyMiddlewareIDs.isEmpty) return null;
      
      final lastId = state!.historyMiddlewareIDs.last;
      final newHistory = List<String>.from(state!.historyMiddlewareIDs)..removeLast();
      
      state = state!.copyWith(historyMiddlewareIDs: newHistory);
      return lastId;
  }

  void saveSlideMiddlewareID(String id) {
    if (state != null) {
      state = state!.copyWith(slideMiddlewareID: id);
    }
  }
  
  void replaceCurrent(MiddlewareItem item) {
    if (state != null) {
      state = state!.copyWith(middlewareItem: item);
    } else {
      init(item);
    }
  }
}

final currentMiddlewareProvider = StateNotifierProvider<CurrentMiddlewareNotifier, CurrentMiddleware?>((ref) {
  return CurrentMiddlewareNotifier();
});

// Connection State
final currentSessionProvider = StateProvider<String?>((ref) => null);
final connectionStatusProvider = StateProvider<bool>((ref) => false);
final connectionLoadingProvider = StateProvider<bool>((ref) => false);
final currentRouterProvider = StateProvider<CurrentRouter?>((ref) {
  final themeRepo = ref.read(themeRepositoryProvider);
  final settings = themeRepo.getSettings();
  final lastId = settings?.lastConnectedRouterId;

  if (lastId != null) {
    final routerRepo = ref.read(routerRepositoryProvider);
    final routers = routerRepo.getAllRouters();
    try {
      final routerItem = routers.firstWhere((element) => element.id == lastId);
      return CurrentRouter(
        routerItem: routerItem,
        token: null,
      );
    } catch (e) {
      // Router might have been deleted
      return null;
    }
  }
  return null;
});
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
  Future<bool>? _pendingConnection;

  RouterConnectionNotifier(this.ref);

  Future<void> selectRouter(RouterItem routerItem, {String? newToken}) async {
    // Get existing CurrentRouter to preserve old token if not providing a new one
    final oldCurrentRouter = ref.read(currentRouterProvider);
    final String? tokenToUse = newToken ?? oldCurrentRouter?.token;

    final updatedRouter = CurrentRouter(
      routerItem: routerItem,
      token: tokenToUse,
    );
    
    ref.read(currentRouterProvider.notifier).state = updatedRouter;
  }

  Future<bool> connect(RouterItem routerItem) async {
    if (_pendingConnection != null) {
      return _pendingConnection!;
    }

    _pendingConnection = _connectInternal(routerItem);
    try {
      return await _pendingConnection!;
    } finally {
      _pendingConnection = null;
    }
  }

  Future<bool> _connectInternal(RouterItem routerItem) async {
    ref.read(connectionLoadingProvider.notifier).state = true;
    try {
      final systemService = ref.read(systemServiceProvider);
      // Use 000... for session ID when logging in
      final result = await systemService.call(
        routerItem.host,
        routerItem.port,
        "00000000000000000000000000000000", 
        routerItem.isHttps,
        "session",
        "login",
        {"username": routerItem.username, "password": routerItem.password}
      );

      String? session;
      if (result != null && result is Map && result['ubus_rpc_session'] != null) {
        session = result['ubus_rpc_session'] as String;
      }

      if (session != null) {
        ref.read(currentSessionProvider.notifier).state = session;
        ref.read(connectionStatusProvider.notifier).state = true;
        
        // Only connect writes the token back to CurrentRouter
        await selectRouter(routerItem, newToken: session);
        
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

  Future<bool> testConnection(RouterItem routerItem) async {
    ref.read(connectionLoadingProvider.notifier).state = true;
    try {
      final systemService = ref.read(systemServiceProvider);
      final result = await systemService.call(
        routerItem.host,
        routerItem.port,
        "00000000000000000000000000000000", 
        routerItem.isHttps,
        "session",
        "login",
        {"username": routerItem.username, "password": routerItem.password}
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
