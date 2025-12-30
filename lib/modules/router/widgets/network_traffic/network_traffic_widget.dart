import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';
import 'network_traffic_service.dart';

class NetworkTrafficWidget extends BaseWidget<Map<String, NetworkRate>> {
  const NetworkTrafficWidget({super.key});

  @override
  String get typeKey => 'network_traffic';
  @override
  String get name => 'Network Traffic';
  @override
  String get description => 'Shows real-time network traffic rates.';
  
  @override
  IconData get icon => Icons.compare_arrows;
  
  @override
  List<String> get supportedSizes => const ['1x1', '1x2', '2x1', '2x2', '2x4', '4x2', '4x4'];

  static const _rpcRequest = RpcRequest(
    namespace: 'network.device',
    method: 'status',
  );

  @override
  AsyncValue<Map<String, NetworkRate>> watchData(WidgetRef ref) {
    return ref.watch(networkRateProvider(_rpcRequest));
  }

  @override
  Widget render2x1(BuildContext context, Map<String, NetworkRate> rates, WidgetRef ref) {
    return _buildContent(context, rates, isCompact: true);
  }

  @override
  Widget render2x2(BuildContext context, Map<String, NetworkRate> rates, WidgetRef ref) {
    return _buildContent(context, rates, isCompact: false);
  }

  @override
  Widget render4x4(BuildContext context, Map<String, NetworkRate> rates, WidgetRef ref) {
    return _buildContent(context, rates, isCompact: false, isFull: true);
  }

  Widget _buildContent(BuildContext context, Map<String, NetworkRate> rates, {required bool isCompact, bool isFull = false}) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppMeta.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: isCompact ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppMeta.smallPadding),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (rates.isEmpty) {
                    return const Center(child: Text('...'));
                  }
                  final activeRates = rates.entries.where((e) => e.value.rxRate > 1 || e.value.txRate > 1).toList();
                  if (activeRates.isEmpty) return const Center(child: Text('No Traffic'));

                  return ListView.builder(
                    itemCount: isCompact ? 1 : activeRates.length,
                    itemBuilder: (context, index) {
                      final entry = activeRates[index];
                      return _buildRateRow(context, entry.key, entry.value.rxRate, entry.value.txRate, isCompact);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateRow(BuildContext context, String interface, double rx, double tx, bool isCompact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isCompact) Expanded(child: Text(interface, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('↓ ${_formatRate(rx)}', style: const TextStyle(color: Colors.green, fontSize: 11)),
              Text('↑ ${_formatRate(tx)}', style: const TextStyle(color: Colors.blue, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRate(double bytesPerSec) {
    if (bytesPerSec > AppMeta.bytesPerMegabyte) {
      return '${(bytesPerSec / AppMeta.bytesPerMegabyte).toStringAsFixed(1)} MB/s';
    } else if (bytesPerSec > AppMeta.bytesPerKilobyte) {
      return '${(bytesPerSec / AppMeta.bytesPerKilobyte).toStringAsFixed(1)} KB/s';
    } else {
      return '${bytesPerSec.toStringAsFixed(0)} B/s';
    }
  }
}