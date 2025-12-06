import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:easywrt/model/menu_config.dart';
import 'package:easywrt/database/storage.dart'; // Assuming HiveDB handles MenuConfig box
import 'package:uuid/uuid.dart';

class NavigationProvider extends ChangeNotifier {
  late Box<MenuConfig> _menuConfigBox;
  List<MenuConfig> _menuTree = [];

  List<MenuConfig> get menuTree => _menuTree;

  NavigationProvider() {
    _init();
  }

  Future<void> _init() async {
    // Assuming HiveDB.init() registers the adapter and opens the box
    _menuConfigBox = await Hive.openBox<MenuConfig>('menuConfigBox'); // Use a dedicated box name

    if (_menuConfigBox.isEmpty) {
      // Initialize with a default menu if empty
      _menuTree = _createDefaultMenu();
      for (var item in _menuTree) {
        await _menuConfigBox.put(item.id, item);
      }
    } else {
      _menuTree = _menuConfigBox.values.toList();
      // Basic sorting or tree reconstruction might be needed if not stored as a single root
    }
    notifyListeners();
  }

  List<MenuConfig> _createDefaultMenu() {
    return [
      MenuConfig(
        id: const Uuid().v4(),
        label: 'System',
        type: 'group',
        icon: 'system_icon',
        children: [
          MenuConfig(
            id: const Uuid().v4(),
            label: 'Overview',
            type: 'function',
            targetId: 'system_overview',
            icon: 'overview_icon',
          ),
          MenuConfig(
            id: const Uuid().v4(),
            label: 'Reboot',
            type: 'function',
            targetId: 'system_reboot',
            icon: 'reboot_icon',
          ),
        ],
      ),
      MenuConfig(
        id: const Uuid().v4(),
        label: 'Network',
        type: 'group',
        icon: 'network_icon',
        children: [
          MenuConfig(
            id: const Uuid().v4(),
            label: 'Interfaces',
            type: 'function',
            targetId: 'network_interfaces',
            icon: 'interfaces_icon',
          ),
          MenuConfig(
            id: const Uuid().v4(),
            label: 'Wireless',
            type: 'function',
            targetId: 'network_wireless',
            icon: 'wireless_icon',
          ),
        ],
      ),
    ];
  }

  void updateMenuTree(List<MenuConfig> newTree) async {
    _menuTree = newTree;
    await _menuConfigBox.clear(); // Clear existing
    for (var item in newTree) {
      await _menuConfigBox.put(item.id, item); // Save new tree
    }
    notifyListeners();
  }

  // Method to get a menu item by ID (useful for traversal)
  MenuConfig? getMenuItemById(String id, {List<MenuConfig>? searchList}) {
    searchList ??= _menuTree;
    for (var item in searchList) {
      if (item.id == id) {
        return item;
      }
      if (item.children.isNotEmpty) {
        final found = getMenuItemById(id, searchList: item.children);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }
}
