# Router (Module)

## Overview (Page)

## Status (Middleware)

### Software (Page)

- OpenWRT Info(Widget)

- Log (Widget)
    - **Tabs**: System Log, Kernel Log
    - **System Log**: Displays system logs with timestamp, daemon, and message.
    - **Kernel Log**: Displays kernel logs (dmesg).
    - **Actions**: Scroll to bottom.

### Hardware (Page)

- Memory Info & Usage(Widget)

- CPU Info & Usage(Widget)

- Disk Info & Usage(Widget)

- Network Card Info (Widget)

- Device Info (Widget)

### Network Status (Middleware)

- Channel Scan (Widget)
    - **Visual**: Graph showing signal strength (-dBm) vs Channels (1-13).
    - **Tabs**: Radio selectors (e.g., 2.4GHz, 5GHz).
    - **List**: Signal, SSID, Channel, Width, Mode, BSSID.
    - **Actions**: Refresh Channel.

- Speed Status (Widget)
    - **Tabs**: Load, Traffic, Wireless, Connections.
    - **Visual**: Real-time traffic graph.
    - **Stats**: Inbound/Outbound (Current, Average, Peak) rates.
    - **Interface Selection**: Buttons for br-lan, eth0, wan, etc.

- Wireless Status (Widget)
    - **Tabs**: Interface/Radio selectors (e.g., wl0-ap0).
    - **Visual**: Graphs for Signal/Noise and Traffic.
    - **Stats**: Signal/Noise (Current, Avg, Peak).

## Setting (Middleware)

### General (Page)

- Info Setting (Widget)
    - **Fields**:
        - Hostname (Input)
        - Description (Input)
        - Notes (Text Area)

- Time Setting (Widget)
    - **Display**: Local Time.
    - **Fields**:
        - Timezone (Dropdown).
        - Candidate NTP Servers (List with Add/Remove).
    - **Options**:
        - Enable NTP Client.
        - Provide NTP Server Service.
        - Use DHCP Advertised Servers.
    - **Actions**: Sync Browser Time, Sync with NTP Server.

- Log Setting (Widget)
    - **Fields**:
        - System Log Buffer Size (Input, kiB).
        - External System Log Server Address (Input).
        - External System Log Server Port (Input).
        - External System Log Server Protocol (Dropdown: UDP/TCP).
        - Write System Log to File (Input path).
        - Log Recording Level (Dropdown).
        - Cron Log Level (Dropdown).

- Performance Setting (Widget)
    - **Section**: CPU Performance Tuning.
    - **Fields**:
        - CPU Governor (Dropdown).
        - Min Idle CPU Frequency (Dropdown).
        - Max Turbo Boost CPU Frequency (Dropdown).
        - CPU Switching Period (Input, ms).
        - CPU Switching Frequency Threshold (Input, %).

### Security (Page)

- SSH Security (Widget)
    - **Section**: Dropbear Instance.
    - **Fields**:
        - Interface (Dropdown/Multi-select).
        - Port (Input).
        - Password Auth (Checkbox).
        - Allow Root Password Login (Checkbox).
        - Gateway Ports (Checkbox).
    - **Section**: SSH Keys.
    - **Fields**: Paste SSH Key (Text Area).
    - **Actions**: Add Instance, Add Key.

- Luci Security (Widget)
    - **Fields**:
        - Router Password (Input).
        - Confirm Password (Input).
    - **Settings**:
        - Redirect to HTTPS (Checkbox).

## Application (Page)

### Manage (Widget)

### Nikki (Widget)

### SmartDNS (Widget)

### DDNS (Widget)

### WebSSH (Widget)

### Dnsmasq (Widget)

## Network (Middleware)

### Network Intertface (Page)

- Network Interface (Widget)
    - **List**: Interfaces (LAN, WAN, etc.) cards.
    - **Card Details**:
        - Icon, Name, Protocol.
        - Uptime, MAC Address.
        - RX/TX Stats.
        - IPv4/IPv6 Addresses.
    - **Actions**: Restart, Stop, Edit, Delete (per interface).
    - **Global Action**: Add New Interface.

- Network Device (Widget)
    - **Table**: Device, Type, MAC Address, MTU.
    - **Actions**: Configure, Cancel Config (per device).
    - **Global Action**: Add Device Configuration.

- Network Global Setting (Widget)
    - **Fields**:
        - IPv6 ULA Prefix (Input).
        - Packet Steering (Checkbox).

### Wireless Network (Page)

- Wireless Interface (Widget)
    - **List**: Radios (e.g., radio0, radio1).
    - **Radio Details**: Chipset, Mode, Channel, Bitrate.
    - **Radio Actions**: Restart, Scan, Add.
    - **Interface Details**: SSID, Mode, BSSID, Encryption, Signal Bar.
    - **Interface Actions**: Disable, Edit, Remove.

- Wireless Device (Widget)
    - **Table**: Connected Stations.
    - **Columns**: Network, MAC Address, Host, Signal/Noise, RX/TX Rate.
    - **Action**: Disconnect.

### Router (Page)

- Static Router (Widget)
    - **Sections**: IPv4, IPv6.
    - **Table**: Interface, Target, Gateway, Metric, Table, Disable.
    - **Action**: Add.

- IP Rule (Widget)
    - **Sections**: IPv4, IPv6.
    - **Table**: Priority, In Interface, Source, Out Interface, Destination, Table, Disable.
    - **Action**: Add.

### FireWall (Page)

- Firewall Setting (Widget)
    - **General Settings**:
        - Enable SYN-flood protection (Checkbox).
        - Drop invalid packets (Checkbox).
        - Enable FullCone NAT (Checkbox).
        - Enable FullCone NAT6 (Checkbox).
        - Default Policies (Input/Output/Forward) -> Accept/Reject/Drop.
    - **Zones**:
        - Table: Zone, Forwardings, Input, Output, Forward, Masquerading.
        - Actions: Edit, Delete, Add.
    - **Communication Rules**:
        - Table: Name, Match Rule, Action, Enable.
        - Actions: Sort, Edit, Delete.

- Port Forward (Widget)
    - **Table**: Name, Match Rule (Incoming/Protocol/Source/Dest), Action (Forward to), Enable.
    - **Actions**: Sort, Edit, Delete.
    - **Global Action**: Add.