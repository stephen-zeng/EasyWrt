import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';
import 'package:easywrt/modules/router/widgets/cpu_usage/cpu_usage_widget.dart';
import 'package:easywrt/modules/router/widgets/memory_usage/memory_usage_widget.dart';
import 'package:easywrt/modules/router/widgets/network_traffic/network_traffic_widget.dart';

/// Provides the catalog of all available widgets.
final widgetCatalogProvider = Provider<List<BaseWidget>>((ref) {
  return const [
    CpuUsageWidget(),
    MemoryUsageWidget(),
    NetworkTrafficWidget(),
  ];
});
