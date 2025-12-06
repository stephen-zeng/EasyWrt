# Feature Specification: EasyWrt Core Features

**Feature Branch**: `001-easywrt-core-features` (Created manually, no git ops)
**Created**: 2025-12-05
**Status**: Draft
**Input**: User description: "I'm building an app for openwrt. I want it to suuport multi-device management, customizable path of control, in-app bio-authentification and mcp support. For the UI, I want it to support side-by-side page for landscape screen, and single page for vertical screen. For the side-by-side screen, left page shows the middleware page, and the right page shows the final widget and function pages. You are NOT permitted to operate the git version control."

## User Scenarios & Testing

### User Story 1 - Multi-Device Management (Priority: P1)

Users can manage a list of multiple OpenWrt devices, adding new ones with credentials, and switching the active device to control different routers without re-entering details.

**Why this priority**: Fundamental to the "Multi-device management" requirement; the app is useless without connecting to at least one device, and valuable when managing many.

**Independent Test**: Can be tested by adding 2 mock devices and verifying the app can switch context between them, displaying different (mock) status data for each.

**Acceptance Scenarios**:

1. **Given** the app is empty, **When** the user adds a new device (IP, Username, Password), **Then** it appears in the device list and is selected as active.
2. **Given** multiple devices exist, **When** the user selects Device B, **Then** the dashboard updates to show Device B's status.
3. **Given** a device in the list, **When** the user deletes it, **Then** it is removed from storage.

---

### User Story 2 - Responsive Dashboard Layout (Priority: P1)

The application UI adapts to screen orientation. In landscape, it displays a side-by-side view (Middleware/Nav on left, Content on right). In portrait, it shows a single view with navigation to content.

**Why this priority**: Core UX requirement specified ("side-by-side page for landscape... single page for vertical"). Essential for usability across devices.

**Independent Test**: Can be tested by resizing the window (Desktop) or rotating the device (Mobile/Sim) and verifying the widget tree structure changes from Row (Split) to Navigator/Stack (Single).

**Acceptance Scenarios**:

1. **Given** the app is in Landscape mode, **When** viewing the main page, **Then** the "Middleware" page is visible on the left (approx 1/3 or fixed width) and "Widget/Function" page on the right.
2. **Given** the app is in Portrait mode, **When** viewing the main page, **Then** only the current focus (Middleware OR Function) is visible, with navigation controls to switch.
3. **Given** split view, **When** interacting with the Middleware pane, **Then** the Function pane updates to reflect the selection.

---

### User Story 3 - Bio-Authentication Integration (Priority: P2)

Users can secure access to the app or specific high-risk actions using their device's biometric authentication (Fingerprint, FaceID).

**Why this priority**: Security feature requested ("in-app bio-authentification").

**Independent Test**: Can be tested using platform simulators (FaceID/TouchID) to verify prompt appears and grants/denies access based on match.

**Acceptance Scenarios**:

1. **Given** bio-auth is enabled, **When** the app launches, **Then** the user is prompted for biometrics before seeing device data.
2. **Given** a sensitive action (if configured), **When** attempted, **Then** bio-auth is required to proceed.

---

### User Story 4 - Advanced Control & MCP Support (Priority: P3)

Users can configure how the app controls the device and utilize "MCP" capabilities.

**Why this priority**: Requested features ("customizable path of control", "mcp support").

**Independent Test**: Verifying configuration changes alter the API request paths or enable the MCP interface.

**Acceptance Scenarios**:

1. **Given** a device configuration, **When** the user customizes the menu structure ("Path of Control"), **Then** the app navigation updates to reflect the new path to the target widget.
2. **Given** the app is running, **When** an external AI agent connects via MCP, **Then** it can query device status or perform actions exposed by the app's MCP server.

## Requirements

### Functional Requirements

- **FR-001**: System MUST allow storage and retrieval of multiple device profiles (Name, Host, Credentials).
- **FR-002**: System MUST support encrypted storage of device passwords/keys.
- **FR-003**: System MUST detect screen orientation or window width to toggle between Split View and Single View.
- **FR-004**: In Split View, the Left Pane MUST display the "Middleware" (Navigation/Control) interface.
- **FR-005**: In Split View, the Right Pane MUST display the "Final Widget/Function" interface corresponding to the selection in the Left Pane.
- **FR-006**: System MUST support Biometric Authentication (using local platform APIs) to unlock the application or authorize actions.
- **FR-007**: System MUST support the Model Context Protocol (MCP) to allow integration with AI agents.
- **FR-008**: System MUST allow users to customize the navigation path (menus/sub-menus) used to reach specific widgets or functions.

### Key Entities

- **DeviceProfile**: Stores connection details (IP, Port, Protocol, Path, Auth Credentials).
- **AppSettings**: Stores UI preferences (Theme) and Security preferences (Bio-Auth enabled).

## Success Criteria

### Measurable Outcomes

- **SC-001**: Users can switch between stored devices in fewer than 3 clicks/taps.
- **SC-002**: UI layout transition between Landscape and Portrait completes in under 300ms without state loss.
- **SC-003**: Biometric prompt appears within 1 second of app launch (when enabled).
- **SC-004**: Device connection is successful using customized "Path of Control" settings.
