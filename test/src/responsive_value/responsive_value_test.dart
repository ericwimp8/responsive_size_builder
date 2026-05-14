import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('ResponsiveValue', () {
    test('requires at least one size value', () {
      expect(ResponsiveValue<int>.new, throwsAssertionError);
    });

    test('maps each LayoutSize to its configured value', () {
      final value = ResponsiveValue<int>(
        extraLarge: 5,
        large: 4,
        medium: 3,
        small: 2,
        extraSmall: 1,
      );

      expect(value.values, <LayoutSize, int?>{
        LayoutSize.extraLarge: 5,
        LayoutSize.large: 4,
        LayoutSize.medium: 3,
        LayoutSize.small: 2,
        LayoutSize.extraSmall: 1,
      });
    });

    test('uses configured breakpoints for screen-size classification', () {
      final value = ResponsiveValue<String>(
        breakpoints: const Breakpoints(
          extraLarge: 1000,
          large: 800,
          medium: 500,
          small: 300,
        ),
        medium: 'medium',
        extraSmall: 'extraSmall',
      );

      expect(value.getScreenSize(1200), LayoutSize.extraLarge);
      expect(value.getScreenSize(850), LayoutSize.large);
      expect(value.getScreenSize(550), LayoutSize.medium);
      expect(value.getScreenSize(350), LayoutSize.small);
      expect(value.getScreenSize(250), LayoutSize.extraSmall);
    });

    test('falls back to nearest populated lower breakpoint value', () {
      final value = ResponsiveValue<String>(
        large: 'large',
        extraSmall: 'extraSmall',
      );

      expect(
        value.getScreenSizeValue(screenSize: LayoutSize.extraLarge),
        'large',
      );
      expect(
        value.getScreenSizeValue(screenSize: LayoutSize.medium),
        'extraSmall',
      );
      expect(
        value.getScreenSizeValue(screenSize: LayoutSize.small),
        'extraSmall',
      );
    });
  });

  group('ResponsiveValueGranular', () {
    test('requires at least one size value', () {
      expect(ResponsiveValueGranular<int>.new, throwsAssertionError);
    });

    test('maps each LayoutSizeGranular to its configured value', () {
      final value = ResponsiveValueGranular<int>(
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

      expect(value.values, <LayoutSizeGranular, int?>{
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

    test('uses configured breakpoints for screen-size classification', () {
      final value = ResponsiveValueGranular<String>(
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

      expect(value.getScreenSize(1200), LayoutSizeGranular.jumboExtraLarge);
      expect(value.getScreenSize(950), LayoutSizeGranular.jumboLarge);
      expect(value.getScreenSize(850), LayoutSizeGranular.jumboNormal);
      expect(value.getScreenSize(750), LayoutSizeGranular.jumboSmall);
      expect(value.getScreenSize(650), LayoutSizeGranular.standardExtraLarge);
      expect(value.getScreenSize(550), LayoutSizeGranular.standardLarge);
      expect(value.getScreenSize(450), LayoutSizeGranular.standardNormal);
      expect(value.getScreenSize(350), LayoutSizeGranular.standardSmall);
      expect(value.getScreenSize(250), LayoutSizeGranular.compactExtraLarge);
      expect(value.getScreenSize(180), LayoutSizeGranular.compactLarge);
      expect(value.getScreenSize(120), LayoutSizeGranular.compactNormal);
      expect(value.getScreenSize(70), LayoutSizeGranular.compactSmall);
      expect(value.getScreenSize(40), LayoutSizeGranular.tiny);
    });

    test('falls back to nearest populated lower breakpoint value', () {
      final value = ResponsiveValueGranular<String>(
        standardLarge: 'standardLarge',
        compactSmall: 'compactSmall',
      );

      expect(
        value.getScreenSizeValue(
          screenSize: LayoutSizeGranular.jumboExtraLarge,
        ),
        'standardLarge',
      );
      expect(
        value.getScreenSizeValue(screenSize: LayoutSizeGranular.standardSmall),
        'compactSmall',
      );
      expect(
        value.getScreenSizeValue(screenSize: LayoutSizeGranular.tiny),
        'compactSmall',
      );
    });
  });
}
