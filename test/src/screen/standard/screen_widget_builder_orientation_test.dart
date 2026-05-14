import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenWidgetBuilderOrientation', () {
    test('requires at least one portrait or landscape builder', () {
      expect(
        ScreenWidgetBuilderOrientation.new,
        throwsAssertionError,
      );
    });

    testWidgets('uses portrait builders when orientation is portrait', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(620, 900),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenWidgetBuilderOrientation(
            medium: (_, __) => const SizedBox(key: Key('portrait-value')),
            mediumLandscape: (_, __) =>
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
        customSize: const Size(980, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenWidgetBuilderOrientation(
            large: (_, __) => const SizedBox(key: Key('portrait-value')),
            largeLandscape: (_, __) =>
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
          customSize: const Size(980, 700),
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenWidgetBuilderOrientation(
              large: (_, __) => const SizedBox(key: Key('portrait-fallback')),
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
          customSize: const Size(620, 900),
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenWidgetBuilderOrientation(
              mediumLandscape: (_, __) =>
                  const SizedBox(key: Key('landscape-fallback')),
            ),
          ),
        );

        expect(find.byKey(const Key('landscape-fallback')), findsOneWidget);
      },
    );

    testWidgets('passes screen data to resolved builder', (tester) async {
      ScreenSizeModelData<LayoutSize>? resolvedData;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenWidgetBuilderOrientation(
            largeLandscape: (_, data) {
              resolvedData = data;
              return const SizedBox(key: Key('resolved-child'));
            },
          ),
        ),
      );

      expect(find.byKey(const Key('resolved-child')), findsOneWidget);
      expect(resolvedData, isNotNull);
      expect(resolvedData!.screenSize, LayoutSize.large);
      expect(resolvedData!.logicalScreenWidth, 980);
      expect(resolvedData!.logicalScreenHeight, 700);
      expect(resolvedData!.orientation, Orientation.landscape);
    });

    testWidgets('wraps resolved child in AnimatedSwitcher when enabled', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 700),
        withScaffold: false,
        settle: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenWidgetBuilderOrientation(
            largeLandscape: (_, __) =>
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
