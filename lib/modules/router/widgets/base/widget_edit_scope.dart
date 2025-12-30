import 'package:flutter/widgets.dart';

class WidgetEditScope extends InheritedWidget {
  final bool isEditing;
  final String? stripeId;
  final String? widgetId;

  const WidgetEditScope({
    super.key,
    required this.isEditing,
    this.stripeId,
    this.widgetId,
    required super.child,
  });

  static WidgetEditScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WidgetEditScope>();
  }

  @override
  bool updateShouldNotify(WidgetEditScope oldWidget) {
    return isEditing != oldWidget.isEditing ||
        stripeId != oldWidget.stripeId ||
        widgetId != oldWidget.widgetId;
  }
}
