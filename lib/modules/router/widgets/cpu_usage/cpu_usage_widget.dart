import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/widgets/base_widget.dart';
import 'cpu_usage_service.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';

class CpuUsageWidget extends BaseWidget {
  const CpuUsageWidget({super.key});

  @override
  String get typeKey => 'cpu_usage';
  
  @override
  String get name => 'CPU Usage';
  
  @override
  String get description => 'Shows system load averages (1m, 5m, 15m).';
  
  @override
  int get iconCode => 0xe1d0; // speed icon
  
  @override
  List<String> get supportedSizes => const ['2x1', '2x2', '4x2'];

  static const _rpcRequest = RpcRequest(
    namespace: 'system',
    method: 'info',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rpcState = ref.watch(cpuLoadProvider(_rpcRequest));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: rpcState.when(
                data: (load) {
                  if (load.isNotEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLoadItem(context, '1 min', load.isNotEmpty ? load[0] : 0),
                        _buildLoadItem(context, '5 min', load.length > 1 ? load[1] : 0),
                        _buildLoadItem(context, '15 min', load.length > 2 ? load[2] : 0),
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