import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';
import 'cpu_usage_service.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';

class CpuUsageWidget extends BaseWidget<List<double>> {
  const CpuUsageWidget({super.key});

  @override
  String get typeKey => 'cpu_usage';
  
  @override
  String get name => 'CPU Usage';
  
  @override
  String get description => 'Shows system load averages (1m, 5m, 15m).';
  
  @override
  IconData get icon => Icons.speed;
  
  @override
  List<String> get supportedSizes => const ['1x1', '2x1', '2x2', '4x2'];

  static const _rpcRequest = RpcRequest(
    namespace: 'system',
    method: 'info',
  );

  @override
  AsyncValue<List<double>> watchData(WidgetRef ref) {
    return ref.watch(cpuLoadProvider(_rpcRequest));
  }

  @override
  Widget render2x1(BuildContext context, List<double> load, WidgetRef ref) {
    return _buildCard(
      context,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLoadItem(context, '1m', load.isNotEmpty ? load[0] : 0, small: true),
          _buildLoadItem(context, '5m', load.length > 1 ? load[1] : 0, small: true),
          _buildLoadItem(context, '15m', load.length > 2 ? load[2] : 0, small: true),
        ],
      ),
    );
  }

  @override
  Widget render2x2(BuildContext context, List<double> load, WidgetRef ref) {
    return _buildCard(
      context,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Column(
            children: [
              _buildLoadItem(context, '1 min', load.isNotEmpty ? load[0] : 0),
              const SizedBox(height: 4),
              _buildLoadItem(context, '5 min', load.length > 1 ? load[1] : 0),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget render4x2(BuildContext context, List<double> load, WidgetRef ref) {
    return _buildCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLoadItem(context, '1 minute', load.isNotEmpty ? load[0] : 0),
                _buildLoadItem(context, '5 minutes', load.length > 1 ? load[1] : 0),
                _buildLoadItem(context, '15 minutes', load.length > 2 ? load[2] : 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget renderPage(BuildContext context, List<double> load, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Load Average', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                   title: const Text('1 Minute Average'),
                   trailing: Text(load.isNotEmpty ? load[0].toStringAsFixed(2) : '0.00', style: Theme.of(context).textTheme.titleLarge),
                ),
                const Divider(height: 1),
                ListTile(
                   title: const Text('5 Minute Average'),
                   trailing: Text(load.length > 1 ? load[1].toStringAsFixed(2) : '0.00', style: Theme.of(context).textTheme.titleLarge),
                ),
                const Divider(height: 1),
                ListTile(
                   title: const Text('15 Minute Average'),
                   trailing: Text(load.length > 2 ? load[2].toStringAsFixed(2) : '0.00', style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('CPU usage details from RPC system.info call.', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  Widget _buildLoadItem(BuildContext context, String label, double value, {bool small = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toStringAsFixed(2),
          style: small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
