import 'package:flutter/widgets.dart';

/// Provides the grid size (width x height) to descendant widgets.
class GridSizeScope extends InheritedWidget {
  final int width;
  final int height;

  const GridSizeScope({
    super.key,
    required this.width,
    required this.height,
    required super.child,
  });

  static GridSizeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GridSizeScope>();
  }

  static GridSizeScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No GridSizeScope found in context');
    return scope!;
  }

  /// Returns a string representation like "2x1"
  String get sizeString => '${width}x${height}';

  @override
  bool updateShouldNotify(GridSizeScope oldWidget) {
    return width != oldWidget.width || height != oldWidget.height;
  }
}
