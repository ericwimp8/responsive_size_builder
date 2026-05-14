import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('BreakpointsHandlerGranular', () {
    test('requires at least one size value', () {
      expect(BreakpointsHandlerGranular<int>.new, throwsAssertionError);
    });

    test('maps each LayoutSizeGranular to its configured value', () {
      final handler = BreakpointsHandlerGranular<int>(
        jumboExtraLarge: 13,
        jumboLarge: 12,
        jumboNormal: 11,
        jumboSmall: 10,
        standardExtraLarge: 9,
        standardLarge: 8,
        standardNormal: 7,
        standardSmall: 6,
        compactExtraLarge: 5,
        compactLarge: 4,
        compactNormal: 3,
        compactSmall: 2,
        tiny: 1,
      );

      expect(handler.values, <LayoutSizeGranular, int?>{
        LayoutSizeGranular.jumboExtraLarge: 13,
        LayoutSizeGranular.jumboLarge: 12,
        LayoutSizeGranular.jumboNormal: 11,
        LayoutSizeGranular.jumboSmall: 10,
        LayoutSizeGranular.standardExtraLarge: 9,
        LayoutSizeGranular.standardLarge: 8,
        LayoutSizeGranular.standardNormal: 7,
        LayoutSizeGranular.standardSmall: 6,
        LayoutSizeGranular.compactExtraLarge: 5,
        LayoutSizeGranular.compactLarge: 4,
        LayoutSizeGranular.compactNormal: 3,
        LayoutSizeGranular.compactSmall: 2,
        LayoutSizeGranular.tiny: 1,
      });
    });

    test('uses the configured breakpoints to classify screen size', () {
      final handler = BreakpointsHandlerGranular<String>(
        breakpoints: const BreakpointsGranular(
          jumboExtraLarge: 1000,
          jumboLarge: 900,
          jumboNormal: 800,
          jumboSmall: 700,
          standardExtraLarge: 600,
          standardLarge: 500,
          standardNormal: 400,
          standardSmall: 300,
          compactExtraLarge: 200,
          compactLarge: 150,
          compactNormal: 100,
          compactSmall: 50,
        ),
        compactSmall: 'compactSmall',
        tiny: 'tiny',
      );

      expect(handler.getScreenSize(1200), LayoutSizeGranular.jumboExtraLarge);
      expect(handler.getScreenSize(950), LayoutSizeGranular.jumboLarge);
      expect(handler.getScreenSize(850), LayoutSizeGranular.jumboNormal);
      expect(handler.getScreenSize(750), LayoutSizeGranular.jumboSmall);
      expect(handler.getScreenSize(650), LayoutSizeGranular.standardExtraLarge);
      expect(handler.getScreenSize(550), LayoutSizeGranular.standardLarge);
      expect(handler.getScreenSize(450), LayoutSizeGranular.standardNormal);
      expect(handler.getScreenSize(350), LayoutSizeGranular.standardSmall);
      expect(handler.getScreenSize(250), LayoutSizeGranular.compactExtraLarge);
      expect(handler.getScreenSize(180), LayoutSizeGranular.compactLarge);
      expect(handler.getScreenSize(120), LayoutSizeGranular.compactNormal);
      expect(handler.getScreenSize(70), LayoutSizeGranular.compactSmall);
      expect(handler.getScreenSize(40), LayoutSizeGranular.tiny);
    });

    test('falls back to nearest populated lower breakpoint value', () {
      final handler = BreakpointsHandlerGranular<String>(
        standardLarge: 'standardLarge',
        compactSmall: 'compactSmall',
      );

      expect(
        handler.getScreenSizeValue(
          screenSize: LayoutSizeGranular.jumboExtraLarge,
        ),
        'standardLarge',
      );
      expect(
        handler.getScreenSizeValue(
          screenSize: LayoutSizeGranular.standardSmall,
        ),
        'compactSmall',
      );
      expect(
        handler.getScreenSizeValue(screenSize: LayoutSizeGranular.tiny),
        'compactSmall',
      );
    });

    test('falls back to last non-null value when no lower values are set', () {
      final handler = BreakpointsHandlerGranular<String>(
        standardLarge: 'standardLarge',
      );

      expect(
        handler.getScreenSizeValue(screenSize: LayoutSizeGranular.tiny),
        'standardLarge',
      );
    });

    test('caches value and only calls onChanged when breakpoint changes', () {
      final changes = <LayoutSizeGranular>[];
      final handler = BreakpointsHandlerGranular<String>(
        standardNormal: 'standardNormal',
        compactSmall: 'compactSmall',
        onChanged: changes.add,
      );

      expect(
        handler.getScreenSizeValue(
          screenSize: LayoutSizeGranular.standardNormal,
        ),
        'standardNormal',
      );
      expect(
        handler.getScreenSizeValue(
          screenSize: LayoutSizeGranular.standardNormal,
        ),
        'standardNormal',
      );
      expect(
        handler.getScreenSizeValue(
          screenSize: LayoutSizeGranular.compactNormal,
        ),
        'compactSmall',
      );
      expect(
        handler.getScreenSizeValue(
          screenSize: LayoutSizeGranular.compactNormal,
        ),
        'compactSmall',
      );

      expect(changes, <LayoutSizeGranular>[
        LayoutSizeGranular.standardNormal,
        LayoutSizeGranular.compactNormal,
      ]);
    });

    test('resolves layout value by shortest side when requested', () {
      final handler = BreakpointsHandlerGranular<String>(
        breakpoints: const BreakpointsGranular(
          jumboExtraLarge: 1000,
          jumboLarge: 900,
          jumboNormal: 800,
          jumboSmall: 700,
          standardExtraLarge: 600,
          standardLarge: 500,
          standardNormal: 400,
          standardSmall: 300,
          compactExtraLarge: 200,
          compactLarge: 150,
          compactNormal: 100,
          compactSmall: 50,
        ),
        standardNormal: 'standardNormal',
        compactExtraLarge: 'compactExtraLarge',
        tiny: 'tiny',
      );

      const constraints = BoxConstraints(
        maxWidth: 450,
        maxHeight: 250,
      );

      expect(
        handler.getLayoutSizeValue(constraints: constraints),
        'standardNormal',
      );
      expect(
        handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: true,
        ),
        'compactExtraLarge',
      );
    });
  });
}
