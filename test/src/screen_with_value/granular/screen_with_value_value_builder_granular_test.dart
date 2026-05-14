import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenWithValueValueBuilderGranular', () {
    test('requires at least one value', () {
      expect(
        () => ScreenWithValueValueBuilderGranular<String, String>(
          builder: (_, __, {data, responsiveValue}) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
      'resolves value and exposes responsive value when provider is present',
      (tester) async {
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
            child: ScreenWithValueValueBuilderGranular<String, String>(
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
        expect(resolvedData!.logicalScreenWidth, 1024);
        expect(resolvedData!.logicalScreenHeight, 700);
      },
    );

    testWidgets('rebuilds handler when widget values change', (tester) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1024, 700),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSizeGranular, String>(
          breakpoints: BreakpointsGranular.defaultBreakpoints,
          valueProvider: ResponsiveValueGranular<String>(
            standardLarge: 'providerValue',
          ),
          child: ScreenWithValueValueBuilderGranular<String, String>(
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
          child: ScreenSizeWithValue<LayoutSizeGranular, String>(
            breakpoints: BreakpointsGranular.defaultBreakpoints,
            valueProvider: ResponsiveValueGranular<String>(
              standardLarge: 'providerValue',
            ),
            child: ScreenWithValueValueBuilderGranular<String, String>(
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
