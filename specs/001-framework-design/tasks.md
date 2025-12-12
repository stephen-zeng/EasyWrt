---
description: "Task list for OpenWRT Manager App Implementation"
---

# Tasks: OpenWRT Manager App

**Input**: Design documents from `/specs/001-framework-design/`
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/, research.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project directory structure (`lib/beam`, `lib/db/hive`, `lib/db/models`, `lib/modules/router`, `lib/modules/setting`, `lib/utils`)
- [ ] T002 Add dependencies to `pubspec.yaml` (`flutter_riverpod`, `go_router`, `hive`, `hive_flutter`, `dio`, `json_annotation`, `json_serializable`, `build_runner`, `freezed_annotation`, `freezed`)
- [ ] T003 [P] Configure `analysis_options.yaml` for strict linting

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T004 Setup Hive initialization and register adapters in `lib/db/hive/hive_init.dart`
- [ ] T005 [P] Create Dio client wrapper with interceptors in `lib/utils/http_client.dart`
- [ ] T006 [P] Create `RouterItem` model in `lib/db/models/router_item.dart`
- [ ] T007 [P] Create `AppSettingItem` model in `lib/db/models/app_setting_item.dart`
- [ ] T008 [P] Create Hierarchy models (`MiddlewareItem`, `PageItem`) in `lib/db/models/hierarchy_items.dart`
- [ ] T009 [P] Create Transient models (`CurrentRouter`, `CurrentMiddleware`, `CurrentPage`) in `lib/db/models/transient_models.dart`
- [ ] T010 Run `build_runner` to generate Hive adapters and JSON serialization
- [ ] T011 Implement basic GoRouter configuration with ShellRoute for main layout in `lib/router.dart`
- [ ] T012 Implement `AppTheme` definition and provider in `lib/utils/theme.dart`
- [ ] T013 Implement `ResponsiveLayout` wrapper (Portrait/Landscape logic) in `lib/beam/responsive_layout.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Add and Connect to Routers (Priority: P1) 🎯 MVP

**Goal**: Manage router profiles in Settings and connect to a device.

**Independent Test**: User can add a router profile, see it in the list, and successfully "connect" (simulate auth) to it.

### Implementation for User Story 1

- [ ] T014a [US1] Create unit tests for `RouterRepository` in `test/unit/router_repository_test.dart`
- [ ] T014b [US1] Create unit tests for `OpenWrtAuthService` in `test/unit/openwrt_auth_service_test.dart`
- [ ] T014 [US1] Implement `RouterRepository` (Hive CRUD operations) in `lib/modules/router/router_repository.dart`
- [ ] T015 [US1] Implement `OpenWrtAuthService` (uBus login) in `lib/utils/openwrt_auth_service.dart`
- [ ] T016 [US1] Create Settings Module Root Middleware UI in `lib/modules/setting/middlewares/setting_root_middleware.dart`
- [ ] T017 [US1] Create Router Management Page (List View) in `lib/modules/setting/pages/router_management_page.dart`
- [ ] T018 [US1] Implement Add/Edit Router Dialog with validation in `lib/modules/setting/items/router_dialog.dart`
- [ ] T019 [US1] Implement "Connect" logic (Auth Service call -> State Update) in `lib/modules/router/router_controller.dart`
- [ ] T020 [US1] Implement Navigation Logic: Jump to Router Module upon success in `lib/router.dart` (update redirection)

**Checkpoint**: User can store router details and authenticate.
**Tips**: Using mock data at this stage because the utils functions haven't been implemented.

---

## Phase 4: User Story 2 - View Router CPU Usage (Priority: P1)

**Goal**: Navigate the Router Module hierarchy and view real-time CPU data.

**Independent Test**: Connected user can navigate Router->Status->Hardware->Internal Device and see CPU widget updating.

### Implementation for User Story 2

- [ ] T021a [US2] Create unit tests for `SystemInfoService` (mocking uBus responses) in `test/unit/system_info_service_test.dart`
- [ ] T021 [US2] Implement `SystemInfoService` (uBus system.info/board) in `lib/utils/system_service.dart`
- [ ] T022 [US2] Implement `MiddlewareView` (Generic rendering of MiddlewareItem) in `lib/modules/router/middleware/middleware_view.dart`
- [ ] T023 [US2] Implement `PageView` (Generic rendering of PageItem) in `lib/modules/router/page/page_view.dart`
- [ ] T024 [US2] Implement `CpuUsageWidget` (Material 3 Card) in `lib/modules/router/widgets/cpu_usage_widget.dart`
- [ ] T025 [US2] Implement "Seeding" logic to create default hierarchy (Router->Status->Hardware->Internal Device) in `lib/utils/hierarchy_seeder.dart`
- [ ] T026 [US2] Implement Navigation Rail / Drawer logic for switching between Router/Setting modules in `lib/main_scaffold.dart`
- [ ] T027 [US2] Integrate `CpuUsageWidget` into the "Internal Device" Page configuration by editing Hive database.

**Checkpoint**: Router Module is functional with hierarchy navigation and live widgets.

---

## Phase 4b: User Story 2b - Dashboard Customization (Priority: P1)

**Goal**: User can enter "Edit Mode" to reorder widgets or modify the layout.

- [ ] T027a [US2b] Implement "Edit Mode" toggle state in `lib/modules/router/router_controller.dart`
- [ ] T027b [US2b] Implement Drag-and-Drop reordering logic for `PageView` widgets in `lib/modules/router/page/page_view.dart`
- [ ] T027c [US2b] Implement "Add Widget" bottom sheet/dialog in `lib/modules/router/widgets/add_widget_dialog.dart`
- [ ] T027d [US2b] Persist layout changes to Hive (`PageItem.widgetChildren`) in `lib/db/models/hierarchy_items.dart`

---

## Phase 4c: User Story 2c - View Router Memory & Network Usage (Priority: P1)

**Goal**: Extend router monitoring to include memory and network traffic.

- [ ] T027e [US2c] Implement `MemoryUsageWidget` (Material 3 Card) in `lib/modules/router/widgets/memory_usage_widget.dart`
- [ ] T027f [US2c] Implement `NetworkTrafficWidget` (Material 3 Card) in `lib/modules/router/widgets/network_traffic_widget.dart`
- [ ] T027g [US2c] Integrate `MemoryUsageWidget` and `NetworkTrafficWidget` into the "Internal Device" Page configuration by editing Hive database.

---

## Phase 5: User Story 3 - Change App Theme (Priority: P2)

**Goal**: User can switch between Light/Dark/System themes.

**Independent Test**: Changing theme in Settings immediately reflects across the app.

### Implementation for User Story 3

- [ ] T035a [US3] Create unit tests for `ThemeRepository` in `test/unit/theme_repository_test.dart`
- [ ] T035b [US3] Create unit tests for `ThemeNotifier` in `test/unit/theme_notifier_test.dart`
- [ ] T035 [US3] Create `ThemeRepository` (Hive persistence) in `lib/modules/setting/theme_repository.dart`
- [ ] T036 [US3] Implement `ThemeNotifier` (State Management) in `lib/modules/setting/theme_provider.dart`
- [ ] T037 [US3] Create Theme Selection Page in `lib/modules/setting/pages/theme_page.dart`
- [ ] T038 [US3] Integrate Theme Page into Settings Middleware hierarchy (update seeder/config)
- [ ] T039 [US3] Update `MaterialApp` to listen to `ThemeNotifier` in `lib/main.dart`

**Checkpoint**: Theme personalization is functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T040 Refine Portrait/Landscape transitions (ensure smooth state preservation)
- [ ] T041 Implement "Back Button" long-press menu (Path History) in `lib/beam/history_menu.dart`
- [ ] T042 Add error handling/snackbars for network failures (Global)
- [ ] T043 Optimize Hive read performance (Lazy boxes if needed)
- [ ] T044 Verify accessibility (semantics) for Navigation Rail and Widgets

---

## Dependencies & Execution Order

1. **Setup & Foundation**: T001-T013 MUST be done first.
2. **US1 (Add/Connect)**: Depends on Foundation. Enables actual app usage.
3. **US2 (View CPU)**: Depends on US1 (need a connected router to show data, using mock data at this stage).
4. **US2b (Dashboard Customization)**: Depends on US2 (needs generic Middleware/PageView to customize).
5. **US2c (View Memory & Network)**: Depends on US2 (extends monitoring capability).
6. **US3 (Theme)**: Technically independent of US1/US2/US2b/US2c, but logically fits after core functionality.

## Implementation Strategy

1. **Build the Shell**: Get the App to run with Navigation Rail (T001-T013).
2. **Enable Data**: Allow adding a router (US1).
3. **Show CPU Data**: Build the dynamic UI engine and display CPU (US2).
4. **Customize Layout**: Implement dashboard customization (US2b).
5. **Show More Data**: Extend monitoring with Memory and Network (US2c).
6. **Style**: Allow customization (US3).