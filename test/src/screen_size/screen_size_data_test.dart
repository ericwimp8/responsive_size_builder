import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('ScreenSize', () {
    testWidgets('exposes breakpoint and metrics from width', (tester) async {
      late ScreenSizeModelData<LayoutSize> data;
      late LayoutSize breakpoint;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(620, 900),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: Builder(
            builder: (context) {
              data = ScreenSizeModel.of<LayoutSize>(context);
              breakpoint = ScreenSizeModel.breakpointOf<LayoutSize>(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(breakpoint, LayoutSize.medium);
      expect(data.currentBreakpoint, 600);
      expect(data.screenSize, LayoutSize.medium);
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

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(640, 300),
        withScaffold: false,
        child: ScreenSize<LayoutSize>(
          breakpoints: const Breakpoints(
            extraLarge: 700,
            large: 600,
            medium: 500,
            small: 400,
          ),
          useShortestSide: true,
          child: Builder(
            builder: (context) {
              breakpoint = ScreenSizeModel.breakpointOf<LayoutSize>(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(breakpoint, LayoutSize.extraSmall);
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
        () => ScreenSizeModel.of<LayoutSize>(context),
        throwsA(
          isA<FlutterError>().having(
            (error) => error.toString(),
            'message',
            contains('ScreenSizeModel<LayoutSize> not found'),
          ),
        ),
      );
      expect(
        () => ScreenSizeModel.breakpointOf<LayoutSize>(context),
        throwsA(
          isA<FlutterError>().having(
            (error) => error.toString(),
            'message',
            contains('ScreenSizeModel<LayoutSize> not found'),
          ),
        ),
      );
    });
  });

  group('ScreenSizeModel', () {
    test('notifies screenSize dependents when breakpoint changes', () {
      const previousData = _baseData;
      const currentData = ScreenSizeModelData<LayoutSize>(
        breakpoints: Breakpoints.defaultBreakpoints,
        currentBreakpoint: 950,
        screenSize: LayoutSize.large,
        physicalWidth: 980,
        physicalHeight: 900,
        devicePixelRatio: 1,
        logicalScreenWidth: 980,
        logicalScreenHeight: 900,
        orientation: Orientation.portrait,
      );

      const previousModel = ScreenSizeModel<LayoutSize>(
        data: previousData,
        child: SizedBox.shrink(),
      );
      const currentModel = ScreenSizeModel<LayoutSize>(
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
      const currentData = ScreenSizeModelData<LayoutSize>(
        breakpoints: Breakpoints.defaultBreakpoints,
        currentBreakpoint: 600,
        screenSize: LayoutSize.medium,
        physicalWidth: 700,
        physicalHeight: 900,
        devicePixelRatio: 1,
        logicalScreenWidth: 620,
        logicalScreenHeight: 900,
        orientation: Orientation.portrait,
      );

      const previousModel = ScreenSizeModel<LayoutSize>(
        data: previousData,
        child: SizedBox.shrink(),
      );
      const currentModel = ScreenSizeModel<LayoutSize>(
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

  group('ScreenSizeModelData', () {
    test('supports value equality and stable hashCode', () {
      const first = _baseData;
      const second = _baseData;
      const third = ScreenSizeModelData<LayoutSize>(
        breakpoints: Breakpoints.defaultBreakpoints,
        currentBreakpoint: 600,
        screenSize: LayoutSize.medium,
        physicalWidth: 620,
        physicalHeight: 901,
        devicePixelRatio: 1,
        logicalScreenWidth: 620,
        logicalScreenHeight: 900,
        orientation: Orientation.portrait,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('platform helpers mirror package platform flags', () {
      const data = _baseData;

      expect(data.isDesktopDevcie, kIsDesktopDevice);
      expect(data.isTouchDevice, kIsTouchDevice);
      expect(data.isWeb, kIsWeb);
    });

    test('toString includes key metric fields', () {
      const data = _baseData;
      final value = data.toString();

      expect(value, contains('currentBreakpoint: 600'));
      expect(value, contains('screenSize: LayoutSize.medium'));
      expect(value, contains('logicalScreenHeight: 900'));
    });
  });
}

const _baseData = ScreenSizeModelData<LayoutSize>(
  breakpoints: Breakpoints.defaultBreakpoints,
  currentBreakpoint: 600,
  screenSize: LayoutSize.medium,
  physicalWidth: 620,
  physicalHeight: 900,
  devicePixelRatio: 1,
  logicalScreenWidth: 620,
  logicalScreenHeight: 900,
  orientation: Orientation.portrait,
);
