import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/transient_models.dart';
import 'current_router_controller.dart';
import 'connection_controller.dart';
import 'package:easywrt/utils/network/rpc_service.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/utils/network/rpc_types.dart';

export 'package:easywrt/utils/network/rpc_types.dart';

// Service Provider
final systemServiceRpcProvider = Provider<RpcService>((ref) {
  return RpcService();
});

// Generic Polling Notifier
class RpcNotifier extends StateNotifier<AsyncValue<dynamic>> {
  final RpcService _service;
  final Ref _ref;
  final RpcRequest _request;
  bool _isLoggingIn = false;

  RpcNotifier(this._service, this._ref, this._request)
      : super(const AsyncValue.loading()) {
    _startPolling();
  }

  Future<void> _startPolling() async {
    while (mounted) {
      await _fetchData();
      if (!mounted) break;
      await Future.delayed(const Duration(seconds: AppMeta.defaultPollingIntervalSeconds));
    }
  }

  Future<void> _fetchData() async {
    // If currently logging in, skip this poll cycle
    if (_isLoggingIn) return;

    CurrentRouter? router = _ref.read<CurrentRouter?>(currentRouterProvider);

    // If no router selected, nothing to poll
    if (router == null) return;

    // Check if token is valid (present)
    if (router.token == null || router.token!.isEmpty) {
      final success = await _attemptAutoLogin();
      debugPrint('Auto-login attempt: ${success ? "Success" : "Failure"}');
      if (!success) {
        if (mounted) state = const AsyncValue.error('Not connected', StackTrace.empty);
        return;
      }
      // Refresh local vars after login
      router = _ref.read<CurrentRouter?>(currentRouterProvider);
    }

    if (router == null || router.token == null) return;

    try {
      dynamic result;
      for (int i=1;i<=3;i++) {
        result = await _service.call(
          router!.routerItem.host,
          router.routerItem.port,
          router.token!,
          router.routerItem.isHttps,
          _request.namespace,
          _request.method,
          _request.params,
        );
        if (result != null) break;
        final success = await _attemptAutoLogin();
        debugPrint('Auto-login attempt: ${success ? "Success" : "Failure"}');
        if (!success) {
          if (mounted) state = const AsyncValue.error('Not connected', StackTrace.empty);
          return;
        }
        // Refresh local vars after login
        router = _ref.read<CurrentRouter?>(currentRouterProvider);
      }

      if (mounted) {
        if (result != null) {
          state = AsyncValue.data(result);
        } else {
          // If result is null, it could be auth failure or other error.
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
      final currentRouter = _ref.read<CurrentRouter?>(currentRouterProvider);
      if (currentRouter == null) return false;

      // No need to fetch RouterItem from repo as connect now takes CurrentRouter
      debugPrint("Attempting auto-login for router: ${currentRouter.routerItem.host}");
      
      final connectionNotifier = _ref.read(routerConnectionProvider);
      return await connectionNotifier.connect(currentRouter.routerItem);
      
    } catch (e) {
      return false;
    } finally {
      _isLoggingIn = false;
    }
  }
}

// The Family Provider
final rpcPollingProvider = StateNotifierProvider.family.autoDispose<
    RpcNotifier,
    AsyncValue<dynamic>,
    RpcRequest>((ref, request) {
  final service = ref.watch(systemServiceRpcProvider);
  return RpcNotifier(service, ref, request);
});