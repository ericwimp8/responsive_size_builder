import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('selectOrientationPayload', () {
    test('returns portrait payload when orientation is portrait', () {
      var portraitCalls = 0;
      var landscapeCalls = 0;

      final result = selectOrientationPayload<String>(
        orientation: Orientation.portrait,
        portrait: () {
          portraitCalls += 1;
          return 'portrait';
        },
        landscape: () {
          landscapeCalls += 1;
          return 'landscape';
        },
      );

      expect(result, 'portrait');
      expect(portraitCalls, 1);
      expect(landscapeCalls, 0);
    });

    test('returns landscape payload when orientation is landscape', () {
      var portraitCalls = 0;
      var landscapeCalls = 0;

      final result = selectOrientationPayload<String>(
        orientation: Orientation.landscape,
        portrait: () {
          portraitCalls += 1;
          return 'portrait';
        },
        landscape: () {
          landscapeCalls += 1;
          return 'landscape';
        },
      );

      expect(result, 'landscape');
      expect(portraitCalls, 0);
      expect(landscapeCalls, 1);
    });
  });

  group('resolveOrientationValues', () {
    test('uses landscape values when orientation is landscape and populated',
        () {
      final portrait = <_TestSize, int?>{
        _TestSize.large: 1,
        _TestSize.small: null,
      };
      final landscape = <_TestSize, int?>{
        _TestSize.large: 2,
        _TestSize.small: null,
      };

      final selected = resolveOrientationValues<_TestSize, int>(
        orientation: Orientation.landscape,
        portrait: portrait,
        landscape: landscape,
      );

      expect(selected, same(landscape));
    });

    test(
        'falls back to portrait values when landscape orientation has no non-null values',
        () {
      final portrait = <_TestSize, int?>{
        _TestSize.large: 1,
        _TestSize.small: null,
      };
      final landscape = <_TestSize, int?>{
        _TestSize.large: null,
        _TestSize.small: null,
      };

      final selected = resolveOrientationValues<_TestSize, int>(
        orientation: Orientation.landscape,
        portrait: portrait,
        landscape: landscape,
      );

      expect(selected, same(portrait));
    });

    test('uses portrait values when orientation is portrait and populated', () {
      final portrait = <_TestSize, int?>{
        _TestSize.large: 1,
        _TestSize.small: null,
      };
      final landscape = <_TestSize, int?>{
        _TestSize.large: 2,
        _TestSize.small: null,
      };

      final selected = resolveOrientationValues<_TestSize, int>(
        orientation: Orientation.portrait,
        portrait: portrait,
        landscape: landscape,
      );

      expect(selected, same(portrait));
    });

    test(
        'falls back to landscape values when portrait orientation has no non-null values',
        () {
      final portrait = <_TestSize, int?>{
        _TestSize.large: null,
        _TestSize.small: null,
      };
      final landscape = <_TestSize, int?>{
        _TestSize.large: 2,
        _TestSize.small: null,
      };

      final selected = resolveOrientationValues<_TestSize, int>(
        orientation: Orientation.portrait,
        portrait: portrait,
        landscape: landscape,
      );

      expect(selected, same(landscape));
    });

    test('throws when both portrait and landscape are fully null', () {
      expect(
        () => resolveOrientationValues<_TestSize, int>(
          orientation: Orientation.portrait,
          portrait: const <_TestSize, int?>{
            _TestSize.large: null,
            _TestSize.small: null,
          },
          landscape: const <_TestSize, int?>{
            _TestSize.large: null,
            _TestSize.small: null,
          },
        ),
        throwsA(
          isA<FlutterError>().having(
            (error) => error.message,
            'message',
            'At least one breakpoint value must be provided for portrait or landscape.',
          ),
        ),
      );
    });
  });

  group('AnimatedChildMixin.maybeAnimate', () {
    test('returns original child when animateChange is false', () {
      final host = _AnimatedChildHost(animateChange: false);
      final child = Container();

      final result = host.maybeAnimate(child);

      expect(result, same(child));
    });

    test('wraps child in AnimatedSwitcher when animateChange is true', () {
      final host = _AnimatedChildHost(animateChange: true);
      final child = Container();

      final result = host.maybeAnimate(child);

      expect(result, isA<AnimatedSwitcher>());
      final switcher = result as AnimatedSwitcher;
      expect(switcher.duration, const Duration(milliseconds: 300));
      expect(switcher.child, same(child));
    });
  });
}

enum _TestSize { large, small }

class _AnimatedChildHost with AnimatedChildMixin {
  _AnimatedChildHost({required this.animateChange});

  @override
  final bool animateChange;
}
