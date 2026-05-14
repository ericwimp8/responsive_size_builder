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
  group('LayoutWidgetBuilderGranularOrientation', () {
    testWidgets('requires at least one portrait or landscape builder', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: const LayoutWidgetBuilderGranularOrientation(),
        ),
      );

      expect(tester.takeException(), isFlutterError);
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
          child: LayoutWidgetBuilderGranularOrientation(
            breakpoints: _breakpoints,
            standardNormal: (_) => const SizedBox(key: Key('portrait-value')),
            standardNormalLandscape: (_) =>
                const SizedBox(key: Key('landscape-value')),
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
          child: LayoutWidgetBuilderGranularOrientation(
            breakpoints: _breakpoints,
            standardNormal: (_) => const SizedBox(key: Key('portrait-value')),
            standardNormalLandscape: (_) =>
                const SizedBox(key: Key('landscape-value')),
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
            child: LayoutWidgetBuilderGranularOrientation(
              breakpoints: _breakpoints,
              standardNormal: (_) =>
                  const SizedBox(key: Key('portrait-fallback')),
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
            child: LayoutWidgetBuilderGranularOrientation(
              breakpoints: _breakpoints,
              standardNormalLandscape: (_) =>
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
        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(450, 250),
          withScaffold: false,
          child: LayoutWidgetBuilderGranularOrientation(
            breakpoints: _breakpoints,
            standardNormalLandscape: (_) =>
                const SizedBox(key: Key('standard-normal-landscape')),
            compactExtraLargeLandscape: (_) =>
                const SizedBox(key: Key('compact-extra-large-landscape')),
            useShortestSide: true,
          ),
        );

        expect(
          find.byKey(const Key('compact-extra-large-landscape')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('standard-normal-landscape')),
          findsNothing,
        );
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
        child: LayoutWidgetBuilderGranularOrientation(
          breakpoints: _breakpoints,
          standardNormalLandscape: (_) =>
              const SizedBox(key: Key('animated-child')),
          animateChange: true,
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byKey(const Key('animated-child')), findsOneWidget);
    });
  });
}
