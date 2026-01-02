# Feature Specification: Widget as Page

**Feature Branch**: `003-widget-as-page`
**Created**: 2026-01-02
**Status**: Draft
**Input**: User description: "Widget as Page implementation."

## Clarifications

### Session 2026-01-02
- Q: How should state/data be managed when transitioning from a Dashboard Widget to its WidgetPage? → A: Share same state/instance as Dashboard widget.
- Q: How should contextual data/parameters be passed to a WidgetPage when accessed via deep link or navigation? → A: Via URL query parameters (e.g. ?id=eth0).
- Q: Which component is responsible for rendering the Page Shell (AppBar, Back Button) for a WidgetPage? → A: System wrapper provides AppBar/Back button.
- Q: Should there be a visual indicator (e.g., an icon) on the Dashboard Widget to signal that it can be expanded into a Page? → A: No visual indicator (Discovery via long-press only).
- Q: How should the back button behave if a WidgetPage is accessed via a direct deep-link (no history)? → A: Navigate to primary Dashboard/Home.

## UI/UX *(mandatory)*

### Widget (Update)
#### WidgetPage Concept
- The existing **Widget** acts as an overview or quick action panel for a specific functional module, but does not provide full functionality itself. The newly introduced **WidgetPage** serves as the complete panel presentation for the functionality represented by the Widget.
- **WidgetPage** is a new rendering mode for a Widget. It belongs to a specific **Widget** (implemented as a render function, conceptually abstracted as **WidgetPage**) and can occupy the entire PageView space to display full functionality.

#### WidgetPage Display Area
It is displayed within the `RouterPageView`:
- **Portrait Mode**: Consistent with a standard Page displaying Stripes.
- **Landscape Mode**: Consistent with a standard Page displaying Stripes, displayed within the RightPane.

#### Entry Methods for WidgetPage
- Distinct from the existing Page, Stripe, and Widget three-layer display system, a WidgetPage can be accessed directly via Middleware, similar to a standard Page. For compatibility with standard Pages, WidgetPage is assigned a `pageID` with the format `widget_{typeKey}`.
- Users can also long-press a Widget within a Stripe to directly navigate to the corresponding WidgetPage for quick access.

### Base Widget (Update)
- `BaseWidget` is already implemented. It requires updates to support WidgetPage implementation.
- A `renderPage` entry point must be reserved in the `BaseWidget` class. Specific Widgets will override this method to implement their functionality, consistent with other size-specific render methods.

### Middleware (Update)
- `Middleware` is already implemented. It requires updates to support adding WidgetPage items.
- To maintain compatibility with the existing architecture, each Widget's WidgetPage is assigned a `pageID` with the format `widget_{typeKey}`.
- Since Widgets are not stored in the database, the system must query `widgetCatalogProvider` to retrieve existing widgets when adding a WidgetPage as an entry point.

### Page (Update)
- `Page` is already implemented for displaying Stripes and traditional Widget styles. It requires updates to support displaying Widgets in Page form (WidgetPage).
- To minimize changes, all Widgets are assigned a `pageID` with the format `widget_{typeKey}`. When the `RouterPageView` identifies a target as a Widget, it automatically retrieves and renders content from the corresponding Widget's `renderPage` method.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Add Widget to Middleware List (Priority: P1)
As a user customizing my navigation, I want to add a Widget directly to a Middleware list so that I can access its full functionality quickly.

**Why this priority**: Enables the core feature of "Widget as Page", allowing widgets to be treated as first-class navigation destinations.

**Acceptance Scenarios**:
1.  **Given** the user is in Middleware Edit Mode, **When** they click the "add" button, **Then** the selection dialog includes available Widgets (retrieved from `widgetCatalogProvider`) alongside Middleware and Pages.
2.  **Given** the user selects a Widget from the dialog, **Then** the Widget is added to the Middleware list with its icon and name.
3.  **Given** the user saves the changes, **Then** the Widget appears in the Middleware list in normal view.

### User Story 2 - Navigate to WidgetPage via Middleware (Priority: P1)
As a user, I want to tap a Widget item in a Middleware list to open its full-page view.

**Why this priority**: Core navigation path for the new feature.

**Acceptance Scenarios**:
1.  **Given** a Middleware list containing a Widget item, **When** the user taps the Widget item, **Then** the app navigates to a new page displaying the `WidgetPage` content (full functionality of the widget).
2.  **Given** the WidgetPage is displayed, **Then** the AppBar title matches the Widget's name.
3.  **Given** the WidgetPage is displayed, **Then** the content occupies the full available space (Body Region in Portrait, Right Pane in Landscape).

### User Story 3 - Quick Access to WidgetPage via Long Press (Priority: P2)
As a user viewing a dashboard, I want to long-press a widget to jump to its detailed page.

**Why this priority**: Provides a convenient shortcut for power users to access detailed controls without navigating through menus.

**Acceptance Scenarios**:
1.  **Given** a Widget displayed on a Page (Stripe), **When** the user long-presses the Widget, **Then** the app navigates to the corresponding `WidgetPage`.
2.  **Given** the user is on the `WidgetPage` accessed via long-press, **When** they press Back, **Then** they return to the original Page.

### Edge Cases

- **EC-01:** What happens if a specific Widget implementation does not override the `renderPage` method? (Assumption: The developer might forget to implement the full page view).
- **EC-02:** What happens if a Widget referenced in a Middleware list (via `widget_{typeKey}`) is removed from the codebase? (Assumption: The app is updated, but the user's configuration remains).
- **EC-03:** What happens if the content within a `WidgetPage` exceeds the screen height? (Assumption: Full-page content might be extensive).
- **EC-04:** What happens when a user tries to add a Widget to a Middleware list that already contains that Widget? (Assumption: Users might want multiple access points).

### Solutions

- **EC-01:** `BaseWidget` provides a default `renderPage` implementation that displays the Widget's 4x4 representation centered on the screen, or a generic "Details not available" message. (Rationale: Prevents crashes and ensures a baseline experience).
- **EC-02:** The Middleware renderer checks the `WidgetCatalogProvider`. If the `typeKey` is missing, it renders a "Unknown Widget" placeholder or hides the item. (Rationale: Prevents crashes due to missing code assets).
- **EC-03:** The `WidgetPage` wrapper automatically wraps the content in a `SingleChildScrollView` (or equivalent). (Rationale: Ensures all content is accessible regardless of screen size).
- **EC-04:** The system allows duplicate entries. (Rationale: Flexibility in navigation design; the same widget might be relevant in different contexts).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST update `BaseWidget` to support full-page rendering.
    - **FR-001.1**: `BaseWidget` MUST include a `renderPage(BuildContext context)` method.
    - **FR-001.2**: The default implementation of `renderPage` MUST return a valid Widget (e.g., the 4x4 view or a placeholder).
    - **FR-001.3**: WidgetPage instances MUST share the same data state/instance as their dashboard widget counterparts to ensure consistency.
- **FR-002**: The system MUST implement `WidgetPage` as a top-level navigation destination.
    - **FR-002.1**: `WidgetPage` MUST accept a `typeKey` to identify the target Widget.
    - **FR-002.2**: `WidgetPage` MUST instantiate the correct Widget using `WidgetFactory` and invoke its `renderPage` method.
    - **FR-002.3**: The system wrapper MUST provide the global layout (AppBar with Widget name, Back Button) for WidgetPages, consistent with standard Pages. If accessed via deep-link without history, the Back Button MUST navigate to the primary Dashboard.
    - **FR-002.4**: `WidgetPage` MUST support receiving configuration parameters via URL query strings.
- **FR-003**: The system MUST support adding Widgets to Middleware lists.
    - **FR-003.1**: The "Add Item" dialog in Middleware Edit Mode MUST query `WidgetCatalogProvider` for available Widgets.
    - **FR-003.2**: Selected Widgets MUST be saved with a `pageID` format of `widget_{typeKey}`.
    - **FR-003.3**: The Middleware list renderer MUST recognize `widget_{typeKey}` IDs and render them with the Widget's icon and name.
- **FR-004**: The system MUST support "Long Press" navigation from the Dashboard.
    - **FR-004.1**: The Widget container in the Dashboard (Stripe) MUST detect long-press gestures.
    - **FR-004.2**: On long-press, the system MUST navigate to the `WidgetPage` corresponding to that Widget.

### Key Entities

- **WidgetPage**: A wrapper Page class that hosts the full-screen content of a Widget.
- **BaseWidget**: Updated to include `renderPage` contract.
- **WidgetCatalogProvider**: Registry of all available Widgets, used to populate selection lists.
- **MiddlewareItem**: Updated to support `widget_{typeKey}` as a valid target ID.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can successfully add a "CPU Usage" widget to the "System Status" Middleware list.
- **SC-002**: Tapping the "CPU Usage" item in the Middleware list opens a full-page view dedicated to CPU metrics.
- **SC-003**: Long-pressing the "CPU Usage" widget on the main dashboard navigates to the same full-page view.
- **SC-004**: If the "CPU Usage" widget code is removed, the Middleware list displays a placeholder instead of crashing.
- **SC-005**: The `WidgetPage` correctly adapts to both Portrait (Full Screen) and Landscape (Right Pane) modes.
