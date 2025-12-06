# Implementation Plan: EasyWrt Core Features

**Branch**: `001-easywrt-core-features` | **Date**: 2025-12-05 | **Spec**: [.specify/features/001-easywrt-core-features/spec.md](spec.md)
**Input**: Feature specification from `/specs/001-easywrt-core-features/spec.md`

## Summary

Implement core features for EasyWrt including Multi-Device Management (Hive storage), Responsive Split-View Dashboard (LayoutBuilder), Biometric Authentication (local_auth), and Model Context Protocol (MCP) support (shelf server).

## Technical Context

**Language/Version**: Dart 3.0+ / Flutter 3.10+
**Primary Dependencies**: 
- `hive`, `hive_flutter` (Storage)
- `provider` (State Management)
- `flutter_modular` (Routing/DI)
- `local_auth` (Biometrics)
- `shelf`, `shelf_router` (MCP Server)
- `http` (OpenWrt RPC)
**Storage**: Hive (NoSQL local DB)
**Testing**: `flutter_test`, `mockito`
**Target Platform**: macOS, Windows, Linux (Desktop), Android/iOS (Mobile)
**Project Type**: Flutter Application (Desktop/Mobile)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

*   [x] **I. Code Quality**: Plan uses standard packages and modular architecture.
*   [x] **II. Rigorous Testing**: Unit tests for Hive models and MCP logic; Widget tests for Layout.
*   [x] **III. Consistent User Experience (UX)**: Responsive design ensures consistency across form factors.
*   [x] **IV. Performance by Design**: Local storage is fast; MCP server runs asynchronously.
*   [x] **V. Maintainability and Modularity**: Features are separated into providers and services.

## Project Structure

### Documentation (this feature)

```text
.specify/features/001-easywrt-core-features/
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
├── model/
│   ├── device_profile.dart       # Hive model
│   └── menu_config.dart          # Hive model
├── page/
│   ├── dashboard/                # New split-view dashboard
│   │   ├── dashboard_page.dart
│   │   ├── sidebar_widget.dart
│   │   └── content_widget.dart
│   └── settings/
│       └── auth_settings.dart    # Bio-auth toggle
├── services/
│   ├── mcp/                      # New MCP Server module
│   │   ├── mcp_server.dart
│   │   └── mcp_tools.dart
│   └── auth/
│       └── bio_auth_service.dart # Biometric wrapper
└── provider/
    ├── device_provider.dart
    └── navigation_provider.dart
```

**Structure Decision**: Option 1 (Single project) - Standard Flutter structure.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Custom Menu Tree | User requirement (FR-008) | Hardcoded routes don't allow user customization. |
| Embedded HTTP Server | User requirement (FR-007) | No other way to expose MCP to external agents locally. |
