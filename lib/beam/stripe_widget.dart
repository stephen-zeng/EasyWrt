import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/beam/responsive_layout.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/modules/router/widgets/widget_factory.dart';

class StripeWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate stripe height based on rows
    int maxRow = 0;
    for (var w in stripe.widgets) {
      if (w.y + w.height > maxRow) maxRow = w.y + w.height;
    }
    // In edit mode, ensure at least one empty row or min height
    if (isEditing) {
      maxRow += 1; // Extra row for dropping
    }
    if (maxRow == 0) maxRow = 1; // Minimum 1 row

    final cellWidth = ResponsiveLayout.calculateCellWidth(width);
    final rowHeight = cellWidth; // Square cells
    final gap = ResponsiveLayout.rem;
    
    final totalHeight = (maxRow * rowHeight) + ((maxRow - 1) * gap);

    return Container(
      width: width,
      height: totalHeight > 0 ? totalHeight : 100, // Fallback
      decoration: isEditing
          ? BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.5), style: BorderStyle.solid),
            )
          : null,
      child: Stack(
        children: [
          if (isEditing) ..._buildGridPlaceholders(context, ref, maxRow, cellWidth, gap),
          ...stripe.widgets.map((w) => _buildWidget(context, ref, w, cellWidth, gap)),
        ],
      ),
    );
  }

  List<Widget> _buildGridPlaceholders(BuildContext context, WidgetRef ref, int rows, double cellWidth, double gap) {
    List<Widget> placeholders = [];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < 4; x++) {
        final left = (x * cellWidth) + (x * gap);
        final top = (y * cellWidth) + (y * gap);
        
        placeholders.add(Positioned(
          left: left,
          top: top,
          width: cellWidth,
          height: cellWidth,
          child: DragTarget<String>(
            onWillAccept: (data) => true,
            onAccept: (data) {
              final parts = data.split('/');
              if (parts.length == 2) {
                final sourceStripeId = parts[0];
                final widgetId = parts[1];
                // For now, support only same stripe move
                if (sourceStripeId == stripe.id) {
                   ref.read(editManagerProvider.notifier).moveWidget(stripe.id, widgetId, x, y);
                }
              }
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                decoration: BoxDecoration(
                  color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ));
      }
    }
    return placeholders;
  }

  Widget _buildWidget(BuildContext context, WidgetRef ref, WidgetInstance w, double cellWidth, double gap) {
    final left = (w.x * cellWidth) + (w.x * gap);
    final top = (w.y * cellWidth) + (w.y * gap);
    final size = ResponsiveLayout.calculateWidgetSize(width, w.width, w.height);
    
    final child = SizedBox(
      width: size.width,
      height: size.height,
      child: WidgetFactory.create(w.widgetTypeKey),
    );

    Widget content = child;

    if (isEditing) {
       content = Draggable<String>(
           data: '${stripe.id}/${w.id}',
           feedback: Material(
             color: Colors.transparent,
             child: Opacity(opacity: 0.7, child: SizedBox(width: size.width, height: size.height, child: child)),
           ),
           childWhenDragging: Opacity(opacity: 0.3, child: child), // Ghost
           child: Stack(
             children: [
               child,
               Positioned(
                 right: 0,
                 bottom: 0,
                 child: GestureDetector(
                   onPanUpdate: (details) {
                     // Calculate resize
                     // Need current size + delta
                     // logic...
                   },
                   child: const Icon(Icons.arrow_outward, size: 24, color: Colors.blue), // Resize handle
                 ),
               ),
             ],
           ),
       );
    }

    return AnimatedPositioned(
      key: ValueKey(w.id),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: left,
      top: top,
      width: size.width,
      height: size.height,
      child: content,
    );
  }
}
