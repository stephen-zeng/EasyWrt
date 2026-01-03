# Tasks: Widget as Page

**Feature**: `003-widget-as-page`
**Status**: Pending

## Dependencies

- **Phase 1 (Setup)**: Dependencies for all subsequent phases
- **Phase 2 (Foundational)**: Prerequisite for all User Stories
- **Phase 3 (US1)**: Dependent on Phase 2
- **Phase 4 (US2)**: Dependent on Phase 2
- **Phase 5 (US3)**: Dependent on Phase 2
- **Phase 6 (Polish)**: Dependent on all prior phases

## Phase 1: Setup

**Goal**: Initialize project structure and ensure base contracts are in place.

- [x] T001 Verify project structure and dependencies in `pubspec.yaml`
- [x] T002 [P] Create directory structure for new components in `lib/modules/router/page/`

## Phase 2: Foundational

**Goal**: Establish the core architecture updates for `BaseWidget` and `WidgetPage` wrapper.
**Blocking**: Must complete before starting User Stories.

- [x] T003 Update `BaseWidget` contract in `lib/modules/router/widgets/base/base_widget.dart` to include `renderPage` and 0x0 size logic
- [x] T004 Create `WidgetPage` wrapper in `lib/modules/router/page/widget_page.dart`
- [x] T005 [P] Update `RouterSplitWrapper` in `lib/modules/router/router_split_wrapper.dart` to handle `widget_` PIDs
- [x] T006 Update `MiddlewareView` logic in `lib/modules/router/middleware/middleware_view.dart` to support rendering widget items
- [x] T020 [P] Create widget tests for `WidgetPage` wrapper in `test/widget/widget_page_test.dart` (verify app bar, back button, content rendering)
- [x] T021 [P] Create unit tests for `BaseWidget` routing logic in `test/unit/base_widget_test.dart`

## Phase 3: User Story 1 - Add Widget to Middleware List (P1)

**Goal**: Enable users to add widgets to the middleware navigation list.
**Independent Test**: Can be tested by opening the "Add Item" dialog and verifying widgets appear and can be saved to the list.

- [x] T007 [US1] Update `AddWidgetDialog` in `lib/modules/router/page/add_widget_dialog.dart` (or create new `AddMiddlewareItemDialog` variant) to support selecting widgets from `widgetCatalogProvider`
- [x] T008 [US1] Ensure `MiddlewareItem` persistence handles `widget_{typeKey}` format (verification task)
- [x] T009 [US1] Update Middleware list rendering to display widget items with correct icon/name in `lib/modules/router/middleware/middleware_view.dart`

## Phase 4: User Story 2 - Navigate to WidgetPage via Middleware (P1)

**Goal**: Enable navigation to the full-page widget view when a widget item is tapped.
**Independent Test**: Can be tested by tapping a widget item in the sidebar and verifying the `WidgetPage` loads in the main view.

- [x] T010 [US2] Implement navigation logic in `MiddlewareView` to push `/router?mid=...&pid=widget_...` when a widget item is tapped
- [x] T011 [US2] Verify `WidgetPage` wrapper correctly looks up widget from `WidgetCatalogProvider` and renders it
- [x] T012 [US2] Ensure state sharing: Verify `WidgetPage` uses the same provider scope/instances as dashboard widgets (by using `ref.watch` in `BaseWidget`)

## Phase 5: User Story 3 - Quick Access to WidgetPage via Long Press (P2)

**Goal**: Enable long-press on dashboard widgets to jump to their specific page.
**Independent Test**: Can be tested by long-pressing a widget on a stripe and verifying navigation.

- [x] T013 [US3] Update `StripeWidget` or `BaseWidget` wrapper to detect long-press gestures
- [x] T014 [US3] Implement navigation action on long-press to go to `/router?pid=widget_{typeKey}`

## Phase 6: Polish & Cross-Cutting Concerns

**Goal**: Ensure quality, handling edge cases, and updating example widgets.

- [x] T015 [P] Update `SystemStatusWidget` (or equivalent example) to implement a meaningful `renderPage` view
- [x] T016 [P] Update `CpuUsageWidget` (or equivalent example) to implement a meaningful `renderPage` view
- [x] T017 Verify "Back" button behavior deep-link scenario (navigates to Dashboard if no history) in `WidgetPage` wrapper
- [x] T018 Check responsive layout: Ensure `WidgetPage` works in both Portrait (full screen) and Landscape (right pane)
- [x] T019 Clean up any temporary debug prints or TODOs

## Implementation Strategy

1.  **MVP Scope**: Complete Phase 1, 2, 3, and 4. This provides the core capability to add widgets to the menu and view them as pages.
2.  **Incremental Delivery**: US3 (Long Press) can be delivered as a follow-up enhancement.
3.  **Parallelization**: T015/T016 (Widget implementations) can be done in parallel with T007-T014 once T003 (BaseWidget update) is done.
