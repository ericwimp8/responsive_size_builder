import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('BaseBreakpointsHandler.getScreenSize', () {
    final handler = _TestBreakpointsHandler(
      breakpoints: const _TestBreakpoints(),
      values: {
        _TestSize.extraLarge: 'extraLarge',
        _TestSize.large: 'large',
        _TestSize.medium: 'medium',
        _TestSize.small: 'small',
      },
    );

    test('returns the first breakpoint whose threshold is met', () {
      expect(handler.getScreenSize(1200), _TestSize.extraLarge);
      expect(handler.getScreenSize(900), _TestSize.large);
      expect(handler.getScreenSize(500), _TestSize.medium);
    });

    test('returns the last breakpoint when no thresholds are met', () {
      expect(handler.getScreenSize(-1), _TestSize.small);
    });
  });

  group('BaseBreakpointsHandler.getScreenSizeValue', () {
    test('returns cached value without firing onChanged for same screen size',
        () {
      final changes = <_TestSize>[];
      final values = <_TestSize, String?>{
        _TestSize.extraLarge: 'extraLarge',
        _TestSize.large: 'large',
        _TestSize.medium: 'medium',
        _TestSize.small: 'small',
      };
      final handler = _TestBreakpointsHandler(
        breakpoints: const _TestBreakpoints(),
        values: values,
        onChanged: changes.add,
      );

      final first = handler.getScreenSizeValue(screenSize: _TestSize.large);
      values[_TestSize.large] = 'mutated';
      final second = handler.getScreenSizeValue(screenSize: _TestSize.large);

      expect(first, 'large');
      expect(second, 'large');
      expect(changes, [_TestSize.large]);
    });

    test('falls back to the next non-null value at or below the breakpoint',
        () {
      final handler = _TestBreakpointsHandler(
        breakpoints: const _TestBreakpoints(),
        values: {
          _TestSize.extraLarge: null,
          _TestSize.large: 'large',
          _TestSize.medium: null,
          _TestSize.small: 'small',
        },
      );

      expect(
        handler.getScreenSizeValue(screenSize: _TestSize.extraLarge),
        'large',
      );
      expect(
        handler.getScreenSizeValue(screenSize: _TestSize.medium),
        'small',
      );
    });

    test('falls back to the last non-null value when later values are null',
        () {
      final handler = _TestBreakpointsHandler(
        breakpoints: const _TestBreakpoints(),
        values: {
          _TestSize.extraLarge: 'extraLarge',
          _TestSize.large: 'large',
          _TestSize.medium: null,
          _TestSize.small: null,
        },
      );

      expect(
        handler.getScreenSizeValue(screenSize: _TestSize.medium),
        'large',
      );
    });
  });

  group('BaseBreakpointsHandler.getLayoutSizeValue', () {
    test('uses width by default and shortest side when requested', () {
      final handler = _TestBreakpointsHandler(
        breakpoints: const _TestBreakpoints(),
        values: {
          _TestSize.extraLarge: 'extraLarge',
          _TestSize.large: 'large',
          _TestSize.medium: 'medium',
          _TestSize.small: 'small',
        },
      );
      const constraints = BoxConstraints(maxWidth: 850, maxHeight: 300);

      expect(
        handler.getLayoutSizeValue(constraints: constraints),
        'large',
      );
      expect(
        handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: true,
        ),
        'small',
      );
    });
  });
}

class _TestBreakpointsHandler
    extends BaseBreakpointsHandler<String, _TestSize> {
  _TestBreakpointsHandler({
    required super.breakpoints,
    required Map<_TestSize, String?> values,
    super.onChanged,
  }) : _values = values;

  final Map<_TestSize, String?> _values;

  @override
  Map<_TestSize, String?> get values => _values;
}

class _TestBreakpoints implements BaseBreakpoints<_TestSize> {
  const _TestBreakpoints();

  @override
  Map<_TestSize, double> get values => {
        _TestSize.extraLarge: 1000,
        _TestSize.large: 800,
        _TestSize.medium: 400,
        _TestSize.small: 0,
      };
}

enum _TestSize { extraLarge, large, medium, small }
