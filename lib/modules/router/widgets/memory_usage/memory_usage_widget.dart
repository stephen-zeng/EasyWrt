import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';
import 'memory_usage_service.dart';

/// MemoryUsageWidget
class MemoryUsageWidget extends BaseWidget<MemoryUsage?> {
  const MemoryUsageWidget({super.key});

  @override
  String get typeKey => 'memory_usage';
  @override
  String get name => 'Memory Usage';
  @override
  String get description => 'Shows total memory usage.';
  
  @override
  IconData get icon => Icons.memory;
  
  @override
  List<String> get supportedSizes => const ['1x1', '2x1', '2x2', '4x2', '4x4'];

  static const _rpcRequest = RpcRequest(
    namespace: 'system',
    method: 'info',
  );

  @override
  AsyncValue<MemoryUsage?> watchData(WidgetRef ref) {
    return ref.watch(memoryUsageProvider(_rpcRequest));
  }

  @override
  Widget renderPage(BuildContext context, MemoryUsage? usage, WidgetRef ref) {
    if (usage == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppMeta.defaultPadding),
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: usage.percent,
                  strokeWidth: 20,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(usage.percent * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        'Used',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Column(
              children: [
                _buildDetailTile(context, 'Used Memory', usage.used),
                const Divider(height: 1),
                _buildDetailTile(context, 'Free Memory', usage.free),
                const Divider(height: 1),
                _buildDetailTile(context, 'Total Memory', usage.total, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context, String label, double bytes, {bool isTotal = false}) {
     final mb = (bytes / AppMeta.bytesPerMegabyte).toStringAsFixed(2);
     return ListTile(
       title: Text(label),
       trailing: Text('$mb MB', style: isTotal ? const TextStyle(fontWeight: FontWeight.bold) : null),
     );
  }

  @override
  Widget render2x1(BuildContext context, MemoryUsage? usage, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppMeta.defaultPadding),
        child: usage != null ? Row(
          children: [
            const Icon(Icons.memory, size: 24),
            const SizedBox(width: AppMeta.smallPadding),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'RAM',
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${(usage.percent * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(value: usage.percent, minHeight: 6),
                ],
              ),
            ),
          ],
        ) : const Center(child: Text('No Data')),
      ),
    );
  }

  @override
  Widget render2x2(BuildContext context, MemoryUsage? usage, WidgetRef ref) {
    return _renderLinearContent(context, usage, isCompact: true);
  }

  @override
  Widget render4x2(BuildContext context, MemoryUsage? usage, WidgetRef ref) {
    return _renderLinearContent(context, usage, isCompact: false);
  }

  @override
  Widget render4x4(BuildContext context, MemoryUsage? usage, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppMeta.defaultPadding),
        child: Column(
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Expanded(
              child: usage != null ? Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 160, maxWidth: 160),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: usage.percent,
                                strokeWidth: 12,
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                strokeCap: StrokeCap.round,
                              ),
                              Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${(usage.percent * 100).toStringAsFixed(0)}%',
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppMeta.smallPadding),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDetailRow(context, 'Used', usage.used),
                      _buildDetailRow(context, 'Free', usage.free),
                      const Divider(),
                      _buildDetailRow(context, 'Total', usage.total, isTotal: true),
                    ],
                  ),
                ],
              ) : const Center(child: Text('No Data')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, double bytes, {bool isTotal = false}) {
    final mb = (bytes / AppMeta.bytesPerMegabyte).toStringAsFixed(1);
    final style = isTotal ? Theme.of(context).textTheme.titleSmall : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('$mb MB', style: style),
        ],
      ),
    );
  }

  Widget _renderLinearContent(BuildContext context, MemoryUsage? usage, {required bool isCompact}) {
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
              child: usage != null ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: usage.percent, 
                    minHeight: isCompact ? 8 : 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: AppMeta.smallPadding),
                  Text(
                    '${(usage.percent * 100).toStringAsFixed(1)}% Used',
                    style: isCompact ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  if (!isCompact) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${(usage.used / AppMeta.bytesPerMegabyte).toStringAsFixed(1)} MB / ${(usage.total / AppMeta.bytesPerMegabyte).toStringAsFixed(1)} MB',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ]
                ],
              ) : const Text('No Data'),
            ),
          ],
        ),
      ),
    );
  }
}