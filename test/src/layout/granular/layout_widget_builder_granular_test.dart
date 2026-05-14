import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('LayoutWidgetBuilderGranular', () {
    testWidgets('requires at least one builder', (tester) async {
      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: const LayoutWidgetBuilderGranular(),
        ),
      );

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('resolves builder from layout width by default',
        (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(420, 700),
        withScaffold: false,
        child: LayoutWidgetBuilderGranular(
          compactNormal: (_) => const SizedBox(key: Key('compact-normal')),
          compactSmall: (_) => const SizedBox(key: Key('compact-small')),
        ),
      );

      expect(find.byKey(const Key('compact-normal')), findsOneWidget);
      expect(find.byKey(const Key('compact-small')), findsNothing);
    });

    testWidgets(
      'uses shortest side classification when useShortestSide is true',
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
          customSize: const Size(450, 250),
          withScaffold: false,
          child: LayoutWidgetBuilderGranular(
            breakpoints: breakpoints,
            standardNormal: (_) => const SizedBox(key: Key('standard-normal')),
            compactExtraLarge: (_) =>
                const SizedBox(key: Key('compact-extra-large')),
            tiny: (_) => const SizedBox(key: Key('tiny')),
            useShortestSide: true,
          ),
        );

        expect(find.byKey(const Key('compact-extra-large')), findsOneWidget);
        expect(find.byKey(const Key('standard-normal')), findsNothing);
      },
    );

    testWidgets('rebuilds handler when widget builders change', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1024, 700),
        withScaffold: false,
        child: LayoutWidgetBuilderGranular(
          standardLarge: (_) => const SizedBox(key: Key('first-value')),
        ),
      );

      expect(find.byKey(const Key('first-value')), findsOneWidget);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutWidgetBuilderGranular(
            standardLarge: (_) => const SizedBox(key: Key('updated-value')),
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
        child: LayoutWidgetBuilderGranular(
          compactNormal: (_) => const SizedBox(key: Key('animated-child')),
          animateChange: true,
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byKey(const Key('animated-child')), findsOneWidget);
    });
  });
}
