# Quickstart: Customization

**Feature**: `002-customization`

## How to Add a New Widget

1. **Create the Widget Folder**:
   Create a new directory in `lib/modules/router/widgets/my_new_widget/`.

2. **Implement the Service**:
   Create `my_new_widget_service.dart` to handle data fetching, parsing, and business logic.

3. **Implement the Widget**:
   Create `my_new_widget_widget.dart` extending `BaseWidget`. This class should shadow the metadata getters and implement the `build` method for various sizes.

   ```dart
   class MyNewWidget extends BaseWidget {
     const MyNewWidget({super.key});

     @override
     String get typeKey => 'my_new_widget';
     
     @override
     String get name => 'My Widget';
     
     @override
     String get description => 'Real-time monitoring of my feature.';

     @override
     int get iconCode => 0xe1d0;

     @override
     List<String> get supportedSizes => const ['1x1', '2x1', '2x2', '4x4'];

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       // 1. Get data from the service provider
       // final data = ref.watch(myNewWidgetServiceProvider);
       
       // 2. Get current allocated size from context or parent
       // final size = getCurrentGridSize(context); 

       // 3. Return different UI based on size
       // if (size == '1x1') return IconView();
       return FullView();
     }
   }
   ```

4. **Register the Widget**:
   - Add your new widget class to the `WidgetFactory` in `lib/modules/router/widgets/widget_factory.dart`.
   - Ensure a prototype instance is added to the `widgetCatalogProvider` for discovery in the "Add Widget" dialog.

3. **Verify**:
   - Run the app.
   - Enter Edit Mode on any page.
   - Click "+".
   - Your widget should appear in the selection dialog.

## How to Test Edit Mode

1. **Enable Edit Mode**:
   - Navigate to any page (e.g., Dashboard).
   - **Mobile (Portrait)**: Click the "Menu" icon in the top-right AppBar -> Select "Edit Page".
   - **Desktop (Landscape)**: Click the "Menu" icon in the Right Pane AppBar -> Select "Edit Page".

2. **Interactions**:
   - **Add**: Click the Floating Action Button (+).
   - **Move**: Drag any widget. Note the "ghost" placeholder.
   - **Resize**: Drag the handle at the bottom-right of a widget.
   - **Save**: Click the "Check" icon in the AppBar.
   - **Discard**: Click the "Close" (X) icon in the AppBar.

## Development Constraints

- **Grid Size**: 1rem = 16px. Do not use hardcoded pixel values for layout; use the grid math helpers.
- **Stripe Width**: Ensure your widget layout adapts to stripe widths between `19rem` (304px) and `35rem` (560px).
