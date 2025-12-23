# Implementation Plan: Customization

**Branch**: `002-customization` | **Date**: 2025-12-23 | **Spec**: [specs/002-customization/spec.md](specs/002-customization/spec.md)
**Input**: Feature specification from `/specs/002-customization/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

This feature implements a user-customizable dashboard system where users can arrange Widgets on Pages using a quantized grid system. Key components include a `BaseWidget` abstract class for standardizing widget implementation, a "Stripe" based responsive layout engine that manages 4-column grids, and a comprehensive Edit Mode supporting drag-and-drop, resizing, and transactional saving (Save/Discard). Data persistence is handled via Hive, storing layouts in `PageItem` and `MiddlewareItem`.

## Technical Context

**Language/Version**: Dart 3.x (Flutter 3.x)
**Primary Dependencies**: 
- `flutter_riverpod` (State Management)
- `go_router` (Navigation)
- `hive` / `hive_flutter` (Persistence)
- `freezed_annotation` / `json_annotation` (Data Modeling)
- `uuid` (Unique IDs)
- *Research needed*: Optimal Flutter widgets for custom grid drag-and-drop (e.g., `Draggable`/`DragTarget` vs custom `MultiChildLayoutDelegate`).
**Storage**: Hive (Local NoSQL)
**Testing**: `flutter_test` (Unit/Widget), `integration_test` (User Flows)
**Target Platform**: MacOS, Windows (Primary for edit mode testing), Android, iOS.
**Project Type**: Cross-platform App (Mobile + Desktop)
**Performance Goals**: 
- 60fps during drag-and-drop operations.
- Zero layout jank when resizing stripes.
**Constraints**: 
- Strict 1rem (16px) grid quantization.
- Stripes must conform to 19rem-35rem width range.
- "Fit or Fail" collision detection strategy.
**Scale/Scope**: 
- ~3 initial test widgets (CPU, Memory, Network).
- ~10-20 stripes per page max.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **I. Code Quality**: `BaseWidget` enforces inheritance pattern. `freezed` ensures immutable state models.
- [x] **II. Testing First**: Unit tests required for `EditManager` (collision logic, "fit or fail" rules). Widget tests for `Stripe` responsiveness.
- [x] **III. UX**: Drag interactions must include "ghost" placeholders and smooth snapping animations (SC-001, SC-009).
- [x] **IV. Performance**: Drag state should be local to the editing overlay to avoid rebuilding the entire app tree.
- [x] **V. Standardized Interoperability**: `PageItem` schema defined in Hive; `WidgetItem` catalog defined as static code.
- [x] **VI. Documentation**: `BaseWidget` must have clear header comments for subclassing instructions.

## Project Structure

### Documentation (this feature)

```text
specs/002-customization/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── beam/                         # Specialized layout and navigation components
├── db/                           # Data persistence layer
│   ├── interface/                # Hive box initialization and repository interfaces
│   └── models/                   # Hive entities (PageItem) and static models (WidgetItem)
├── modules/                      # Feature-based business modules
│   ├── router/                   # Main dashboard and navigation logic
│   │   ├── controllers/          # Riverpod state managers for current page/router
│   │   ├── middleware/           # Views for navigation group nodes
│   │   ├── page/           # Main view for leaf nodes (Pages) supporting widgets
│   │   └── widgets/        # Widget implementations and BaseWidget contract
│   │       ├── base_widget.dart
│   │       ├── widget_factory.dart # Factory to instantiate widgets by typeKey
│   │       ├── cpu_usage/          # Folder per widget type
│   │       │   ├── cpu_usage_service.dart # Logic and data parsing
│   │       │   └── cpu_usage_widget.dart  # UI class inheriting BaseWidget
│   │       ├── memory_usage/
│   │       │   ├── memory_usage_service.dart
│   │       │   └── memory_usage_widget.dart
│   │       └── network_traffic/
│   │           ├── network_traffic_service.dart
│   │           └── network_traffic_widget.dart
│   └── setting/                  # Application settings and management
│       ├── controller/           # Setting-related state management
│       ├── pages/                # Management pages (Router, Theme)
│       └── theme/                # Theme providers and styles
├── utils/                        # Shared utilities and helpers、
├── main.dart                     # Entry point
└── router.dart                   # GoRouter navigation configuration
```

**Structure Decision**: Integrated into existing `lib/` structure, utilizing `beam/` for the specialized rendering engine and `modules/router/widgets/` for the widget plugin architecture.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|--------------------------------------|
| N/A       |            |                                      |
