import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenValueBuilder', () {
    test('requires at least one value', () {
      expect(
        () => ScreenValueBuilder<String, String>(
          builder: (_, __, {data, responsiveValue}) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
      'resolves value from screen width and exposes screen data by default',
      (tester) async {
        String? resolvedValue;
        String? resolvedResponsiveValue;
        ScreenSizeModelData<LayoutSize>? resolvedData;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(620, 900),
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenValueBuilder<String, String>(
              medium: 'medium',
              small: 'small',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                resolvedData = data;
                resolvedResponsiveValue = responsiveValue;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'medium');
        expect(resolvedResponsiveValue, isNull);
        expect(resolvedData, isNotNull);
        expect(resolvedData!.screenSize, LayoutSize.medium);
        expect(resolvedData!.logicalScreenWidth, 620);
        expect(resolvedData!.logicalScreenHeight, 900);
      },
    );

    testWidgets('passes responsiveValue when ScreenSizeWithValue is present', (
      tester,
    ) async {
      String? resolvedValue;
      String? resolvedResponsiveValue;
      ScreenSizeModelData<LayoutSize>? resolvedData;

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
          child: ScreenValueBuilder<String, String>(
            large: 'fromBuilder',
            medium: 'builderFallback',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              resolvedData = data;
              resolvedResponsiveValue = responsiveValue;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'fromBuilder');
      expect(resolvedResponsiveValue, 'fromProvider');
      expect(resolvedData, isNotNull);
      expect(resolvedData!.screenSize, LayoutSize.large);
    });

    testWidgets('rebuilds handler when widget values change', (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenValueBuilder<String, String>(
            large: 'firstValue',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'firstValue');

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenValueBuilder<String, String>(
              large: 'updatedValue',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      await tester.pump();

      expect(resolvedValue, 'updatedValue');
    });
  });
}
