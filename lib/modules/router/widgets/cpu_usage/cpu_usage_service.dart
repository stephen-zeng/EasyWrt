import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/rpc_controller.dart';
import 'package:easywrt/utils/init/meta.dart';

class CpuUsageNotifier extends StateNotifier<double?> {
  CpuUsageNotifier() : super(null);
}

final cpuLoadProvider = Provider.family.autoDispose<AsyncValue<List<double>>, RpcRequest>((ref, request) {
  final rpcState = ref.watch(rpcPollingProvider(request));
  
  return rpcState.whenData((data) {
    if (data != null && data is Map && data['load'] != null) {
      return (data['load'] as List)
          .map((e) => (e as num).toDouble() / AppMeta.cpuLoadDivisor)
          .toList();
    }
    return [];
  });
});
