import 'package:flutter/material.dart' hide LayoutWidgetBuilder;
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('LayoutWidgetBuilder', () {
    test('requires at least one builder', () {
      expect(
        LayoutWidgetBuilder.new,
        throwsAssertionError,
      );
    });

    testWidgets('resolves builder from layout width by default',
        (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(620, 900),
        withScaffold: false,
        child: LayoutWidgetBuilder(
          medium: (_) => const SizedBox(key: Key('medium')),
          small: (_) => const SizedBox(key: Key('small')),
        ),
      );

      expect(find.byKey(const Key('medium')), findsOneWidget);
      expect(find.byKey(const Key('small')), findsNothing);
    });

    testWidgets(
      'uses shortest side classification when useShortestSide is true',
      (tester) async {
        const breakpoints = Breakpoints(
          extraLarge: 700,
          large: 600,
          medium: 500,
          small: 400,
        );

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(640, 300),
          withScaffold: false,
          child: LayoutWidgetBuilder(
            breakpoints: breakpoints,
            large: (_) => const SizedBox(key: Key('large')),
            medium: (_) => const SizedBox(key: Key('medium')),
            extraSmall: (_) => const SizedBox(key: Key('extra-small')),
            useShortestSide: true,
          ),
        );

        expect(find.byKey(const Key('extra-small')), findsOneWidget);
        expect(find.byKey(const Key('large')), findsNothing);
      },
    );

    testWidgets('rebuilds handler when widget builders change', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 800),
        withScaffold: false,
        child: LayoutWidgetBuilder(
          large: (_) => const SizedBox(key: Key('first-value')),
        ),
      );

      expect(find.byKey(const Key('first-value')), findsOneWidget);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutWidgetBuilder(
            large: (_) => const SizedBox(key: Key('updated-value')),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('updated-value')), findsOneWidget);
      expect(find.byKey(const Key('first-value')), findsNothing);
    });

    testWidgets('rebuilds handler when breakpoints change', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(650, 900),
        withScaffold: false,
        child: LayoutWidgetBuilder(
          breakpoints: const Breakpoints(
            extraLarge: 700,
            large: 600,
            medium: 500,
            small: 400,
          ),
          large: (_) => const SizedBox(key: Key('large-value')),
          small: (_) => const SizedBox(key: Key('small-value')),
        ),
      );

      expect(find.byKey(const Key('large-value')), findsOneWidget);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutWidgetBuilder(
            breakpoints: const Breakpoints(
              extraLarge: 900,
              large: 800,
              medium: 700,
              small: 600,
            ),
            large: (_) => const SizedBox(key: Key('large-value')),
            small: (_) => const SizedBox(key: Key('small-value')),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('small-value')), findsOneWidget);
      expect(find.byKey(const Key('large-value')), findsNothing);
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
        child: LayoutWidgetBuilder(
          medium: (_) => const SizedBox(key: Key('animated-child')),
          animateChange: true,
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byKey(const Key('animated-child')), findsOneWidget);
    });
  });
}
