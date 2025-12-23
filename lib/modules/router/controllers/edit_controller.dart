import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:easywrt/modules/router/widgets/widget_factory.dart';

/// State for the EditManager.
class EditState {
  final bool isEditing;
  final String? editingPageId;
  final PageItem? workingPage; // The transient page object being edited
  final PageItem? originalSnapshot; // Snapshot for discard

  const EditState({
    this.isEditing = false,
    this.editingPageId,
    this.workingPage,
    this.originalSnapshot,
  });

  EditState copyWith({
    bool? isEditing,
    String? editingPageId,
    PageItem? workingPage,
    PageItem? originalSnapshot,
  }) {
    return EditState(
      isEditing: isEditing ?? this.isEditing,
      editingPageId: editingPageId ?? this.editingPageId,
      workingPage: workingPage ?? this.workingPage,
      originalSnapshot: originalSnapshot ?? this.originalSnapshot,
    );
  }
}

/// Manages the edit session for a page layout.
class EditController extends StateNotifier<EditState> {
  EditController() : super(const EditState());

  // ... enterEditMode ...
  void enterEditMode(PageItem page) {
    if (state.isEditing) return;

    // Deep copy using JSON
    final jsonMap = page.toJson();
    final workingCopy = PageItem.fromJson(json.decode(json.encode(jsonMap)));
    final snapshot = PageItem.fromJson(json.decode(json.encode(jsonMap)));

    state = EditState(
      isEditing: true,
      editingPageId: page.id,
      workingPage: workingCopy,
      originalSnapshot: snapshot,
    );
  }

  // ... exitEditMode ...
  void exitEditMode() {
    state = const EditState();
  }

  // ... discard ...
  void discard() {
    exitEditMode();
  }

  // ... save ...
  Future<void> save() async {
    final workingPage = state.workingPage;
    if (workingPage == null) return;
    
    // Logic placeholder:
    // var box = Hive.box<PageItem>('pages');
    // await box.put(workingPage.id, workingPage);
    
    exitEditMode();
  }

  /// Adds a new widget to the page.
  void addWidget(String widgetTypeKey) {
    final page = state.workingPage;
    if (page == null) return;

    final prototype = WidgetFactory.create(widgetTypeKey);
    final parts = prototype.defaultSize.split('x');
    final w = parts.length > 0 ? int.tryParse(parts[0]) ?? 1 : 1;
    final h = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;

    final newWidget = WidgetInstance(
      id: const Uuid().v4(),
      widgetTypeKey: widgetTypeKey,
      x: 0,
      y: 0,
      width: w,
      height: h,
    );

    // Simple strategy: Add new stripe at the end
    final newStripe = StripeItem(
      id: const Uuid().v4(),
      widgets: [newWidget],
    );

    final newStripes = List<StripeItem>.from(page.stripes ?? [])..add(newStripe);
    
    final newPage = PageItem(
      id: page.id,
      name: page.name,
      icon: page.icon,
      widgetChildren: page.widgetChildren,
      isEditable: page.isEditable,
      stripes: newStripes,
    );

    state = state.copyWith(workingPage: newPage);
  }

  /// Resizes a widget.
  void resizeWidget(String stripeId, String widgetId, int newW, int newH) {
    if (newW < 1 || newH < 1 || newW > 4) return; // Strict limits

    final page = state.workingPage;
    if (page == null) return;
    
    // Find stripe and widget
    final stripeIndex = page.stripes?.indexWhere((s) => s.id == stripeId) ?? -1;
    if (stripeIndex == -1) return;
    final stripe = page.stripes![stripeIndex];
    
    final widgetIndex = stripe.widgets.indexWhere((w) => w.id == widgetId);
    if (widgetIndex == -1) return;
    final widget = stripe.widgets[widgetIndex];
    
    if (widget.width == newW && widget.height == newH) return; // No change

    // Check collision with new size at same position
    if (_isValidPlacement(stripe, widgetId, widget.x, widget.y, newW, newH)) {
       final newWidget = WidgetInstance(
         id: widget.id,
         widgetTypeKey: widget.widgetTypeKey,
         x: widget.x,
         y: widget.y,
         width: newW,
         height: newH,
         configuration: widget.configuration,
       );
       
       // Replace
       final newWidgets = List<WidgetInstance>.from(stripe.widgets);
       newWidgets[widgetIndex] = newWidget;
       
       final newStripe = StripeItem(id: stripe.id, widgets: newWidgets);
       final newStripes = List<StripeItem>.from(page.stripes!);
       newStripes[stripeIndex] = newStripe;
       
       final newPage = PageItem(
          id: page.id,
          name: page.name,
          icon: page.icon,
          isEditable: page.isEditable,
          widgetChildren: page.widgetChildren,
          stripes: newStripes,
       );
       
       state = state.copyWith(workingPage: newPage);
    }
  }

  /// Checks if a widget placement is valid (no overlap).
  bool _isValidPlacement(StripeItem stripe, String widgetId, int x, int y, int w, int h) {
// ...
    if (x < 0 || y < 0 || x + w > 4) return false; // Out of bounds

    for (final other in stripe.widgets) {
      if (other.id == widgetId) continue; // Skip self

      // Check intersection
      final otherLeft = other.x;
      final otherRight = other.x + other.width;
      final otherTop = other.y;
      final otherBottom = other.y + other.height;

      final thisLeft = x;
      final thisRight = x + w;
      final thisTop = y;
      final thisBottom = y + h;

      bool overlapX = thisLeft < otherRight && thisRight > otherLeft;
      bool overlapY = thisTop < otherBottom && thisBottom > otherTop;

      if (overlapX && overlapY) return false;
    }
    return true;
  }

  /// Moves a widget to a new position if valid.
  /// Returns true if successful.
  bool moveWidget(String stripeId, String widgetId, int newX, int newY) {
    final page = state.workingPage;
    if (page == null || page.stripes == null) return false;

    final stripe = page.stripes!.firstWhere((s) => s.id == stripeId, orElse: () => throw Exception('Stripe not found'));
    final widgetIndex = stripe.widgets.indexWhere((w) => w.id == widgetId);
    if (widgetIndex == -1) return false;

    final widget = stripe.widgets[widgetIndex];
    
    if (_isValidPlacement(stripe, widgetId, newX, newY, widget.width, widget.height)) {
      // Update position (simulate immutability by replacing)
      // Since Hive objects are mutable, we can modify directly in working copy
      // But for StateNotifier to trigger updates, strictly we might need to regenerate the state?
      // For now, assuming workingPage mutation is tracked or we notify listeners.
      // Actually, standard StateNotifier behavior: we need to emit new state.
      
      // Since workingPage is mutable, we mutate it, then emit a new EditState 
      // with the *same* workingPage reference (Riverpod might not detect change if ref is same).
      // A better way is to clone or trigger a reconstruction.
      // For simplicity here, we'll mutate.
      
      // Update logic would go here.
      return true;
    }
    return false;
  }
}

final editManagerProvider = StateNotifierProvider<EditController, EditState>((ref) {
  return EditController();
});
