# Feature Specification: Customization
 
**Feature Branch**: `002-customization`
**Created**: 2025-12-20  
**Status**: Draft  
**Input**: User description: "现在需要在原有项目的基础上进行page和widget的进一步完善，要求将每个page分为方格区域，然后编写一个widget基类，要求所有的widget继承 this 基类，提供1x1, 2x1, 1x2, 2x2, 2x4, 4x2, 4x4这七中大小，然后选择可以实现的UI进行实现，并在数据库widgetItem中记录已经实现的大小。然后用户在一些page中可以进行添加，调整widgets的相对位置等。数据库pageItem要记录下该page所包含s的widgets及其大小，位置信息。现在已经有写好的cpu_usage，memory_usage以及network_traffic三个测试widget用于测试"

## Clarifications
### Session 2025-12-23
- Q: Collision Handling during drag/resize? → A: Option A - Strict Mode (Fit or Fail).
- Q: When should empty rows in a Stripe be collapsed? → A: Option A - Auto-Collapse on Save (remains during session).
- Q: Multi-Stripe Drag behavior? → A: Option A - Detach on Drag Start (removes from source model immediately).
- Q: Middleware/Page Entity Sharing? → A: Option A - Shared Entities (canonical updates apply to all references).
- Q: REM to Pixel Mapping? → A: Option A - Base-16 Mapping (1rem = 16 logical pixels).

## UI/UX *(Mandatory)*

### Defined Page Framework
The project defines a four-layer UI framework consisting of **Module**, **Middleware**, **Page**, and **Widget**. Please refer to `001-framework-design` and the code files in the `lib` directory.

*   **Module:** Represents the two main sections of the program: the Router management section and the Application Setting section.
*   **Middleware:** Used to guide users into a **Page**.
*   **Page:** The user's final destination, where **Widgets** are displayed.
*   **Widget:** Communicates directly with the router via the network, displaying router information and allowing operations on the router.

Customization primarily involves the **Widget** and **Page** layers, with limited involvement in the **Middleware** layer.

### Dimensional Quantization (Grid System)
Dimensions are quantized into a grid system. The spacing (top, bottom, left, right) between grid cells is **1rem** (defined as **16 logical pixels**). Consequently, the visual spacing between Widgets is **1rem**. The length and width of a grid cell are calculated as one-quarter of a **Stripe's** (defined below) width after deducting the spacing.

### Widget
#### BaseWidget Class
To facilitate future Widget expansion, a `BaseWidget` base class is required. All legitimate Widgets must inherit from this base class.

#### Size
*   `BaseWidget` allows Widgets to have the following grid sizes: **1x1**, **1x2**, **2x1**, **2x2**, **2x4**, **4x2**, **1x4**, **4x1**, and **4x4**. More size support will be added in the future. Widgets can freely choose which sizes to support by overriding the corresponding functions in `BaseWidget`.
*   Every Widget must support at least two size tiers: **1x1** (defaulting to the Widget's icon) and **4x4** (the Widget's full form).

#### Communication
Each Widget communicates independently with the router to ensure network isolation. However, Widgets can freely communicate with each other at the application level (e.g., retrieving router information via another Widget or adjusting router settings) to reduce network load.

#### Identity
*   Every Widget requires an **icon** and a **name**, stored as static data within the Widget class.

### Stripe
**Stripe** is a rendering concept defined to better adapt to responsive layouts. Each Stripe is unique and cannot be reused.

#### Size and Layout
*   The minimum width of each Stripe is **19rem**, and the maximum width is **35rem**.
*   The grid size of each Stripe is **4xN**, where N depends on the arrangement of Widgets within that Stripe.
*   The spacing between Stripes (top, bottom, left, right) is **1rem**, resulting in a final visual spacing of **1rem** between Widgets.
*   The number of Stripe columns displayed in parallel on a Page is determined by the Page's width. When the width is sufficient, they are displayed in parallel; when insufficient, the maximum number of displayable columns are centered and shown at maximum width.

#### Relationship with Framework
*   Widgets are placed directly on a Stripe with a fixed layout. There is no limit to the number of Widgets a single Stripe can hold.
*   A specific Widget type can be owned by Stripes on multiple different Pages, but a single Page cannot contain duplicate Widgets.
*   Each Page can contain an infinite number of Stripes, and their order is fixed.

### Page
#### Customization
*   Every built-in system Page has a default Stripe and Widget arrangement saved in the database (`PageItem`).
*   Not every Page is editable; the editability status should be stored in the `PageItem` in the database.
*   Upon entering the Page edit screen, users can freely add Widgets and adjust their position and size.
*   Widgets can be dragged freely to different positions across different Stripes. However, a Stripe cannot contain a row of grid cells that is completely empty (except during creation/editing logic as specified).
*   The Widget's size and absolute position within the Stripe are persisted in the `PageItem` in the database.

#### Edit Mode
*   Upon entering edit mode:
    *   If an area has no Widget, the grid dimensions of that area are visualized as **semi-transparent gray circles**.
    *   If an area has a Widget, only the Widget is displayed.
    *   Each Stripe is surrounded by a **semi-transparent gray dashed line** for visualization.
*   In edit mode, existing Stripes must display one additional row of grid area at the bottom compared to non-edit mode, used for placing new Widgets.
*   In edit mode, in addition to existing Stripes, one extra empty Stripe must be displayed to allow adding Widgets to a new Stripe.
*   The layout of Stripes follows the same responsive logic as in non-edit mode.

### Middleware
#### Customization
*   Middleware adds the ability to customize list order. Users entering the Middleware edit page can drag to reorder list items and add Middleware or Pages, but cannot add the current Middleware itself (no recursion).
*   After editing, the list is persisted in the `MiddlewareItem` in the database.
*   If an item in the Middleware is itself a middleware, a "chevron_right" icon is added to the far right, implying navigation to the next level.

#### Edit Mode
*   Upon entering edit mode, every item in the list becomes draggable. A **menu icon** is added to the far right of each item to imply draggability.
*   To the left of the menu icon, a red **"close" button** is added. Clicking this deletes the item from the list.

## User Scenarios & Testing *(Mandatory)*

### User Story 1.1 - Enter Page Edit Mode (Portrait) (Priority: P1)

Users can enter edit mode on a mobile/portrait screen to customize the page layout.

**Why this priority**: Essential for personalization on mobile devices.

**Independent Test**: Verify the menu option availability and the UI transformation upon clicking it in portrait mode.

**Acceptance Scenarios**:

1.  **Given** the user is on a Page in portrait mode, **When** they click the "menu" button on the far right of the Appbar, **Then** a dropdown menu appears containing an "Edit Page" option.
2.  **Given** the menu is open, **If** the Page is editable, **Then** the "Edit Page" option is enabled; **Else**, it is grayed out/disabled.
3.  **Given** the user clicks "Edit Page", **Then** the Appbar right button changes from "menu" to "check" (Save), the left button changes from "back" to "close" (Discard), and an "add" FloatingActionButton appears in the bottom right.

### User Story 1.2 - Enter Page Edit Mode (Landscape) (Priority: P1)

Users can enter edit mode on a tablet/desktop/landscape screen to customize the page layout.

**Why this priority**: Essential for personalization on larger screens with split-pane views.

**Independent Test**: Verify the menu option in the Right Pane and the UI transformation of the Right Pane's Appbar.

**Acceptance Scenarios**:

1.  **Given** the user is navigating a Page in the Right Pane (landscape mode), **When** they click the "menu" button on the Right Pane's Appbar, **Then** the menu containing "Edit Page" appears.
2.  **Given** the menu is open, **If** the Page is editable, **Then** the option is available; **Else**, it is disabled.
3.  **Given** the user clicks "Edit Page", **Then** the Right Pane's Appbar right buttons change to "close" (Discard) and "check" (Save), and an "add" FloatingActionButton appears in the bottom right of the Right Pane.

### User Story 2 - Add Widget to Page Stripe (Priority: P1)

Users can add new widgets to the page layout via the edit interface.

**Why this priority**: Core functionality for dashboard construction.

**Independent Test**: Successfully adding a widget that is not currently on the page and seeing it appear in the correct location.

**Acceptance Scenarios**:

1.  **Given** the Page is in edit mode, **When** the user clicks the "add" FloatingActionButton, **Then** a dialog appears listing the icons and names of Widgets **not currently on the page**.
2.  **Given** the dialog is open, **When** the user clicks the area outside the dialog (within the Page), **Then** the dialog closes without selecting a widget.
3.  **Given** the user selects a Widget from the dialog, **Then** the dialog closes, the Widget appears with a **1x1** size in the first available grid of the new row (or new Stripe) displayed in edit mode, and the placeholder gray circle for that grid disappears.

### User Story 3 - Adjust Widget Position and Size (Priority: P1)

Users can resize and move widgets within and across Stripes.

**Why this priority**: Allows users to organize information according to their preference.

**Independent Test**: Resize a widget, move a widget within a stripe, and move a widget to a new stripe.

**Acceptance Scenarios**:

1.  **Given** a Widget in edit mode, **Then** a small arrow pointing Southeast appears in the bottom right corner of the Widget.
2.  **Given** the user drags the resize arrow, **When** the size changes, **Then** the Widget style updates in real-time.
3.  **Given** the user releases the resize drag, **If** there is insufficient continuous space for the new size, **Then** the Widget snaps back to its original size (Strict Mode: Fit or Fail).
4.  **Given** the user drags a Widget to the last row of a Stripe, **Then** the Stripe dynamically adds a new empty row to accommodate resizing (unless blocked horizontally).
5.  **Given** the user drags a Widget to move it, **When** hovering over a new position, **Then** the Widget magnetically snaps to empty positions. **If** the target position is insufficient/invalid (e.g., overlaps another widget) upon release, **Then** the Widget returns to its original position (Strict Mode: Fit or Fail).
6.  **Given** the user drags a Widget to a new Stripe, **Then** a new empty Stripe placeholder is immediately displayed to allow further expansion.
7.  **Given** any movement or resizing, **Then** the animations must be smooth and continuous.
8.  **Given** a widget drag starts, **Then** it is detached from its source Stripe data model immediately, but a visual placeholder remains in the source until the drop is finalized to prevent sudden layout reflow (Detach on Drag Start).

### User Story 4 - Enter Middleware Edit Mode (Portrait) (Priority: P2)

Users can customize the order and contents of Middleware lists in portrait mode.

**Why this priority**: Allows customization of navigation paths.

**Independent Test**: Accessing edit mode from a Middleware screen vs. a Page screen.

**Acceptance Scenarios**:

1.  **Given** the user is on a Middleware screen, **When** they click the Appbar "menu" button, **Then** an "Edit Middleware" option is available.
2.  **Given** the user is on a Page screen, **When** they click the menu, **Then** the "Edit Middleware" option is disabled/hidden.
3.  **Given** the user clicks "Edit Middleware", **Then** the Appbar buttons change (Right: "menu" -> "check", Left: "back" -> "close"), and an "add" FloatingActionButton appears.

### User Story 5 - Enter Middleware Edit Mode (Landscape) (Priority: P2)

Users can customize Middleware lists while using the split-pane view in landscape mode.

**Why this priority**: consistent experience across device orientations.

**Independent Test**: Triggering edit mode for the Left Pane via the controls on the Right Pane (or main app bar context).

**Acceptance Scenarios**:

1.  **Given** the user is viewing a Middleware in the Left Pane, **When** they click the **Left Pane's** Appbar menu (if available) or context action, **Then** the "Edit Middleware" option is available.
2.  **Given** the user clicks "Edit Middleware", **Then** the **Left Pane's** Appbar left button changes from "back" to "close" and "check", and an "add" FloatingActionButton appears in the bottom left of the Left Pane.

### User Story 6 - Add and Modify Middleware Items (Priority: P2)

Users can add new navigation items (Middleware/Pages) and reorder or delete existing ones.

**Why this priority**: Users need to build their own navigation structure.

**Independent Test**: Add a new page to the list, reorder it, and delete it.

**Acceptance Scenarios**:

1.  **Given** Middleware edit mode, **When** the user clicks the "add" FloatingActionButton, **Then** a dialog appears browsing all available Middleware and Pages (excluding the current Middleware and items already in the list).
2.  **Given** the user selects an item, **Then** it is added to the end of the Middleware list and the dialog closes.
3.  **Given** the user clicks outside the dialog, **Then** the action is cancelled and the dialog closes.
4.  **Given** the list in edit mode, **When** the user drags an item by the menu handle, **Then** the order updates.
5.  **Given** the user clicks the red "close" button on an item, **Then** the item is removed from the list.

### User Story 7 - Save or Discard Changes (Priority: P1)

Users can finalize their edits or revert to the previous state.

**Why this priority**: Data integrity and user error recovery.

**Independent Test**: Make a change and click Save; make a change and click Discard.

**Acceptance Scenarios**:

1.  **Given** the user has made edits to a Page or Middleware, **When** they click the "check" (Save) button, **Then** the layout is persisted to the database, edit mode is exited, and the new layout is displayed.
2.  **Given** the user has made edits, **When** they click the "close" (Discard) button, **Then** the changes are discarded, edit mode is exited, and the layout reverts to the state stored in the database.


### Edge Cases

- **EC-01:** What happens if the device screen width is narrower than the minimum defined Stripe width (19rem + margins)? (Assumption: Small mobile devices or split-screen multitasking on phones).
- **EC-02:** What happens when a user attempts to add a Middleware to its own list, or creates a circular reference (A -> B -> A)? (Assumption: Infinite navigation loops must be prevented).
- **EC-03:** What happens if the persistence layer loads a Layout containing a Widget ID that no longer exists in the application code? (Assumption: Codebase was updated to remove a widget, but user configuration remains).
- **EC-04:** What happens when the user presses the system "Back" button (Android) or performs a back gesture while in Edit Mode? (Assumption: User might intend to discard, or might have pressed it accidentally).
- **EC-05:** What happens to a Stripe in Edit Mode when the last Widget is dragged out of it? (Assumption: The Stripe should not disappear immediately to allow dragging items back in).
- **EC-06:** What happens if a user rotates the device from Landscape to Portrait while in Edit Mode? (Assumption: The grid layout width changes significantly, potentially invalidating the current row arrangement).

### Solutions

- **EC-01:** The Page container enforces the mandatory 19rem minimum width and enables horizontal scrolling. (Rationale: Prioritizes strict grid quantization and widget usability over responsive shrinking on non-standard, extremely narrow viewports).
- **EC-02:** The "Add Item" dialog logic recursively filters out the current Middleware and all its ancestors from the selectable list. (Rationale: Proactively prevents the user from creating infinite navigation loops at the source).
- **EC-03:** The system renders a fallback "Unknown Widget" (locked to 1x1 size) that can only be deleted. (Rationale: Prevents application crashes during deserialization while allowing users to manually clean up obsolete data from their layout).
- **EC-04:** The system intercepts the back event and triggers a confirmation dialog asking the user to "Save" or "Discard". (Rationale: Prevents accidental data loss since the physical back button is often used instinctively to exit context).
- **EC-05:** The empty Stripe remains visible as a semi-transparent "ghost" placeholder until the edit session is saved. (Rationale: Prevents UI jitter and allows users to easily drag widgets back into the area they just cleared without manual recreation).
- **EC-06:** The system automatically saves the current layout and exits Edit Mode immediately upon screen rotation. (Rationale: Avoids complex state synchronization issues between the active drag-and-drop canvas and the underlying responsive reflow engine).

## Requirements *(mandatory)*

### Functional Requirements - Page & Widget Layout

- **FR-001**: The system MUST implement a responsive layout engine based on the **Stripe** concept.
    - **FR-001.1**: Each Stripe MUST define a 4-column grid.
    - **FR-001.2**: Stripes MUST define a minimum width of **19rem** and a maximum of **35rem**.
    - **FR-001.3**: The layout MUST automatically wrap Stripes to the next row based on the Page width.
- **FR-002**: The system MUST provide a `BaseWidget` abstract class.
    - **FR-002.1**: All Widgets MUST inherit from `BaseWidget`.
    - **FR-002.2**: `BaseWidget` MUST enforce implementation of at least two size tiers: **1x1** (Icon) and **4x4** (Full).
    - **FR-002.3**: `BaseWidget` MUST allow optional implementation of intermediate sizes: **1x2, 2x1, 2x2, 2x4, 4x2, 1x4, 4x1**.
- **FR-003**: The system MUST implement a **Grid System** with a mandatory **1rem** spacing between grid cells, stripes, and widgets.
    - **FR-003.1**: The system MUST map `1rem` to **16 logical pixels** for all layout calculations (Base-16 Mapping).
- **FR-004**: The system MUST support **Page Edit Mode**.
    - **FR-004.1**: Users MUST be able to enter Edit Mode via the Appbar menu (Portrait) or Right Pane Appbar (Landscape).
    - **FR-004.2**: In Edit Mode, the system MUST visualize empty grid areas as semi-transparent gray circles and Stripes as dashed gray borders.
    - **FR-004.3**: In Edit Mode, an extra empty row MUST be appended to existing Stripes, and a new empty Stripe MUST be appended to the Page.
- **FR-005**: The system MUST implement transactional editing (Save/Discard).
    - **FR-005.1**: Changes made in Edit Mode MUST NOT be persisted until the user clicks "Save".
    - **FR-005.2**: Clicking "Discard" or the system Back button (interrupted by confirmation) MUST revert the layout to its pre-edit state.
    - **FR-005.3**: Screen rotation during Edit Mode MUST trigger an auto-save and exit Edit Mode (EC-06).
    - **FR-005.4**: Empty rows in a Stripe MUST NOT be removed during an active edit session; they MUST be collapsed only upon successful "Save" (Auto-Collapse on Save).

### Functional Requirements - Middleware

- **FR-006**: The system MUST allow customization of Middleware lists.
    - **FR-006.1**: Users MUST be able to reorder items within a Middleware list.
    - **FR-006.2**: Users MUST be able to add new Middleware or Pages to the list.
    - **FR-006.3**: Users MUST be able to delete items from the list.
- **FR-007**: The system MUST prevent recursive navigation loops (EC-02).
    - **FR-007.1**: When adding items, the system MUST filter out the current Middleware and its ancestors from the selection list.
- **FR-007.2**: The system MUST implement a shared entity model for Middleware and Pages. Editing a common Middleware or Page's canonical layout MUST update all instances and references across different navigation paths (Shared Entities).

### Functional Requirements - Data & Interaction

- **FR-008**: The system MUST manage Widget persistence and structure.
    - **FR-008.1**: Widget definitions (metadata, supported sizes) MUST be defined directly in concrete `BaseWidget` implementations.
    - **FR-008.2**: Each Widget MUST be organized in its own directory under `lib/modules/router/widgets/` containing:
        - `{name}_service.dart`: Logic, data fetching, and parsing.
        - `{name}_widget.dart`: The UI class inheriting from `BaseWidget`.
    - **FR-008.3**: Widget instances (position, size, parent Stripe) MUST be stored in `PageItem`.
    - **FR-008.4**: If a loaded Widget ID does not exist in the codebase, the system MUST render a fallback "Unknown Widget" (locked 1x1).
    - **FR-008.5**: The system MUST implement a `WidgetFactory` to instantiate concrete `BaseWidget` implementations based on the `typeKey`.
- **FR-009**: The system MUST implement Drag-and-Drop interactions.
    - **FR-009.1**: Widgets MUST snap to the nearest valid grid position during drag.
    - **FR-009.2**: Moving a Widget to the last row of a Stripe MUST dynamically expand the Stripe (if space allows).
    - **FR-009.3**: Moving the last Widget out of a Stripe MUST leave a "ghost" placeholder until the session is saved (EC-05).
    - **FR-009.4**: (Strict Mode) Drag or resize actions resulting in an overlap with existing widgets MUST fail and snap the widget back to its original state.
    - **FR-009.5**: The system MUST detach a widget from its source Stripe data model immediately upon starting a drag action to allow cross-stripe movement without interfering with source layout constraints (Detach on Drag Start).

### Key Entities

- **BaseWidget**: Abstract class defining the contract (icon, name, size variants) for all dashboard widgets.
- **Stripe**: A rendering container that manages a 4xN grid and handles responsive wrapping logic.
- **PageItem**: Database entity representing a persisted layout (Widget Instance -> Position/Size -> Stripe Index).
- **MiddlewareItem**: Database entity representing the ordered list of navigation nodes (Pages or other Middlewares).
- **EditManager**: A state controller that handles the temporary layout state, undo/discard logic, and drag collisions.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can successfully place a widget in any valid 4x4 grid slot, and it magnetically snaps to the 1rem grid lines.
- **SC-002**: Resizing a widget to **4x4** forces the Stripe to expand vertically if the current row is insufficient, without breaking the 19rem-35rem width constraint.
- **SC-003**: When adding a sub-item to "Middleware A", "Middleware A" itself does NOT appear in the selection dialog (Recursion Prevention).
- **SC-004**: Clicking "Discard" after deleting 3 widgets restores all 3 widgets to their exact original positions and sizes.
- **SC-005**: On a generic mobile screen (Portrait), Stripes stack vertically; on a wide Desktop screen, Stripes arrange in parallel columns.
- **SC-006**: Loading a layout with a deleted widget ID displays a 1x1 placeholder instead of crashing the app.
- **SC-007**: Rotating the device while editing a Page automatically saves changes and returns to View Mode.
- **SC-008**: Attempting to drag a widget onto an occupied slot (Strict Mode) results in the widget returning to its starting position.
- **SC-009**: Deleting all widgets in Row 2 of a Stripe during edit mode does NOT cause Row 3 to shift up until "Save" is clicked.
- **SC-010**: A widget dragged from Stripe A to Stripe B is successfully persisted in Stripe B's record in `PageItem` after clicking "Save".
- **SC-011**: Modifying the order of Middleware B via Section X automatically reflects the same new order when Middleware B is accessed via Section Y (Shared Entities).
- **SC-012**: The total width of a 4-column Stripe in a 35rem viewport is exactly `35 * 16 = 560` logical pixels (Base-16 Mapping).