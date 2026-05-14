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
  group('ScreenWithValueWidgetBuilderGranularOrientation', () {
    test('requires at least one portrait or landscape builder', () {
      expect(
        ScreenWithValueWidgetBuilderGranularOrientation<String>.new,
        throwsAssertionError,
      );
    });

    testWidgets('uses portrait builders when orientation is portrait', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 700),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSizeGranular, String>(
          breakpoints: _breakpoints,
          valueProvider: ResponsiveValueGranular<String>(
            breakpoints: _breakpoints,
            standardNormal: 'providerPortrait',
          ),
          child: ScreenWithValueWidgetBuilderGranularOrientation<String>(
            breakpoints: _breakpoints,
            standardNormal: (_, __) => const SizedBox(key: Key('portrait')),
            standardNormalLandscape: (_, __) =>
                const SizedBox(key: Key('landscape')),
          ),
        ),
      );

      expect(find.byKey(const Key('portrait')), findsOneWidget);
      expect(find.byKey(const Key('landscape')), findsNothing);
    });

    testWidgets('uses landscape builders when orientation is landscape', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 300),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSizeGranular, String>(
          breakpoints: _breakpoints,
          valueProvider: ResponsiveValueGranular<String>(
            breakpoints: _breakpoints,
            standardNormal: 'providerLandscape',
          ),
          child: ScreenWithValueWidgetBuilderGranularOrientation<String>(
            breakpoints: _breakpoints,
            standardNormal: (_, __) => const SizedBox(key: Key('portrait')),
            standardNormalLandscape: (_, __) =>
                const SizedBox(key: Key('landscape')),
          ),
        ),
      );

      expect(find.byKey(const Key('landscape')), findsOneWidget);
      expect(find.byKey(const Key('portrait')), findsNothing);
    });

    testWidgets(
      'falls back to portrait builders when landscape builders are empty',
      (tester) async {
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
            child: ScreenWithValueWidgetBuilderGranularOrientation<String>(
              breakpoints: _breakpoints,
              standardNormal: (_, __) =>
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
          customSize: const Size(450, 700),
          withScaffold: false,
          child: ScreenSizeWithValue<LayoutSizeGranular, String>(
            breakpoints: _breakpoints,
            valueProvider: ResponsiveValueGranular<String>(
              breakpoints: _breakpoints,
              standardNormal: 'providerValue',
            ),
            child: ScreenWithValueWidgetBuilderGranularOrientation<String>(
              breakpoints: _breakpoints,
              standardNormalLandscape: (_, __) =>
                  const SizedBox(key: Key('landscape-fallback')),
            ),
          ),
        );

        expect(find.byKey(const Key('landscape-fallback')), findsOneWidget);
      },
    );

    testWidgets('passes screen data and responsive value to resolved builder', (
      tester,
    ) async {
      ScreenSizeModelDataWithValue<LayoutSizeGranular, String>? resolvedData;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 300),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSizeGranular, String>(
          breakpoints: _breakpoints,
          valueProvider: ResponsiveValueGranular<String>(
            breakpoints: _breakpoints,
            standardNormal: 'providerLandscape',
          ),
          child: ScreenWithValueWidgetBuilderGranularOrientation<String>(
            breakpoints: _breakpoints,
            standardNormalLandscape: (_, data) {
              resolvedData = data;
              return const SizedBox(key: Key('resolved-child'));
            },
          ),
        ),
      );

      expect(find.byKey(const Key('resolved-child')), findsOneWidget);
      expect(resolvedData, isNotNull);
      expect(resolvedData!.screenSize, LayoutSizeGranular.standardNormal);
      expect(resolvedData!.logicalScreenWidth, 450);
      expect(resolvedData!.logicalScreenHeight, 300);
      expect(resolvedData!.orientation, Orientation.landscape);
      expect(resolvedData!.responsiveValue, 'providerLandscape');
    });

    testWidgets('wraps resolved child in AnimatedSwitcher when enabled', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 300),
        withScaffold: false,
        settle: false,
        child: ScreenSizeWithValue<LayoutSizeGranular, String>(
          breakpoints: _breakpoints,
          valueProvider: ResponsiveValueGranular<String>(
            breakpoints: _breakpoints,
            standardNormal: 'providerLandscape',
          ),
          child: ScreenWithValueWidgetBuilderGranularOrientation<String>(
            breakpoints: _breakpoints,
            standardNormalLandscape: (_, __) =>
                const SizedBox(key: Key('animated-child')),
            animateChange: true,
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byKey(const Key('animated-child')), findsOneWidget);
    });
  });
}
