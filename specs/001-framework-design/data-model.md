# Data Model

## Domain Entities

### RouterProfile
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
| `themeColor` | Int (Hex) | No | Custom color for this router's dashboard. |

### AppSettings
*Global application preferences.*

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `themeMode` | Enum | Yes | `system`, `light`, `dark`. |
| `language` | String | No | Locale code (e.g., 'en', 'zh'). |

### RouterStatus (Transient)
*Real-time status fetched from the router. Not persisted in Hive.*

| Field | Type | Description |
|-------|------|-------------|
| `cpuUsage` | Double | Percentage (0-100). |
| `memoryTotal` | Int | Total RAM in bytes. |
| `memoryFree` | Int | Free RAM in bytes. |
| `uptime` | Duration | Device uptime. |
| `loadAverage` | List<Double> | [1min, 5min, 15min] load. |

## Hive Schemas

### Box: `router_profiles`
- Key: `id` (String)
- Value: `RouterProfile` object (HiveType)

### Box: `app_settings`
- Key: "settings" (Constant)
- Value: `AppSettings` object (HiveType)
