import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('ScreenSizeWithValue', () {
    testWidgets('exposes breakpoint, value, and metrics from width', (
      tester,
    ) async {
      late ScreenSizeModelDataWithValue<LayoutSize, String> data;
      late ScreenSizeModelDataWithValue<LayoutSize, String>? maybeData;
      late LayoutSize breakpoint;
      late String responsiveValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(620, 900),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSize, String>(
          breakpoints: Breakpoints.defaultBreakpoints,
          valueProvider: ResponsiveValue<String>(
            extraLarge: 'extraLarge',
            large: 'large',
            medium: 'medium',
            small: 'small',
            extraSmall: 'extraSmall',
          ),
          child: Builder(
            builder: (context) {
              data = ScreenSizeModelWithValue.of<LayoutSize, String>(context);
              maybeData = ScreenSizeModelWithValue.maybeOf<LayoutSize, String>(
                context,
              );
              breakpoint = ScreenSizeModelWithValue.breakpointOf<LayoutSize>(
                context,
              );
              responsiveValue = ScreenSizeModelWithValue.responsiveValueOf<
                  LayoutSize, String>(context);

              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(maybeData, isNotNull);
      expect(breakpoint, LayoutSize.medium);
      expect(responsiveValue, 'medium');
      expect(data.currentBreakpoint, 600);
      expect(data.logicalScreenWidth, 620);
      expect(data.logicalScreenHeight, 900);
      expect(data.physicalWidth, 620);
      expect(data.physicalHeight, 900);
      expect(data.devicePixelRatio, 1);
      expect(data.orientation, Orientation.portrait);
    });

    testWidgets('uses shortest side classification when requested', (
      tester,
    ) async {
      late LayoutSize breakpoint;
      late String responsiveValue;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(640, 300),
        withScaffold: false,
        child: ScreenSizeWithValue<LayoutSize, String>(
          breakpoints: const Breakpoints(
            extraLarge: 700,
            large: 600,
            medium: 500,
            small: 400,
          ),
          valueProvider: ResponsiveValue<String>(
            breakpoints: const Breakpoints(
              extraLarge: 700,
              large: 600,
              medium: 500,
              small: 400,
            ),
            extraLarge: 'extraLarge',
            large: 'large',
            medium: 'medium',
            small: 'small',
            extraSmall: 'extraSmall',
          ),
          useShortestSide: true,
          child: Builder(
            builder: (context) {
              breakpoint = ScreenSizeModelWithValue.breakpointOf<LayoutSize>(
                context,
              );
              responsiveValue = ScreenSizeModelWithValue.responsiveValueOf<
                  LayoutSize, String>(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(breakpoint, LayoutSize.extraSmall);
      expect(responsiveValue, 'extraSmall');
    });

    testWidgets('throws for required lookups when no model is present', (
      tester,
    ) async {
      late BuildContext context;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: Builder(
          builder: (value) {
            context = value;
            return const SizedBox.shrink();
          },
        ),
      );

      expect(
        () => ScreenSizeModelWithValue.of<LayoutSize, String>(context),
        throwsA(
          isA<FlutterError>().having(
            (error) => error.toString(),
            'message',
            contains('ScreenSizeModelWithValue<LayoutSize, String> not found'),
          ),
        ),
      );
      expect(
        () => ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, String>(
          context,
        ),
        throwsA(
          isA<FlutterError>().having(
            (error) => error.toString(),
            'message',
            contains('ScreenSizeModelWithValue<LayoutSize, String> not found'),
          ),
        ),
      );
      expect(
        () => ScreenSizeModelWithValue.breakpointOf<LayoutSize>(context),
        throwsA(
          isA<FlutterError>().having(
            (error) => error.toString(),
            'message',
            contains('ScreenSizeWithValue<LayoutSize, ?> not found'),
          ),
        ),
      );
      expect(
        ScreenSizeModelWithValue.maybeOf<LayoutSize, String>(context),
        isNull,
      );
    });
  });

  group('ScreenSizeModelWithValue', () {
    test('notifies screenSize dependents when responsive value changes', () {
      const previousData = _baseData;
      const currentData = ScreenSizeModelDataWithValue<LayoutSize, String>(
        breakpoints: Breakpoints.defaultBreakpoints,
        currentBreakpoint: 600,
        screenSize: LayoutSize.medium,
        physicalWidth: 620,
        physicalHeight: 900,
        devicePixelRatio: 1,
        logicalScreenWidth: 620,
        logicalScreenHeight: 900,
        orientation: Orientation.portrait,
        responsiveValue: 'updated',
      );

      const previousModel = ScreenSizeModelWithValue<LayoutSize, String>(
        data: previousData,
        child: SizedBox.shrink(),
      );
      const currentModel = ScreenSizeModelWithValue<LayoutSize, String>(
        data: currentData,
        child: SizedBox.shrink(),
      );

      expect(currentModel.updateShouldNotify(previousModel), isTrue);
      expect(
        currentModel.updateShouldNotifyDependent(
          previousModel,
          const {ScreenSizeAspect.screenSize},
        ),
        isTrue,
      );
    });

    test('only notifies other dependents for non-screen metrics changes', () {
      const previousData = _baseData;
      const currentData = ScreenSizeModelDataWithValue<LayoutSize, String>(
        breakpoints: Breakpoints.defaultBreakpoints,
        currentBreakpoint: 600,
        screenSize: LayoutSize.medium,
        physicalWidth: 700,
        physicalHeight: 900,
        devicePixelRatio: 1,
        logicalScreenWidth: 620,
        logicalScreenHeight: 900,
        orientation: Orientation.portrait,
        responsiveValue: 'medium',
      );

      const previousModel = ScreenSizeModelWithValue<LayoutSize, String>(
        data: previousData,
        child: SizedBox.shrink(),
      );
      const currentModel = ScreenSizeModelWithValue<LayoutSize, String>(
        data: currentData,
        child: SizedBox.shrink(),
      );

      expect(
        currentModel.updateShouldNotifyDependent(
          previousModel,
          const {ScreenSizeAspect.screenSize},
        ),
        isFalse,
      );
      expect(
        currentModel.updateShouldNotifyDependent(
          previousModel,
          const {ScreenSizeAspect.other},
        ),
        isTrue,
      );
    });
  });

  group('ScreenSizeModelDataWithValue', () {
    test('asScreenData returns an equivalent screen-only view', () {
      const data = _baseData;
      final screenData = data.asScreenData();

      expect(
        screenData,
        const ScreenSizeModelData<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          currentBreakpoint: 600,
          screenSize: LayoutSize.medium,
          physicalWidth: 620,
          physicalHeight: 900,
          devicePixelRatio: 1,
          logicalScreenWidth: 620,
          logicalScreenHeight: 900,
          orientation: Orientation.portrait,
        ),
      );
    });

    test('supports value equality and stable hashCode', () {
      const first = _baseData;
      const second = _baseData;
      const third = ScreenSizeModelDataWithValue<LayoutSize, String>(
        breakpoints: Breakpoints.defaultBreakpoints,
        currentBreakpoint: 600,
        screenSize: LayoutSize.medium,
        physicalWidth: 620,
        physicalHeight: 900,
        devicePixelRatio: 1,
        logicalScreenWidth: 620,
        logicalScreenHeight: 900,
        orientation: Orientation.portrait,
        responsiveValue: 'large',
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('toString includes responsive value and orientation', () {
      const data = _baseData;

      expect(data.toString(), contains('responsiveValue: medium'));
      expect(data.toString(), contains('orientation: Orientation.portrait'));
    });
  });
}

const _baseData = ScreenSizeModelDataWithValue<LayoutSize, String>(
  breakpoints: Breakpoints.defaultBreakpoints,
  currentBreakpoint: 600,
  screenSize: LayoutSize.medium,
  physicalWidth: 620,
  physicalHeight: 900,
  devicePixelRatio: 1,
  logicalScreenWidth: 620,
  logicalScreenHeight: 900,
  orientation: Orientation.portrait,
  responsiveValue: 'medium',
);
