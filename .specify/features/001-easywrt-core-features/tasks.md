# Tasks: EasyWrt Core Features

**Input**: Design documents from `.specify/features/001-easywrt-core-features/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

Tests: Per the constitution's "Rigorous Testing" principle, all new features must be accompanied by tests.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Paths are relative to the project root.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Add Flutter dependencies to `pubspec.yaml`: `hive`, `hive_flutter`, `provider`, `flutter_modular`, `local_auth`, `shelf`, `shelf_router`, `http`.
- [x] T002 Initialize Hive in `lib/main.dart`.
- [x] T003 Configure `flutter_modular` in `lib/main.dart` and `lib/base/module.dart`.
- [x] T004 Review and enforce linting rules in `analysis_options.yaml`.
- [x] T005 Create base utility functions in `lib/utils/utils.dart` if not already present.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T006 Implement `OpenWrtClient` for HTTP/RPC communication in `lib/utils/wrt.dart`.
- [x] T007 Implement global `ThemeProvider` for consistent theming in `lib/bean/theme/`.
- [x] T008 Develop common UI widgets (e.g., `InfoWidget` as started, loading indicators, error displays) in `lib/widget/index.dart` and `lib/widget/infoWidget.dart`.
- [x] T009 [P] Configure basic logging for all modules using `lib/utils/logger.dart`.
- [x] T010 [P] Define `AppModule` and core routes in `lib/app_module.dart` (new file) and `lib/app_widget.dart` (new file).
- [x] T011 [P] Create mock implementation for `OpenWrtClient` for testing without a real device in `test/mock_wrt_client.dart` (new file).

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Multi-Device Management (P1) 🎯 MVP

**Goal**: Users can manage a list of multiple OpenWrt devices, adding new ones with credentials, and switching the active device to control different routers without re-entering details.

**Independent Test**: Can be tested by adding 2 mock devices and verifying the app can switch context between them, displaying different (mock) status data for each.

- [x] T012 [P] [US1] Create `DeviceProfile` Hive model in `lib/model/device_profile.dart` (new file).
- [x] T013 [P] [US1] Generate Hive adapter for `DeviceProfile` in `lib/model/device_profile.g.dart`.
- [x] T014 [US1] Implement `DeviceRepository` for Hive storage in `lib/database/device.dart`.
- [x] T015 [US1] Implement `DeviceProvider` for active device state management in `lib/provider/device_provider.dart` (new file).
- [x] T016 [US1] Create Device List UI page in `lib/page/device/device_list_page.dart` (new file).
- [x] T017 [US1] Create Add/Edit Device UI page in `lib/page/device/device_edit_page.dart` (new file).
- [x] T018 [US1] Implement device switching logic within `DeviceProvider` and integrate with `OpenWrtClient`.
- [x] T019 [US1] Add basic unit tests for `DeviceRepository` in `test/device_repository_test.dart` (new file).

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - Responsive Dashboard Layout (P1)

**Goal**: The application UI adapts to screen orientation. In landscape, it displays a side-by-side view (Middleware/Nav on left, Content on right). In portrait, it shows a single view with navigation to content.

**Independent Test**: Can be tested by resizing the window (Desktop) or rotating the device (Mobile/Sim) and verifying the widget tree structure changes from Row (Split) to Navigator/Stack (Single).

### Implementation for User Story 2

- [x] T020 [P] [US2] Implement `LayoutBuilder` based responsive layout logic in `lib/page/dashboard/dashboard_page.dart` (new file).
- [x] T021 [P] [US2] Create `MiddlewarePage` (left pane/navigation) in `lib/page/dashboard/middleware_page.dart` (new file).
- [x] T022 [P] [US2] Create `FunctionPage` (right pane/content display) in `lib/page/dashboard/function_page.dart` (new file).
- [x] T023 [US2] Implement navigation between `MiddlewarePage` and `FunctionPage` in Portrait mode using `flutter_modular` routes.
- [x] T024 [US2] Add widget tests for `DashboardPage` responsive behavior in `test/dashboard_page_test.dart` (new file).

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - Bio-Authentication Integration (P2)

**Goal**: Users can secure access to the app or specific high-risk actions using their device's biometric authentication (Fingerprint, FaceID).

**Independent Test**: Can be tested using platform simulators (FaceID/TouchID) to verify prompt appears and grants/denies access based on match.

### Implementation for User Story 3

- [x] T025 [P] [US3] Create `AppSettings` Hive model in `lib/model/app_settings.dart` (new file).
- [x] T026 [P] [US3] Generate Hive adapter for `AppSettings` in `lib/model/app_settings.g.dart`.
- [x] T027 [US3] Implement `BioAuthService` using `local_auth` package in `lib/services/auth/bio_auth_service.dart` (new file).
- [x] T028 [US3] Implement `AppSettingsProvider` for global app settings in `lib/provider/app_settings_provider.dart` (new file).
- [x] T029 [US3] Create Bio-Auth settings UI in `lib/page/settings/auth_settings_page.dart` (new file).
- [x] T030 [US3] Integrate bio-auth prompt on app launch using `MainApp` widget or root module guard.
- [x] T031 [US3] Add unit tests for `BioAuthService` in `test/bio_auth_service_test.dart` (new file).

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: User Story 4 - Advanced Control & MCP Support (P3)

**Goal**: Users can configure how the app controls the device and utilize "MCP" capabilities.

**Independent Test**: Verifying configuration changes alter the API request paths or enable the MCP interface.

### Implementation for User Story 4

- [x] T032 [P] [US4] Create `MenuConfig` Hive model in `lib/model/menu_config.dart` (new file).
- [x] T033 [P] [US4] Generate Hive adapter for `MenuConfig` in `lib/model/menu_config.g.dart`.
- [x] T034 [US4] Implement `NavigationProvider` to manage the data-driven menu tree in `lib/provider/navigation_provider.dart` (new file).
- [x] T035 [US4] Create Menu Editor UI for "Path of Control" in `lib/page/settings/menu_editor_page.dart` (new file).
- [x] T036 [US4] Implement `McpServer` using `shelf` and `shelf_router` in `lib/services/mcp/mcp_server.dart` (new file).
- [x] T037 [US4] Implement MCP tools (`list_devices`, `get_device_info`, `reboot_device`) in `lib/services/mcp/mcp_tools.dart` (new file).
- [x] T038 [US4] Integrate MCP server start/stop based on `AppSettings` and `AppSettingsProvider`.
- [x] T039 [US4] Add unit tests for `McpServer` and `McpTools` in `test/mcp_server_test.dart` (new file).

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [x] T040 [P] Implement comprehensive error handling and user feedback mechanisms across the app.
- [x] T041 [P] Review UI/UX for consistency and accessibility.
- [x] T042 [P] Performance profiling and optimization for long-running operations.
- [x] T043 [P] Update `quickstart.md` with detailed instructions for running and testing all features.
- [x] T044 Final review of code for quality, documentation, and adherence to constitution.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable
- **User Story 4 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2/US3 but should be independently testable

### Within Each User Story

- Tests MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- Tasks T009, T010, T011 in Foundational phase can run in parallel.
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- Within User Story 1: T012, T013
- Within User Story 2: T020, T021, T022
- Within User Story 3: T025, T026
- Within User Story 4: T032, T033
- Phase 7 tasks T040, T041, T042, T043, T044 can run in parallel.

---

## Parallel Example: User Story 1

```bash
# Launch all models for User Story 1 together:
- [ ] T012 [P] [US1] Create `DeviceProfile` Hive model in `lib/model/device_profile.dart` (new file).
- [ ] T013 [P] [US1] Generate Hive adapter for `DeviceProfile` in `lib/model/device_profile.g.dart`.

# Launch all Foundational tests together:
- [x] T009 [P] Configure basic logging for all modules using `lib/utils/logger.dart`.
- [ ] T010 [P] Define `AppModule` and core routes in `lib/app_module.dart` (new file) and `lib/app_widget.dart` (new file).
- [ ] T011 [P] Create mock implementation for `OpenWrtClient` for testing without a real device in `test/mock_wrt_client.dart` (new file).
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Add User Story 4 → Test independently → Deploy/Demo
6. Complete Polish Phase → Final Release

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (Multi-Device Management)
   - Developer B: User Story 2 (Responsive Dashboard Layout)
   - Developer C: User Story 3 (Bio-Authentication)
   - Developer D: User Story 4 (Advanced Control & MCP)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
