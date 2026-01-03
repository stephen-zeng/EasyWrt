# OpenWRT uBus API Contract for Router Admin Panel

**Protocol**: JSON-RPC over HTTP POST
**Endpoint**: `http://{router_ip}/ubus`
**Content-Type**: `application/json`

> **Note**: All requests must include a valid `session_id` obtained from the Authentication step (except the login request itself). The session ID is passed as the **first argument** in the `params` array.

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
    { "param_key": "param_value" }
  ]
}
```

---

## 1. Authentication (Global)

### Login
**Namespace**: `session`
**Method**: `login`
**Params**:
```json
{
  "username": "root",
  "password": "your_password"
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
      "ubus_rpc_session": "86202f9a123...",
      "timeout": 300,
      "expires": 300,
      "acls": { ... }
    }
  ]
}
```
*Use `ubus_rpc_session` as the first parameter for all subsequent calls.*

---

## 2. Status Monitor

### System Status (Software)
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
      "load": [ 65536, 32768, 16384 ],
      "memory": {
        "total": 512000000,
        "free": 200000000,
        "shared": 0,
        "buffered": 1024000
      }
    }
  ]
}
```

### Hardware Info (Internal/External Device)
**Namespace**: `system`
**Method**: `board`
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "kernel": "5.15.x",
      "hostname": "OpenWrt",
      "model": "Raspberry Pi 4 Model B",
      "board_name": "bcm2711"
    }
  ]
}
```

### Network Speed Status (Real-time Traffic)
*Note: Client must poll this endpoint (e.g., every 1s) and calculate (NewBytes - OldBytes) / TimeDelta.*
**Namespace**: `network.device`
**Method**: `status`
**Params**:
```json
{
  "name": "eth0"
}
```
**Response**:
```json
{
  "result": [
    0,
    {
      "statistics": {
        "rx_bytes": 123456789,
        "tx_bytes": 987654321
      },
      "up": true
    }
  ]
}
```

### Wireless Status & Channel Scan
**Namespace**: `iwinfo`
**Method**: `info` (Status) / `scan` (Channel Scan)
**Params**:
```json
{
  "device": "wlan0"
}
```
**Response (Scan)**:
```json
{
  "result": [
    0,
    {
      "results": [
        {
          "ssid": "NeighborWiFi",
          "channel": 6,
          "signal": -70,
          "quality": 40,
          "encryption": { "enabled": true }
        }
      ]
    }
  ]
}
```

### Log View
**Namespace**: `file` (Requires `rpcd-mod-file`)
**Method**: `read`
**Params**:
```json
{
  "path": "/var/log/messages",
  "limit": 1000
}
```
*Alternatively, use `log` namespace with `read` method if available.*

---

## 3. System Configuration

### Read Configuration (General/Time/Security)
**Namespace**: `uci`
**Method**: `get`
**Params**:
```json
{
  "config": "system" 
}
```
*Change "config" to "dropbear" for SSH, "uhttpd" for HTTPS/Luci settings.*

### Write Configuration
**Namespace**: `uci`
**Method**: `set`
**Params**:
```json
{
  "config": "system",
  "section": "ntp",
  "values": {
    "server": ["0.openwrt.pool.ntp.org"]
  }
}
```

### Apply Configuration
**Namespace**: `uci`
**Method**: `commit`
**Params**: `{"config": "system"}`

### Security: Change Password (Advanced)
**Namespace**: `file`
**Method**: `exec`
**Params**:
```json
{
  "command": "/bin/sh",
  "params": ["-c", "echo -e 'newpass\\nnewpass' | passwd root"]
}
```

---

## 4. Application Management 

### Service Control (Start/Stop OpenClash, SmartDNS, etc.)
**Namespace**: `service`
**Method**: `list` (Check status) / `action` (Control)
**Params (Action)**:
```json
{
  "name": "openclash",
  "action": "restart"
}
```

### Read App Config
**Namespace**: `uci`
**Method**: `get`
**Params**:
```json
{
  "config": "openclash" 
}
```
*Replace "openclash" with "smartdns", "ddns", etc.*

### WebSSH (TTYD)
*WebSSH requires a WebSocket connection to a running `ttyd` process. ubus is used to configure/start the process.*
**Namespace**: `uci`
**Method**: `set`
**Params**:
```json
{
  "config": "ttyd",
  "section": "@ttyd[0]",
  "values": { "port": "7681" }
}
```

---

## 5. Network Management 

### Network Interfaces (LAN/WAN/IPs)
**Namespace**: `network.interface`
**Method**: `dump`
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "interface": [
        {
          "interface": "wan",
          "up": true,
          "ipv4-address": [ { "address": "192.168.10.2", "mask": 24 } ],
          "device": "eth0"
        }
      ]
    }
  ]
}
```

### DHCP Leases (Connected Devices)
**Namespace**: `file`
**Method**: `read`
**Params**:
```json
{
  "path": "/tmp/dhcp.leases"
}
```
*Parses the lease file to show connected client List.*

### Firewall Rules
**Namespace**: `uci`
**Method**: `get`
**Params**: `{"config": "firewall"}`

---

## 6. App Data & Import/Export

### Custom Settings (Frontend Preferences)
*Since ubus is stateless, store frontend preferences (Theme, Layout) in a custom UCI file.*
**Namespace**: `uci`
**Method**: `get`
**Params**:
```json
{
  "config": "custom_dashboard"
}
```

### Config Export (Backup)
**Namespace**: `file`
**Method**: `read`
**Params**:
```json
{
  "path": "/etc/config/network"
}
```
*Loop through critical config files (`network`, `wireless`, `system`, `dhcp`) to create a backup JSON.*

### System Reboot
**Namespace**: `system`
**Method**: `reboot`
**Params**: `{}`

---

## Error Codes
The first element of the `result` array indicates the status:
- **0**: Success
- **1**: Invalid command
- **2**: Invalid argument
- **3**: Method not found
- **4**: Entry not found
- **6**: Permission denied (Check `/usr/share/rpcd/acl.d/`)
- **9**: Validation failed