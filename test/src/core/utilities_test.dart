import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('platform utility flags', () {
    test('kIsDesktopDevice matches desktop platform membership', () {
      final expectedDesktop = <TargetPlatform>{
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.linux,
      }.contains(defaultTargetPlatform);

      expect(kIsDesktopDevice, expectedDesktop);
    });

    test('kIsTouchDevice matches touch platform membership', () {
      final expectedTouch = <TargetPlatform>{
        TargetPlatform.android,
        TargetPlatform.iOS,
      }.contains(defaultTargetPlatform);

      expect(kIsTouchDevice, expectedTouch);
    });

    test('desktop and touch flags are mutually exclusive', () {
      expect(kIsDesktopDevice && kIsTouchDevice, isFalse);
    });
  });
}
