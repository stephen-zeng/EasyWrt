# Tasks: Customization

**Feature**: `002-customization`
**Phase**: Implementation

## Phase 1: Setup
**Goal**: Initialize project structure, base contracts, and data models.

- [x] T001 Create directory structure for beam and widget modules in `lib/beam/` and `lib/modules/router/widgets/`
- [x] T002 Implement `BaseWidget` contract in `lib/modules/router/widgets/base_widget.dart`
- [x] T003 Update `PageItem` model to include `isEditable` and `stripes` in `lib/db/models/hierarchy_items.dart`
- [x] T004 Create `StripeItem` and `WidgetInstance` value objects in `lib/db/models/hierarchy_items.dart`
- [x] T005 Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate Hive adapters

## Phase 2: Foundational (Layout & State)
**Goal**: Implement the responsive grid layout engine and the core editing state manager.
**Independent Test**: `Stripe` widget correctly renders a 4-column grid that wraps based on width; `EditManager` correctly handles collision logic.

- [x] T006 [P] Create `StripeWidget` for rendering grid layouts in `lib/beam/stripe_widget.dart`
- [x] T007 [P] Implement `ResponsiveLayout` logic (19rem-35rem rules) in `lib/beam/responsive_layout.dart`
- [x] T008 [P] Implement `EditManager` StateNotifier with collision detection logic in `lib/modules/router/controllers/edit_controller.dart`
- [x] T009 Create unit tests for `EditManager` collision logic ("Fit or Fail") in `test/unit/edit_manager_test.dart`
- [x] T010 Create widget tests for `StripeWidget` responsiveness in `test/widget/stripe_widget_test.dart`

## Phase 3: User Stories 1 & 7 (Page Edit Mode)
**Goal**: Enable entering/exiting edit mode and persisting changes (even if empty).
**Independent Test**: User can toggle edit mode, seeing visual cues (dashed lines), and click Save/Discard which persists/reverts state.

- [x] T011 [US1] Update `PageView` to support "Edit Mode" state toggling in `lib/modules/router/page/page_view.dart`
- [x] T012 [US1] Implement AppBar "Edit" action menu (Portrait/Landscape logic) in `lib/modules/router/page/page_view.dart`
- [x] T013 [US1] Implement "Edit Mode" visual cues (dashed borders, ghost circles) in `lib/beam/stripe_widget.dart`
- [x] T014 [US7] Implement `Save` logic in `EditManager` to persist `PageItem` to Hive in `lib/modules/router/controllers/edit_controller.dart`
- [x] T015 [US7] Implement `Discard` logic (revert to original state) in `lib/modules/router/controllers/edit_controller.dart`

## Phase 4: User Story 2 & FR-008 (Widgets & Catalog)
**Goal**: Implement the widget factory and allow users to add new widgets to the page.
**Independent Test**: User can open "Add Widget" dialog, select a widget, and see it appear in the grid.

- [x] T016 [US2] Create `WidgetFactory` to instantiate widgets by typeKey in `lib/modules/router/widgets/widget_factory.dart`
- [x] T017 [US2] Create `widgetCatalogProvider` to expose available widgets in `lib/modules/router/controllers/widget_catalog_controller.dart`
- [x] T018 [P] [US2] Implement `CpuUsageService` in `lib/modules/router/widgets/cpu_usage/cpu_usage_service.dart`
- [x] T019 [P] [US2] Implement `CpuUsageWidget` (extending BaseWidget) in `lib/modules/router/widgets/cpu_usage/cpu_usage_widget.dart`
- [x] T020 [P] [US2] Implement `MemoryUsageService` in `lib/modules/router/widgets/memory_usage/memory_usage_service.dart`
- [x] T021 [P] [US2] Implement `MemoryUsageWidget` in `lib/modules/router/widgets/memory_usage/memory_usage_widget.dart`
- [x] T022 [P] [US2] Implement `NetworkTrafficService` in `lib/modules/router/widgets/network_traffic/network_traffic_service.dart`
- [x] T023 [P] [US2] Implement `NetworkTrafficWidget` in `lib/modules/router/widgets/network_traffic/network_traffic_widget.dart`
- [x] T024 [US2] Implement `AddWidgetDialog` UI in `lib/modules/router/widgets/add_widget_dialog.dart`
- [x] T025 [US2] Connect `AddWidgetDialog` to `EditManager` to insert new widgets into the grid in `lib/modules/router/page/page_view.dart`

## Phase 5: User Story 3 (Drag & Drop & Resize)
**Goal**: Enable moving and resizing widgets within the grid.
**Independent Test**: User can drag a widget to a new slot; resizing snaps to valid grid sizes; strict mode prevents overlaps.

- [x] T026 [US3] Wrap widgets in `Draggable` and grid cells in `DragTarget` in `lib/beam/stripe_widget.dart`
- [x] T027 [US3] Implement resize handles on widgets in Edit Mode in `lib/beam/stripe_widget.dart`
- [x] T028 [US3] Update `EditManager` to handle `onDragAccept` events (move widget) in `lib/modules/router/controllers/edit_controller.dart`
- [x] T029 [US3] Update `EditManager` to handle `onResize` events (snap to grid) in `lib/modules/router/controllers/edit_controller.dart`
- [x] T030 [US3] Implement "Ghost" placeholder logic during drag in `lib/beam/stripe_widget.dart`

## Phase 6: User Stories 4, 5 & 6 (Middleware Editing)
**Goal**: Enable customization of middleware lists (add/remove/reorder).
**Independent Test**: User can reorder middleware items, add a new page to the list, and delete an item.

- [x] T031 [US4] Update `MiddlewareView` to support "Edit Mode" toggling in `lib/modules/router/middleware/middleware_view.dart`
- [x] T032 [US6] Implement reorderable list logic for `MiddlewareItem` children in `lib/modules/router/middleware/middleware_view.dart`
- [x] T033 [US6] Implement "Add Item" dialog for Middleware (filtering recursion) in `lib/modules/router/middleware/middleware_view.dart`
- [x] T034 [US6] Implement persistence for Middleware changes in `lib/modules/router/controllers/current_middleware_controller.dart`

## Phase 7: Polish & Cross-cutting
**Goal**: Refine UI/UX and handle edge cases.

- [x] T035 [P] Implement rotation handling (auto-save on rotate) in `lib/modules/router/page/page_view.dart`
- [x] T036 [P] Add animations for widget insertion and removal in `lib/beam/stripe_widget.dart`
- [x] T037 [P] Verify "Unknown Widget" fallback rendering in `lib/modules/router/widgets/widget_factory.dart`

## Dependencies

- Phase 2 (Foundation) requires Phase 1 (Setup)
- Phase 3 (US1/US7) requires Phase 2 (Foundation)
- Phase 4 (US2) requires Phase 3 (US1/US7)
- Phase 5 (US3) requires Phase 4 (US2)
- Phase 6 (Middleware) is largely independent but shares patterns with Phase 3

## Parallel Execution Examples

- **Widget Implementation**: T018-T023 (CPU, Memory, Network) can be implemented in parallel by different developers.
- **Foundation**: T006 (UI), T007 (Logic), and T008 (State) can be developed concurrently.
- **Polish**: T035, T036, T037 are independent.

## Implementation Strategy

1. **Skeleton**: Establish the data models and `BaseWidget` contract first to unblock parallel widget development.
2. **Layout Engine**: Build the `StripeWidget` and `EditManager` core next, as this is the most complex logic (tested via T009/T010).
3. **MVP (Page Edit)**: Focus on entering edit mode, adding a simple 1x1 widget, and saving.
4. **Interaction**: Add drag-and-drop and resizing once the grid rendering is stable.
5. **Middleware**: Tackle middleware customization last as it uses existing list patterns.
