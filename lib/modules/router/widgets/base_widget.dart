import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract base class for all dashboard widgets.
///
/// Hierarchy:
/// ConsumerWidget <- BaseWidget <- ConcreteWidget
///
/// Principles:
/// - I. Code Quality: Enforces standard structure for all widgets.
/// - V. Interoperability: Provides a common contract for the layout engine.
abstract class BaseWidget extends ConsumerWidget {
  const BaseWidget({super.key});

  /// Unique key identifying this widget type (e.g. 'cpu_usage').
  String get typeKey;

  /// Display name of the widget.
  String get name;

  /// Brief description of the widget.
  String get description;

  /// Icon code point (mapped to IconData).
  int get iconCode;

  /// List of supported grid sizes.
  /// Example: ['1x1', '4x4']
  List<String> get supportedSizes;

  /// Default size when first added to a dashboard.
  String get defaultSize => '1x1';

  /// Standard build method for ConsumerWidget.
  /// Subclasses must override this to provide the UI.
  @override
  Widget build(BuildContext context, WidgetRef ref);
}
