import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'memory_usage_service.dart';

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
    final rpcState = ref.watch(memoryUsageProvider(_rpcRequest));

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
              data: (usage) {
                if (usage != null) {
                  return Column(
                    children: [
                      LinearProgressIndicator(value: usage.percent),
                      const SizedBox(height: AppMeta.smallPadding),
                      Text('${(usage.percent * 100).toStringAsFixed(1)}% Used'),
                      Text('${(usage.used / AppMeta.bytesPerMegabyte).toStringAsFixed(1)}MB / ${(usage.total / AppMeta.bytesPerMegabyte).toStringAsFixed(1)}MB'),
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