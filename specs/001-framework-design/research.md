# Research: Framework Design

**Feature**: 001-framework-design

## Unknowns & Clarifications

### 1. State Management Selection
**Context**: The app requires reactive UI updates for router status and complex navigation state.
**Research**: Evaluated Provider, Bloc, and Riverpod.
**Decision**: **Riverpod** (specifically `flutter_riverpod`).
**Rationale**:
- Offers compile-time safety (unlike Provider).
- No build context dependency (easier testing/logic separation).
- Supports async data handling (AsyncValue) natively, which fits the "Network Request -> UI Update" flow perfectly.
**Alternatives**:
- **Bloc**: Too much boilerplate for this scope.
- **Provider**: Older, less safe than Riverpod.

### 2. Navigation & Routing
**Context**: "Middleware" and "Page" hierarchy, plus Deep Linking support implies robust routing. Responsive layout requires split-view logic.
**Research**: Navigator 2.0 complexity vs packages.
**Decision**: **go_router**.
**Rationale**:
- Simplifies Navigator 2.0 API.
- Native support for nested routes (ShellRoute), which is essential for the "Navigation Rail" + "Body" layout described in the Spec.
- Easy redirection logic (guard rails).
**Alternatives**:
- **AutoRoute**: Code generation heavy, steep learning curve.
- **Navigator 1.0**: Insufficient for complex deep linking and state restoration.

### 3. OpenWRT API Communication
**Context**: User specified "mainly POST request". OpenWRT typically uses `uBus` via JSON-RPC.
**Research**: OpenWRT uBus HTTP interface.
**Decision**: **JSON-RPC over HTTP POST**.
**Rationale**:
- Standard OpenWRT management protocol.
- Endpoint: `/ubus`.
- Auth: Session-based via `session` ID in JSON-RPC payload.
**Alternatives**:
- **SSH**: Too complex to manage persistent connections and parse output for a simple dashboard.
- **LuCI web scraping**: Brittle.

### 4. Local Storage Structure
**Context**: Storing router profiles and app settings.
**Research**: SQLite (sqflite) vs NoSQL (Hive).
**Decision**: **Hive**.
**Rationale**:
- Specified by user.
- Extremely fast (Dart native).
- Simple TypeAdapters for storing `RouterProfile` objects.
**Alternatives**:
- **SharedPreferences**: Too primitive for lists of objects.
- **Isar**: Good alternative, but user requested Hive.

## Technology Stack Summary

| Component        | Choice     | Version Constraint |
|------------------|------------|--------------------|
| UI Framework     | Flutter    | Latest Stable      |
| Language         | Dart       | Latest Stable      |
| State Management | Riverpod   | ^2.0.0             |
| Navigation       | go_router  | ^10.0.0            |
| Network          | Dio        | ^5.0.0             |
| Local DB         | Hive       | ^2.2.0             |
| Theme            | Material 3 | Built-in           |
