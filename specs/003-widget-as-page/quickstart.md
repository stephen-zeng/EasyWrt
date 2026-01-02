# Quickstart: Widget as Page

**Feature**: `003-widget-as-page`

## Enabling Page Mode for a Widget

To allow a widget to be displayed as a full page:

1.  **Override `renderPage`**:
    In your concrete widget class (extending `BaseWidget`), override the `renderPage` method.

    ```dart
    @override
    Widget renderPage(BuildContext context, MyData data, WidgetRef ref) {
      return Scaffold(
        // Note: AppBar is provided by the wrapper, but you can add local toolbars
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Full Detail View', style: Theme.of(context).textTheme.headlineMedium),
              // ... build your full UI using data
            ],
          ),
        ),
      );
    }
    ```

2.  **Verify Catalog**:
    Ensure your widget is added to the `widgetCatalogProvider` list in `lib/modules/router/controllers/widget_catalog_controller.dart`.

## Adding a Widget to Middleware

1.  Navigate to **Middleware Edit Mode** (Long press sidebar or click Edit).
2.  Click **Add Item** (+).
3.  Select **Widget** tab (New).
4.  Choose your widget from the list.
5.  Save.

## Deep Linking

Access your widget directly via URL:
`http://<host>/router?pid=widget_<typeKey>`

Example:
`/router?pid=widget_system_info`
