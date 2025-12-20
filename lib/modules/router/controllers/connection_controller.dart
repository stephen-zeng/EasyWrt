import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/utils/network/rpc_service.dart';
import 'package:easywrt/db/models/router_item.dart';
import 'current_router_controller.dart';

final systemServiceProvider = Provider<RpcService>((ref) {
  return RpcService();
});

final currentSessionProvider = StateProvider<String?>((ref) => null);
final connectionStatusProvider = StateProvider<bool>((ref) => false);
final connectionLoadingProvider = StateProvider<bool>((ref) => false);

class RouterConnectionNotifier {
  final Ref ref;
  Future<bool>? _pendingConnection;

  RouterConnectionNotifier(this.ref);

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
        ref.read(currentRouterProvider.notifier).selectRouter(routerItem, newToken: session);
        
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

final routerConnectionProvider = Provider<RouterConnectionNotifier>((ref) {
  return RouterConnectionNotifier(ref);
});
