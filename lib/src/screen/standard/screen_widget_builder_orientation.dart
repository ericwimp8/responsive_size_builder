import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware screen widget selector (5 breakpoints, portrait/landscape sets with fallback).

class ScreenWidgetBuilderOrientation extends StatefulWidget
    with AnimatedChildMixin {
  const ScreenWidgetBuilderOrientation({
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

  final ScreenWidgetBuilderFn<LayoutSize>? extraLarge;
  final ScreenWidgetBuilderFn<LayoutSize>? large;
  final ScreenWidgetBuilderFn<LayoutSize>? medium;
  final ScreenWidgetBuilderFn<LayoutSize>? small;
  final ScreenWidgetBuilderFn<LayoutSize>? extraSmall;

  final ScreenWidgetBuilderFn<LayoutSize>? extraLargeLandscape;
  final ScreenWidgetBuilderFn<LayoutSize>? largeLandscape;
  final ScreenWidgetBuilderFn<LayoutSize>? mediumLandscape;
  final ScreenWidgetBuilderFn<LayoutSize>? smallLandscape;
  final ScreenWidgetBuilderFn<LayoutSize>? extraSmallLandscape;

  final Breakpoints breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWidgetBuilderOrientation> createState() =>
      _ScreenWidgetBuilderOrientationState();
}

class _ScreenWidgetBuilderOrientationState
    extends State<ScreenWidgetBuilderOrientation> {
  BreakpointsHandler<ScreenWidgetBuilderFn<LayoutSize>> _handlerFor(
    Orientation orientation,
  ) {
    final portraitValues = <LayoutSize, ScreenWidgetBuilderFn<LayoutSize>?>{
      LayoutSize.extraLarge: widget.extraLarge,
      LayoutSize.large: widget.large,
      LayoutSize.medium: widget.medium,
      LayoutSize.small: widget.small,
      LayoutSize.extraSmall: widget.extraSmall,
    };

    final landscapeValues = <LayoutSize, ScreenWidgetBuilderFn<LayoutSize>?>{
      LayoutSize.extraLarge: widget.extraLargeLandscape,
      LayoutSize.large: widget.largeLandscape,
      LayoutSize.medium: widget.mediumLandscape,
      LayoutSize.small: widget.smallLandscape,
      LayoutSize.extraSmall: widget.extraSmallLandscape,
    };

    final selected = resolveOrientationValues(
      orientation: orientation,
      portrait: portraitValues,
      landscape: landscapeValues,
    );

    return BreakpointsHandler<ScreenWidgetBuilderFn<LayoutSize>>(
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
    final data = ScreenSizeModel.of<LayoutSize>(context);
    final builder = handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
