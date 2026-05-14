import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenWidgetBuilderGranular', () {
    test('requires at least one builder', () {
      expect(
        ScreenWidgetBuilderGranular.new,
        throwsAssertionError,
      );
    });

    testWidgets(
      'resolves builder from screen width and exposes screen data by default',
      (tester) async {
        ScreenSizeModelData<LayoutSizeGranular>? resolvedData;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(420, 700),
          withScaffold: false,
          child: ScreenSize<LayoutSizeGranular>(
            breakpoints: BreakpointsGranular.defaultBreakpoints,
            child: ScreenWidgetBuilderGranular(
              compactNormal: (_, data) {
                resolvedData = data;
                return const SizedBox(key: Key('compact-normal'));
              },
              compactSmall: (_, data) =>
                  const SizedBox(key: Key('compact-small')),
            ),
          ),
        );

        expect(find.byKey(const Key('compact-normal')), findsOneWidget);
        expect(find.byKey(const Key('compact-small')), findsNothing);
        expect(resolvedData, isNotNull);
        expect(resolvedData!.screenSize, LayoutSizeGranular.compactNormal);
        expect(resolvedData!.logicalScreenWidth, 420);
        expect(resolvedData!.logicalScreenHeight, 700);
      },
    );

    testWidgets('uses custom breakpoints for handler resolution',
        (tester) async {
      const breakpoints = BreakpointsGranular(
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

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSizeGranular>(
          breakpoints: breakpoints,
          child: ScreenWidgetBuilderGranular(
            breakpoints: breakpoints,
            standardNormal: (_, __) =>
                const SizedBox(key: Key('standard-normal')),
            compactExtraLarge: (_, __) =>
                const SizedBox(key: Key('compact-extra-large')),
            tiny: (_, __) => const SizedBox(key: Key('tiny')),
          ),
        ),
      );

      expect(find.byKey(const Key('standard-normal')), findsOneWidget);
      expect(find.byKey(const Key('compact-extra-large')), findsNothing);
      expect(find.byKey(const Key('tiny')), findsNothing);
    });

    testWidgets('rebuilds handler when widget builders change', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1024, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSizeGranular>(
          breakpoints: BreakpointsGranular.defaultBreakpoints,
          child: ScreenWidgetBuilderGranular(
            standardLarge: (_, __) => const SizedBox(key: Key('first-value')),
          ),
        ),
      );

      expect(find.byKey(const Key('first-value')), findsOneWidget);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: ScreenSize<LayoutSizeGranular>(
            breakpoints: BreakpointsGranular.defaultBreakpoints,
            child: ScreenWidgetBuilderGranular(
              standardLarge: (_, __) =>
                  const SizedBox(key: Key('updated-value')),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('updated-value')), findsOneWidget);
      expect(find.byKey(const Key('first-value')), findsNothing);
    });

    testWidgets('wraps resolved child in AnimatedSwitcher when enabled', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(420, 700),
        withScaffold: false,
        settle: false,
        child: ScreenSize<LayoutSizeGranular>(
          breakpoints: BreakpointsGranular.defaultBreakpoints,
          child: ScreenWidgetBuilderGranular(
            compactNormal: (_, __) =>
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
