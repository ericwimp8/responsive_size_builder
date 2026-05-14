import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('Breakpoints', () {
    test('uses expected defaults', () {
      const breakpoints = Breakpoints.defaultBreakpoints;

      expect(breakpoints.extraLarge, 1200);
      expect(breakpoints.large, 950);
      expect(breakpoints.medium, 600);
      expect(breakpoints.small, 200);
    });

    test('exposes enum values map including extraSmall fallback', () {
      const breakpoints = Breakpoints(
        extraLarge: 1100,
        large: 900,
        medium: 700,
        small: 300,
      );

      expect(
        breakpoints.values,
        equals(<LayoutSize, double>{
          LayoutSize.extraLarge: 1100,
          LayoutSize.large: 900,
          LayoutSize.medium: 700,
          LayoutSize.small: 300,
          LayoutSize.extraSmall: -1,
        }),
      );
    });

    test('copyWith updates provided fields and keeps others', () {
      const original = Breakpoints(
        extraLarge: 1300,
        large: 980,
        medium: 640,
        small: 240,
      );

      final updated = original.copyWith(
        medium: 620,
        small: 220,
      );

      expect(
        updated,
        const Breakpoints(
          extraLarge: 1300,
          large: 980,
          medium: 620,
          small: 220,
        ),
      );
    });

    test('supports value equality and stable hashCode', () {
      const first = Breakpoints(
        extraLarge: 1000,
        large: 800,
        small: 400,
      );
      const second = Breakpoints(
        extraLarge: 1000,
        large: 800,
        small: 400,
      );
      const third = Breakpoints(
        extraLarge: 1100,
        large: 800,
        small: 400,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('toString includes all thresholds', () {
      const breakpoints = Breakpoints(
        extraLarge: 1400,
        large: 1000,
        medium: 700,
        small: 300,
      );

      expect(
        breakpoints.toString(),
        'Breakpoints(extraLarge: 1400.0, large: 1000.0, medium: 700.0, small: 300.0)',
      );
    });

    test('asserts when thresholds are out of descending order', () {
      expect(
        () => Breakpoints(
          extraLarge: 900,
          large: 901,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('asserts when small is negative', () {
      expect(
        () => Breakpoints(
          extraLarge: 900,
          large: 800,
          small: -1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('BreakpointsGranular', () {
    test('uses expected defaults', () {
      const breakpoints = BreakpointsGranular.defaultBreakpoints;

      expect(breakpoints.jumboExtraLarge, 4096);
      expect(breakpoints.jumboLarge, 3840);
      expect(breakpoints.jumboNormal, 2560);
      expect(breakpoints.jumboSmall, 1920);
      expect(breakpoints.standardExtraLarge, 1280);
      expect(breakpoints.standardLarge, 1024);
      expect(breakpoints.standardNormal, 768);
      expect(breakpoints.standardSmall, 568);
      expect(breakpoints.compactExtraLarge, 480);
      expect(breakpoints.compactLarge, 430);
      expect(breakpoints.compactNormal, 360);
      expect(breakpoints.compactSmall, 300);
    });

    test('exposes enum values map including tiny fallback', () {
      const breakpoints = BreakpointsGranular(
        jumboExtraLarge: 3000,
        jumboLarge: 2800,
        jumboNormal: 2400,
        jumboSmall: 1900,
        standardExtraLarge: 1400,
        standardLarge: 1100,
        standardNormal: 800,
        standardSmall: 600,
        compactExtraLarge: 500,
        compactLarge: 440,
        compactNormal: 370,
        compactSmall: 320,
      );

      expect(
        breakpoints.values,
        equals(<LayoutSizeGranular, double>{
          LayoutSizeGranular.jumboExtraLarge: 3000,
          LayoutSizeGranular.jumboLarge: 2800,
          LayoutSizeGranular.jumboNormal: 2400,
          LayoutSizeGranular.jumboSmall: 1900,
          LayoutSizeGranular.standardExtraLarge: 1400,
          LayoutSizeGranular.standardLarge: 1100,
          LayoutSizeGranular.standardNormal: 800,
          LayoutSizeGranular.standardSmall: 600,
          LayoutSizeGranular.compactExtraLarge: 500,
          LayoutSizeGranular.compactLarge: 440,
          LayoutSizeGranular.compactNormal: 370,
          LayoutSizeGranular.compactSmall: 320,
          LayoutSizeGranular.tiny: -1,
        }),
      );
    });

    test('copyWith updates provided fields and keeps others', () {
      const original = BreakpointsGranular.defaultBreakpoints;

      final updated = original.copyWith(
        jumboNormal: 2500,
        standardSmall: 560,
        compactSmall: 290,
      );

      expect(updated.jumboNormal, 2500);
      expect(updated.standardSmall, 560);
      expect(updated.compactSmall, 290);
      expect(updated.jumboExtraLarge, original.jumboExtraLarge);
      expect(updated.compactLarge, original.compactLarge);
    });

    test('supports value equality and stable hashCode', () {
      const first = BreakpointsGranular.defaultBreakpoints;
      const second = BreakpointsGranular.defaultBreakpoints;
      const third = BreakpointsGranular(jumboLarge: 3800);

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('toString includes all thresholds', () {
      const breakpoints = BreakpointsGranular(
        jumboExtraLarge: 4100,
        jumboLarge: 3900,
        jumboNormal: 2600,
        jumboSmall: 2000,
        standardExtraLarge: 1300,
        standardLarge: 1050,
        standardNormal: 790,
        standardSmall: 570,
        compactExtraLarge: 490,
        compactLarge: 435,
        compactNormal: 365,
        compactSmall: 305,
      );

      expect(
        breakpoints.toString(),
        'BreakpointsGranular(jumboExtraLarge: 4100.0, jumboLarge: 3900.0, jumboNormal: 2600.0, jumboSmall: 2000.0, standardExtraLarge: 1300.0, standardLarge: 1050.0, standardNormal: 790.0, standardSmall: 570.0, compactExtraLarge: 490.0, compactLarge: 435.0, compactNormal: 365.0, compactSmall: 305.0)',
      );
    });

    test('asserts when thresholds are out of descending order', () {
      expect(
        () => BreakpointsGranular(
          jumboExtraLarge: 4000,
          jumboLarge: 4100,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('asserts when compactSmall is negative', () {
      expect(
        () => BreakpointsGranular(
          jumboExtraLarge: 4000,
          jumboLarge: 3900,
          jumboNormal: 2800,
          jumboSmall: 2000,
          standardExtraLarge: 1300,
          standardLarge: 1100,
          standardNormal: 800,
          standardSmall: 600,
          compactExtraLarge: 500,
          compactSmall: -1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
