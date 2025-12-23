import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/widgets/base_widget.dart';
import 'memory_usage_service.dart';

/// MemoryUsageWidget
class MemoryUsageWidget extends BaseWidget {
  const MemoryUsageWidget({super.key});

  @override
  String get typeKey => 'memory_usage';
  @override
  String get name => 'Memory Usage';
  @override
  String get description => 'Real-time memory consumption.';
  @override
  int get iconCode => 0xe5d2; // memory icon
  @override
  List<String> get supportedSizes => const ['2x2', '4x2'];

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
              name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppMeta.defaultPadding),
            Expanded(
              child: rpcState.when(
                data: (usage) {
                  if (usage != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
        ),
      ),
    );
  }
}
