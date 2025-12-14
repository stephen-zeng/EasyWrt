import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/rpc_polling_service.dart';
import '../../../utils/meta.dart';

/// MemoryUsageWidget
class MemoryUsageWidget extends ConsumerWidget {
  const MemoryUsageWidget({super.key});

  // Widget stores its own params
  static const _rpcRequest = RpcRequest(
    namespace: 'system',
    method: 'info',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Call utils function by passing params
    final rpcState = ref.watch(rpcPollingProvider(_rpcRequest));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppMeta.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memory Usage',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppMeta.defaultPadding),
            rpcState.when(
              data: (data) {
                if (data != null && data is Map && data['memory'] != null) {
                  final mem = data['memory'] as Map<String, dynamic>;
                  final total = mem['total'] as num;
                  final free = mem['free'] as num;
                  final used = total - free;
                  final percent = (used / total);
                  return Column(
                    children: [
                      LinearProgressIndicator(value: percent),
                      const SizedBox(height: AppMeta.smallPadding),
                      Text('${(percent * 100).toStringAsFixed(1)}% Used'),
                      Text('${(used / AppMeta.bytesPerMegabyte).toStringAsFixed(1)}MB / ${(total / AppMeta.bytesPerMegabyte).toStringAsFixed(1)}MB'),
                    ],
                  );
                }
                return const Text('No Data');
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