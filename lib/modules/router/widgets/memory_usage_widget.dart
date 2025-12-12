import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../router_controller.dart';
import '../../../utils/system_service.dart';
import 'cpu_usage_widget.dart'; // Reuse service provider

// State for Memory Usage
/// MemoryUsageNotifier
/// 
/// Function: Fetches and manages memory usage data.
class MemoryUsageNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final SystemInfoService _service;
  final Ref _ref;
  Timer? _timer;

  MemoryUsageNotifier(this._service, this._ref) : super(const AsyncValue.loading()) {
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

      if (info != null && info['memory'] != null) {
        if (mounted) state = AsyncValue.data(info['memory'] as Map<String, dynamic>);
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

/// memoryUsageProvider
/// 
/// Function: Provides memory usage state.
final memoryUsageProvider = StateNotifierProvider.autoDispose<MemoryUsageNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(systemInfoServiceProvider);
  return MemoryUsageNotifier(service, ref);
});

/// MemoryUsageWidget
/// 
/// Function: Displays memory usage statistics.
class MemoryUsageWidget extends ConsumerWidget {
  const MemoryUsageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memState = ref.watch(memoryUsageProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory Usage',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            memState.when(
              data: (mem) {
                final total = mem['total'] as num;
                final free = mem['free'] as num;
                final used = total - free;
                final percent = (used / total);
                return Column(
                  children: [
                    LinearProgressIndicator(value: percent),
                    const SizedBox(height: 8),
                    Text('${(percent * 100).toStringAsFixed(1)}% Used'),
                    Text('${(used / 1024 / 1024).toStringAsFixed(1)}MB / ${(total / 1024 / 1024).toStringAsFixed(1)}MB'),
                  ],
                );
              },
              error: (err, stack) => Text('Error: $err'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}