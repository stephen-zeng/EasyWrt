import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../router_controller.dart';
import '../../../utils/system_service.dart';

// Provider for System Service
/// systemInfoServiceProvider
/// 
/// Function: Provides the SystemInfoService instance.
final systemInfoServiceProvider = Provider<SystemInfoService>((ref) {
  return SystemInfoService();
});

// State for CPU Usage
/// CpuUsageNotifier
/// 
/// Function: Fetches and manages CPU load data.
class CpuUsageNotifier extends StateNotifier<AsyncValue<List<double>>> {
  final SystemInfoService _service;
  final Ref _ref;
  Timer? _timer;

  CpuUsageNotifier(this._service, this._ref) : super(const AsyncValue.loading()) {
    _startPolling();
  }

  void _startPolling() {
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchData());
  }

  Future<void> _fetchData() async {
    final session = _ref.read(currentSessionProvider);
    final router = _ref.read(currentRouterProvider);
    
    if (session == null || router == null) return;
    
    try {
      final info = await _service.getSystemInfo(
        router.host,
        router.port,
        session,
        router.isHttps,
      );

      if (info != null && info['load'] != null) {
        // 'load' is typically [1min, 5min, 15min] average
        final load = (info['load'] as List).map((e) => (e as num).toDouble()).toList();
        if (mounted) state = AsyncValue.data(load);
      }
    } catch (e, stack) {
      if (mounted) state = AsyncValue.error(e, stack);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// cpuUsageProvider
/// 
/// Function: Provides CPU usage state.
final cpuUsageProvider = StateNotifierProvider.autoDispose<CpuUsageNotifier, AsyncValue<List<double>>>((ref) {
  final service = ref.watch(systemInfoServiceProvider);
  return CpuUsageNotifier(service, ref);
});

/// CpuUsageWidget
/// 
/// Function: Displays system load averages.
class CpuUsageWidget extends ConsumerWidget {
  const CpuUsageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cpuState = ref.watch(cpuUsageProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Load',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            cpuState.when(
              data: (load) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLoadItem(context, '1 min', load.isNotEmpty ? load[0] : 0),
                  _buildLoadItem(context, '5 min', load.length > 1 ? load[1] : 0),
                  _buildLoadItem(context, '15 min', load.length > 2 ? load[2] : 0),
                ],
              ),
              error: (err, stack) => Text('Error: $err'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadItem(BuildContext context, String label, double value) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(2),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
