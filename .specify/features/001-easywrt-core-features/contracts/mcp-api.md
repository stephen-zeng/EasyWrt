# MCP Server Tools Contract

The application exposes an MCP Server over SSE. Below are the tools available to connected agents.

## Tools

### `list_devices`
Returns a list of configured devices.

**Input Schema**: `{}`
**Output Schema**:
```json
[
  {
    "uuid": "string",
    "name": "string",
    "hostname": "string",
    "status": "connected|disconnected"
  }
]
```

### `get_device_info`
Gets system information for a specific device (proxies to OpenWrt `system.board` / `system.info`).

**Input Schema**:
```json
{
  "device_uuid": "string"
}
```

### `reboot_device`
Reboots the specified device.

**Input Schema**:
```json
{
  "device_uuid": "string"
}
```
