import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/db/models/transient_models.dart';

class CurrentMiddlewareNotifier extends StateNotifier<CurrentMiddleware?> {
  CurrentMiddlewareNotifier() : super(null);

  void init(MiddlewareItem item) {
    if (state == null) {
      state = CurrentMiddleware(
        middlewareItem: item,
        historyMiddlewareIDs: [],
        slideMiddlewareID: '',
      );
    }
  }
  
  void push(MiddlewareItem newItem) {
    if (state == null) {
        init(newItem);
        return;
    }
    // Prevent pushing same item
    if (state!.middlewareItem.id == newItem.id) return;
    
    final newHistory = List<String>.from(state!.historyMiddlewareIDs)..add(state!.middlewareItem.id);
    state = state!.copyWith(
        middlewareItem: newItem,
        historyMiddlewareIDs: newHistory
    );
  }

  String? pop() {
      if (state == null || state!.historyMiddlewareIDs.isEmpty) return null;
      
      final lastId = state!.historyMiddlewareIDs.last;
      final newHistory = List<String>.from(state!.historyMiddlewareIDs)..removeLast();
      
      state = state!.copyWith(historyMiddlewareIDs: newHistory);
      return lastId;
  }

  void saveSlideMiddlewareID(String id) {
    if (state != null) {
      state = state!.copyWith(slideMiddlewareID: id);
    }
  }
  
  void replaceCurrent(MiddlewareItem item) {
    if (state != null) {
      state = state!.copyWith(middlewareItem: item);
    } else {
      init(item);
    }
  }

  /// Reorders children of the current middleware and persists to Hive.
  Future<void> reorderChildren(int oldIndex, int newIndex) async {
    if (state == null) return;
    final item = state!.middlewareItem;
    final children = List<String>.from(item.children ?? []);
    
    if (oldIndex < newIndex) newIndex -= 1;
    final childId = children.removeAt(oldIndex);
    children.insert(newIndex, childId);

    final newItem = MiddlewareItem(
      id: item.id,
      name: item.name,
      icon: item.icon,
      middlewareChildren: item.middlewareChildren,
      pageChildren: item.pageChildren,
      children: children,
    );
    
    // Persist
    final box = Hive.box<MiddlewareItem>('middlewares');
    await box.put(item.id, newItem);
    
    // Update State
    state = state!.copyWith(middlewareItem: newItem);
  }

  /// Adds a child to the current middleware and persists.
  Future<void> addChild(String childId) async {
    if (state == null) return;
    final item = state!.middlewareItem;
    final children = List<String>.from(item.children ?? [])..add(childId);
    
    final newItem = MiddlewareItem(
      id: item.id,
      name: item.name,
      icon: item.icon,
      middlewareChildren: item.middlewareChildren,
      pageChildren: item.pageChildren,
      children: children,
    );
    
    final box = Hive.box<MiddlewareItem>('middlewares');
    await box.put(item.id, newItem);
    
    state = state!.copyWith(middlewareItem: newItem);
  }

  /// Removes a child from the current middleware and persists.
  Future<void> removeChild(String childId) async {
    if (state == null) return;
    final item = state!.middlewareItem;
    final children = List<String>.from(item.children ?? [])..remove(childId);
    
    final newItem = MiddlewareItem(
      id: item.id,
      name: item.name,
      icon: item.icon,
      middlewareChildren: item.middlewareChildren,
      pageChildren: item.pageChildren,
      children: children,
    );
    
    final box = Hive.box<MiddlewareItem>('middlewares');
    await box.put(item.id, newItem);
    
    state = state!.copyWith(middlewareItem: newItem);
  }
}

final currentMiddlewareProvider = StateNotifierProvider<CurrentMiddlewareNotifier, CurrentMiddleware?>((ref) {
  return CurrentMiddlewareNotifier();
});
