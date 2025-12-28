import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ResizeHandle extends StatefulWidget {
  final double cellWidth;
  final int width;
  final int height;
  final void Function(int newW, int newH) onResize;
  final void Function(double shadowW, double shadowH)? onShadowUpdate;

  const ResizeHandle({
    super.key,
    required this.cellWidth,
    required this.width,
    required this.height,
    required this.onResize,
    this.onShadowUpdate,
  });

  @override
  State<ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle>
    with TickerProviderStateMixin {
  // Track accumulated drag distance from the start of the gesture
  double _totalDragX = 0;
  double _totalDragY = 0;
  
  // Snapshot of dimensions when drag started
  int _startW = 0;
  int _startH = 0;
  
  // Last target grid size (to avoid restarting animation unnecessarily)
  int _lastTargetGridW = 0;
  int _lastTargetGridH = 0;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Shadow size animation (Internal to drive callback)
  late AnimationController _shadowController;
  late Animation<double> _shadowWAnimation;
  late Animation<double> _shadowHAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

    _shadowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _shadowController.addListener(() {
      if (widget.onShadowUpdate != null) {
        widget.onShadowUpdate!(_shadowWAnimation.value, _shadowHAnimation.value);
      }
    });
    
    // Initialize with dummy values
    _shadowWAnimation = ConstantTween<double>(1.0).animate(_shadowController);
    _shadowHAnimation = ConstantTween<double>(1.0).animate(_shadowController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  void _updateShadowTarget(int targetGridW, int targetGridH) {
    // Clamp to 1..4
    final int clampedW = targetGridW.clamp(1, 4);
    final int clampedH = targetGridH.clamp(1, 4);

    if (clampedW != _lastTargetGridW || clampedH != _lastTargetGridH) {
      _lastTargetGridW = clampedW;
      _lastTargetGridH = clampedH;

      // Start from current animated value if mid-animation
      // But _shadowWAnimation.value might be outdated if controller stopped?
      // No, value is current.
      // However, we need to know if we are dragging? 
      // Yes, this is only called during drag.
      
      final double startW = _shadowWAnimation.value;
      final double startH = _shadowHAnimation.value;

      _shadowWAnimation = Tween<double>(
        begin: startW,
        end: clampedW.toDouble(),
      ).animate(CurvedAnimation(parent: _shadowController, curve: Curves.easeOutCubic));

      _shadowHAnimation = Tween<double>(
        begin: startH,
        end: clampedH.toDouble(),
      ).animate(CurvedAnimation(parent: _shadowController, curve: Curves.easeOutCubic));

      _shadowController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) {
        HapticFeedback.mediumImpact();
        // Capture initial state
        _startW = widget.width;
        _startH = widget.height;
        _totalDragX = 0;
        _totalDragY = 0;
        
        _lastTargetGridW = _startW;
        _lastTargetGridH = _startH;
        
        // Reset animations to start from current size
        _shadowWAnimation = ConstantTween<double>(_startW.toDouble()).animate(_shadowController);
        _shadowHAnimation = ConstantTween<double>(_startH.toDouble()).animate(_shadowController);
        // Force update to parent
        widget.onShadowUpdate?.call(_startW.toDouble(), _startH.toDouble());
        
        _scaleController.forward();
      },
      onPanUpdate: (details) {
        _totalDragX += details.delta.dx;
        _totalDragY += details.delta.dy;

        // Calculate target grid dimensions based on total drag
        final int dGridX = (_totalDragX / widget.cellWidth).round();
        final int dGridY = (_totalDragY / widget.cellWidth).round();

        final int targetW = _startW + dGridX;
        final int targetH = _startH + dGridY;
        
        _updateShadowTarget(targetW, targetH);
        
        // Emit raw target to parent for real-time preview
        widget.onResize(targetW, targetH);
      },
      onPanEnd: (_) {
        widget.onShadowUpdate?.call(0, 0); // Reset/Hide shadow
        _scaleController.reverse();
      },
      onPanCancel: () {
        widget.onShadowUpdate?.call(0, 0); // Reset/Hide shadow
        _scaleController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ResizeHandlePainter(
              scale: _scaleAnimation.value,
            ),
            child: Container(
              width: 40,
              height: 40,
              color: Colors.transparent, // Hit test target
            ),
          );
        },
      ),
    );
  }
}

class _ResizeHandlePainter extends CustomPainter {
  final double scale;

  _ResizeHandlePainter({
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;

    // 2. Draw Arc
    // Center at (20, 20)
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 11.0 * scale;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0, // Start angle (0 is East/Right)
      math.pi / 2, // Sweep angle (90 degrees, down to South/Bottom)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ResizeHandlePainter oldDelegate) {
    return oldDelegate.scale != scale;
  }
}

