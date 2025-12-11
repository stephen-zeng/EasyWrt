# OpenWRT uBus API Contract

**Protocol**: JSON-RPC over HTTP POST
**Endpoint**: `http(s)://{host}:{port}/ubus`

## Standard Request Format

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "call",
  "params": [
    "{session_id}",
    "{namespace}",
    "{method}",
    { "param1": "value" }
  ]
}
```

## Core Methods

### 1. Authentication
**Namespace**: `session`
**Method**: `login`
**Params**:
```json
{
  "username": "root",
  "password": "..."
}
```
**Response**:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    0,
    {
      "ubus_rpc_session": "8347f892...",
      "timeout": 300,
      "expires": 300,
      "acls": { ... }
    }
  ]
}
```

### 2. System Board Info
**Namespace**: `system`
**Method**: `board`
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "kernel": "5.4.188",
      "hostname": "OpenWrt",
      "system": "ARMv8 Processor",
      "model": "Raspberry Pi 4 Model B",
      "release": {
        "distribution": "OpenWrt",
        "version": "22.03.0"
      }
    }
  ]
}
```

### 3. System Info (Load/RAM)
**Namespace**: `system`
**Method**: `info`
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "uptime": 12345,
      "load": [ 0.12, 0.05, 0.01 ],
      "memory": {
        "total": 1024000,
        "free": 512000,
        "shared": 0,
        "buffered": 10240
      }
    }
  ]
}
```

## Error Handling

Standard JSON-RPC errors or uBus return codes (first element of `result` array).
- `0`: Success
- `6`: Permission denied
- `10`: Invalid data
