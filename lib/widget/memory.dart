import 'package:easywrt/database/app.dart';
import 'package:easywrt/model/app.dart';
import 'package:flutter/material.dart';

import '../utils/wrt.dart';

class MemoryInfoWidget extends StatefulWidget {
  const MemoryInfoWidget({
    super.key,
  });

  @override
  State<MemoryInfoWidget> createState() => _MemoryInfoWidgetState();
}

class _MemoryInfoWidgetState extends State<MemoryInfoWidget> {
  // 在真实的应用中，这些数据可以从API或系统服务中动态获取
  // 然后使用 setState() 来更新UI
  final double _totalMemory = 238.73;
  final Map<String, double> _memoryData = {
    '可用数': 30.48,
    '已使用': 199.23,
    '已缓存': 27.93,
  };
  late Future<List<dynamic>> _status;

  void initState() {
    super.initState();
    debugPrint("deviceID : ${AppController.getAppStatus().deviceID}");
    _status = Wrt.call(
      AppController.getAppStatus().deviceID,
      [["network.interface", "dump"]],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 使用Container来创建卡片背景
    return FutureBuilder<String>(
      future: _status.then((value) => value.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // 加载中
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: Theme.of(context).textTheme.bodySmall,
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E), // 类似于图片中的深灰色
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 让Column的高度包裹其内容
              crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
              children: [
                // 标题
                const Text(
                  '内存',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20), // 标题和内容之间的间距

                // 使用ListView.separated来构建带分隔符的列表
                ListView.separated(
                  shrinkWrap: true, // 让ListView的高度适应其内容
                  physics: const NeverScrollableScrollPhysics(), // 禁用滚动
                  itemCount: _memoryData.length,
                  itemBuilder: (context, index) {
                    final label = _memoryData.keys.elementAt(index);
                    final value = _memoryData.values.elementAt(index);
                    return _buildInfoRow(label, value, _totalMemory);
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 16), // 行之间的间距
                ),
              ],
            ),
          );
        }
      },
    );
  }

  /// 构建每一行的信息（标签、进度条和数值）
  Widget _buildInfoRow(String label, double value, double total) {
    final double percentage = value / total;
    return Row(
      children: [
        // 左侧的标签，使用SizedBox来固定宽度以对齐
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),

        // 中间的进度条，使用Expanded来填充可用空间
        Expanded(
          child: ClipRRect( // 使用ClipRRect给进度条添加圆角
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 12, // 进度条的高度
              backgroundColor: const Color(0xFF1C1C1E).withOpacity(0.5), // 进度条背景色
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34C759)), // 进度条颜色
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 右侧的详细信息文本
        Text(
          '${value.toStringAsFixed(2)} MiB / ${total.toStringAsFixed(2)} MiB (${(percentage * 100).round()}%)',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }
}