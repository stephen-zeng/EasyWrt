# Data Model: EasyWrt Core Features

## Hive Models

### 1. DeviceProfile
Stores connection information for a single OpenWrt device.

| Field | Type | Description |
|-------|------|-------------|
| `uuid` | `String` | Unique ID (UUID v4) |
| `name` | `String` | User-friendly display name |
| `hostname` | `String` | IP address or domain name |
| `port` | `int` | Port (default 80/443) |
| `protocol` | `String` | "http" or "https" |
| `username` | `String` | Login username (default "root") |
| `password` | `String` | **Encrypted** password |
| `rootPath` | `String` | Base RPC path (default "/cgi-bin/luci/rpc") |

### 2. MenuConfig
Stores the customized navigation structure.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | Unique ID |
| `label` | `String` | Display text |
| `type` | `String` | "group", "middleware", or "function" |
| `targetId` | `String?` | ID of the widget/function to load (if type != group) |
| `icon` | `String?` | Icon name/code |
| `children` | `List<MenuConfig>` | Recursive list of sub-items |

### 3. AppSettings
Global application preferences.

| Field | Type | Description |
|-------|------|-------------|
| `themeMode` | `String` | "system", "light", "dark" |
| `bioAuthEnabled` | `bool` | Whether biometric auth is required at launch |
| `mcpEnabled` | `bool` | Whether MCP server is active |
| `mcpPort` | `int` | Local port for MCP server (default 3000) |

## Runtime State (Provider)

### DeviceProvider
- `activeDevice`: `DeviceProfile?`
- `connectionStatus`: `enum { disconnected, connecting, connected, error }`
- `devices`: `List<DeviceProfile>`

### NavigationProvider
- `menuTree`: `List<MenuConfig>` (Loaded from Hive or default)
- `selectedMiddleware`: `MenuConfig?` (Active left pane item)
- `selectedFunction`: `MenuConfig?` (Active right pane item)
