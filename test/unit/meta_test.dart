import 'package:easywrt/utils/init/meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMeta Constants', () {
    test('Polling Interval is reasonable', () {
      expect(AppMeta.defaultPollingIntervalSeconds, greaterThan(0));
    });

    test('Data conversion constants are correct', () {
      expect(AppMeta.bytesPerKilobyte, 1024);
      expect(AppMeta.bytesPerMegabyte, 1024 * 1024);
    });

    test('UI Layout constants are present', () {
      expect(AppMeta.defaultPadding, 16.0);
      expect(AppMeta.smallPadding, 8.0);
      expect(AppMeta.tinyPadding, 4.0);
    });
  });
}
