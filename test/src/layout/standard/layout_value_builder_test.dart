import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('LayoutValueBuilder', () {
    test('requires at least one value', () {
      expect(
        () => LayoutValueBuilder<String>(
          builder: (_, __, constraints) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('resolves value from layout width by default', (tester) async {
      String? resolvedValue;
      BoxConstraints? resolvedConstraints;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(620, 900),
        withScaffold: false,
        child: LayoutValueBuilder<String>(
          medium: 'medium',
          small: 'small',
          builder: (_, value, constraints) {
            resolvedValue = value;
            resolvedConstraints = constraints;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(resolvedValue, 'medium');
      expect(resolvedConstraints?.maxWidth, 620);
      expect(resolvedConstraints?.maxHeight, 900);
    });

    testWidgets(
      'uses shortest side classification when useShortestSide is true',
      (tester) async {
        String? resolvedValue;

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
          child: LayoutValueBuilder<String>(
            breakpoints: breakpoints,
            large: 'large',
            medium: 'medium',
            extraSmall: 'extraSmall',
            useShortestSide: true,
            builder: (_, value, constraints) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        );

        expect(resolvedValue, 'extraSmall');
      },
    );

    testWidgets('rebuilds handler when widget values change', (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 800),
        withScaffold: false,
        child: LayoutValueBuilder<String>(
          large: 'firstValue',
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
          child: LayoutValueBuilder<String>(
            large: 'updatedValue',
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

    testWidgets('rebuilds handler when breakpoints change', (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(650, 900),
        withScaffold: false,
        child: LayoutValueBuilder<String>(
          breakpoints: const Breakpoints(
            extraLarge: 700,
            large: 600,
            medium: 500,
            small: 400,
          ),
          large: 'largeValue',
          small: 'smallValue',
          builder: (_, value, constraints) {
            resolvedValue = value;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(resolvedValue, 'largeValue');

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutValueBuilder<String>(
            breakpoints: const Breakpoints(
              extraLarge: 900,
              large: 800,
              medium: 700,
              small: 600,
            ),
            large: 'largeValue',
            small: 'smallValue',
            builder: (_, value, constraints) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pump();

      expect(resolvedValue, 'smallValue');
    });
  });
}
