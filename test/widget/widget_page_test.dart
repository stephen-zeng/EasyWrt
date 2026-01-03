import 'package:flutter/material.dart' hide PageView;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/page/page_view.dart';
import 'package:easywrt/modules/router/controllers/widget_catalog_controller.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';

// Mock Widget
class TestWidget extends BaseWidget<void> {
  const TestWidget({super.key});
  @override String get typeKey => 'test_widget';
  @override String get name => 'Test Widget';
  @override String get description => 'Description';
  @override IconData get icon => Icons.ac_unit;
  @override List<String> get supportedSizes => ['1x1'];
  @override AsyncValue<void> watchData(WidgetRef ref) => const AsyncValue.data(null);
  
  @override
  Widget render1x1(BuildContext context, void data, WidgetRef ref) {
    return const Text('1x1 Content');
  }
  
  @override
  Widget renderPage(BuildContext context, void data, WidgetRef ref) {
    return const Text('Page Content');
  }
}

void main() {
  testWidgets('PageView renders widget correctly for valid widget ID', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          widgetCatalogProvider.overrideWithValue([const TestWidget()]),
        ],
        child: const MaterialApp(
          home: PageView(pageId: 'widget_test_widget'),
        ),
      ),
    );

    expect(find.text('Test Widget'), findsOneWidget); // AppBar title
    expect(find.text('Page Content'), findsOneWidget); // Body
  });

  testWidgets('PageView shows not found for missing widget', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          widgetCatalogProvider.overrideWithValue([]),
        ],
        child: const MaterialApp(
          home: PageView(pageId: 'widget_unknown'),
        ),
      ),
    );

    expect(find.text('Not Found'), findsOneWidget);
  });
}
