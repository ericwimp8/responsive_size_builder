import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware widget selector with responsive value (5 breakpoints).

class ScreenWithValueWidgetBuilderOrientation<V extends Object?>
    extends StatefulWidget with AnimatedChildMixin {
  const ScreenWithValueWidgetBuilderOrientation({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.extraLargeLandscape,
    this.largeLandscape,
    this.mediumLandscape,
    this.smallLandscape,
    this.extraSmallLandscape,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  }) : assert(
          (extraLarge != null ||
                  large != null ||
                  medium != null ||
                  small != null ||
                  extraSmall != null) ||
              (extraLargeLandscape != null ||
                  largeLandscape != null ||
                  mediumLandscape != null ||
                  smallLandscape != null ||
                  extraSmallLandscape != null),
          'Provide at least one portrait or landscape builder',
        );

  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? extraLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? large;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? medium;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? small;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? extraSmall;

  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? extraLargeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? largeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? mediumLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? smallLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? extraSmallLandscape;

  final Breakpoints breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWithValueWidgetBuilderOrientation<V>> createState() =>
      _ScreenWithValueWidgetBuilderOrientationState<V>();
}

class _ScreenWithValueWidgetBuilderOrientationState<V extends Object?>
    extends State<ScreenWithValueWidgetBuilderOrientation<V>> {
  BreakpointsHandler<ScreenWithValueWidgetBuilderFn<LayoutSize, V>> _handlerFor(
    Orientation orientation,
  ) {
    final portrait =
        <LayoutSize, ScreenWithValueWidgetBuilderFn<LayoutSize, V>?>{
      LayoutSize.extraLarge: widget.extraLarge,
      LayoutSize.large: widget.large,
      LayoutSize.medium: widget.medium,
      LayoutSize.small: widget.small,
      LayoutSize.extraSmall: widget.extraSmall,
    };
    final landscape =
        <LayoutSize, ScreenWithValueWidgetBuilderFn<LayoutSize, V>?>{
      LayoutSize.extraLarge: widget.extraLargeLandscape,
      LayoutSize.large: widget.largeLandscape,
      LayoutSize.medium: widget.mediumLandscape,
      LayoutSize.small: widget.smallLandscape,
      LayoutSize.extraSmall: widget.extraSmallLandscape,
    };

    final selected = resolveOrientationValues(
      orientation: orientation,
      portrait: portrait,
      landscape: landscape,
    );

    return BreakpointsHandler<ScreenWithValueWidgetBuilderFn<LayoutSize, V>>(
      breakpoints: widget.breakpoints,
      extraLarge: selected[LayoutSize.extraLarge],
      large: selected[LayoutSize.large],
      medium: selected[LayoutSize.medium],
      small: selected[LayoutSize.small],
      extraSmall: selected[LayoutSize.extraSmall],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final handler = _handlerFor(orientation);
    final data = ScreenSizeModelWithValue.of<LayoutSize, V>(context);
    final builder = handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
