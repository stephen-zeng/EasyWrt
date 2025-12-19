import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';
import 'package:easywrt/utils/init/meta.dart';

class MemoryUsageNotifier extends StateNotifier<double?> {
  MemoryUsageNotifier() : super(null);
}

class MemoryUsage {
  final double total;
  final double free;
  final double used;
  final double percent;
  
  MemoryUsage({required this.total, required this.free, required this.used, required this.percent});
}

final memoryUsageProvider = Provider.family.autoDispose<AsyncValue<MemoryUsage?>, RpcRequest>((ref, request) {
  final rpcState = ref.watch(rpcPollingProvider(request));
  
  return rpcState.whenData((data) {
    if (data != null && data is Map && data['memory'] != null) {
      final mem = data['memory'] as Map<String, dynamic>;
      final total = (mem['total'] as num).toDouble();
      final free = (mem['free'] as num).toDouble();
      final used = total - free;
      final percent = total > 0 ? (used / total) : 0.0;
      
      return MemoryUsage(
        total: total,
        free: free,
        used: used,
        percent: percent,
      );
    }
    return null;
  });
});
