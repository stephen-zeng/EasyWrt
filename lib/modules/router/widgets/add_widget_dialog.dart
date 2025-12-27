import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/controllers/widget_catalog_controller.dart';

/// AddWidgetDialog
/// 
/// Function: A dialog to select a widget to add to a page.
class AddWidgetDialog extends ConsumerWidget {
  final ValueChanged<String> onAdd;

  const AddWidgetDialog({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(widgetCatalogProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Widget',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: catalog.length,
              itemBuilder: (context, index) {
                final widget = catalog[index];
                return ListTile(
                  leading: Icon(widget.icon),
                  title: Text(widget.name),
                  subtitle: Text(widget.description),
                  onTap: () {
                    onAdd(widget.typeKey);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}