import 'package:flutter/material.dart';
import 'package:easywrt/utils/init/meta.dart';

class ResizeShadow extends StatelessWidget {
  final double cellWidth;
  final double width; // Animated width in grid units
  final double height; // Animated height in grid units

  const ResizeShadow({
    super.key,
    required this.cellWidth,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (width <= 0 || height <= 0) return const SizedBox.shrink();

    return CustomPaint(
      painter: _ShadowPainter(
        cellWidth: cellWidth,
        width: width,
        height: height,
      ),
    );
  }
}

class _ShadowPainter extends CustomPainter {
  final double cellWidth;
  final double width;
  final double height;

  _ShadowPainter({
    required this.cellWidth,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = AppMeta.rem;
    
    // Calculate target pixel size
    final double targetPixelW = (width * cellWidth) + ((width - 1) * gap);
    final double targetPixelH = (height * cellWidth) + ((height - 1) * gap);
    
    final shadowRect = Rect.fromLTWH(
      0, 
      0, 
      targetPixelW, 
      targetPixelH
    );

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
      
    // Draw rounded rect for shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(shadowRect, const Radius.circular(12.0)),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ShadowPainter oldDelegate) {
    return oldDelegate.width != width ||
           oldDelegate.height != height ||
           oldDelegate.cellWidth != cellWidth;
  }
}
