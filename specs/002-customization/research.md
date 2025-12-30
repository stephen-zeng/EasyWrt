# Research: Customization Feature

**Feature**: `002-customization` | **Date**: 2025-12-23

## Research Items

### 1. Flutter Layout Engine Strategy for Custom Grid
**Context**: We need a 4-column grid that supports variable sized widgets (1x1 to 4x4), strict snapping, and drag-and-drop.
**Unknown**: Best approach for performance and correctness (handling "Fit or Fail").

**Decision**: **Custom Stack-based Layout with Global Drag Overlay**
**Rationale**: 
- **Performance**: Using individual `DragTarget` widgets for every 1x1 grid cell (potentially hundreds per page) is expensive. A single `Listener`/`GestureDetector` on the Edit Overlay can track coordinates and map them to grid slots using simple O(1) math.
- **Precision**: "Fit or Fail" collision detection requires knowing the exact bounds of *all* other widgets. A centralized `EditManager` state can check collisions purely in data (Rect intersection) without relying on the render tree's hit testing.
- **UX**: "Ghost" placeholders and complex animations (snapping back) are easier to control when the dragged item is in a global `OverlayEntry` or top-level `Stack`, decoupled from the scrolling list of Stripes.

**Alternatives Considered**:
- *Nested DragTargets*: Easiest to code initially, but scales poorly.
- *ReorderableWrap*: Standard widget, but doesn't support multi-cell items (2x2, 2x4) gracefully without heavy modification.

### 2. Data Persistence Strategy
**Context**: Storing `BaseWidget` configurations where different widgets have different properties.
**Unknown**: How to store polymorphic data in Hive.

**Decision**: **JSON String Serialization for Widget Config**
**Rationale**:
- Hive supports simple types. Storing a custom subclass for every widget type in Hive requires registering adapters for every single new widget created.
- Instead, `WidgetItem` will store a `Map<String, dynamic> config` (or a JSON string) and a `String typeId`.
- The `BaseWidget` factory will re-hydrate the specific widget class from this `typeId` and `config` at runtime.
- This allows adding new Widgets without migrating the database schema (Standardized Interoperability V).

**Alternatives Considered**:
- *Polymorphic Hive Adapters*: Requires code generation and adapter registration for every new widget. High maintenance.

### 3. Responsive "Stripe" Implementation
**Context**: Stripes are 4-column grids that wrap based on page width.
**Decision**: **Wrap Widget for Stripes, Custom Layout for Inside**
**Rationale**:
- The outer page layout (placing Stripes) fits the `Wrap` widget behavior perfectly (flow layout).
- The *inner* layout of a Stripe (placing Widgets) must be a fixed `CustomMultiChildLayout` or `Stack` because the grid is strict (4 columns fixed, items have absolute grid coordinates).
