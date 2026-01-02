import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easywrt/modules/router/widgets/base/base_widget.dart';
import 'package:easywrt/beam/widget/grid_size_scope.dart';

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
  testWidgets('BaseWidget renders 1x1 by default', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: GridSizeScope(
            width: 1,
            height: 1,
            child: TestWidget(),
          ),
        ),
      ),
    );
    expect(find.text('1x1 Content'), findsOneWidget);
  });

  testWidgets('BaseWidget renders Page Content when 0x0', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: GridSizeScope(
            width: 0,
            height: 0,
            child: TestWidget(),
          ),
        ),
      ),
    );
    expect(find.text('Page Content'), findsOneWidget);
  });
}
