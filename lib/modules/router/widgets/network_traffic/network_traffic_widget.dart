import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/widgets/base_widget.dart';
import 'network_traffic_service.dart';

class NetworkTrafficWidget extends BaseWidget {
  const NetworkTrafficWidget({super.key});

  @override
  String get typeKey => 'network_traffic';
  @override
  String get name => 'Network Traffic';
  @override
  String get description => 'Real-time upload and download speeds.';
  @override
  int get iconCode => 0xe405; // network_check
  @override
  List<String> get supportedSizes => const ['2x1', '2x2', '4x4'];

  // Widget stores its own params
  static const _rpcRequest = RpcRequest(
    namespace: 'network.device',
    method: 'status',
  );

  String _formatRate(double bytesPerSec) {
    if (bytesPerSec > AppMeta.bytesPerMegabyte) {
      return '${(bytesPerSec / AppMeta.bytesPerMegabyte).toStringAsFixed(1)} MB/s';
    } else if (bytesPerSec > AppMeta.bytesPerKilobyte) {
      return '${(bytesPerSec / AppMeta.bytesPerKilobyte).toStringAsFixed(1)} KB/s';
    } else {
      return '${bytesPerSec.toStringAsFixed(0)} B/s';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Call utils function (via rate provider) by passing params
    final trafficState = ref.watch(networkRateProvider(_rpcRequest));

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
              child: SingleChildScrollView(
                child: trafficState.when(
                  data: (rates) {
                    if (rates.isEmpty) {
                      return const Text('Measuring...');
                    }
                    final sortedKeys = rates.keys.toList()..sort();
                    
                    return Column(
                      children: sortedKeys.map((key) {
                        final rate = rates[key]!;
                        if (rate.rxRate < 1 && rate.txRate < 1) return const SizedBox.shrink();
                
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppMeta.tinyPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(key, style: const TextStyle(fontWeight: FontWeight.bold))),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('↓ ${_formatRate(rate.rxRate)}', style: const TextStyle(color: Colors.green)),
                                  Text('↑ ${_formatRate(rate.txRate)}', style: const TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  error: (err, stack) => Text('Error: $err'),
                  loading: () => const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
