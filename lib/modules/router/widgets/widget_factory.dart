import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/widgets/base_widget.dart';
import 'package:easywrt/modules/router/widgets/cpu_usage/cpu_usage_widget.dart';
import 'package:easywrt/modules/router/widgets/memory_usage/memory_usage_widget.dart';
import 'package:easywrt/modules/router/widgets/network_traffic/network_traffic_widget.dart';

/// Factory to instantiate widgets by their typeKey.
class WidgetFactory {
  /// Returns a concrete instance of [BaseWidget] for the given [typeKey].
  /// If unknown, returns an [UnknownWidget].
  static BaseWidget create(String typeKey) {
    switch (typeKey) {
      case 'cpu_usage':
        return const CpuUsageWidget();
      case 'memory_usage':
        return const MemoryUsageWidget();
      case 'network_traffic':
        return const NetworkTrafficWidget();
      default:
        return UnknownWidget(typeKey: typeKey);
    }
  }
}

class UnknownWidget extends BaseWidget {
  @override
  final String typeKey;

  const UnknownWidget({super.key, required this.typeKey});

  @override
  String get name => 'Unknown Widget';
  @override
  String get description => 'This widget type is not recognized.';
  @override
  int get iconCode => 0xe000; // error
  @override
  List<String> get supportedSizes => const ['1x1'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.red.withOpacity(0.1),
      child: Center(child: Text('Unknown: $typeKey')),
    );
  }
}