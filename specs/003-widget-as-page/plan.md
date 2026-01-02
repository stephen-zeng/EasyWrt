# Implementation Plan: Widget as Page

**Branch**: `003-widget-as-page` | **Date**: 2026-01-02 | **Spec**: [specs/003-widget-as-page/spec.md](spec.md)
**Input**: Feature specification from `specs/003-widget-as-page/spec.md`

## Summary

This feature enables widgets to be rendered as full standalone pages ("WidgetPage"), accessible via direct URL deep links (e.g., `/widget/cpu-usage`) or through the application's middleware navigation. Key architectural changes include updating the `BaseWidget` abstract class to enforce a `renderPage` contract, creating a `WidgetPage` wrapper component that handles the page shell (AppBar, Back Button) and state sharing, and updating the routing configuration to support dynamic widget routes.

## Technical Context

**Language/Version**: Dart 3.9.2 (Flutter 3.x)
**Primary Dependencies**: 
- `flutter_riverpod` (State Management)
- `go_router` (Routing)
- `hive` (Persistence for Middleware)
**Storage**: Hive (for MiddlewareItem persistence)
**Testing**: `flutter_test` (Unit/Widget tests)
**Target Platform**: Cross-platform (iOS, Android, macOS, Windows, Linux, Web)
**Project Type**: Flutter Mobile/Desktop Application
**Performance Goals**: 60fps UI transitions, sub-500ms navigation to WidgetPage.
**Constraints**: 
- Must maintain compatibility with existing `RouterPageView` and `Middleware` structures.
- Widget pages must be responsive (Portrait full screen vs Landscape pane).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **Code Quality**: Will follow Effective Dart and existing project style.
- [x] **Testing First**: Will include Widget tests for `WidgetPage` and unit tests for routing logic.
- [x] **UX**: Will ensure standard navigation patterns (Back button behavior) and responsive layout.
- [x] **Performance**: Will share state to avoid unnecessary rebuilds/refetches.
- [x] **Interoperability**: Will use standardized `pageID` format `widget_{typeKey}`.
- [x] **Documentation**: Will update `BaseWidget` documentation and add header comments to new classes.

## Project Structure

### Documentation (this feature)

```text
specs/003-widget-as-page/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
lib/
├── modules/
│   ├── router/
│   │   ├── widgets/
│   │   │   ├── base/
│   │   │   │   └── base_widget.dart      # Modify: Add renderPage
│   │   │   └── [specific_widgets]/       # Modify: Implement renderPage
│   │   ├── page/
│   │   │   └── widget_page.dart          # New: WidgetPage Wrapper
│   │   ├── controllers/
│   │   │   └── widget_catalog_controller.dart # Existing
│   │   └── middleware/
│   │       └── middleware_view.dart      # Modify: Support widget items
└── router.dart                           # Modify: Add /widget/:id route
```

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | | |

## Phases

### Phase 0: Outline & Research

1. **Research Tasks**:
   - Verify `BaseWidget` generic type usage to ensure `renderPage` can return a widget interacting with the same state.
   - Investigate `MiddlewareItem` serialization in Hive to ensure `widget_{typeKey}` string IDs don't break existing logic.
   - Check `GoRouter` configuration in `lib/router.dart` for best place to inject the new `/widget/:typeKey` route (top-level vs shell route).

2. **Output**: `specs/003-widget-as-page/research.md`

### Phase 1: Design & Contracts

1. **Data Model**:
   - Define updates to `MiddlewareItem` (conceptually, if ID format changes need validation).
   - Document `pageID` format `widget_{typeKey}`.

2. **API Contracts**:
   - Define `renderPage` signature in `BaseWidget`.
   - Define `WidgetPage` constructor contract.

3. **Output**: 
   - `specs/003-widget-as-page/data-model.md`
   - `specs/003-widget-as-page/contracts/base_widget.dart` (updated abstract class)

### Phase 2: Task Breakdown

1. **Implementation Tasks**:
   - Update `BaseWidget` definition.
   - Implement `WidgetPage` wrapper.
   - Update `Router` configuration.
   - Update `Middleware` add dialog and list rendering.
   - Implement "Long Press" gesture on Dashboard widgets.
   - Update example widgets to implement `renderPage`.

2. **Output**: `specs/003-widget-as-page/tasks.md`