# Feature Specification: OpenWRT Manager App

**Feature Branch**: `001-openwrt-manager`
**Created**: 2025-12-10
**Status**: Draft
**Input**: User description: "需要写一个跨平台的APP，用于管理多个OpenWRT路由器，可以查看设备状态，并调整设备参数等，功能和网页版LuCI对齐。用户拥有高度的APP界面自定义权限，适配横竖屏两种设备形态，APP本身可使用生物识别保护，自带MCP可以进行自动管理操作。"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Multi-Router Management & Monitoring (Priority: P1)

As a network administrator, I want to add multiple OpenWRT routers to the app and view their real-time status (CPU, RAM, Traffic) on a unified dashboard so that I can monitor my entire network infrastructure from one place.

**Why this priority**: This is the core value proposition. Without connecting to routers and seeing their status, the app has no utility.

**Independent Test**: Can be tested by adding 2 distinct router endpoints (simulated or real) and verifying their individual status metrics are displayed correctly on the dashboard.

**Acceptance Scenarios**:

1. **Given** a fresh install, **When** the user taps "Add Router", **Then** they can input IP, Port, Username, and Password (or SSH key) to save a profile.
2. **Given** saved routers, **When** the user opens the app, **Then** they see a list of routers with a quick status summary (Online/Offline, Load).
3. **Given** a specific router selected, **When** viewing the detail dashboard, **Then** real-time graphs for CPU, Memory, and Network Traffic are displayed.

---

### User Story 2 - LuCI Parity Configuration (Priority: P2)

As a power user, I want to modify router settings (Interfaces, Wireless, Firewall, System) through the app with a native UI that matches the capabilities of the web-based LuCI interface, so that I don't need to open a browser for common tasks.

**Why this priority**: "LuCI parity" is a key requirement. Users expect to do more than just monitor; they need to manage.

**Independent Test**: Can be tested by changing a specific setting (e.g., changing the LAN IP or toggling a wireless radio) in the app and verifying the change is reflected on the router configuration.

**Acceptance Scenarios**:

1. **Given** a connected router, **When** the user navigates to "Network > Interfaces", **Then** they can view and edit settings for LAN/WAN interfaces.
2. **Given** a connected router, **When** the user navigates to "System", **Then** they can perform reboot, firmware upgrade, or change password operations.
3. **Given** complex configurations, **When** saving changes, **Then** the app handles the "Save & Apply" process reliably.

---

### User Story 3 - Adaptive UI & Customization (Priority: P3)

As a user with different devices (Phone, Tablet), I want the app interface to adapt to portrait and landscape modes and allow me to customize the dashboard widgets, so that I have an optimal viewing experience tailored to my workflow.

**Why this priority**: Enhances usability across platforms and respects user preference for "High UI customization".

**Independent Test**: Can be tested by rotating the device and verifying layout adjustments, and by reordering dashboard widgets.

**Acceptance Scenarios**:

1. **Given** a tablet device, **When** rotated to landscape, **Then** the layout expands to show a sidebar navigation and multi-column dashboard.
2. **Given** the dashboard view, **When** the user enters "Edit Mode", **Then** they can hide less important widgets or reorder them.

---

### User Story 4 - Security & Automation (Priority: P4)

As a security-conscious user, I want to protect the app with biometric authentication and use the built-in MCP (Model Context Protocol) agent to automate routine management tasks, so that my network remains secure and self-optimizing.

**Why this priority**: Differentiates the app with modern AI/Agentic capabilities and security.

**Independent Test**: Can be tested by enabling FaceID/TouchID and restarting the app, and by defining a simple automation rule (e.g., "Reboot at 3 AM").

**Acceptance Scenarios**:

1. **Given** biometrics enabled, **When** the app is brought to foreground, **Then** it prompts for authentication before showing data.
2. **Given** the MCP interface, **When** the user issues a natural language command (e.g., "Block internet for device X"), **Then** the agent interprets and executes the corresponding router command.

### Edge Cases

- **Connection Loss**: If the app loses connection to the router while open, it should display a "Reconnecting..." banner and cache the last known state rather than crashing or showing a blank screen.
- **Authentication Failure**: If stored credentials become invalid (e.g., changed via SSH), the app must prompt the user to re-enter credentials without deleting the router profile.
- **Unsupported Firmware**: If the connected router is running an unsupported or very old version of OpenWRT, the app should warn the user that some features may not function correctly.
- **Invalid Configuration**: If a user attempts to save a configuration that would sever the network connection (e.g., bad LAN IP), the app should warn the user before applying.

## UI/UX Design & Interaction

### Overall Theme & Design

- **Modern**: Use Material Design 3 Expressive for overall UI/UX
- **Customizable**: User can choose the theme color as well as light/dark/complete dark(OLED Optimized) theme mode.
- **Requirements**: Width need to be over 200px

### Layout

#### Portrait Mode
- **Activation Scope**: Utilized when horizontal width is less than **872px**. The excess 72px is reserved for the Portrait Navigation Rail.
- **AppBar**: A **Topbar** capable of auto-hiding.
  - **Left**: Back Button / Switch Device (used to return to the previous level or switch devices).
  - **Center**: Title of the current page.
  - **Right**: Menu Button (opens a List Menu upon click).
- **Navigation Region**: A **Navigation Bar** containing two parts for global switching:
  1. Router Page (**Router**)
  2. Application Settings (**Setting**)
- **Body Region**: Displays the corresponding main content.

#### Landscape Mode
- **Activation Scope**: Utilized when horizontal width is greater than **872px**. The excess 72px is allocated for the **Navigation Rail**.
- **Navigation Region**: A **Navigation Rail** containing two parts for global switching: Router Page (**Router**) and Application Settings (**Setting**). Both parts must adhere to this overall Layout design.
- **Body**: Divided into two separate Panes (Left and Right).

##### Left Pane
- **Naming**: The module naming must include "**Left Pane**".
- **Layout**: 
  - No vertical margins (top/bottom); height must be equal to the Navigation Rail.
  - Separated from the Right Pane by a **Spacer**.
  - The Spacer is used to adjust the width of both panes.
  - Minimum width: **400px**.
- **AppBar**: A **Topbar** capable of auto-hiding.
  - **Left**: Back Button / Switch Device (used to return to the previous level or switch devices).
  - **Center**: Title of the Left Pane.
- **Body**: The content displayed within the Left Pane.

##### Right Pane
- **Naming**: The module naming must include "**Right Pane**".
- **Layout**: 
  - No vertical margins (top/bottom); height must be equal to the Navigation Rail.
  - Separated from the Left Pane by a **Spacer**.
  - The Spacer is used to adjust the width of both panes.
  - Minimum width: **400px**.
- **AppBar**: A **Topbar** capable of auto-hiding.
  - **Center**: Title of the Right Pane.
  - **Right**: Menu Button (opens a List Menu upon click).
- **Body**: The content displayed within the Right Pane.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support storage and management of multiple router profiles (Credentials, Address).
- **FR-002**: System MUST communicate with OpenWRT routers via standard protocols (uBus/RPC, SSH, or LuCI API).
- **FR-003**: System MUST provide real-time monitoring of System Load, Memory Usage, and Network Traffic.
- **FR-004**: System MUST implement configuration screens for core OpenWRT modules: Status, System, Network, Wireless.
- **FR-005**: User MUST be able to customize the dashboard layout (widget visibility and order).
- **FR-006**: System MUST support responsive layout for both Portrait (Phone) and Landscape (Tablet/Desktop) orientations.
- **FR-007**: System MUST support Biometric Authentication (Fingerprint/FaceID) to access the app.
- **FR-008**: System MUST integrate an MCP (Model Context Protocol) client or similar agentic interface to interpret user intent and perform automated management actions.

### Key Entities

- **RouterProfile**: Stores connection details (Name, Host, Port, Auth Token/Creds).
- **DashboardLayout**: Stores user preferences for widget arrangement.
- **AutomationRule**: Defines a trigger and action for the MCP/Automation system.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Adding a new router profile takes less than 30 seconds.
- **SC-002**: Dashboard status updates (polling) occur with less than 2 seconds latency on a local network.
- **SC-003**: App supports at least 80% of the standard LuCI "System" and "Network" menu items.
- **SC-004**: UI successfully transitions between Portrait and Landscape modes without rendering errors or cut-off content.
- **SC-005**: Biometric unlock prompt appears within 500ms of app launch when enabled.