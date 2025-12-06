import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easywrt/provider/navigation_provider.dart';
import 'package:easywrt/model/menu_config.dart';
import 'package:uuid/uuid.dart';

class MenuEditorPage extends StatefulWidget {
  const MenuEditorPage({super.key});

  @override
  State<MenuEditorPage> createState() => _MenuEditorPageState();
}

class _MenuEditorPageState extends State<MenuEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showEditMenuDialog(context, null);
            },
          ),
        ],
      ),
      body: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          if (navigationProvider.menuTree.isEmpty) {
            return const Center(child: Text('No menu items. Add some!'));
          }
          return ListView.builder(
            itemCount: navigationProvider.menuTree.length,
            itemBuilder: (context, index) {
              final menuConfig = navigationProvider.menuTree[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.drag_handle), // Placeholder for reordering
                  title: Text(menuConfig.label),
                  subtitle: Text('${menuConfig.type} - ${menuConfig.targetId ?? 'N/A'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditMenuDialog(context, menuConfig),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Implement delete logic here
                          // For simplicity, this initial version doesn't handle full tree deletion
                          // It should rebuild the tree and then updateMenuTree
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showEditMenuDialog(BuildContext context, MenuConfig? menuConfig) async {
    final TextEditingController idController = TextEditingController(text: menuConfig?.id ?? const Uuid().v4());
    final TextEditingController labelController = TextEditingController(text: menuConfig?.label ?? '');
    String selectedType = menuConfig?.type ?? 'function';
    final TextEditingController targetIdController = TextEditingController(text: menuConfig?.targetId ?? '');
    final TextEditingController iconController = TextEditingController(text: menuConfig?.icon ?? '');

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(menuConfig == null ? 'Add Menu Item' : 'Edit Menu Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: labelController,
                  decoration: const InputDecoration(labelText: 'Label'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: ['group', 'middleware', 'function'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedType = newValue;
                    }
                  },
                ),
                TextFormField(
                  controller: targetIdController,
                  decoration: const InputDecoration(labelText: 'Target ID (for function/middleware)'),
                ),
                TextFormField(
                  controller: iconController,
                  decoration: const InputDecoration(labelText: 'Icon Name'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final newMenuConfig = MenuConfig(
                  id: menuConfig?.id ?? const Uuid().v4(), // Keep existing ID or generate new
                  label: labelController.text,
                  type: selectedType,
                  targetId: targetIdController.text.isNotEmpty ? targetIdController.text : null,
                  icon: iconController.text.isNotEmpty ? iconController.text : null,
                  children: menuConfig?.children ?? [], // Preserve children for now
                );

                final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
                List<MenuConfig> currentTree = List.from(navigationProvider.menuTree);

                if (menuConfig == null) {
                  // Add new item
                  currentTree.add(newMenuConfig);
                } else {
                  // Edit existing item
                  int index = currentTree.indexWhere((element) => element.id == newMenuConfig.id);
                  if (index != -1) {
                    currentTree[index] = newMenuConfig;
                  }
                }
                navigationProvider.updateMenuTree(currentTree);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
