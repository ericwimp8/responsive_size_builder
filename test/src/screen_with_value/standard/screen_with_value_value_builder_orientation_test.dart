import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../../harness/harness.dart';

void main() {
  group('ScreenWithValueValueBuilderOrientation', () {
    test('requires at least one portrait or landscape value', () {
      expect(
        () => ScreenWithValueValueBuilderOrientation<String, String>(
          builder: (_, __, {data, responsiveValue}) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
      'uses portrait values in portrait orientation and exposes provider value',
      (tester) async {
        String? resolvedValue;
        String? resolvedResponsiveValue;
        ScreenSizeModelData<LayoutSize>? resolvedData;

        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: const Size(620, 900),
          withScaffold: false,
          child: ScreenSizeWithValue<LayoutSize, String>(
            breakpoints: Breakpoints.defaultBreakpoints,
            valueProvider: ResponsiveValue<String>(
              medium: 'providerPortrait',
            ),
            child: ScreenWithValueValueBuilderOrientation<String, String>(
              medium: 'portraitValue',
              mediumLandscape: 'landscapeValue',
              builder: (_, value, {data, responsiveValue}) {
                resolvedValue = value;
                resolvedData = data;
                resolvedResponsiveValue = responsiveValue;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(resolvedValue, 'portraitValue');
        expect(resolvedResponsiveValue, 'providerPortrait');
        expect(resolvedData, isNotNull);
        expect(resolvedData!.screenSize, LayoutSize.medium);
        expect(resolvedData!.orientation, Orientation.portrait);
        expect(resolvedData!.logicalScreenWidth, 620);
        expect(resolvedData!.logicalScreenHeight, 900);
      },
    );

    testWidgets(
      'uses landscape values in landscape orientation and exposes provider value',
      (tester) async {
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
              large: 'providerLandscape',
            ),
            child: ScreenWithValueValueBuilderOrientation<String, String>(
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
        expect(resolvedResponsiveValue, 'providerLandscape');
        expect(resolvedData, isNotNull);
        expect(resolvedData!.screenSize, LayoutSize.large);
        expect(resolvedData!.orientation, Orientation.landscape);
      },
    );

    testWidgets(
      'falls back to portrait values when landscape values are empty',
      (tester) async {
        String? resolvedValue;

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
            child: ScreenWithValueValueBuilderOrientation<String, String>(
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
          child: ScreenSizeWithValue<LayoutSize, String>(
            breakpoints: Breakpoints.defaultBreakpoints,
            valueProvider: ResponsiveValue<String>(
              medium: 'providerValue',
            ),
            child: ScreenWithValueValueBuilderOrientation<String, String>(
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
  });
}
