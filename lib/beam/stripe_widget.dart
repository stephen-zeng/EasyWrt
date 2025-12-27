import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/utils/init/meta.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/modules/router/widgets/widget_factory.dart';
import 'package:easywrt/beam/grid_size_scope.dart';
import 'package:easywrt/beam/resize_handle.dart';
import 'package:easywrt/beam/resize_shadow.dart';

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

  @override
  void dispose() {
    for (var notifier in _shadowNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  ValueNotifier<Size> _getNotifier(String widgetId) {
    return _shadowNotifiers.putIfAbsent(widgetId, () => ValueNotifier(Size.zero));
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
    final rowHeight = cellWidth; // Square cells
    final gap = AppMeta.rem;

    // Height includes grid rows, gaps between rows, and 1rem padding on top and bottom
    final totalHeight = (maxRow * rowHeight) + ((maxRow - 1) * gap) + (2 * gap);

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

    return Container(
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
      // Size is handled by ResizeShadow painting, but Positioned needs constraints?
      // No, ResizeShadow paints relative to (0,0) of this Positioned.
      // But Positioned usually requires width/height or right/bottom?
      // If child has intrinsic size, Positioned(left, top) works.
      // ResizeShadow returns CustomPaint which expands if size not given.
      // We should probably give it a safe large size or let it paint without bounds?
      // Or pass constraints.
      // CustomPaint size is Size.zero by default.
      // We will let CustomPaint handle it.
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
            child: DragTarget<String>(
              onWillAcceptWithDetails: (details) => true,
              onAcceptWithDetails: (details) {
                final data = details.data;
                final parts = data.split('/');
                if (parts.length == 2) {
                  final sourceStripeId = parts[0];
                  final widgetId = parts[1];
                  ref
                      .read(editManagerProvider.notifier)
                      .moveWidget(widget.stripe.id, sourceStripeId, widgetId, x, y);
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty
                        ? Colors.blue.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                );
              },
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
      content = Draggable<String>(
        data: '${widget.stripe.id}/${w.id}',
        feedback: Material(
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.7,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: child,
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: child), // Ghost
        child: child, 
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
