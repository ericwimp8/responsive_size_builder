import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('LayoutWidgetBuilderOrientation', () {
    test('requires at least one portrait or landscape builder', () {
      expect(LayoutWidgetBuilderOrientation.new, throwsAssertionError);
    });

    testWidgets('uses portrait builders when orientation is portrait', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(700, 1000),
        withScaffold: false,
        child: SizedBox(
          width: 450,
          height: 500,
          child: LayoutWidgetBuilderOrientation(
            small: (_) => const SizedBox(key: Key('portrait-value')),
            smallLandscape: (_) => const SizedBox(key: Key('landscape-value')),
          ),
        ),
      );

      expect(find.byKey(const Key('portrait-value')), findsOneWidget);
      expect(find.byKey(const Key('landscape-value')), findsNothing);
    });

    testWidgets('uses landscape builders when orientation is landscape', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1000, 700),
        withScaffold: false,
        child: SizedBox(
          width: 450,
          height: 500,
          child: LayoutWidgetBuilderOrientation(
            small: (_) => const SizedBox(key: Key('portrait-value')),
            smallLandscape: (_) => const SizedBox(key: Key('landscape-value')),
          ),
        ),
      );

      expect(find.byKey(const Key('landscape-value')), findsOneWidget);
      expect(find.byKey(const Key('portrait-value')), findsNothing);
    });

    testWidgets(
      'falls back to portrait builders when landscape builders are empty',
      (tester) async {
        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(1000, 700),
          withScaffold: false,
          child: SizedBox(
            width: 450,
            height: 500,
            child: LayoutWidgetBuilderOrientation(
              small: (_) => const SizedBox(key: Key('portrait-fallback')),
            ),
          ),
        );

        expect(find.byKey(const Key('portrait-fallback')), findsOneWidget);
      },
    );

    testWidgets(
      'falls back to landscape builders when portrait builders are empty',
      (tester) async {
        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(700, 1000),
          withScaffold: false,
          child: SizedBox(
            width: 450,
            height: 500,
            child: LayoutWidgetBuilderOrientation(
              smallLandscape: (_) =>
                  const SizedBox(key: Key('landscape-fallback')),
            ),
          ),
        );

        expect(find.byKey(const Key('landscape-fallback')), findsOneWidget);
      },
    );

    testWidgets(
      'uses shortest side classification when useShortestSide is true',
      (tester) async {
        const breakpoints = Breakpoints(
          extraLarge: 900,
          large: 800,
          medium: 700,
          small: 600,
        );

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(1000, 650),
          withScaffold: false,
          child: LayoutWidgetBuilderOrientation(
            breakpoints: breakpoints,
            extraLargeLandscape: (_) =>
                const SizedBox(key: Key('extra-large-landscape')),
            smallLandscape: (_) => const SizedBox(key: Key('small-landscape')),
            useShortestSide: true,
          ),
        );

        expect(find.byKey(const Key('small-landscape')), findsOneWidget);
        expect(find.byKey(const Key('extra-large-landscape')), findsNothing);
      },
    );

    testWidgets('wraps resolved child in AnimatedSwitcher when enabled', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1000, 700),
        withScaffold: false,
        settle: false,
        child: LayoutWidgetBuilderOrientation(
          smallLandscape: (_) => const SizedBox(key: Key('animated-child')),
          animateChange: true,
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byKey(const Key('animated-child')), findsOneWidget);
    });
  });
}
