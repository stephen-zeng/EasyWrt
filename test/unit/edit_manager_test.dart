import 'package:flutter_test/flutter_test.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';

void main() {
  group('EditManager Collision Logic', () {
    late EditController controller;
    late PageItem testPage;

    setUp(() {
      controller = EditController();
      testPage = PageItem(
        id: 'p1',
        name: 'Test Page',
        icon: 'home',
        stripes: [
          StripeItem(
            id: 's1',
            widgets: [
              WidgetInstance(id: 'w1', widgetTypeKey: 'cpu', x: 0, y: 0, width: 2, height: 2),
            ],
          )
        ],
      );
    });

    test('Should allow placement in empty space', () {
      controller.enterEditMode(testPage);
      // Try to move w1 to 2,0 (valid, 2x2 fits in remaining 2 cols)
      final result = controller.moveWidget('s1', 'w1', 2, 0);
      expect(result, isTrue);
    });

    test('Should fail if overlapping another widget', () {
      // Add another widget w2 at 2,0
      testPage.stripes!.first.widgets.add(
        WidgetInstance(id: 'w2', widgetTypeKey: 'mem', x: 2, y: 0, width: 2, height: 2)
      );
      
      controller.enterEditMode(testPage);
      
      // Try to move w1 to 1,0 (overlaps w2 at 2,0)
      // w1 is 2 wide. At 1,0 it occupies x=1, x=2.
      // w2 is at x=2. Overlap at x=2.
      final result = controller.moveWidget('s1', 'w1', 1, 0);
      expect(result, isFalse);
    });

    test('Should fail if out of bounds', () {
      controller.enterEditMode(testPage);
      // w1 is 2x2. Try to move to x=3 (3+2 = 5 > 4)
      final result = controller.moveWidget('s1', 'w1', 3, 0);
      expect(result, isFalse);
    });
  });
}
