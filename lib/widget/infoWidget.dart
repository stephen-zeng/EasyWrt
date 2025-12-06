import 'package:flutter/material.dart';

/// Represents a single info row entry consisting of a label and any value.
typedef InfoEntry = MapEntry<String, dynamic>;

/// Base widget every info widget should extend to receive the shared entries list.
abstract class InfoWidgetBase extends StatefulWidget {
  const InfoWidgetBase({super.key, required this.entries});

  final List<InfoEntry> entries;
}

/// Convenience base state exposing the entries to subclasses.
abstract class InfoWidgetBaseState<T extends InfoWidgetBase> extends State<T> {
  List<InfoEntry> get entries => widget.entries;
}

class InfoWidget extends InfoWidgetBase {
  const InfoWidget({
    super.key,
    required super.entries,
    this.itemBuilder,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.emptyBuilder,
  });

  /// Optional builder to override how each entry row is drawn.
  final Widget Function(BuildContext context, InfoEntry entry)? itemBuilder;

  /// Padding applied to the surrounding scroll view.
  final EdgeInsetsGeometry padding;

  /// Builder invoked when [entries] is empty.
  final Widget Function(BuildContext context)? emptyBuilder;

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends InfoWidgetBaseState<InfoWidget> {
  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return widget.emptyBuilder?.call(context) ?? const _EmptyPlaceholder();
    }

    return ListView.separated(
      padding: widget.padding,
      itemBuilder: (context, index) {
        final entry = entries[index];
        if (widget.itemBuilder != null) {
          return widget.itemBuilder!(context, entry);
        }
        return _DefaultInfoRow(entry: entry);
      },
      separatorBuilder: (_, __) => const Divider(height: 24),
      itemCount: entries.length,
    );
  }
}

class _DefaultInfoRow extends StatelessWidget {
  const _DefaultInfoRow({required this.entry});

  final InfoEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle = theme.textTheme.bodyMedium;
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            entry.key,
            style: labelStyle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            '${entry.value}',
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        '暂无数据',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
