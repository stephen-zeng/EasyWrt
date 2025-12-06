# Research & Architecture Decisions: EasyWrt Core Features

**Feature**: EasyWrt Core Features
**Date**: 2025-12-05

## 1. Model Context Protocol (MCP) Implementation

**Problem**: How to enable external AI agents to control the app and query device status as requested in FR-007.

**Options Considered**:
1. **Stdio Transport**: Standard for local CLI tools. Harder to integrate with a GUI app unless launched specifically.
2. **SSE (Server-Sent Events) Transport**: Standard for remote/web-based agents. Allows the app to listen on a local port.

**Decision**: **SSE Transport via `shelf` package**.
**Rationale**:
- The app is a long-running GUI process, not a CLI tool spawned by the agent.
- SSE over a local HTTP port allows any MCP-compliant client (Claude Desktop, local scripts) to connect to the running app.
- `shelf` is a standard Dart web server package.

## 2. Biometric Authentication on Desktop

**Problem**: Secure access (FR-006) on Windows, macOS, and Linux.

**Options Considered**:
1. **`local_auth` package**: The official Flutter plugin.
2. **Platform-specific FFI**: Custom C++ bindings.

**Decision**: **`local_auth` package**.
**Rationale**:
- Supports Android, iOS, macOS, and Windows (Linux support is partial/community-dependent, but acceptable for now).
- Standard community choice.

## 3. Customizable "Path of Control" (Menu System)

**Problem**: Users need to customize how they navigate to widgets (FR-008).

**Options Considered**:
1. **Hardcoded Routes**: Standard Flutter routing. Not customizable.
2. **Data-Driven Menu Tree**: Store menu structure in Hive. Render navigation dynamically.

**Decision**: **Data-Driven Menu Tree (Hive Models)**.
**Rationale**:
- Allows complete user customization of the hierarchy.
- Can serialize/deserialize easily to JSON/Hive.
- Supports deep nesting (Groups -> Subgroups -> Widgets).

## 4. Split View Architecture

**Problem**: Switch between Single and Split view based on width (FR-003).

**Options Considered**:
1. **`LayoutBuilder` + `Row`/`Stack`**: Manual switching.
2. **`flutter_adaptive_scaffold`**: Google's material adaptive implementation.

**Decision**: **`LayoutBuilder` + Custom Implementation**.
**Rationale**:
- Gives precise control over the "Middleware" (Left) vs "Function" (Right) split described in spec.
- `flutter_adaptive_scaffold` might be too opinionated for the specific "Middleware/Final Widget" terminology.
