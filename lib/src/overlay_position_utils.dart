/// Utilities for calculating widget positioning and spacing for overlay placement.
///
/// This library provides tools to calculate available space around widgets on
/// screen, which is essential for positioning overlays like tooltips, dropdowns,
/// and context menus in responsive layouts.
///
/// The main functionality centers around [getWidgetSpacing], which analyzes a
/// widget's position relative to screen boundaries and calculates available
/// space in all directions.
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

// TODO(ericwimp): Add ability to position overlay origin relative to widget eg, topleft, topright, bottomleft, bottomright etc
// TODO(ericwimp): Add ability to position overlay based on origin, so top center would place the top
// center of the overlay at the choose overlay origin

/// Calculates spacing and available area around a widget for overlay positioning.
///
/// This function analyzes the render tree to determine a widget's exact position
/// and size relative to the screen, then calculates available space in all four
/// directions. This information is essential for intelligently positioning
/// overlays like tooltips, dropdowns, and context menus.
///
/// The function requires a valid [RenderBox] with a computed size to work
/// properly. It should typically be called from [State.didChangeDependencies]
/// or after the widget has been laid out.
///
/// The type parameter [T] represents the screen size enum type (e.g.,
/// [LayoutSize] or [LayoutSizeGranular]) used by the responsive size system.
///
/// Returns [WidgetSpacing.empty] if the widget hasn't been laid out yet or
/// doesn't have a valid size, providing a safe fallback for widgets that
/// haven't completed their layout phase.
///
/// {@tool snippet}
/// This example shows how to use [getWidgetSpacing] to position a tooltip:
///
/// ```dart
/// class TooltipWidget extends StatefulWidget {
///   @override
///   State<TooltipWidget> createState() => _TooltipWidgetState();
/// }
///
/// class _TooltipWidgetState extends State<TooltipWidget> {
///   WidgetSpacing? spacing;
///
///   @override
///   void didChangeDependencies() {
///     super.didChangeDependencies();
///     spacing = getWidgetSpacing<LayoutSize>(context);
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     final (constraints, direction) = spacing?.constraintsVertical() ??
///         (BoxConstraints.tight(Size.zero), VerticalDirection.down);
///     
///     return Stack(
///       children: [
///         MyWidget(),
///         if (spacing != null)
///           Positioned(
///             top: direction == VerticalDirection.down 
///                 ? spacing!.widgetPosition.dy + spacing!.widgetSize.height
///                 : null,
///             bottom: direction == VerticalDirection.up
///                 ? spacing!.heightAbove
///                 : null,
///             child: ConstrainedBox(
///               constraints: constraints,
///               child: TooltipContent(),
///             ),
///           ),
///       ],
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [WidgetSpacing], which contains the calculated spacing data
///  * [ScreenSizeModel], which provides screen size information
///  * [RenderBox.localToGlobal], which converts local coordinates to global
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

/// Immutable data class containing comprehensive spacing information for overlay positioning.
///
/// [WidgetSpacing] provides detailed measurements of available space around a
/// widget, including distances to screen edges and calculated area sizes for
/// each direction. This information is essential for intelligent overlay
/// positioning that adapts to available screen real estate.
///
/// The class includes convenience methods for determining optimal overlay
/// placement based on space requirements and preferred directions.
///
/// All measurements are in logical pixels (the same coordinate system used by
/// Flutter widgets), accounting for device pixel density automatically.
@immutable
class WidgetSpacing {
  /// Creates a [WidgetSpacing] with the specified measurements.
  ///
  /// All parameters represent measurements in logical pixels and are required
  /// to provide complete spacing information for overlay positioning.
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
  /// The total logical height of the screen.
  final double screenHeight;

  /// The total logical width of the screen.
  final double screenWidth;

  /// The size of the widget being positioned relative to.
  final Size widgetSize;

  /// The global position of the widget's top-left corner.
  ///
  /// This offset represents the widget's position in the global coordinate
  /// system, where (0,0) is the top-left corner of the screen.
  final Offset widgetPosition;

  /// The available height above the widget.
  ///
  /// This is the distance from the top of the screen to the top edge of
  /// the widget.
  final double heightAbove;

  /// The available height below the widget.
  ///
  /// This is the distance from the bottom edge of the widget to the bottom
  /// of the screen.
  final double heightBelow;

  /// The available width to the left of the widget.
  ///
  /// This is the distance from the left edge of the screen to the left edge
  /// of the widget.
  final double widthLeft;

  /// The available width to the right of the widget.
  ///
  /// This is the distance from the right edge of the widget to the right
  /// edge of the screen.
  final double widthRight;

  /// The full size of the area above the widget.
  ///
  /// This represents a rectangle spanning the full screen width with height
  /// equal to [heightAbove].
  final Size sizeAbove;

  /// The full size of the area below the widget.
  ///
  /// This represents a rectangle spanning the full screen width with height
  /// equal to [heightBelow].
  final Size sizeBelow;

  /// The full size of the area to the left of the widget.
  ///
  /// This represents a rectangle spanning the full screen height with width
  /// equal to [widthLeft].
  final Size sizeLeft;

  /// The full size of the area to the right of the widget.
  ///
  /// This represents a rectangle spanning the full screen height with width
  /// equal to [widthRight].
  final Size sizeRight;

  /// A constant [WidgetSpacing] instance with all measurements set to zero.
  ///
  /// This is returned by [getWidgetSpacing] when the widget hasn't been laid
  /// out yet or doesn't have a valid render object.
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

  /// Whether there is any available space to the left of the widget.
  bool get hasSpaceLeft => widthLeft > 0;

  /// Whether there is any available space to the right of the widget.
  bool get hasSpaceRight => widthRight > 0;

  /// Whether there is any available space above the widget.
  bool get hasSpaceAbove => heightAbove > 0;

  /// Whether there is any available space below the widget.
  bool get hasSpaceBelow => heightBelow > 0;
  /// Calculates optimal vertical positioning constraints for overlay placement.
  ///
  /// This method analyzes available vertical space and determines the best
  /// direction and constraints for positioning an overlay above or below the
  /// widget. It prioritizes the [desiredDirection] but will automatically
  /// switch to the opposite direction if insufficient space is available.
  ///
  /// The [minimumSpace] parameter specifies the minimum height required for
  /// the overlay. If the desired direction doesn't have enough space, the
  /// method will try the opposite direction.
  ///
  /// The [desiredDirection] indicates the preferred placement direction.
  /// Defaults to [VerticalDirection.down] (below the widget).
  ///
  /// The [maximumWidth] parameter allows constraining the overlay width.
  /// If null, defaults to the widget's width.
  ///
  /// Returns a record containing:
  /// - [BoxConstraints] that define the available space for the overlay
  /// - [VerticalDirection] indicating where the overlay should be placed
  ///
  /// If this is [WidgetSpacing.empty], returns zero constraints and
  /// [VerticalDirection.down].
  ///
  /// {@tool snippet}
  /// ```dart
  /// final spacing = getWidgetSpacing<LayoutSize>(context);
  /// final (constraints, direction) = spacing.constraintsVertical(
  ///   minimumSpace: 200,
  ///   desiredDirection: VerticalDirection.up,
  ///   maximumWidth: 300,
  /// );
  /// 
  /// final overlay = ConstrainedBox(
  ///   constraints: constraints,
  ///   child: MyOverlayContent(),
  /// );
  /// ```
  /// {@end-tool}
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

  /// Calculates optimal horizontal positioning constraints for overlay placement.
  ///
  /// This method analyzes available horizontal space and determines the best
  /// direction and constraints for positioning an overlay to the left or right
  /// of the widget. It prioritizes the [desiredDirection] but will automatically
  /// switch to the opposite direction if insufficient space is available.
  ///
  /// The [minimumWidth] parameter specifies the minimum width required for
  /// the overlay. If the desired direction doesn't have enough space, the
  /// method will try the opposite direction.
  ///
  /// The [desiredDirection] indicates the preferred placement direction.
  /// Defaults to [HorizonatalDirection.right] (to the right of the widget).
  ///
  /// The [maximumHeight] parameter allows constraining the overlay height.
  /// If null, defaults to the full screen height.
  ///
  /// Returns a record containing:
  /// - [BoxConstraints] that define the available space for the overlay
  /// - [HorizonatalDirection] indicating where the overlay should be placed
  ///
  /// If this is [WidgetSpacing.empty], returns zero constraints and
  /// [HorizonatalDirection.right].
  ///
  /// Note: There appears to be a typo in the method name - it should be
  /// "constraintsHorizontal" instead of "onstraintsHorizontal".
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

  /// Creates a copy of this [WidgetSpacing] with the given fields replaced.
  ///
  /// This method allows creating a modified version of the spacing data while
  /// preserving unchanged values. Useful for adjusting specific measurements
  /// or creating variations for different overlay scenarios.
  ///
  /// Any parameter set to null will preserve the current value from this
  /// instance.
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

  /// String representation of this [WidgetSpacing] instance.
  ///
  /// Returns a string containing all measurement values, useful for debugging
  /// and logging overlay positioning calculations.
  @override
  String toString() {
    return 'WidgetSpacing(maxHeight: $screenHeight, maxWidth: $screenWidth, widgetSize: $widgetSize, widgetPosition: $widgetPosition, heightAbove: $heightAbove, heightBelow: $heightBelow, widthLeft: $widthLeft, widthRight: $widthRight, sizeAbove: $sizeAbove, sizeBelow: $sizeBelow, sizeLeft: $sizeLeft, sizeRight: $sizeRight)';
  }

  /// Whether this [WidgetSpacing] is equal to another object.
  ///
  /// Two [WidgetSpacing] instances are considered equal if all their
  /// measurement properties have the same values.
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

  /// Hash code for this [WidgetSpacing] instance.
  ///
  /// The hash code is computed from all measurement properties to ensure
  /// consistent behavior when used in collections.
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

/// Represents horizontal directions for overlay positioning.
///
/// Used by [WidgetSpacing.onstraintsHorizontal] to indicate whether an
/// overlay should be positioned to the left or right of a widget.
///
/// Note: The enum name contains a typo - it should be "HorizontalDirection"
/// instead of "HorizonatalDirection".
enum HorizonatalDirection {
  /// Position the overlay to the left of the widget.
  left,

  /// Position the overlay to the right of the widget.
  right,
}
