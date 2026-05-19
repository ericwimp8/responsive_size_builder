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
  group('LayoutValueBuilderGranularOrientation', () {
    test('requires at least one portrait or landscape value', () {
      expect(
        () => LayoutValueBuilderGranularOrientation<String>(
          builder: (_, __, constraints) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('uses portrait values when orientation is portrait',
        (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(700, 1000),
        withScaffold: false,
        child: SizedBox(
          width: 450,
          height: 500,
          child: LayoutValueBuilderGranularOrientation<String>(
            breakpoints: _breakpoints,
            standardNormal: 'portraitValue',
            standardNormalLandscape: 'landscapeValue',
            builder: (_, value, constraints) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'portraitValue');
    });

    testWidgets('uses landscape values when orientation is landscape',
        (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1000, 700),
        withScaffold: false,
        child: SizedBox(
          width: 450,
          height: 500,
          child: LayoutValueBuilderGranularOrientation<String>(
            breakpoints: _breakpoints,
            standardNormal: 'portraitValue',
            standardNormalLandscape: 'landscapeValue',
            builder: (_, value, constraints) {
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
          customSize: const Size(1000, 700),
          withScaffold: false,
          child: SizedBox(
            width: 450,
            height: 500,
            child: LayoutValueBuilderGranularOrientation<String>(
              breakpoints: _breakpoints,
              standardNormal: 'portraitFallback',
              builder: (_, value, constraints) {
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
          customSize: const Size(700, 1000),
          withScaffold: false,
          child: SizedBox(
            width: 450,
            height: 500,
            child: LayoutValueBuilderGranularOrientation<String>(
              breakpoints: _breakpoints,
              standardNormalLandscape: 'landscapeFallback',
              builder: (_, value, constraints) {
                resolvedValue = value;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'landscapeFallback');
      },
    );

    testWidgets(
      'uses shortest side classification when useShortestSide is true',
      (tester) async {
        String? resolvedValue;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(450, 250),
          withScaffold: false,
          child: LayoutValueBuilderGranularOrientation<String>(
            breakpoints: _breakpoints,
            standardNormalLandscape: 'standardNormalLandscape',
            compactExtraLargeLandscape: 'compactExtraLargeLandscape',
            useShortestSide: true,
            builder: (_, value, constraints) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        );

        expect(resolvedValue, 'compactExtraLargeLandscape');
      },
    );
  });
}
