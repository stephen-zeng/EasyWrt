# OpenWRT uBus API Contract

**Protocol**: JSON-RPC over HTTP POST
**Endpoint**: `http(s)://{host}:{port}/cgi-bin/luci/admin/ubus`

## Standard Request Format

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "call",
  "params": [
    "{sysauth_token}",
    "{namespace}",
    "{method}",
    { "param1": "value" }
  ]
}
```

## Authentication

**Type**: Form-based (Standard LuCI Login)
**Endpoint**: `http(s)://{host}:{port}/cgi-bin/luci/`
**Method**: POST
**Content-Type**: `application/x-www-form-urlencoded`
**Body**: `luci_username={username}&luci_password={password}`

**Response**:
- **Success**: HTTP 200/302. The auth token is returned in the `sysauth` cookie (e.g., `sysauth=2f9a...; path=/cgi-bin/luci`).
- **Failure**: HTTP 403 or no `sysauth` cookie.

---

## System Methods

### 1. System Board Info
**Namespace**: `system`
**Method**: `board`
**Params**: `{}`
**Response**:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": [
    0,
    {
      "kernel": "5.15.134",
      "hostname": "OpenWrt",
      "system": "ARMv8 Processor",
      "model": "Generic",
      "board_name": "mock-router-x",
      "release": {
        "distribution": "OpenWrt",
        "version": "23.05.0",
        "revision": "r23497-6637af95aa",
        "target": "mock/generic",
        "description": "OpenWrt 23.05.0 Mock"
      }
    }
  ]
}
```

### 2. System Info
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
      "load": [ 1000, 2000, 1500 ],
      "memory": {
        "total": 268435456,
        "free": 134217728,
        "shared": 1048576,
        "buffered": 10485760,
        "cached": 20971520,
        "available": 150000000
      },
      "localtime": 1678900000
    }
  ]
}
```

### 3. System Reboot
**Namespace**: `system`
**Method**: `reboot`
**Params**: `{}`
**Response**:
```json
{
  "result": [ 0 ]
}
```

### 4. System Execute
**Namespace**: `system`
**Method**: `exec`
**Params**:
```json
{
  "command": "wifi reload"
}
```
**Response**:
```json
{
  "result": [
    0,
    {
      "code": 0,
      "stdout": "",
      "stderr": ""
    }
  ]
}
```

---

## Network & Interface Methods

### 5. Network Interface Dump
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
          "device": "eth0",
          "proto": "dhcp",
          "ipv4-address": [
            { "address": "100.64.0.123", "mask": 24 }
          ],
          "route": [ ... ]
        },
        ...
      ]
    }
  ]
}
```

### 6. Network Device Stats (Realtime)
**Namespace**: `network.device` (or `luci-rpc` alias)
**Method**: `getNetworkDevices` (or `device` for direct ubus)
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "eth0": {
        "device": "eth0",
        "up": true,
        "stats": {
          "rx_bytes": 1234567890,
          "tx_bytes": 987654321,
          "rx_packets": 12345,
          "tx_packets": 9876
        }
      },
      "br-lan": { ... }
    }
  ]
}
```

### 7. Wireless Associated Stations
**Namespace**: `iwinfo`
**Method**: `assoclist`
**Params**:
```json
{
  "device": "wlan0"
}
```
**Response**:
```json
{
  "result": [
    0,
    {
      "results": [
        {
          "mac": "AA:BB:CC:DD:EE:FF",
          "signal": -50,
          "noise": -95,
          "rx_rate": 144000,
          "tx_rate": 72000
        }
      ]
    }
  ]
}
```

---

## Custom & Helper Methods

### 8. Get Wireless Devices
**Namespace**: `luci-rpc`
**Method**: `getWirelessDevices`
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "radio0": {
        "up": true,
        "frequency": 2437,
        "interfaces": [
          {
            "ifname": "wlan0",
            "ssid": "MyWiFi",
            "encryption": "psk2"
          }
        ]
      }
    }
  ]
}
```

### 9. Get DHCP Leases
**Namespace**: `luci-rpc`
**Method**: `getDHCPLeases`
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "dhcp_leases": [
        {
          "macaddr": "aa:bb:cc:11:22:33",
          "ipaddr": "192.168.1.100",
          "hostname": "iPhone",
          "expires": 1678903600
        }
      ]
    }
  ]
}
```

### 10. WireGuard Instances
**Namespace**: `luci.wireguard`
**Method**: `getWgInstances`
**Params**: `{}`
**Response**:
```json
{
  "result": [
    0,
    {
      "wg0": {
        "interface": "wg0",
        "peers": {
          "public_key_...": {
            "endpoint": "1.2.3.4:51820",
            "latest_handshake": 1678900000
          }
        }
      }
    }
  ]
}
```

---

## Configuration Methods (UCI)

### 11. Get UCI Config
**Namespace**: `uci`
**Method**: `get`
**Params**:
```json
{
  "config": "wireless"
}
```
**Response**:
```json
{
  "result": [
    0,
    {
      "values": {
        "radio0": { ".type": "wifi-device", ... },
        "default_radio0": { ".type": "wifi-iface", ... }
      }
    }
  ]
}
```

### 12. Set UCI Config
**Namespace**: `uci`
**Method**: `set`
**Params**:
```json
{
  "config": "wireless",
  "section": "default_radio0",
  "values": {
    "disabled": "0"
  }
}
```
**Response**:
```json
{
  "result": [ 0 ]
}
```

### 13. Commit UCI Config
**Namespace**: `uci`
**Method**: `commit`
**Params**:
```json
{
  "config": "wireless"
}
```
**Response**:
```json
{
  "result": [ 0 ]
}
```

## Error Handling

Standard JSON-RPC errors or uBus return codes (first element of `result` array).
- `0`: Success
- `6`: Permission denied
- `10`: Invalid data