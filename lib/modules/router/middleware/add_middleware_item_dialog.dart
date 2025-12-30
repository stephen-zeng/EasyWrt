import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/utils/init/meta.dart';

class AddMiddlewareItemDialog extends StatelessWidget {
  final String currentMiddlewareId;
  final List<String> ancestorIds;
  final List<String> existingChildIds;
  final Function(String) onAdd;

  const AddMiddlewareItemDialog({
    super.key,
    required this.currentMiddlewareId,
    required this.ancestorIds,
    required this.existingChildIds,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch all available items
    final allMiddlewares = Hive.box<MiddlewareItem>('middlewares').values.toList();
    final allPages = Hive.box<PageItem>('pages').values.toList();

    // Filter Logic
    final availableMiddlewares = allMiddlewares.where((m) {
      if (m.id == currentMiddlewareId) return false; // Self
      if (ancestorIds.contains(m.id)) return false; // Ancestors (Recursion check)
      if (existingChildIds.contains(m.id)) return false; // Already added
      return true;
    }).toList();

    final availablePages = allPages.where((p) {
      if (existingChildIds.contains(p.id)) return false; // Already added
      return true;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Navigation Item',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                if (availableMiddlewares.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Middlewares', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).hintColor)),
                  ),
                  ...availableMiddlewares.map((m) => ListTile(
                    leading: Icon(AppMeta.getIconData(m.icon)),
                    title: Text(m.name),
                    onTap: () {
                      onAdd(m.id);
                      Navigator.of(context).pop();
                    },
                  )),
                ],
                if (availablePages.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Pages', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).hintColor)),
                  ),
                  ...availablePages.map((p) => ListTile(
                    leading: Icon(AppMeta.getIconData(p.icon)),
                    title: Text(p.name),
                    onTap: () {
                      onAdd(p.id);
                      Navigator.of(context).pop();
                    },
                  )),
                ],
                if (availableMiddlewares.isEmpty && availablePages.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No items available to add.')),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
