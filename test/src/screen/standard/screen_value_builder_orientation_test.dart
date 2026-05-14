import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenValueBuilderOrientation', () {
    test('requires at least one portrait or landscape value', () {
      expect(
        () => ScreenValueBuilderOrientation<String, String>(
          builder: (_, __, {data, responsiveValue}) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets('uses portrait values when orientation is portrait', (
      tester,
    ) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(620, 900),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenValueBuilderOrientation<String, String>(
            medium: 'portraitValue',
            mediumLandscape: 'landscapeValue',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'portraitValue');
    });

    testWidgets('uses landscape values when orientation is landscape', (
      tester,
    ) async {
      String? resolvedValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(980, 700),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenValueBuilderOrientation<String, String>(
            large: 'portraitValue',
            largeLandscape: 'landscapeValue',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'landscapeValue');
    });

    testWidgets(
      'falls back to portrait values when landscape values are empty',
      (tester) async {
        String? resolvedValue;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(980, 700),
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenValueBuilderOrientation<String, String>(
              large: 'portraitFallback',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'portraitFallback');
      },
    );

    testWidgets(
      'falls back to landscape values when portrait values are empty',
      (tester) async {
        String? resolvedValue;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(620, 900),
          withScaffold: false,
          child: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenValueBuilderOrientation<String, String>(
              mediumLandscape: 'landscapeFallback',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'landscapeFallback');
      },
    );

    testWidgets('passes screen data and responsive value when available', (
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
            large: 'providerValue',
          ),
          child: ScreenValueBuilderOrientation<String, String>(
            large: 'portraitValue',
            largeLandscape: 'landscapeValue',
            builder: (_, value, {data, responsiveValue}) {
              resolvedValue = value;
              resolvedData = data;
              resolvedResponsiveValue = responsiveValue;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedValue, 'landscapeValue');
      expect(resolvedResponsiveValue, 'providerValue');
      expect(resolvedData, isNotNull);
      expect(resolvedData!.screenSize, LayoutSize.large);
      expect(resolvedData!.orientation, Orientation.landscape);
    });
  });
}
