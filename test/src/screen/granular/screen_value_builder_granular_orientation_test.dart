import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

const _breakpoints = BreakpointsGranular(
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
);

void main() {
  group('ScreenValueBuilderGranularOrientation', () {
    test('requires at least one portrait or landscape value', () {
      expect(
        () => ScreenValueBuilderGranularOrientation<String, String>(
          builder: (_, __, {data, responsiveValue}) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('uses portrait values when orientation is portrait', (
      tester,
    ) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSizeGranular>(
          breakpoints: _breakpoints,
          child: ScreenValueBuilderGranularOrientation<String, String>(
            breakpoints: _breakpoints,
            standardNormal: 'portraitValue',
            standardNormalLandscape: 'landscapeValue',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'portraitValue');
    });

    testWidgets('uses landscape values when orientation is landscape', (
      tester,
    ) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 300),
        withScaffold: false,
        child: ScreenSize<LayoutSizeGranular>(
          breakpoints: _breakpoints,
          child: ScreenValueBuilderGranularOrientation<String, String>(
            breakpoints: _breakpoints,
            standardNormal: 'portraitValue',
            standardNormalLandscape: 'landscapeValue',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'landscapeValue');
    });

    testWidgets(
      'falls back to portrait values when landscape values are empty',
      (tester) async {
        String? resolvedValue;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(450, 300),
          withScaffold: false,
          child: ScreenSize<LayoutSizeGranular>(
            breakpoints: _breakpoints,
            child: ScreenValueBuilderGranularOrientation<String, String>(
              breakpoints: _breakpoints,
              standardNormal: 'portraitFallback',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'portraitFallback');
      },
    );

    testWidgets(
      'falls back to landscape values when portrait values are empty',
      (tester) async {
        String? resolvedValue;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(450, 700),
          withScaffold: false,
          child: ScreenSize<LayoutSizeGranular>(
            breakpoints: _breakpoints,
            child: ScreenValueBuilderGranularOrientation<String, String>(
              breakpoints: _breakpoints,
              standardNormalLandscape: 'landscapeFallback',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'landscapeFallback');
      },
    );

    testWidgets('passes screen data and responsive value when available', (
      tester,
    ) async {
      String? resolvedValue;
      String? resolvedResponsiveValue;
      ScreenSizeModelData<LayoutSizeGranular>? resolvedData;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 300),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSizeGranular, String>(
          breakpoints: _breakpoints,
          valueProvider: ResponsiveValueGranular<String>(
            breakpoints: _breakpoints,
            standardNormal: 'providerValue',
          ),
          child: ScreenValueBuilderGranularOrientation<String, String>(
            breakpoints: _breakpoints,
            standardNormal: 'portraitValue',
            standardNormalLandscape: 'landscapeValue',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              resolvedData = data;
              resolvedResponsiveValue = responsiveValue;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'landscapeValue');
      expect(resolvedResponsiveValue, 'providerValue');
      expect(resolvedData, isNotNull);
      expect(resolvedData!.screenSize, LayoutSizeGranular.standardNormal);
      expect(resolvedData!.orientation, Orientation.landscape);
    });
  });
}
