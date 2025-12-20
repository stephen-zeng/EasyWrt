import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}

final currentMiddlewareProvider = StateNotifierProvider<CurrentMiddlewareNotifier, CurrentMiddleware?>((ref) {
  return CurrentMiddlewareNotifier();
});
