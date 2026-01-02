import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/db/models/transient_models.dart';

class CurrentPageNotifier extends StateNotifier<CurrentPage?> {
  CurrentPageNotifier() : super(null);

  void init(PageItem pageItem) {
    if (state != null && state!.id == pageItem.id) {
        return;
    }
    
    state = CurrentPage(
      id: pageItem.id,
      path: [],
      name: pageItem.name,
      icon: pageItem.icon,
      isEditMode: false,
      widgetChildren: pageItem.widgetChildren,
      historyPageIDs: [],
    );
  }

  void push({
    required String id, 
    required String name, 
    required String icon, 
    List<String>? widgetChildren
  }) {
    if (state == null) {
      // First load, no history
      state = CurrentPage(
        id: id,
        path: [],
        name: name,
        icon: icon,
        isEditMode: false,
        widgetChildren: widgetChildren,
        historyPageIDs: [],
      );
      return;
    }

    if (state!.id == id) return;

    final newHistory = List<String>.from(state!.historyPageIDs)..add(state!.id);
    state = CurrentPage(
      id: id,
      path: [],
      name: name,
      icon: icon,
      isEditMode: false,
      widgetChildren: widgetChildren,
      historyPageIDs: newHistory,
    );
  }

  String? pop() {
    if (state == null || state!.historyPageIDs.isEmpty) return null;

    final prevId = state!.historyPageIDs.last;
    final newHistory = List<String>.from(state!.historyPageIDs)..removeLast();
    
    // Update state to reflect the previous page as current.
    // Note: We retain the old name/icon as we don't have the previous page's metadata here,
    // but PageView fetches display data independently so this is safe for history tracking.
    state = state!.copyWith(
      id: prevId,
      historyPageIDs: newHistory,
    );
    return prevId;
  }
  
  void toggleEditMode() {
    if (state != null) {
      state = state!.copyWith(isEditMode: !state!.isEditMode);
    }
  }

  void setEditMode(bool value) {
    if (state != null) {
      state = state!.copyWith(isEditMode: value);
    }
  }
  
  void clear() {
      state = null;
  }
}

final currentPageProvider = StateNotifierProvider<CurrentPageNotifier, CurrentPage?>((ref) {
  return CurrentPageNotifier();
});
