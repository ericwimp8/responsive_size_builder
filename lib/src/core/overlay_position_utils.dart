library;

import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

// TODO(ericwimp): Add ability to position overlay origin relative to widget eg, topleft, topright, bottomleft, bottomright etc
// TODO(ericwimp): Add ability to position overlay based on origin, so top center would place the top
// center of the overlay at the choose overlay origin

WidgetSpacing getWidgetSpacing<T extends Enum>(BuildContext context) {
  final renderBox = context.findRenderObject() as RenderBox?;
  final screenSizeModel = ScreenSizeModel.of<T>(context);

  if (renderBox == null || !renderBox.hasSize) {
    // It's crucial that the renderBox has been laid out and has a size.
    // Returning a default or throwing might depend on your use case.
    // Throwing is safer if the logic absolutely depends on valid measurements.
    return WidgetSpacing.empty;
  }

  // Get widget's size and position
  final widgetSize = renderBox.size;
  final widgetPosition = renderBox.localToGlobal(Offset.zero);

  // Get screen dimensions from the model
  final screenWidth = screenSizeModel.logicalScreenWidth;
  final screenHeight = screenSizeModel.logicalScreenHeight;

  // Calculate spacing
  final heightAbove = widgetPosition.dy;
  final heightBelow = screenHeight - (widgetPosition.dy + widgetSize.height);
  final widthLeft = widgetPosition.dx;
  final widthRight = screenWidth - (widgetPosition.dx + widgetSize.width);

  // Calculate the size of the areas around the widget
  // Note: Ensure these calculations make sense for your specific overlay needs.
  // These assume the areas span the full width/height outside the widget bounds.
  final sizeAbove = Size(screenWidth, heightAbove);
  final sizeBelow = Size(screenWidth, heightBelow);
  final sizeLeft = Size(widthLeft, screenHeight);
  final sizeRight = Size(widthRight, screenHeight);

  // Return the calculated spacing
  return WidgetSpacing(
    screenHeight: screenHeight,
    screenWidth: screenWidth,
    widgetSize: widgetSize,
    widgetPosition: widgetPosition,
    heightAbove: heightAbove,
    heightBelow: heightBelow,
    widthLeft: widthLeft,
    widthRight: widthRight,
    sizeAbove: sizeAbove,
    sizeBelow: sizeBelow,
    sizeLeft: sizeLeft,
    sizeRight: sizeRight,
  );
}

WidgetSpacing getWidgetSpacingWithValue<T extends Enum, V extends Object?>(
  BuildContext context,
) {
  final renderBox = context.findRenderObject() as RenderBox?;
  final screenSizeModel = ScreenSizeModelWithValue.of<T, V>(context);

  if (renderBox == null || !renderBox.hasSize) {
    // It's crucial that the renderBox has been laid out and has a size.
    // Returning a default or throwing might depend on your use case.
    // Throwing is safer if the logic absolutely depends on valid measurements.
    return WidgetSpacing.empty;
  }

  // Get widget's size and position
  final widgetSize = renderBox.size;
  final widgetPosition = renderBox.localToGlobal(Offset.zero);

  // Get screen dimensions from the model
  final screenWidth = screenSizeModel.logicalScreenWidth;
  final screenHeight = screenSizeModel.logicalScreenHeight;

  // Calculate spacing
  final heightAbove = widgetPosition.dy;
  final heightBelow = screenHeight - (widgetPosition.dy + widgetSize.height);
  final widthLeft = widgetPosition.dx;
  final widthRight = screenWidth - (widgetPosition.dx + widgetSize.width);

  // Calculate the size of the areas around the widget
  // Note: Ensure these calculations make sense for your specific overlay needs.
  // These assume the areas span the full width/height outside the widget bounds.
  final sizeAbove = Size(screenWidth, heightAbove);
  final sizeBelow = Size(screenWidth, heightBelow);
  final sizeLeft = Size(widthLeft, screenHeight);
  final sizeRight = Size(widthRight, screenHeight);

  // Return the calculated spacing
  return WidgetSpacing(
    screenHeight: screenHeight,
    screenWidth: screenWidth,
    widgetSize: widgetSize,
    widgetPosition: widgetPosition,
    heightAbove: heightAbove,
    heightBelow: heightBelow,
    widthLeft: widthLeft,
    widthRight: widthRight,
    sizeAbove: sizeAbove,
    sizeBelow: sizeBelow,
    sizeLeft: sizeLeft,
    sizeRight: sizeRight,
  );
}

@immutable
class WidgetSpacing {
  const WidgetSpacing({
    required this.screenHeight,
    required this.screenWidth,
    required this.widgetSize,
    required this.widgetPosition,
    required this.heightAbove,
    required this.heightBelow,
    required this.widthLeft,
    required this.widthRight,
    required this.sizeAbove,
    required this.sizeBelow,
    required this.sizeLeft,
    required this.sizeRight,
  });

  final double screenHeight;

  final double screenWidth;

  final Size widgetSize;

  final Offset widgetPosition;

  final double heightAbove;

  final double heightBelow;

  final double widthLeft;

  final double widthRight;

  final Size sizeAbove;

  final Size sizeBelow;

  final Size sizeLeft;

  final Size sizeRight;

  static const empty = WidgetSpacing(
    screenHeight: 0,
    screenWidth: 0,
    widgetSize: Size.zero,
    widgetPosition: Offset.zero,
    heightAbove: 0,
    heightBelow: 0,
    widthLeft: 0,
    widthRight: 0,
    sizeAbove: Size.zero,
    sizeBelow: Size.zero,
    sizeLeft: Size.zero,
    sizeRight: Size.zero,
  );

  bool get hasSpaceLeft => widthLeft > 0;

  bool get hasSpaceRight => widthRight > 0;

  bool get hasSpaceAbove => heightAbove > 0;

  bool get hasSpaceBelow => heightBelow > 0;

  (BoxConstraints effectiveConstraints, VerticalDirection effectiveDirection)
      constraintsVertical({
    double minimumSpace = 250,
    VerticalDirection desiredDirection = VerticalDirection.down,
    double? maximumWidth,
  }) {
    if (this == WidgetSpacing.empty) {
      return (
        const BoxConstraints(maxHeight: 0, maxWidth: 0),
        VerticalDirection.down
      );
    }
    if (desiredDirection == VerticalDirection.down) {
      if (heightBelow >= minimumSpace) {
        return (
          BoxConstraints(
            maxHeight: heightBelow,
            maxWidth: maximumWidth ?? widgetSize.width,
          ),
          VerticalDirection.down
        );
      } else {
        return (
          BoxConstraints(
            maxHeight: heightAbove,
            maxWidth: maximumWidth ?? widgetSize.width,
          ),
          VerticalDirection.up
        );
      }
    } else {
      if (heightAbove >= minimumSpace) {
        return (
          BoxConstraints(
            maxHeight: heightAbove,
            maxWidth: maximumWidth ?? widgetSize.width,
          ),
          VerticalDirection.up
        );
      } else {
        return (
          BoxConstraints(
            maxHeight: heightBelow,
            maxWidth: maximumWidth ?? widgetSize.width,
          ),
          VerticalDirection.down
        );
      }
    }
  }

  (BoxConstraints effectiveConstraints, HorizonatalDirection effectiveDirection)
      onstraintsHorizontal({
    double minimumWidth = 150,
    HorizonatalDirection desiredDirection = HorizonatalDirection.right,
    double? maximumHeight,
  }) {
    if (this == WidgetSpacing.empty) {
      return (
        const BoxConstraints(maxHeight: 0, maxWidth: 0),
        HorizonatalDirection.right
      );
    }
    if (desiredDirection == HorizonatalDirection.right) {
      if (widthRight >= minimumWidth) {
        return (
          BoxConstraints(
            maxHeight: maximumHeight ?? screenHeight,
            maxWidth: widthRight,
          ),
          HorizonatalDirection.right
        );
      } else {
        return (
          BoxConstraints(
            maxHeight: maximumHeight ?? screenHeight,
            maxWidth: widthLeft,
          ),
          HorizonatalDirection.left
        );
      }
    } else {
      if (widthLeft >= minimumWidth) {
        return (
          BoxConstraints(
            maxHeight: maximumHeight ?? screenHeight,
            maxWidth: widthLeft,
          ),
          HorizonatalDirection.left
        );
      } else {
        return (
          BoxConstraints(
            maxHeight: maximumHeight ?? screenHeight,
            maxWidth: widthRight,
          ),
          HorizonatalDirection.right
        );
      }
    }
  }

  WidgetSpacing copyWith({
    double? maxHeight,
    double? maxWidth,
    Size? widgetSize,
    Offset? widgetPosition,
    double? heightAbove,
    double? heightBelow,
    double? widthLeft,
    double? widthRight,
    Size? sizeAbove,
    Size? sizeBelow,
    Size? sizeLeft,
    Size? sizeRight,
  }) {
    return WidgetSpacing(
      screenHeight: maxHeight ?? screenHeight,
      screenWidth: maxWidth ?? screenWidth,
      widgetSize: widgetSize ?? this.widgetSize,
      widgetPosition: widgetPosition ?? this.widgetPosition,
      heightAbove: heightAbove ?? this.heightAbove,
      heightBelow: heightBelow ?? this.heightBelow,
      widthLeft: widthLeft ?? this.widthLeft,
      widthRight: widthRight ?? this.widthRight,
      sizeAbove: sizeAbove ?? this.sizeAbove,
      sizeBelow: sizeBelow ?? this.sizeBelow,
      sizeLeft: sizeLeft ?? this.sizeLeft,
      sizeRight: sizeRight ?? this.sizeRight,
    );
  }

  @override
  String toString() {
    return 'WidgetSpacing(maxHeight: $screenHeight, maxWidth: $screenWidth, widgetSize: $widgetSize, widgetPosition: $widgetPosition, heightAbove: $heightAbove, heightBelow: $heightBelow, widthLeft: $widthLeft, widthRight: $widthRight, sizeAbove: $sizeAbove, sizeBelow: $sizeBelow, sizeLeft: $sizeLeft, sizeRight: $sizeRight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WidgetSpacing &&
        other.screenHeight == screenHeight &&
        other.screenWidth == screenWidth &&
        other.widgetSize == widgetSize &&
        other.widgetPosition == widgetPosition &&
        other.heightAbove == heightAbove &&
        other.heightBelow == heightBelow &&
        other.widthLeft == widthLeft &&
        other.widthRight == widthRight &&
        other.sizeAbove == sizeAbove &&
        other.sizeBelow == sizeBelow &&
        other.sizeLeft == sizeLeft &&
        other.sizeRight == sizeRight;
  }

  @override
  int get hashCode {
    return screenHeight.hashCode ^
        screenWidth.hashCode ^
        widgetSize.hashCode ^
        widgetPosition.hashCode ^
        heightAbove.hashCode ^
        heightBelow.hashCode ^
        widthLeft.hashCode ^
        widthRight.hashCode ^
        sizeAbove.hashCode ^
        sizeBelow.hashCode ^
        sizeLeft.hashCode ^
        sizeRight.hashCode;
  }
}

enum HorizonatalDirection {
  left,

  right,
}
