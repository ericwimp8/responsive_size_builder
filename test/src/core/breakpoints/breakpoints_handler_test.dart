import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('BreakpointsHandler', () {
    test('requires at least one size value', () {
      expect(BreakpointsHandler<int>.new, throwsAssertionError);
    });

    test('maps each LayoutSize to its configured value', () {
      final handler = BreakpointsHandler<int>(
        extraLarge: 5,
        large: 4,
        medium: 3,
        small: 2,
        extraSmall: 1,
      );

      expect(handler.values, <LayoutSize, int?>{
        LayoutSize.extraLarge: 5,
        LayoutSize.large: 4,
        LayoutSize.medium: 3,
        LayoutSize.small: 2,
        LayoutSize.extraSmall: 1,
      });
    });

    test('uses the configured breakpoints to classify screen size', () {
      final handler = BreakpointsHandler<String>(
        breakpoints: const Breakpoints(
          extraLarge: 1000,
          large: 800,
          medium: 500,
          small: 300,
        ),
        small: 'small',
        extraSmall: 'extraSmall',
      );

      expect(handler.getScreenSize(1200), LayoutSize.extraLarge);
      expect(handler.getScreenSize(850), LayoutSize.large);
      expect(handler.getScreenSize(550), LayoutSize.medium);
      expect(handler.getScreenSize(350), LayoutSize.small);
      expect(handler.getScreenSize(250), LayoutSize.extraSmall);
    });

    test('falls back to nearest populated lower breakpoint value', () {
      final handler = BreakpointsHandler<String>(
        large: 'large',
        extraSmall: 'extraSmall',
      );

      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.extraLarge),
        'large',
      );
      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.medium),
        'extraSmall',
      );
      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.small),
        'extraSmall',
      );
    });

    test('falls back to last non-null value when no lower values are set', () {
      final handler = BreakpointsHandler<String>(large: 'large');

      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.extraSmall),
        'large',
      );
    });

    test('caches value and only calls onChanged when breakpoint changes', () {
      final changes = <LayoutSize>[];
      final handler = BreakpointsHandler<String>(
        medium: 'medium',
        extraSmall: 'extraSmall',
        onChanged: changes.add,
      );

      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.medium),
        'medium',
      );
      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.medium),
        'medium',
      );
      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.small),
        'extraSmall',
      );
      expect(
        handler.getScreenSizeValue(screenSize: LayoutSize.small),
        'extraSmall',
      );

      expect(changes, <LayoutSize>[LayoutSize.medium, LayoutSize.small]);
    });

    test('resolves layout value by shortest side when requested', () {
      final handler = BreakpointsHandler<String>(
        medium: 'medium',
        small: 'small',
        extraSmall: 'extraSmall',
      );

      const constraints = BoxConstraints(
        maxWidth: 700,
        maxHeight: 500,
      );

      expect(
        handler.getLayoutSizeValue(constraints: constraints),
        'medium',
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
