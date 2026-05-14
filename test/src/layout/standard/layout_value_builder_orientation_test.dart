import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('LayoutValueBuilderOrientation', () {
    test('requires at least one portrait or landscape value', () {
      expect(
        () => LayoutValueBuilderOrientation<String>(
          builder: (_, __) => const SizedBox.shrink(),
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
        customSize: const Size(700, 1000),
        withScaffold: false,
        child: SizedBox(
          width: 450,
          height: 500,
          child: LayoutValueBuilderOrientation<String>(
            small: 'portraitValue',
            smallLandscape: 'landscapeValue',
            builder: (_, value) {
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
        customSize: const Size(1000, 700),
        withScaffold: false,
        child: SizedBox(
          width: 450,
          height: 500,
          child: LayoutValueBuilderOrientation<String>(
            small: 'portraitValue',
            smallLandscape: 'landscapeValue',
            builder: (_, value) {
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
            child: LayoutValueBuilderOrientation<String>(
              small: 'portraitFallback',
              builder: (_, value) {
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
            child: LayoutValueBuilderOrientation<String>(
              smallLandscape: 'landscapeFallback',
              builder: (_, value) {
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

        const breakpoints = Breakpoints(
          extraLarge: 950,
          large: 900,
          medium: 800,
          small: 750,
        );

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(1000, 700),
          withScaffold: false,
          child: LayoutValueBuilderOrientation<String>(
            breakpoints: breakpoints,
            extraLargeLandscape: 'extraLargeLandscape',
            extraSmallLandscape: 'extraSmallLandscape',
            useShortestSide: true,
            builder: (_, value) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        );

        expect(resolvedValue, 'extraSmallLandscape');
      },
    );
  });
}
