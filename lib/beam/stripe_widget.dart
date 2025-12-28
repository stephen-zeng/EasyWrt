import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/modules/router/widgets/widget_factory.dart';
import 'package:easywrt/beam/grid_size_scope.dart';
import 'package:easywrt/beam/resize_handle.dart';
import 'package:easywrt/beam/resize_shadow.dart';

final dragAnchorOffsetProvider = StateProvider<Offset>((ref) => Offset.zero);

class StripeWidget extends ConsumerStatefulWidget {
  final StripeItem stripe;
  final bool isEditing;
  final double width;

  const StripeWidget({
    super.key,
    required this.stripe,
    this.isEditing = false,
    required this.width,
  });

  @override
  ConsumerState<StripeWidget> createState() => _StripeWidgetState();
}

class _StripeWidgetState extends ConsumerState<StripeWidget> {
  final Map<String, ValueNotifier<Size>> _shadowNotifiers = {};
  Size? _draggedWidgetGridSize;
  Rect? _shadowRect;
  Point<int>? _dropTargetGridPos;

  @override
  void dispose() {
    for (var notifier in _shadowNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  ValueNotifier<Size> _getNotifier(String widgetId) {
    return _shadowNotifiers.putIfAbsent(
        widgetId, () => ValueNotifier(Size.zero));
  }

  @override
  Widget build(BuildContext context) {
    // Calculate stripe height based on rows
    int maxRow = 0;
    for (var w in widget.stripe.widgets) {
      if (w.y + w.height > maxRow) maxRow = w.y + w.height;
    }
    // In edit mode, ensure at least one empty row or min height
    if (widget.isEditing) {
      maxRow += 1; // Extra row for dropping
    }
    if (maxRow == 0) maxRow = 1; // Minimum 1 row

    final cellWidth = AppMeta.calculateCellWidth(widget.width);
    final cellHeight = cellWidth; // Square cells
    final gap = AppMeta.rem;

    // Height includes grid rows, gaps between rows, and 1rem padding on top and bottom
    final totalHeight =
        (maxRow * cellHeight) + ((maxRow - 1) * gap) + (2 * gap);

    // Concept: render layers
    List<Widget> stackChildren = [];

    // 0. Shadows (Bottom-most layer)
    if (widget.isEditing) {
      for (var w in widget.stripe.widgets) {
        stackChildren.add(_buildShadow(context, w, cellWidth, gap));
      }
    }

    // 1. Grid Placeholders
    if (widget.isEditing) {
      stackChildren.addAll(
        _buildGridPlaceholders(context, maxRow, cellWidth, gap),
      );
    }

    // 2. Widgets
    for (var w in widget.stripe.widgets) {
      stackChildren.add(_buildWidget(context, w, cellWidth, gap));
    }

    // 3. Edit Controls (Top layer)
    if (widget.isEditing) {
      for (var w in widget.stripe.widgets) {
        stackChildren.addAll(
          _buildEditControls(context, w, cellWidth, gap),
        );
      }
    }

    // 4. Active Drop Shadow (Calculated from Drag)
    // 4. 拖动时的阴影 (根据拖动位置计算)
    // This renders the shadow indicating where the widget will be dropped.
    // 这部分渲染指示 widget 将被放置位置的阴影。
    if (widget.isEditing && // 是否为编辑模式
        _shadowRect != null && // 阴影矩形已计算
        _draggedWidgetGridSize != null) { // 拖动的 widget 大小已知
      stackChildren.add(
        Positioned(
          left: _shadowRect!.left,
          top: _shadowRect!.top,
          width: _shadowRect!.width,
          height: _shadowRect!.height,
          child: ResizeShadow(
            cellWidth: cellWidth,
            width: _draggedWidgetGridSize!.width,
            height: _draggedWidgetGridSize!.height,
          ),
        ),
      );
    }

    Widget container = Container(
      width: widget.width,
      height: totalHeight > (2 * gap) ? totalHeight : 100, // Fallback
      // padding: EdgeInsets.all(gap), // REMOVED
      decoration: widget.isEditing
          ? BoxDecoration(
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.5),
                style: BorderStyle.solid,
              ),
            )
          : null,
      child: Stack(clipBehavior: Clip.none, children: stackChildren),
    );

    if (!widget.isEditing) return container;

    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => true,
      onMove: (details) {
        final data = details.data;
        final parts = data.split('/');
        if (parts.length >= 4) {
          final w = int.tryParse(parts[2]) ?? 1;
          final h = int.tryParse(parts[3]) ?? 1;

          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox == null) return;
          final widgetTopLeft = renderBox.globalToLocal(details.offset);

          // Find the nearest GridPlaceholder to use as candidate top-left
          int bestX = -1;
          int bestY = -1;
          double minDistSq = double.infinity;

          for (int r = 0; r < maxRow; r++) {
            for (int c = 0; c < 4; c++) {
              final px = (c * cellWidth) + (c * gap) + gap;
              final py = (r * cellWidth) + (r * gap) + gap;

              final dx = widgetTopLeft.dx - px;
              final dy = widgetTopLeft.dy - py;
              final dSq = dx * dx + dy * dy;

              if (dSq < minDistSq) {
                minDistSq = dSq;
                bestX = c;
                bestY = r;
              }
            }
          }

          if (bestX != -1) {
            if (bestX + w > 4) {
              bestX = max(0, 4 - w);
            }
          }

          final x = bestX;
          final y = bestY;

          if (x != -1 && y != -1) {
            final targetLeft = (x * cellWidth) + (x * gap) + gap;
            final targetTop = (y * cellWidth) + (y * gap) + gap;
            final targetPixelSize =
                AppMeta.calculateWidgetSize(widget.width, w, h);
            final targetRect = Rect.fromLTWH(targetLeft, targetTop,
                targetPixelSize.width, targetPixelSize.height);

            if (targetRect != _shadowRect) {
              setState(() {
                // Update shadow position and drop target grid position
                // 更新阴影位置和放置目标的网格位置
                _shadowRect = targetRect;
                _dropTargetGridPos = Point(x, y);
                _draggedWidgetGridSize = Size(w.toDouble(), h.toDouble());
              });
            }
          } else {
            if (_shadowRect != null) {
              setState(() {
                _shadowRect = null;
                _dropTargetGridPos = null;
              });
            }
          }
        }
      },
      onLeave: (_) {
        setState(() {
          _shadowRect = null;
          _dropTargetGridPos = null;
        });
      },
      onAcceptWithDetails: (details) {
        if (_dropTargetGridPos != null) {
          final parts = details.data.split('/');
          if (parts.length >= 2) {
            final sourceStripeId = parts[0];
            final widgetId = parts[1];
            ref.read(editManagerProvider.notifier).moveWidget(
                widget.stripe.id,
                sourceStripeId,
                widgetId,
                _dropTargetGridPos!.x,
                _dropTargetGridPos!.y);
          }
        }
        setState(() {
          _shadowRect = null;
          _dropTargetGridPos = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return container;
      },
    );
  }

  Widget _buildShadow(
    BuildContext context,
    WidgetInstance w,
    double cellWidth,
    double gap,
  ) {
    final left = (w.x * cellWidth) + (w.x * gap) + gap;
    final top = (w.y * cellWidth) + (w.y * gap) + gap;
    final notifier = _getNotifier(w.id);

    return Positioned(
      left: left,
      top: top,
      child: ValueListenableBuilder<Size>(
        valueListenable: notifier,
        builder: (context, size, _) {
          return ResizeShadow(
            cellWidth: cellWidth,
            width: size.width,
            height: size.height,
          );
        },
      ),
    );
  }

  List<Widget> _buildGridPlaceholders(
    BuildContext context,
    int rows,
    double cellWidth,
    double gap,
  ) {
    List<Widget> placeholders = [];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < 4; x++) {
        final left = (x * cellWidth) + (x * gap) + gap;
        final top = (y * cellWidth) + (y * gap) + gap;

        placeholders.add(
          Positioned(
            left: left,
            top: top,
            width: cellWidth,
            height: cellWidth,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }
    }
    return placeholders;
  }

  Widget _buildWidget(
    BuildContext context,
    WidgetInstance w,
    double cellWidth,
    double gap,
  ) {
    final left = (w.x * cellWidth) + (w.x * gap) + gap;
    final top = (w.y * cellWidth) + (w.y * gap) + gap;
    final size = AppMeta.calculateWidgetSize(widget.width, w.width, w.height);

    // Wrap Widget in GridSizeScope
    final child = SizedBox(
      width: size.width,
      height: size.height,
      child: GridSizeScope(
        width: w.width,
        height: w.height,
        child: WidgetFactory.create(w.widgetTypeKey),
      ),
    );

    Widget content = child;

    if (widget.isEditing) {
      content = Listener(
        onPointerDown: (event) {
          ref.read(dragAnchorOffsetProvider.notifier).state =
              event.localPosition;
        },
        child: Draggable<String>(
          data: '${widget.stripe.id}/${w.id}/${w.width}/${w.height}',
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 1.0,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: child,
              ),
            ),
          ),
          childWhenDragging: const IgnorePointer(child: SizedBox.shrink()),
          child: child,
        ),
      );
    }

    return Positioned(
      key: ValueKey(w.id),
      left: left,
      top: top,
      width: size.width,
      height: size.height,
      child: content,
    );
  }

  List<Widget> _buildEditControls(
    BuildContext context,
    WidgetInstance w,
    double cellWidth,
    double gap,
  ) {
    final left = (w.x * cellWidth) + (w.x * gap) + gap;
    final top = (w.y * cellWidth) + (w.y * gap) + gap;
    final size = AppMeta.calculateWidgetSize(widget.width, w.width, w.height);
    final notifier = _getNotifier(w.id);

    return [
      // Delete Button (Top Left)
      Positioned(
        key: ValueKey('delete_${w.id}'),
        left: left - 8,
        top: top - 8,
        child: GestureDetector(
          onTap: () {
            ref.read(editManagerProvider.notifier).deleteWidget(widget.stripe.id, w.id);
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.remove, size: 16, color: Colors.white),
          ),
        ),
      ),
      // Resize Handle (Bottom Right)
      Positioned(
        key: ValueKey('resize_${w.id}'),
        left: left + size.width - 22,
        top: top + size.height - 22,
        child: ResizeHandle(
          cellWidth: cellWidth,
          width: w.width,
          height: w.height,
          onResize: (newW, newH) {
            ref.read(editManagerProvider.notifier).resizeWidget(widget.stripe.id, w.id, newW, newH);
          },
          onShadowUpdate: (shadowW, shadowH) {
            notifier.value = Size(shadowW, shadowH);
          },
        ),
      ),
    ];
  }
}
