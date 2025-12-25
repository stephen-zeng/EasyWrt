import 'package:flutter/material.dart';

class ResizeHandle extends StatefulWidget {
  final double cellWidth;
  final Function(int dx, int dy) onResize;

  const ResizeHandle({
    super.key,
    required this.cellWidth,
    required this.onResize,
  });

  @override
  State<ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle> {
  double _accumulatedX = 0;
  double _accumulatedY = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _accumulatedX += details.delta.dx;
        _accumulatedY += details.delta.dy;

        int dGridX = 0;
        int dGridY = 0;

        // Threshold: move by at least half a cell to trigger resize
        final threshold = widget.cellWidth / 2;

        if (_accumulatedX.abs() >= threshold) {
          dGridX = (_accumulatedX / widget.cellWidth).round();
          _accumulatedX -= dGridX * widget.cellWidth;
        }

        if (_accumulatedY.abs() >= threshold) {
          dGridY = (_accumulatedY / widget.cellWidth).round();
          _accumulatedY -= dGridY * widget.cellWidth;
        }

        if (dGridX != 0 || dGridY != 0) {
          widget.onResize(dGridX, dGridY);
        }
      },
      onPanEnd: (_) {
        _accumulatedX = 0;
        _accumulatedY = 0;
      },
      child: Container(
        color: Colors.transparent, // Hit test target
        padding: const EdgeInsets.all(8), // Touch area
        child: const Icon(Icons.arrow_outward, size: 24, color: Colors.blue),
      ),
    );
  }
}
