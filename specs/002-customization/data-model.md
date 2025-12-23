# Data Model: Customization

**Feature**: `002-customization` | **Date**: 2025-12-23

## Entities NOT in the Hive 

### 1. BaseWidget (Abstract Class - Catalog & Implementation)
Abstract base class for all widgets. Metadata is defined directly in concrete subclasses via getters/static constants.
Extends `ConsumerWidget`.

| Property         | Type           | Description                                       |
|:-----------------|:---------------|:--------------------------------------------------|
| `typeKey`        | `String`       | Unique code reference key (e.g., `cpu_usage`).    |
| `name`           | `String`       | Display name (e.g., "CPU Usage").                 |
| `description`    | `String`       | Brief description.                                |
| `iconCode`       | `int`          | Icon code point (mapped to IconData).             |
| `supportedSizes` | `List<String>` | List of supported sizes (e.g., `["1x1", "4x4"]`). |
| `defaultSize`    | `String`       | Default size when added (e.g., `1x1`).            |

## Entities IN the Hive

### 1. PageItem (Existing Entity - Modified)
Represents a leaf node (Page) in the router hierarchy.
**Source**: `lib/db/models/hierarchy_items.dart`

| Field            | Type               | Description                                     | Status                                     |
|:-----------------|:-------------------|:------------------------------------------------|:-------------------------------------------|
| `id`             | `String`           | Unique identifier.                              | Existing                                   |
| `name`           | `String`           | Page title.                                     | Existing                                   |
| `icon`           | `String`           | Icon name/path.                                 | Existing                                   |
| `widgetChildren` | `List<String>?`    | Simple list of widget IDs.                      | Existing (Keep for backward compatibility) |
| `isEditable`     | `bool`             | Whether the user can edit this page.            | **New**                                    |
| `stripes`        | `List<StripeItem>` | Ordered list of stripes (layout configuration). | **New**                                    |

#### 1a. StripeItem (New Value Object)
Represents one horizontal section (stripe) within a page. To be embedded in `PageItem`.

| Field     | Type                   | Description                            |
|:----------|:-----------------------|:---------------------------------------|
| `id`      | `String` (UUID)        | Unique identifier for the stripe.      |
| `widgets` | `List<WidgetInstance>` | List of widgets placed in this stripe. |

#### 1b. WidgetInstance (New Value Object)
Represents a specific instance of a widget placed on the grid. To be embedded in `StripeItem`.

| Field           | Type                   | Description                         |
|:----------------|:-----------------------|:------------------------------------|
| `id`            | `String` (UUID)        | Unique instance ID.                 |
| `widgetTypeKey` | `String`               | Reference to `BaseWidget.typeKey`.  |
| `x`             | `int`                  | Grid column index (0-3).            |
| `y`             | `int`                  | Grid row index.                     |
| `width`         | `int`                  | Grid width (1-4).                   |
| `height`        | `int`                  | Grid height.                        |
| `configuration` | `Map<String, dynamic>` | Instance-specific settings (JSON).  |

### 2. MiddlewareItem (Existing Entity)
Represents a navigation node (Middleware) in the router hierarchy.
**Source**: `lib/db/models/hierarchy_items.dart`

| Field                | Type            | Description                     | Status   |
|:---------------------|:----------------|:--------------------------------|:---------|
| `id`                 | `String`        | Unique identifier.              | Existing |
| `name`               | `String`        | Display label.                  | Existing |
| `icon`               | `String`        | Icon.                           | Existing |
| `middlewareChildren` | `List<String>?` | IDs of child middlewares.       | Existing |
| `pageChildren`       | `List<String>?` | IDs of child pages.             | Existing |
| `children`           | `List<String>?` | Consolidated list of child IDs. | Existing |

### Relationships

- **Page -> Stripe (1:N)**: A page contains multiple stripes (ordered list).
- **StripeItem -> WidgetInstance (1:N)**: A stripe contains multiple widget instances.
- **WidgetInstance -> BaseWidget (N:1)**: An instance refers to a concrete implementation via `widgetTypeKey`.
- **Middleware -> Middleware/Page (1:N)**: A middleware group points to children via `middlewareChildren`, `pageChildren`, or `children`.

### State Management (Riverpod)

- **`widgetCatalogProvider`**: `Provider<List<BaseWidget>>` - Exposes a list of prototype instances for the catalog.
- **`pageLayoutProvider(pageId)`**: `StreamProvider<PageItem>` - Watch a specific page's layout.
- **`editManagerProvider`**: `StateNotifier<EditState>` - Manages temporary edit state.
