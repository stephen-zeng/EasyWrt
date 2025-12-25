import 'package:flutter_test/flutter_test.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  group('EditManager Collision Logic', () {
    late EditController controller;
    late PageItem testPage;

    setUp(() async {
      await setUpTestHive();
      if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(PageItemAdapter());
      if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(StripeItemAdapter());
      if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(WidgetInstanceAdapter());
      await Hive.openBox<PageItem>('pages');

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

    tearDown(() async {
      await tearDownTestHive();
    });

    test('Should save changes to Hive', () async {
      controller.enterEditMode(testPage);
      
      // Move widget
      controller.moveWidget('s1', 's1', 'w1', 2, 0);
      
      // Save
      await controller.save();
      
      // Verify Hive
      final box = Hive.box<PageItem>('pages');
      final savedPage = box.get('p1');
      expect(savedPage, isNotNull);
      expect(savedPage!.stripes!.first.widgets.first.x, 2);
    });

    test('Should move widget to new stripe', () {
      controller.enterEditMode(testPage);
      
      // Move w1 from s1 to new stripe
      controller.moveWidgetToNewStripe('s1', 'w1');
      
      final workingPage = controller.debugState.workingPage;
      // s1 had only w1. After move, s1 is empty and removed.
      // A new stripe is created with w1.
      // So total stripes should be 1.
      expect(workingPage!.stripes!.length, 1);
      
      final newStripe = workingPage.stripes!.first;
      expect(newStripe.id, isNot('s1')); // ID should be new
      expect(newStripe.widgets.length, 1);
      expect(newStripe.widgets.first.id, 'w1');
    });

    test('Should add widget to existing stripe', () {
      controller.enterEditMode(testPage);
      // testPage already has one stripe s1 with w1 at 0,0 size 2x2. Next Y should be 2.
      
      controller.addWidget('cpu'); // Adds 1x1 widget (default for cpu?) Need to check factory or assume default 1x1
      // Actually widget factory logic is inside controller.addWidget using create().
      // CPU default might be something else. Let's assume standard behavior.
      
      final workingPage = controller.debugState.workingPage;
      expect(workingPage!.stripes!.length, 1); // Should still be 1 stripe
      expect(workingPage.stripes!.first.widgets.length, 2); // Now 2 widgets
      
      final newWidget = workingPage.stripes!.first.widgets.last;
      expect(newWidget.y, 2); // Should be below w1 (y=0, h=2 -> nextY=2)
    });

    test('Should delete widget and cleanup empty stripe', () {
      controller.enterEditMode(testPage);
      
      controller.deleteWidget('s1', 'w1');
      
      final workingPage = controller.debugState.workingPage;
      // s1 became empty -> removed
      // Total 0 stripes
      expect(workingPage!.stripes!, isEmpty);
    });

    test('Should allow placement in empty space', () {
      controller.enterEditMode(testPage);
      // Try to move w1 to 2,0 (valid, 2x2 fits in remaining 2 cols)
      // Same stripe: s1
      final result = controller.moveWidget('s1', 's1', 'w1', 2, 0);
      expect(result, isTrue);
    });

    test('Should fail if overlapping another widget', () {
      // Add another widget w2 at 2,0
      testPage.stripes!.first.widgets.add(
        WidgetInstance(id: 'w2', widgetTypeKey: 'mem', x: 2, y: 0, width: 2, height: 2)
      );
      
      controller.enterEditMode(testPage);
      
      // Try to move w1 to 1,0 (overlaps w2 at 2,0)
      final result = controller.moveWidget('s1', 's1', 'w1', 1, 0);
      expect(result, isFalse);
    });

    test('Should fail if out of bounds', () {
      controller.enterEditMode(testPage);
      // w1 is 2x2. Try to move to x=3 (3+2 = 5 > 4)
      final result = controller.moveWidget('s1', 's1', 'w1', 3, 0);
      expect(result, isFalse);
    });

    test('Should move widget across stripes', () {
      // Setup: Stripe s1 with w1, Stripe s2 (empty)
      testPage.stripes!.add(StripeItem(id: 's2', widgets: []));
      
      controller.enterEditMode(testPage);
      
      // Move w1 from s1 to s2 at 0,0
      final result = controller.moveWidget('s2', 's1', 'w1', 0, 0);
      expect(result, isTrue);
      
      final workingPage = controller.debugState.workingPage;
      // s1 became empty -> removed
      // s2 now has w1 -> kept
      // Total 1 stripe (s2)
      expect(workingPage!.stripes!.length, 1);
      expect(workingPage.stripes!.first.id, 's2');
      expect(workingPage.stripes!.first.widgets.length, 1); // s2 has w1
      expect(workingPage.stripes!.first.widgets.first.id, 'w1');
    });
  });
}
