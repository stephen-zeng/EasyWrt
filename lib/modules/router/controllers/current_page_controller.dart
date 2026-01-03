import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/db/models/transient_models.dart';

class CurrentPageNotifier extends StateNotifier<CurrentPage?> {
  CurrentPageNotifier() : super(null);

  void setPage({
    required String id, 
    required String name, 
    required String icon, 
    List<String>? widgetChildren
  }) {
    // Preserve edit mode if same page
    final isEdit = (state?.id == id) ? (state?.isEditMode ?? false) : false;

    state = CurrentPage(
      id: id,
      path: [],
      name: name,
      icon: icon,
      isEditMode: isEdit,
      widgetChildren: widgetChildren,
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
