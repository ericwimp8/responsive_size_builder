import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('getWidgetSpacing', () {
    testWidgets('computes spacing from render box and screen model', (
      tester,
    ) async {
      const anchorKey = Key('anchor');

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const ScreenSizeModel<LayoutSize>(
          data: _screenData,
          child: _TestCanvas(
            child: Padding(
              padding: EdgeInsets.only(left: 24, top: 40),
              child: SizedBox(
                key: anchorKey,
                width: 100,
                height: 50,
                child: ColoredBox(color: Colors.red),
              ),
            ),
          ),
        ),
      );

      final context = tester.element(find.byKey(anchorKey));
      final renderBox = context.findRenderObject()! as RenderBox;
      final spacing = getWidgetSpacing<LayoutSize>(context);

      _expectSpacingMatchesRenderBox(
        spacing: spacing,
        renderBox: renderBox,
        screenWidth: _screenData.logicalScreenWidth,
        screenHeight: _screenData.logicalScreenHeight,
      );
    });
  });

  group('getWidgetSpacingWithValue', () {
    testWidgets('computes spacing from render box and model with value', (
      tester,
    ) async {
      const anchorKey = Key('anchor');

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const ScreenSizeModelWithValue<LayoutSize, String>(
          data: _screenDataWithValue,
          child: _TestCanvas(
            child: Padding(
              padding: EdgeInsets.only(left: 12, top: 20),
              child: SizedBox(
                key: anchorKey,
                width: 80,
                height: 30,
                child: ColoredBox(color: Colors.blue),
              ),
            ),
          ),
        ),
      );

      final context = tester.element(find.byKey(anchorKey));
      final renderBox = context.findRenderObject()! as RenderBox;
      final spacing = getWidgetSpacingWithValue<LayoutSize, String>(context);

      _expectSpacingMatchesRenderBox(
        spacing: spacing,
        renderBox: renderBox,
        screenWidth: _screenDataWithValue.logicalScreenWidth,
        screenHeight: _screenDataWithValue.logicalScreenHeight,
      );
    });
  });

  group('WidgetSpacing', () {
    test('space getters report availability from dimensions', () {
      expect(_baseSpacing.hasSpaceLeft, isTrue);
      expect(_baseSpacing.hasSpaceRight, isTrue);
      expect(_baseSpacing.hasSpaceAbove, isTrue);
      expect(_baseSpacing.hasSpaceBelow, isTrue);

      expect(WidgetSpacing.empty.hasSpaceLeft, isFalse);
      expect(WidgetSpacing.empty.hasSpaceRight, isFalse);
      expect(WidgetSpacing.empty.hasSpaceAbove, isFalse);
      expect(WidgetSpacing.empty.hasSpaceBelow, isFalse);
    });

    test('constraintsVertical returns zero constraints for empty spacing', () {
      final (constraints, direction) =
          WidgetSpacing.empty.constraintsVertical();

      expect(constraints, const BoxConstraints(maxHeight: 0, maxWidth: 0));
      expect(direction, VerticalDirection.down);
    });

    test('constraintsVertical keeps desired down when below space is enough',
        () {
      final spacing = _baseSpacing.copyWith(heightBelow: 300);
      final (constraints, direction) = spacing.constraintsVertical();

      expect(
        constraints,
        const BoxConstraints(maxHeight: 300, maxWidth: 100),
      );
      expect(direction, VerticalDirection.down);
    });

    test('constraintsVertical flips when desired side has insufficient space',
        () {
      final spacing = _baseSpacing.copyWith(
        heightAbove: 280,
        heightBelow: 120,
      );
      final (constraints, direction) = spacing.constraintsVertical(
        minimumSpace: 200,
      );

      expect(
        constraints,
        const BoxConstraints(maxHeight: 280, maxWidth: 100),
      );
      expect(direction, VerticalDirection.up);
    });

    test('constraintsVertical supports desired up and maximumWidth override',
        () {
      final spacing = _baseSpacing.copyWith(
        heightAbove: 180,
        heightBelow: 90,
      );
      final (constraints, direction) = spacing.constraintsVertical(
        desiredDirection: VerticalDirection.up,
        minimumSpace: 150,
        maximumWidth: 140,
      );

      expect(
        constraints,
        const BoxConstraints(maxHeight: 180, maxWidth: 140),
      );
      expect(direction, VerticalDirection.up);
    });

    test('onstraintsHorizontal returns zero constraints for empty spacing', () {
      final (constraints, direction) =
          WidgetSpacing.empty.onstraintsHorizontal();

      expect(constraints, const BoxConstraints(maxHeight: 0, maxWidth: 0));
      expect(direction, HorizonatalDirection.right);
    });

    test('onstraintsHorizontal keeps desired right when width is enough', () {
      final spacing = _baseSpacing.copyWith(widthRight: 220);
      final (constraints, direction) = spacing.onstraintsHorizontal();

      expect(
        constraints,
        const BoxConstraints(maxHeight: 240, maxWidth: 220),
      );
      expect(direction, HorizonatalDirection.right);
    });

    test('onstraintsHorizontal flips and supports maximumHeight override', () {
      final spacing = _baseSpacing.copyWith(
        widthLeft: 170,
        widthRight: 90,
      );
      final (constraints, direction) = spacing.onstraintsHorizontal(
        minimumWidth: 120,
        maximumHeight: 180,
      );

      expect(
        constraints,
        const BoxConstraints(maxHeight: 180, maxWidth: 170),
      );
      expect(direction, HorizonatalDirection.left);
    });

    test('copyWith updates provided fields and preserves others', () {
      final updated = _baseSpacing.copyWith(
        maxHeight: 500,
        maxWidth: 640,
        widthRight: 88,
      );

      expect(updated.screenHeight, 500);
      expect(updated.screenWidth, 640);
      expect(updated.widthRight, 88);
      expect(updated.widthLeft, _baseSpacing.widthLeft);
      expect(updated.widgetSize, _baseSpacing.widgetSize);
    });

    test('supports value equality and stable hashCode', () {
      const first = WidgetSpacing(
        screenHeight: 240,
        screenWidth: 320,
        widgetSize: Size(100, 50),
        widgetPosition: Offset(24, 40),
        heightAbove: 40,
        heightBelow: 150,
        widthLeft: 24,
        widthRight: 196,
        sizeAbove: Size(320, 40),
        sizeBelow: Size(320, 150),
        sizeLeft: Size(24, 240),
        sizeRight: Size(196, 240),
      );
      const second = WidgetSpacing(
        screenHeight: 240,
        screenWidth: 320,
        widgetSize: Size(100, 50),
        widgetPosition: Offset(24, 40),
        heightAbove: 40,
        heightBelow: 150,
        widthLeft: 24,
        widthRight: 196,
        sizeAbove: Size(320, 40),
        sizeBelow: Size(320, 150),
        sizeLeft: Size(24, 240),
        sizeRight: Size(196, 240),
      );
      const third = WidgetSpacing(
        screenHeight: 240,
        screenWidth: 320,
        widgetSize: Size(100, 50),
        widgetPosition: Offset(24, 40),
        heightAbove: 40,
        heightBelow: 150,
        widthLeft: 24,
        widthRight: 150,
        sizeAbove: Size(320, 40),
        sizeBelow: Size(320, 150),
        sizeLeft: Size(24, 240),
        sizeRight: Size(196, 240),
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });
  });
}

class _TestCanvas extends StatelessWidget {
  const _TestCanvas({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 320,
        height: 240,
        child: child,
      ),
    );
  }
}

const _testBreakpoints = Breakpoints(
  extraLarge: 1000,
  large: 700,
  medium: 400,
);

const _screenData = ScreenSizeModelData<LayoutSize>(
  breakpoints: _testBreakpoints,
  currentBreakpoint: 200,
  screenSize: LayoutSize.small,
  physicalWidth: 320,
  physicalHeight: 240,
  devicePixelRatio: 1,
  logicalScreenWidth: 320,
  logicalScreenHeight: 240,
  orientation: Orientation.landscape,
);

const _screenDataWithValue = ScreenSizeModelDataWithValue<LayoutSize, String>(
  breakpoints: _testBreakpoints,
  currentBreakpoint: 200,
  screenSize: LayoutSize.small,
  physicalWidth: 320,
  physicalHeight: 240,
  devicePixelRatio: 1,
  logicalScreenWidth: 320,
  logicalScreenHeight: 240,
  orientation: Orientation.landscape,
  responsiveValue: 'value',
);

const _baseSpacing = WidgetSpacing(
  screenHeight: 240,
  screenWidth: 320,
  widgetSize: Size(100, 50),
  widgetPosition: Offset(24, 40),
  heightAbove: 40,
  heightBelow: 150,
  widthLeft: 24,
  widthRight: 196,
  sizeAbove: Size(320, 40),
  sizeBelow: Size(320, 150),
  sizeLeft: Size(24, 240),
  sizeRight: Size(196, 240),
);

void _expectSpacingMatchesRenderBox({
  required WidgetSpacing spacing,
  required RenderBox renderBox,
  required double screenWidth,
  required double screenHeight,
}) {
  final widgetSize = renderBox.size;
  final widgetPosition = renderBox.localToGlobal(Offset.zero);
  final heightAbove = widgetPosition.dy;
  final heightBelow = screenHeight - (widgetPosition.dy + widgetSize.height);
  final widthLeft = widgetPosition.dx;
  final widthRight = screenWidth - (widgetPosition.dx + widgetSize.width);

  expect(spacing.screenWidth, screenWidth);
  expect(spacing.screenHeight, screenHeight);
  expect(spacing.widgetSize, widgetSize);
  expect(spacing.widgetPosition, widgetPosition);
  expect(spacing.heightAbove, heightAbove);
  expect(spacing.heightBelow, heightBelow);
  expect(spacing.widthLeft, widthLeft);
  expect(spacing.widthRight, widthRight);
  expect(spacing.sizeAbove, Size(screenWidth, heightAbove));
  expect(spacing.sizeBelow, Size(screenWidth, heightBelow));
  expect(spacing.sizeLeft, Size(widthLeft, screenHeight));
  expect(spacing.sizeRight, Size(widthRight, screenHeight));
}
