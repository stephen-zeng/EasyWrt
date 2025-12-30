import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/beam/grid_size_scope.dart';
import 'package:easywrt/beam/widget_edit_scope.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';

/// Abstract base class for all dashboard widgets.
/// Handles data fetching, state (loading/error), and layout dispatch.
abstract class BaseWidget<T> extends ConsumerWidget {
  const BaseWidget({super.key});

  /// Unique key identifying this widget type (e.g. 'cpu_usage').
  String get typeKey;

  /// Display name of the widget.
  String get name;

  /// Brief description of the widget.
  String get description;

  /// Icon for the widget.
  IconData get icon;

  /// List of supported grid sizes.
  /// Example: ['1x1', '4x4']
  List<String> get supportedSizes;

  /// Default size when first added to a dashboard.
  String get defaultSize => '1x1';

  /// The data stream to watch.
  AsyncValue<T> watchData(WidgetRef ref);

  /// Standard build method for ConsumerWidget.
  /// Dispatches to specific render methods based on [GridSizeScope] and handles state.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = GridSizeScope.maybeOf(context);
    final sizeStr = scope?.sizeString ?? defaultSize;

    // Handle Edit Mode / Delete Button
    final editScope = WidgetEditScope.maybeOf(context);
    final isEditing = editScope != null && editScope.isEditing && editScope.stripeId != null && editScope.widgetId != null;

    final asyncValue = watchData(ref);
    
    final content = asyncValue.when(
      data: (data) {
        switch (sizeStr) {
          case '1x1': return render1x1(context, data, ref);
          case '1x2': return render1x2(context, data, ref);
          case '2x1': return render2x1(context, data, ref);
          case '2x2': return render2x2(context, data, ref);
          case '2x4': return render2x4(context, data, ref);
          case '4x2': return render4x2(context, data, ref);
          case '4x4': return render4x4(context, data, ref);
          default: return renderDefault(context, data, ref);
        }
      },
      error: (err, stack) {
        if (sizeStr == '1x1') {
          return render1x1(context, null, ref);
        } else {
          return buildError(context, err);
        }
      },
      loading: () {
        if (sizeStr == '1x1') {
          return render1x1(context, null, ref);
        } else {
          return buildLoading(context);
        }
      },
    );

    if (isEditing) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            left: -8,
            top: -8,
            child: GestureDetector(
              onTap: () {
                ref.read(editManagerProvider.notifier).deleteWidget(editScope.stripeId!, editScope.widgetId!);
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
        ],
      );
    }

    return content;
  }

  // --- State Rendering Helpers ---

  Widget buildLoading(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildError(BuildContext context, Object error) {
    return Card(
      margin: EdgeInsets.zero,
      child: Center(child: Icon(Icons.error_outline, color: Colors.red)),
    );
  }

  // --- Render methods to be implemented/overridden by subclasses ---
  
  Widget renderDefault(BuildContext context, T data, WidgetRef ref) => const Center(child: Text('Not implemented'));

  /// Default implementation for 1x1 size: displays the widget's icon.
  Widget render1x1(BuildContext context, T? data, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: EdgeInsets.zero,
      child: Center(
        child: Icon(
          icon,
          size: 24,
          color: isDark ? Theme.of(context).colorScheme.onSurface : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
  
  Widget render1x2(BuildContext context, T data, WidgetRef ref) => renderDefault(context, data, ref);
  Widget render2x1(BuildContext context, T data, WidgetRef ref) => renderDefault(context, data, ref);
  Widget render2x2(BuildContext context, T data, WidgetRef ref) => renderDefault(context, data, ref);
  Widget render2x4(BuildContext context, T data, WidgetRef ref) => renderDefault(context, data, ref);
  Widget render4x2(BuildContext context, T data, WidgetRef ref) => renderDefault(context, data, ref);
  Widget render4x4(BuildContext context, T data, WidgetRef ref) => renderDefault(context, data, ref);
}
