import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:easywrt/modules/router/widgets/widget_factory.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

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

  @visibleForTesting
  EditState get debugState => state;

  // ... enterEditMode ...
  void enterEditMode(PageItem page) {
    if (state.isEditing) return;

    // Deep copy using JSON
    final jsonMap = page.toJson();
    final workingCopy = PageItem.fromJson(json.decode(json.encode(jsonMap)) as Map<String, dynamic>);
    final snapshot = PageItem.fromJson(json.decode(json.encode(jsonMap)) as Map<String, dynamic>);

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

    final box = Hive.box<PageItem>('pages');
    await box.put(workingPage.id, workingPage);

    exitEditMode();
  }

  /// Adds a new widget to the page.
  void addWidget(String widgetTypeKey) {
    final page = state.workingPage;
    if (page == null) return;

    final prototype = WidgetFactory.create(widgetTypeKey);
    final parts = prototype.defaultSize.split('x');
    final w = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 1 : 1;
    final h = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;

    final stripes = page.stripes ?? [];
    List<StripeItem> newStripes;

    if (stripes.isEmpty) {
      // Case 1: No stripes, create new one
      final newWidget = WidgetInstance(
        id: const Uuid().v4(),
        widgetTypeKey: widgetTypeKey,
        x: 0,
        y: 0,
        width: w,
        height: h,
        supportedSizes: prototype.supportedSizes,
      );

      final newStripe = StripeItem(id: const Uuid().v4(), widgets: [newWidget]);
      newStripes = [newStripe];
    } else {
      // Case 2: Add to first existing stripe, finding first available spot
      final targetStripeIndex = 0;
      final targetStripe = stripes[targetStripeIndex];

      int foundX = 0;
      int foundY = 0;
      bool found = false;

      // Calculate max Y to determine search bounds
      int maxY = 0;
      for (var widget in targetStripe.widgets) {
        if (widget.y + widget.height > maxY) {
          maxY = widget.y + widget.height;
        }
      }

      // Search for first valid placement (Gap filling or Append)
      // We search up to maxY which ensures we check empty space at the bottom.
      for (int y = 0; y <= maxY; y++) {
        for (int x = 0; x <= 4 - w; x++) {
          if (_isValidPlacement(targetStripe, '', x, y, w, h)) {
            foundX = x;
            foundY = y;
            found = true;
            break;
          }
        }
        if (found) break;
      }

      final newWidget = WidgetInstance(
        id: const Uuid().v4(),
        widgetTypeKey: widgetTypeKey,
        x: foundX,
        y: foundY,
        width: w,
        height: h,
        supportedSizes: prototype.supportedSizes,
      );

      final newWidgets = List<WidgetInstance>.from(targetStripe.widgets)
        ..add(newWidget);
      final newStripe = StripeItem(id: targetStripe.id, widgets: newWidgets);

      newStripes = List<StripeItem>.from(stripes);
      newStripes[targetStripeIndex] = newStripe;
    }

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
    if (newW < 1 || newH < 1 || newH > 4 || newW > 4) return; // Strict limits

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

    // Check if the widget supports this size
    final sizeKey = '${newW}x$newH';
    // Use instance supportedSizes if available, otherwise fallback to Factory
    List<String> supported = widget.supportedSizes;
    if (supported.isEmpty) {
       supported = WidgetFactory.create(widget.widgetTypeKey).supportedSizes;
    }
    
    if (!supported.contains(sizeKey)) {
      return; 
    }

    // Strict validation: Check collision immediately
    if (_isValidPlacement(stripe, widgetId, widget.x, widget.y, newW, newH)) {
      final newWidget = WidgetInstance(
        id: widget.id,
        widgetTypeKey: widget.widgetTypeKey,
        x: widget.x,
        y: widget.y,
        width: newW,
        height: newH,
        configuration: widget.configuration,
        supportedSizes: widget.supportedSizes,
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
  bool _isValidPlacement(
    StripeItem stripe,
    String widgetId,
    int x,
    int y,
    int w,
    int h,
  ) {
    if (x < 0 || y < 0 || x + w > 4) {
      return false; // Out of bounds
    }

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

      final bool overlapX = thisLeft < otherRight && thisRight > otherLeft;
      final bool overlapY = thisTop < otherBottom && thisBottom > otherTop;

      if (overlapX && overlapY) {
        return false;
      }
    }
    return true;
  }

  /// Moves a widget to a new position if valid.
  /// Can move between stripes.
  /// Returns true if successful.
  bool moveWidget(
    String targetStripeId,
    String sourceStripeId,
    String widgetId,
    int newX,
    int newY,
  ) {
    final page = state.workingPage;
    if (page == null || page.stripes == null) return false;

    // 1. Find Source Stripe & Widget
    final sourceStripeIndex = page.stripes!.indexWhere(
      (s) => s.id == sourceStripeId,
    );
    if (sourceStripeIndex == -1) return false;
    final sourceStripe = page.stripes![sourceStripeIndex];

    final widgetIndex = sourceStripe.widgets.indexWhere(
      (w) => w.id == widgetId,
    );
    if (widgetIndex == -1) return false;
    final widget = sourceStripe.widgets[widgetIndex];

    // 2. Find Target Stripe
    final targetStripeIndex = page.stripes!.indexWhere(
      (s) => s.id == targetStripeId,
    );
    if (targetStripeIndex == -1) return false;
    final targetStripe = page.stripes![targetStripeIndex];

    // 3. Check Validity in Target Stripe
    // If same stripe, we skip the widget itself in collision check.
    // If different stripe, we check against all widgets in target.
    // We can reuse _isValidPlacement but need to handle "skip self" logic.
    // _isValidPlacement currently skips checking against widgetId.
    // If moving to a different stripe, widgetId won't exist in targetStripe, so it won't be skipped (correct).

    if (_isValidPlacement(
      targetStripe,
      widgetId,
      newX,
      newY,
      widget.width,
      widget.height,
    )) {
      // Create new widget instance with updated position
      final newWidget = WidgetInstance(
        id: widget.id,
        widgetTypeKey: widget.widgetTypeKey,
        x: newX,
        y: newY,
        width: widget.width,
        height: widget.height,
        configuration: widget.configuration,
        supportedSizes: widget.supportedSizes,
      );

      // Prepare new stripes list
      final newStripes = List<StripeItem>.from(page.stripes!);

      if (sourceStripeId == targetStripeId) {
        // Same Stripe Move
        final newWidgets = List<WidgetInstance>.from(sourceStripe.widgets);
        newWidgets[widgetIndex] = newWidget;
        newStripes[sourceStripeIndex] = StripeItem(
          id: sourceStripe.id,
          widgets: newWidgets,
        );
      } else {
        // Cross Stripe Move

        // Remove from source
        final newSourceWidgets = List<WidgetInstance>.from(sourceStripe.widgets)
          ..removeAt(widgetIndex);
        newStripes[sourceStripeIndex] = StripeItem(
          id: sourceStripe.id,
          widgets: newSourceWidgets,
        );

        // Add to target
        final newTargetWidgets = List<WidgetInstance>.from(targetStripe.widgets)
          ..add(newWidget);
        newStripes[targetStripeIndex] = StripeItem(
          id: targetStripe.id,
          widgets: newTargetWidgets,
        );
      }

      // Cleanup empty stripes
      newStripes.removeWhere((s) => s.widgets.isEmpty);

      // Create new page object
      final newPage = PageItem(
        id: page.id,
        name: page.name,
        icon: page.icon,
        isEditable: page.isEditable,
        widgetChildren: page.widgetChildren,
        stripes: newStripes,
      );

      state = state.copyWith(workingPage: newPage);
      return true;
    }
    return false;
  }

  /// Moves a widget to a new stripe at the end of the page.
  void moveWidgetToNewStripe(String sourceStripeId, String widgetId) {
    final page = state.workingPage;
    if (page == null || page.stripes == null) return;

    // 1. Find and Remove from Source Stripe
    final sourceStripeIndex = page.stripes!.indexWhere(
      (s) => s.id == sourceStripeId,
    );
    if (sourceStripeIndex == -1) return;

    final sourceStripe = page.stripes![sourceStripeIndex];
    final widgetIndex = sourceStripe.widgets.indexWhere(
      (w) => w.id == widgetId,
    );
    if (widgetIndex == -1) return;

    final widget = sourceStripe.widgets[widgetIndex];

    final newSourceWidgets = List<WidgetInstance>.from(sourceStripe.widgets)
      ..removeAt(widgetIndex);

    // 2. Create New Stripe with the Widget (reset x,y to 0,0)
    final newWidget = WidgetInstance(
      id: widget.id,
      widgetTypeKey: widget.widgetTypeKey,
      x: 0,
      y: 0,
      width: widget.width,
      height: widget.height,
      configuration: widget.configuration,
      supportedSizes: widget.supportedSizes,
    );

    final newStripe = StripeItem(id: const Uuid().v4(), widgets: [newWidget]);

    // 3. Construct New Page
    final newStripes = List<StripeItem>.from(page.stripes!);

    // Update source stripe
    newStripes[sourceStripeIndex] = StripeItem(
      id: sourceStripe.id,
      widgets: newSourceWidgets,
    );

    newStripes.add(newStripe);

    // Cleanup empty stripes
    newStripes.removeWhere((s) => s.widgets.isEmpty);

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

  /// Deletes a widget from a stripe.
  void deleteWidget(String stripeId, String widgetId) {
    final page = state.workingPage;
    if (page == null || page.stripes == null) return;

    final stripeIndex = page.stripes!.indexWhere((s) => s.id == stripeId);
    if (stripeIndex == -1) return;
    final stripe = page.stripes![stripeIndex];

    final widgetIndex = stripe.widgets.indexWhere((w) => w.id == widgetId);
    if (widgetIndex == -1) return;

    final newWidgets = List<WidgetInstance>.from(stripe.widgets)
      ..removeAt(widgetIndex);

    final newStripes = List<StripeItem>.from(page.stripes!);
    newStripes[stripeIndex] = StripeItem(id: stripe.id, widgets: newWidgets);

    // Cleanup empty stripes
    newStripes.removeWhere((s) => s.widgets.isEmpty);

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

final editManagerProvider = StateNotifierProvider<EditController, EditState>((
  ref,
) {
  return EditController();
});
