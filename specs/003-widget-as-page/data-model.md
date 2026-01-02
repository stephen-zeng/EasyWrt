# Data Model: Widget as Page

**Feature**: `003-widget-as-page`

## Overview

This feature does not introduce new database entities but extends the usage of existing `MiddlewareItem` to support widget references.

## Entities

### MiddlewareItem (Update)

Existing entity in `lib/db/models/hierarchy_items.dart`.

- **Field**: `pageChildren` (List<String>)
  - **Usage**: Can now contain IDs with the format `widget_{typeKey}` in addition to standard page IDs.
  - **Validation**: The system must treat IDs starting with `widget_` as virtual page references that resolve to a `WidgetPage` instead of a `PageItem`.

### WidgetPage (Virtual)

Conceptually represents the full-page view of a widget.

- **ID Format**: `widget_{typeKey}`
  - `typeKey`: The unique identifier of the widget type (e.g., `cpu_usage`, `network_status`).
- **Resolution**:
  - The ID is parsed to extract `typeKey`.
  - `typeKey` is used to look up the `BaseWidget` instance from `WidgetCatalogProvider`.
  - The `BaseWidget` is rendered in "Page Mode" (Size 0x0).

## Persistence

- **Hive Box**: `middlewares`
  - No schema migration required.
  - Existing `List<String>` fields accept the new ID format.

## State Management

- **Scope**: Shared state between Dashboard Widget and WidgetPage.
- **Mechanism**: `ref.watch(provider)` within `BaseWidget`.
- **Parameters**: passed via URL query parameters, accessible in `BaseWidget.renderPage` if needed (requires updated signature or accessing context/GoRouter state, though `BaseWidget` signature changes are minimized by keeping standard arguments and relying on Providers/Context).
