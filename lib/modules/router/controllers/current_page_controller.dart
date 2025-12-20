import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/db/models/transient_models.dart';

class CurrentPageNotifier extends StateNotifier<CurrentPage?> {
  CurrentPageNotifier() : super(null);

  void init(PageItem pageItem) {
    // If already initialized with this page, do nothing (preserve edit mode)
    if (state != null && state!.id == pageItem.id) {
        // Just update metadata if needed, but keep edit mode
        // For now, assuming static metadata from Hive
        return;
    }
    
    state = CurrentPage(
      id: pageItem.id,
      path: [], // Path handling might be complex, skipping for now as it's not critical
      name: pageItem.name,
      icon: pageItem.icon,
      isEditMode: false,
      widgetChildren: pageItem.widgetChildren,
    );
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
