# Feature Specification: OpenWRT Manager App

**Feature Branch**: `001-framework-design`
**Created**: 2025-12-10
**Status**: Draft
**Input**: User description: "需要写一个跨平台的APP，用于管理OpenWRT路由器，可以查看设备状态，并调整设备参数等。"

## UI/UX *(mandatory)*

### Layout
#### Portrait
- **Activation Scope**: Used when the horizontal width is less than 872px. The extra 72px is utilized for the Portrait Navigation rail.
- **AppBar**: A Topbar that must auto-hide. The leftmost element is a **Back Button** for returning to the previous level; the center displays the **Page Title**; the rightmost element is a **Menu Button**, which opens a List menu upon clicking.
- **Navigation Region**: A Navigation bar consisting of two Modules for global switching: **Router Page (Router)** and **App Settings (Setting)**.
- **Body Region**: Displays the corresponding main content.

#### Landscape
- **Activation Scope**: Used when the horizontal width is greater than 872px. The extra 72px is utilized for the Navigation rail.
- **Navigation Region**: A Navigation rail consisting of two Modules for global switching: **Router Page (Router)** and **App Settings (Setting)**. Both Modules adhere to this general Layout design.
- **Body**: Divided into two separate Panes: Left and Right.

##### Left Pane
- **Naming**: The naming of this module must contain "Left Pane".
- **Layout**: No vertical Padding; height is equal to the Navigation rail. A Spacer exists between it and the Right Pane to adjust the width of both panes. The minimum width is 400px.
- **AppBar**: A Topbar that must auto-hide. The leftmost element is a **Back Button/Switch Device** button, used to return to the previous level or switch devices; the center displays the **Left Pane Title**.
- **Body**: The content displayed in the Left Pane.

##### Right Pane
- **Naming**: The naming of this module must contain "Right Pane".
- **Layout**: No vertical Padding; height is equal to the Navigation rail. A Spacer exists between it and the Left Pane to adjust the width of both panes. The minimum width is 400px.
- **AppBar**: A Topbar that must auto-hide. The center displays the **Right Pane Title**; the rightmost element is a **Menu Button**, which opens a List menu upon clicking.
- **Body**: The content displayed in the Right Pane.

### Operation Page Design
#### Design
- **Overview**: Users enter the next menu level layer by layer through hierarchical menu operations until they reach the final operation panel interface.
- **Construction**: Divided into three parts: **Page**, **Middleware**, and **Widget**.
    - **Page**: The final operation panel interface reached by the user.
    - **Widget**: Individual components within a Page that directly display router data or manipulate router parameters.
    - **Middleware**: The hierarchical menus displayed during the user's journey to a Page. Every menu level is a Middleware.
- **Customizable**:
    - In the **Router Module**, users can freely arrange the relationship between different Middlewares and Pages. Users can freely create Middleware but cannot create Pages (Page creation is reserved for future feature development). However, the ability to create Pages is retained for developers.
    - Users can freely add and adjust Widgets within certain Pages, so Page customizability must be retained.
    - In the **App Settings Module**, users cannot customize the layout, but it needs to be convenient for developers to adjust. The middlewares and pages are written in code.
- **Developer Friendly**: Developers must be able to conveniently and uniformly adjust parameters such as margins, padding, width, and height.
- **Fluent**: Transitions between pages must feature fluid, non-linear animations, directly utilizing the **Material Design 3 Expressive** animation design specifications.

#### Specific Component Descriptions
##### Middleware
- **Definition**: Middleware represents the hierarchical menus before the user reaches a Page. Each menu level is a Middleware.
- **Logic**: Each Middleware can lead to the next Middleware or a Page.
- **Content**: Each Middleware has a title, an icon, and contains the next level of Middleware and Pages.
- **Display**: The title is displayed in the AppBar. The Body displays the contained Middleware and Pages in a menu format. In each menu Item, the left side shows the icon of the Middleware or Page, followed by the title. The default sorting order is first by type (Middleware --> Page), then by alphabetical order (incrementing Pinyin/English).

##### Page
- **Definition**: A Page is the final layer of the menu reached by the user. Each Page contains multiple Widgets used to display and adjust router information.
- **Logic**: A Page can be reached via multiple Middlewares. A Page cannot directly lead to a Middleware or another Page, but jumps to other Middlewares or Pages can be achieved through the Widgets inside it.
- **Content**: Each Page has a title, an icon, and many Widgets contained within.
- **Display**: The title is displayed in the AppBar. The Body displays the contained Widgets. Note the responsive layout: it must automatically adapt to the Body's width, and users can freely arrange the Widget layout.

##### Widget
- **Definition**: A Widget directly displays and manipulates router data and must conform to the **Material Design 3 Expressive** design style.
- **Logic**: A Widget can be used by multiple Pages, but a single Page can only contain one instance of a specific Widget type. A Widget can trigger jumps to other Middlewares or Pages, performing the jump in the corresponding display area (Middleware or Page area).
- **Content**: Relatively free, but must conform to Material Design 3 Expressive design specifications.
- **Specifications**: The height of a Widget is determined by its content. The width must be a multiple of 100px and is determined by the content. Padding between Widgets (up, down, left, right) is 25px. Margins inside the Widget (up, down, left, right) are 5px.
- **Display**: Displayed within the Page body as an information stream. The number of display columns is automatically adjusted based on the Body width, with no upper limit.

#### General Display Rules for Components
##### Portrait
- **General**: Displays the content of the currently required Middleware or Page.
- **Back Button on AppBar**: Displayed on the left side when not in the root Middleware, used to return to the upper-level menu content. Long-pressing the back button reveals a menu displaying the call path of the current Middleware or Page in a list format, used for quickly returning to a specific menu desired by the user.
- **Title On AppBar**: Displays the title of the current Middleware or Page.
- **Menu Button On AppBar**: Menu content includes "Edit"—used to edit the current Middleware or Page (hidden when not editable); and "Switch"—used to jump to the device switching interface (retaining extensibility for specific Middlewares or Pages).

##### Landscape
- **Independence**: The Left Pane and Right Pane are mutually independent, but the Left Pane and Right Pane can mutually determine each other's display content.

###### Left Pane
- **Content**: The Left Pane displays only **Middleware**. Middleware jumps triggered by Widgets and Middleware editing changes occur only within the Left Pane and do not affect the Right Pane.
- **Title On AppBar**: Displays the title of the current Middleware.
- **Back Button on AppBar**: Displayed on the left side when not in the root Middleware, used to return to the upper-level menu content. Long-pressing the back button reveals a menu displaying the call path of the Middleware in a list format, used for quickly returning to a specific menu desired by the user.

###### Right Pane
- **Content**: The Right Pane displays only **Page**. Page jumps triggered by Widgets and Page editing changes occur only within the Right Pane and do not affect the Left Pane.
- **Title On AppBar**: Displays the title of the current Page.
- **Menu Button On AppBar**: Menu content includes "Edit Page"—used to edit the current Page (hidden when not editable); "Edit Middleware"—used to edit the Middleware currently displayed in the Left Pane; and "Switch"—used to jump to the device switching interface (retaining extensibility for specific Middlewares or Pages).

## Middleware and Page Examples for UI/UX Framework Validation *(mandatory)*
### Router Module
#### Middleware
- **Router**: Icon: `router`, is the root middleware.
- **Status**: Icon: `bar_chart`.
- **Hardware**: Icon: `hardware`.

#### Page
- **Internal Device**: Icon: `hard_drive`, editable (the edit button in the appbar popup menu is available).

#### Widget
- **Memory Status**: Displays memory usage.

#### Hierarchy
- **Router** --> **Status** --> **Hardware** --> **Internal Device**

### Setting Module
#### Middleware
- **Setting**: Icon: `settings`, is the root middleware.

#### Page
- **Router**: Icon: `router`. The page contains a `FAB` (Floating Action Button). It defaults to "Edit"; when the list is empty, it acts as "Add". Clicking it allows the user to edit or add a router. Upon clicking, the `FAB` changes to "Add".
- **Theme**: Icon: `colors`. The page offers color and light/dark mode selections.

## User Scenarios & Testing *(mandatory)*
### User Story 1 - Add and Connect to Routers with Error Reporting (Priority: P1)
As a network administrator, I want to add multiple OpenWRT routers to the app and view their real-time status (CPU, RAM, Traffic) on a unified dashboard so that I can monitor my entire network infrastructure from one place.

**Why this priority**: This is the core value proposition. Without connecting to routers and seeing their status, the app has no utility.

**Acceptance Scenarios**:
1.  **Given** a fresh install, **When** the user navigates via Settings (Root) --> Route (Page) to the router management page, **Then** clicks the FAB in the page to add, **Then** they can input IP (Domain), Port, Username, Password, and whether to use HTTPS to save a router.
2.  **Given** saved routers, **When** the user clicks one router, **Then** the app tries to connect to the router, **Then** jumps to the Router Module's root middleware.

### User Story 2 - View Router CPU Usage (Priority: P1)
As a user monitoring network performance, I want to view the real-time hardware information of a specific router so that I can assess the CPU load and device health.

**Why this priority**: Monitoring hardware resources is a fundamental function of router management.

**Acceptance Scenarios**:
1.  **Given** a router is selected and connected, **When** the user navigates through the hierarchy: Router (root) --> Status (middleware) --> Hardware (middleware) --> Internal Device (page), **Then** the page displays the real-time information of internal devices (specifically CPU usage) via the configured Widgets.

### User Story 3 - Change App Theme (Priority: P2)
As a user who cares about visual aesthetics, I want to customize the app's theme so that the interface matches my personal preference or environment (Light/Dark).

**Why this priority**: Personalization enhances user experience, though it is not critical for functionality.

**Acceptance Scenarios**:
1.  **Given** the app is open, **When** the user navigates via Settings (Root) --> Theme (Page) to the theme settings interface, **Then** they can select different color schemes and Light/Dark modes.
2.  **Given** no prior user selection, **Then** the default setting is the Green color scheme + System Follows (Light/Dark based on system settings).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support storage and management of multiple router profiles (Credentials, Address).
- **FR-002**: System MUST support responsive layout for both Portrait (Phone) and Landscape (Tablet/Desktop) orientations.
- **FR-003**: User MUST be able to customize the dashboard layout (widget visibility and order).
- **FR-004**: System MUST communicate with OpenWRT routers via standard protocols (uBus/RPC, SSH, or LuCI API).
- **FR-005**: System MUST provide real-time monitoring of System Load, Memory Usage, and Network Traffic.
- **FR-006**: System MUST implement configuration screens for core OpenWRT modules: Status, System, Network, Wireless.

### Key Entities

- **RouterProfile**: Stores connection details (Name, Host, Port, Auth Token/Creds).
- **DashboardLayout**: Stores user preferences for widget arrangement.
- **AutomationRule**: Defines a trigger and action for the MCP/Automation system.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Adding a new router profile takes less than 30 seconds.
- **SC-002**: UI successfully transitions between Portrait and Landscape modes without rendering errors or cut-off content.
