import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenWithValueWidgetBuilder', () {
    test('requires at least one builder', () {
      expect(
        ScreenWithValueWidgetBuilder<String>.new,
        throwsAssertionError,
      );
    });

    testWidgets(
      'resolves builder from screen width and exposes screen data with responsive value',
      (tester) async {
        ScreenSizeModelDataWithValue<LayoutSize, String>? resolvedData;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(980, 700),
          withScaffold: false,
          child: ScreenSizeWithValue<LayoutSize, String>(
            breakpoints: Breakpoints.defaultBreakpoints,
            valueProvider: ResponsiveValue<String>(
              large: 'fromProvider',
              medium: 'providerFallback',
            ),
            child: ScreenWithValueWidgetBuilder<String>(
              large: (_, data) {
                resolvedData = data;
                return const SizedBox(key: Key('large'));
              },
              medium: (_, __) => const SizedBox(key: Key('medium')),
            ),
          ),
        );

        expect(find.byKey(const Key('large')), findsOneWidget);
        expect(find.byKey(const Key('medium')), findsNothing);
        expect(resolvedData, isNotNull);
        expect(resolvedData!.screenSize, LayoutSize.large);
        expect(resolvedData!.responsiveValue, 'fromProvider');
        expect(resolvedData!.logicalScreenWidth, 980);
        expect(resolvedData!.logicalScreenHeight, 700);
      },
    );

    testWidgets('uses custom breakpoints for handler resolution',
        (tester) async {
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
        child: ScreenSizeWithValue<LayoutSize, String>(
          breakpoints: breakpoints,
          valueProvider: ResponsiveValue<String>(
            breakpoints: breakpoints,
            medium: 'providerMedium',
            small: 'providerSmall',
          ),
          child: ScreenWithValueWidgetBuilder<String>(
            breakpoints: breakpoints,
            medium: (_, data) => SizedBox(
              key: const Key('medium'),
              child: Text(data.responsiveValue),
            ),
            small: (_, __) => const SizedBox(key: Key('small')),
            extraSmall: (_, __) => const SizedBox(key: Key('extra-small')),
          ),
        ),
      );

      expect(find.byKey(const Key('medium')), findsOneWidget);
      expect(find.text('providerMedium'), findsOneWidget);
      expect(find.byKey(const Key('small')), findsNothing);
      expect(find.byKey(const Key('extra-small')), findsNothing);
    });

    testWidgets('rebuilds handler when widget builders change', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 700),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSize, String>(
          breakpoints: Breakpoints.defaultBreakpoints,
          valueProvider: ResponsiveValue<String>(
            large: 'providerValue',
          ),
          child: ScreenWithValueWidgetBuilder<String>(
            large: (_, __) => const SizedBox(key: Key('first-value')),
          ),
        ),
      );

      expect(find.byKey(const Key('first-value')), findsOneWidget);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: ScreenSizeWithValue<LayoutSize, String>(
            breakpoints: Breakpoints.defaultBreakpoints,
            valueProvider: ResponsiveValue<String>(
              large: 'providerValue',
            ),
            child: ScreenWithValueWidgetBuilder<String>(
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
        customSize: const Size(980, 700),
        withScaffold: false,
        settle: false,
        child: ScreenSizeWithValue<LayoutSize, String>(
          breakpoints: Breakpoints.defaultBreakpoints,
          valueProvider: ResponsiveValue<String>(
            large: 'providerValue',
          ),
          child: ScreenWithValueWidgetBuilder<String>(
            large: (_, __) => const SizedBox(key: Key('animated-child')),
            animateChange: true,
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byKey(const Key('animated-child')), findsOneWidget);
    });
  });
}
