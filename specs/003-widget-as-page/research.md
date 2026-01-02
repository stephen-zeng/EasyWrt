# Phase 0 Research: Widget as Page

## 1. BaseWidget Architecture
**Context**: `BaseWidget` is a generic abstract class `BaseWidget<T>`.
**Finding**: `BaseWidget` uses `watchData(ref)` to fetch data and `build` to dispatch render methods based on grid size.
**Decision**: Add `Widget renderPage(BuildContext context, T data, WidgetRef ref)` to `BaseWidget`.
**Rationale**: This allows leveraging the existing data fetching and state management logic. The `WidgetPage` wrapper will instantiate the specific `BaseWidget` implementation. To trigger `renderPage`, we can't easily rely on `GridSizeScope` because `build` is final-ish (though not marked final, it contains core logic).
**Refinement**: We will modify `BaseWidget.build` to check for a specific condition to call `renderPage`.
**Approach**:
- Introduce `PageModeScope` (InheritedWidget) or simply add a `isPage` boolean to `GridSizeScope` (or a special size string like `page`).
- Given `GridSizeScope` uses `width`/`height` integers, we can use a convention (e.g., width=0, height=0 implies Page Mode) OR modify `BaseWidget` to accept an optional `mode` parameter if instantiated directly.
- **Chosen Path**: Since `WidgetPage` will likely instantiate the widget directly, we can wrap it in a `GridSizeScope(width: 0, height: 0)` and update `BaseWidget` to check `if (scope.width == 0 && scope.height == 0) return renderPage(...)`. This avoids changing `GridSizeScope` definition.

## 2. Middleware Persistence
**Context**: `MiddlewareItem` stores children IDs as `List<String>`.
**Finding**: `Hive` persistence supports Strings.
**Decision**: Store widget references as `widget_{typeKey}`.
**Rationale**: No schema change is needed. `MiddlewareView` iterates these IDs. We just need to update `MiddlewareView` (or its child rendering logic) to detect `widget_` prefix and render a widget item instead of a page link, and navigate to `mid=...&pid=widget_...`.

## 3. Routing & Navigation
**Context**: `RouterSplitWrapper` orchestrates the view based on `mid` and `pid`. `RouterPageView` expects a valid DB `PageItem`.
**Finding**: Passing `widget_...` ID to `RouterPageView` will cause "Page not found".
**Decision**: Modify `RouterSplitWrapper` to intercept `pid`.
**Logic**:
```dart
if (pid != null && pid.startsWith('widget_')) {
  return WidgetPageWrapper(pageId: pid);
} else {
  return RouterPageView(pageId: pid);
}
```
**Top-Level Route**:
For direct deep links (e.g. `/widget/cpu`), we can add a top-level route in `lib/router.dart` that redirects to `/router?mid=...&pid=widget_cpu` OR renders the `WidgetPageWrapper` in a Shell.
However, to maintain the "Split View" context (sidebar), it is best to route it through `/router`.
If we want a *clean* URL `/widget/cpu`, we can use `GoRoute(path: '/widget/:id')` that internally builds `MainScaffold` -> `RouterSplitWrapper` with injected state.
**Simpler Approach**: just use `/router?pid=widget_cpu`. The spec mentions "navigate directly... via a unique URL". `/router?pid=widget_cpu` IS a unique URL. We can alias it if strictly needed, but query param is sufficient for P1.

## 4. Widget Catalog
**Context**: `WidgetCatalogProvider` exists in `lib/modules/router/controllers/widget_catalog_controller.dart`.
**Finding**: It provides `List<BaseWidget>`.
**Decision**: Use this provider to look up the Widget instance by `typeKey` when rendering `WidgetPage`.

## Summary of Changes
1.  **BaseWidget**: Add `renderPage` method and `0x0` size check.
2.  **RouterSplitWrapper**: Add branching logic for `widget_` PIDs.
3.  **WidgetPageWrapper**: New component to lookup widget from catalog and render it.
4.  **MiddlewareView**: Handle `widget_` IDs in list rendering.
5.  **GoRouter**: No major changes needed if we use query params.
