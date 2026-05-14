import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenWidgetBuilder', () {
    test('requires at least one builder', () {
      expect(
        ScreenWidgetBuilder.new,
        throwsAssertionError,
      );
    });

    testWidgets(
      'resolves builder from screen width and exposes screen data by default',
      (tester) async {
        ScreenSizeModelData<LayoutSize>? resolvedData;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(620, 900),
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenWidgetBuilder(
              medium: (_, data) {
                resolvedData = data;
                return const SizedBox(key: Key('medium'));
              },
              small: (_, __) => const SizedBox(key: Key('small')),
            ),
          ),
        );

        expect(find.byKey(const Key('medium')), findsOneWidget);
        expect(find.byKey(const Key('small')), findsNothing);
        expect(resolvedData, isNotNull);
        expect(resolvedData!.screenSize, LayoutSize.medium);
        expect(resolvedData!.logicalScreenWidth, 620);
        expect(resolvedData!.logicalScreenHeight, 900);
      },
    );

    testWidgets('uses custom breakpoints for handler resolution', (
      tester,
    ) async {
      const breakpoints = Breakpoints(
        extraLarge: 900,
        large: 700,
        medium: 400,
        small: 250,
      );

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(450, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: breakpoints,
          child: ScreenWidgetBuilder(
            breakpoints: breakpoints,
            medium: (_, __) => const SizedBox(key: Key('medium')),
            small: (_, __) => const SizedBox(key: Key('small')),
            extraSmall: (_, __) => const SizedBox(key: Key('extra-small')),
          ),
        ),
      );

      expect(find.byKey(const Key('medium')), findsOneWidget);
      expect(find.byKey(const Key('small')), findsNothing);
      expect(find.byKey(const Key('extra-small')), findsNothing);
    });

    testWidgets('rebuilds handler when widget builders change', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenWidgetBuilder(
            large: (_, __) => const SizedBox(key: Key('first-value')),
          ),
        ),
      );

      expect(find.byKey(const Key('first-value')), findsOneWidget);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenWidgetBuilder(
              large: (_, __) => const SizedBox(key: Key('updated-value')),
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
        customSize: const Size(620, 900),
        withScaffold: false,
        settle: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenWidgetBuilder(
            medium: (_, __) => const SizedBox(key: Key('animated-child')),
            animateChange: true,
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byKey(const Key('animated-child')), findsOneWidget);
    });
  });
}
