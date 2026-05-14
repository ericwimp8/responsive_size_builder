import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenValueBuilderGranular', () {
    test('requires at least one value', () {
      expect(
        () => ScreenValueBuilderGranular<String, String>(
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
        ScreenSizeModelData<LayoutSizeGranular>? resolvedData;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(420, 700),
          withScaffold: false,
          child: ScreenSize<LayoutSizeGranular>(
            breakpoints: BreakpointsGranular.defaultBreakpoints,
            child: ScreenValueBuilderGranular<String, String>(
              compactNormal: 'compactNormal',
              compactSmall: 'compactSmall',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                resolvedData = data;
                resolvedResponsiveValue = responsiveValue;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'compactNormal');
        expect(resolvedResponsiveValue, isNull);
        expect(resolvedData, isNotNull);
        expect(resolvedData!.screenSize, LayoutSizeGranular.compactNormal);
        expect(resolvedData!.logicalScreenWidth, 420);
        expect(resolvedData!.logicalScreenHeight, 700);
      },
    );

    testWidgets('passes responsiveValue when ScreenSizeWithValue is present', (
      tester,
    ) async {
      String? resolvedValue;
      String? resolvedResponsiveValue;
      ScreenSizeModelData<LayoutSizeGranular>? resolvedData;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1024, 700),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSizeGranular, String>(
          breakpoints: BreakpointsGranular.defaultBreakpoints,
          valueProvider: ResponsiveValueGranular<String>(
            standardLarge: 'fromProvider',
            compactNormal: 'providerFallback',
          ),
          child: ScreenValueBuilderGranular<String, String>(
            standardLarge: 'fromBuilder',
            compactNormal: 'builderFallback',
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
      expect(resolvedData!.screenSize, LayoutSizeGranular.standardLarge);
    });

    testWidgets('rebuilds handler when widget values change', (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1024, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSizeGranular>(
          breakpoints: BreakpointsGranular.defaultBreakpoints,
          child: ScreenValueBuilderGranular<String, String>(
            standardLarge: 'firstValue',
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
          child: ScreenSize<LayoutSizeGranular>(
            breakpoints: BreakpointsGranular.defaultBreakpoints,
            child: ScreenValueBuilderGranular<String, String>(
              standardLarge: 'updatedValue',
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
