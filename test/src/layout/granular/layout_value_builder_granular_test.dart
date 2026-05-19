import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('LayoutValueBuilderGranular', () {
    test('requires at least one value', () {
      expect(
        () => LayoutValueBuilderGranular<String>(
          builder: (_, __, constraints) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('resolves value from layout width by default', (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(420, 700),
        withScaffold: false,
        child: LayoutValueBuilderGranular<String>(
          compactNormal: 'compactNormal',
          compactSmall: 'compactSmall',
          builder: (_, value, constraints) {
            resolvedValue = value;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(resolvedValue, 'compactNormal');
    });

    testWidgets(
      'uses shortest side classification when useShortestSide is true',
      (tester) async {
        String? resolvedValue;

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
          child: LayoutValueBuilderGranular<String>(
            breakpoints: breakpoints,
            standardNormal: 'standardNormal',
            compactExtraLarge: 'compactExtraLarge',
            tiny: 'tiny',
            useShortestSide: true,
            builder: (_, value, constraints) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        );

        expect(resolvedValue, 'compactExtraLarge');
      },
    );

    testWidgets('rebuilds handler when widget values change', (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1024, 600),
        withScaffold: false,
        child: LayoutValueBuilderGranular<String>(
          standardLarge: 'firstValue',
          builder: (_, value, constraints) {
            resolvedValue = value;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(resolvedValue, 'firstValue');

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutValueBuilderGranular<String>(
            standardLarge: 'updatedValue',
            builder: (_, value, constraints) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      expect(resolvedValue, 'updatedValue');
    });
  });
}
