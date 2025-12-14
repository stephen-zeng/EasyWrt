import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rpc_polling_service.dart';

// Model for Rate
class NetworkRate {
  final double rxRate; // bytes per second
  final double txRate; // bytes per second

  NetworkRate({required this.rxRate, required this.txRate});
}

// State for Network Traffic Rate Calculation
// This notifier listens to the generic RPC provider and maintains rate state
class NetworkRateNotifier extends StateNotifier<AsyncValue<Map<String, NetworkRate>>> {
  final Ref _ref;
  final RpcRequest _request;
  
  Map<String, dynamic>? _previousStats;
  DateTime? _lastFetchTime;

  NetworkRateNotifier(this._ref, this._request) : super(const AsyncValue.loading()) {
    // Listen to the RPC provider
    _ref.listen<AsyncValue<dynamic>>(rpcPollingProvider(_request), (previous, next) {
      next.when(
        data: (data) => _processData(data),
        error: (err, stack) => state = AsyncValue.error(err, stack),
        loading: () {}, // Keep current state or show loading?
      );
    });
  }

  void _processData(dynamic currentStats) {
    if (currentStats == null) return;
    
    final now = DateTime.now();
    final rates = <String, NetworkRate>{};

    if (_previousStats != null && _lastFetchTime != null) {
      final dt = now.difference(_lastFetchTime!).inMilliseconds / 1000.0;
      if (dt > 0) {
        (currentStats as Map<String, dynamic>).forEach((key, value) {
          if (value is Map && value['stats'] != null) {
            final stats = value['stats'];
            final prevDevice = _previousStats![key];
            if (prevDevice != null && prevDevice['stats'] != null) {
              final prevStats = prevDevice['stats'];
              
              final rxCurrent = (stats['rx_bytes'] as num).toDouble();
              final txCurrent = (stats['tx_bytes'] as num).toDouble();
              final rxPrev = (prevStats['rx_bytes'] as num).toDouble();
              final txPrev = (prevStats['tx_bytes'] as num).toDouble();

              final rxRate = (rxCurrent - rxPrev) / dt;
              final txRate = (txCurrent - txPrev) / dt;

              rates[key] = NetworkRate(
                rxRate: rxRate < 0 ? 0 : rxRate, // Handle reboot/counter reset
                txRate: txRate < 0 ? 0 : txRate,
              );
            }
          }
        });
      }
    }

    _previousStats = currentStats as Map<String, dynamic>;
    _lastFetchTime = now;

    if (mounted) state = AsyncValue.data(rates);
  }
}

// Provider for Network Rate
final networkRateProvider = StateNotifierProvider.family.autoDispose<
    NetworkRateNotifier,
    AsyncValue<Map<String, NetworkRate>>,
    RpcRequest>((ref, request) {
  // We don't watch here because we use listen in constructor to handle logic
  // But we need to keep the RpcPollingNotifier alive?
  // Yes, we should probably watch it to ensure it's active.
  ref.watch(rpcPollingProvider(request)); 
  return NetworkRateNotifier(ref, request);
});