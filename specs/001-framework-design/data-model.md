# Data Model

## Domain Entities

### RouterItem
*Stores connection and display details for a managed OpenWRT device.*

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String (UUID) | Yes | Unique identifier. |
| `name` | String | Yes | User-friendly display name (e.g., "Home Router"). |
| `host` | String | Yes | IP address or Domain name. |
| `port` | Int | Yes | Port number (default 80 or 443). |
| `username` | String | Yes | Login username (usually "root"). |
| `password` | String | Yes | Login password. |
| `isHttps` | Boolean | Yes | Whether to use SSL/TLS. |

### MiddlewareItem
*Stores information about a middleware.*

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique identifier, format is `{name}_{8 random number}`. |
| `name` | String | Yes | The name of this middleware. |
| `icon` | String | Yes | The icon used by this middleware. |
| `middlewareChildren` | List<String> | Yes | Nullable; stores the IDs of the child middlewares of this middleware. |
| `pageChildren` | List<String> | Yes | Nullable; stores the IDs of the child pages of this middleware. |
| `children` | List<String> | Yes | Nullable; stores the IDs of all child members of this middleware, ordered. |

### PageItem
*Stores information about a page.*

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique identifier, format is `{name}_{8 random number}`. |
| `name` | String | Yes | The name of this page. |
| `icon` | String | Yes | The icon used by this page. |
| `widgetChildren` | List<String> | Yes | Nullable; stores the names of the widgets within this page, ordered. |

### AppSettingItem
*Global application preferences.*

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `themeMode` | Enum | Yes | `system`, `light`, `dark`, `oled`. Default is `system`. |
| `themeColor` | Int (Hex) | Yes | Custom color for the app, default is `green`. |
| `language` | String | Yes | Locale code (e.g., 'en', 'zh'). Default is `zh`. |

### CurrentRouter (Transient, Global)
*Current info of the selected router. Not persisted in Hive. Used by widget to communicate with the router.*
| Field | Type | Description |
|-------|------|-------------|
| `id` | String (UUID) | Unique identifier of the router. |
| `name` | String | User-friendly display name (e.g., "Home Router"). |
| `host` | String | IP address or Domain name. |
| `port` | Int | Port number (default 80 or 443). |
| `username` | String | Login username (usually "root"). |
| `password` | String | Login password. |
| `token` | String | Current Token of this Router |
| `isHttps` | Boolean | Whether to use SSL/TLS. |

### CurrentMiddleware (Transient, Global)
*Information of the currently displayed (or last displayed) Middleware. Not persisted in Hive.*
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Unique identifier of the middleware. |
| `path` | List<String> | The sequence of middlewares the user navigated through to reach the current one; used for path tracking; contains middleware IDs. |
| `name` | String | The name of this middleware. |
| `icon` | String | The icon of this middleware. |
| `middlewareChildren` | List<String> | Yes | Nullable; stores the IDs of the child middlewares of this middleware. |
| `pageChildren` | List<String> | Yes | Nullable; stores the IDs of the child pages of this middleware. |

### CurrentPage (Transient, Global)
*Information of the currently displayed (or last displayed) Page. Not persisted in Hive.*
| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Unique identifier of the page. |
| `path` | List<String> | The sequence of middlewares the user navigated through to reach the current page; used for path tracking; contains middleware IDs. |
| `name` | String | The name of this page. |
| `icon` | String | The icon of this page. |
| `widgetChildren` | List<String> | Yes | Nullable; stores widget information within this page. |

## Hive Schemas

### Box: `routers`
- Key: `id` (String)
- Value: `RouterItem` object (HiveType)

### Box: `middlewares`
- Key: `id` (String)
- Value: `MiddlewareItem` object (HiveType)

### Box: `pages`
- Key: `id` (String)
- Value: `PageItem` object (HiveType)

### Box: `app_settings`
- Key: "default" (Constant)
- Value: `AppSettingItem` object (HiveType)