import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modules/router/router_controller.dart';
import '../modules/router/router_repository.dart';
import '../modules/setting/theme_provider.dart';
import 'system_service.dart';
import 'meta.dart';
import 'rpc_types.dart';

export 'rpc_types.dart';

// Service Provider
final systemServiceRpcProvider = Provider<SystemInfoService>((ref) {
  return SystemInfoService();
});

// Generic Polling Notifier
class RpcPollingNotifier extends StateNotifier<AsyncValue<dynamic>> {
  final SystemInfoService _service;
  final Ref _ref;
  final RpcRequest _request;
  Timer? _timer;
  bool _isLoggingIn = false;

  RpcPollingNotifier(this._service, this._ref, this._request)
      : super(const AsyncValue.loading()) {
    _startPolling();
  }

  void _startPolling() {
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: AppMeta.defaultPollingIntervalSeconds), (_) => _fetchData());
  }

  Future<void> _fetchData() async {
    // If currently logging in, skip this poll cycle
    if (_isLoggingIn) return;

    var session = _ref.read(currentSessionProvider);
    var router = _ref.read(currentRouterProvider);

    // If no session, attempt to restore connection
    if (session == null || router == null) {
      final success = await _attemptAutoLogin();
      if (!success) {
        if (mounted) state = const AsyncValue.error('Not connected', StackTrace.empty);
        return;
      }
      // Refresh local vars after login
      session = _ref.read(currentSessionProvider);
      router = _ref.read(currentRouterProvider);
    }

    if (session == null || router == null) return;

    try {
      final result = await _service.call(
        router.host,
        router.port,
        session,
        router.isHttps,
        _request.namespace,
        _request.method,
        _request.params,
      );

      if (mounted) {
        if (result != null) {
          state = AsyncValue.data(result);
        } else {
          // If result is null, it could be auth failure or other error.
          // For now, we assume it might be valid empty data or temporary error.
          // To be more robust, we could try to re-login if we suspect token expiry.
          // But strict "check login" usually implies handling the 403/Permission Denied specifically.
          // Since SystemService returns null on error, we can't distinguish easily without changing it.
          // We'll keep it simple: just report null data.
          state = const AsyncValue.data(null);
        }
      }
    } catch (e, stack) {
      if (mounted) state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> _attemptAutoLogin() async {
    _isLoggingIn = true;
    try {
      final themeRepo = _ref.read(themeRepositoryProvider);
      final settings = themeRepo.getSettings();
      final lastRouterId = settings?.lastConnectedRouterId;

      if (lastRouterId == null) return false;

      final routerRepo = _ref.read(routerRepositoryProvider);
      final router = routerRepo.getRouter(lastRouterId);

      if (router == null) return false;

      // Use the connection logic from router_controller essentially, but inline or via provider
      // Reusing RouterConnectionNotifier.connect would be cleanest but it's designed for UI feedback (loading state etc)
      // We can use it, but we should be careful about side effects if multiple widgets poll.
      // Actually, _isLoggingIn flag protects *this* notifier instance.
      // But if 5 widgets are mounted, 5 notifiers might try to login simultaneously.
      
      // To prevent stampede, we should check if session appeared while we were waiting?
      // Or relies on RouterConnectionNotifier to handle concurrency? It doesn't really.
      
      // Better: Check if already connecting?
      // connectionLoadingProvider is global.
      if (_ref.read(connectionLoadingProvider)) {
        // Someone else is connecting. Wait? or just return false and try next poll?
        return false; 
      }

      final connectionNotifier = _ref.read(routerConnectionProvider);
      return await connectionNotifier.connect(router);
      
    } catch (e) {
      return false;
    } finally {
      _isLoggingIn = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// The Family Provider
final rpcPollingProvider = StateNotifierProvider.family.autoDispose<
    RpcPollingNotifier,
    AsyncValue<dynamic>,
    RpcRequest>((ref, request) {
  final service = ref.watch(systemServiceRpcProvider);
  return RpcPollingNotifier(service, ref, request);
});