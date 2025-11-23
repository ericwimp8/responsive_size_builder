import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware LayoutBuilder widget selector (5 breakpoints, local constraints).

class LayoutWidgetBuilderOrientation extends StatefulWidget
    with AnimatedChildMixin {
  const LayoutWidgetBuilderOrientation({
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
    this.useShortestSide = false,
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

  final LayoutWidgetBuilderFn? extraLarge;
  final LayoutWidgetBuilderFn? large;
  final LayoutWidgetBuilderFn? medium;
  final LayoutWidgetBuilderFn? small;
  final LayoutWidgetBuilderFn? extraSmall;

  final LayoutWidgetBuilderFn? extraLargeLandscape;
  final LayoutWidgetBuilderFn? largeLandscape;
  final LayoutWidgetBuilderFn? mediumLandscape;
  final LayoutWidgetBuilderFn? smallLandscape;
  final LayoutWidgetBuilderFn? extraSmallLandscape;

  final Breakpoints breakpoints;
  final bool useShortestSide;
  @override
  final bool animateChange;

  @override
  State<LayoutWidgetBuilderOrientation> createState() =>
      _LayoutWidgetBuilderOrientationState();
}

class _LayoutWidgetBuilderOrientationState
    extends State<LayoutWidgetBuilderOrientation> {
  BreakpointsHandler<LayoutWidgetBuilderFn> _handlerFor(
    Orientation orientation,
  ) {
    final portrait = <LayoutSize, LayoutWidgetBuilderFn?>{
      LayoutSize.extraLarge: widget.extraLarge,
      LayoutSize.large: widget.large,
      LayoutSize.medium: widget.medium,
      LayoutSize.small: widget.small,
      LayoutSize.extraSmall: widget.extraSmall,
    };

    final landscape = <LayoutSize, LayoutWidgetBuilderFn?>{
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

    return BreakpointsHandler<LayoutWidgetBuilderFn>(
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final builder = handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: widget.useShortestSide,
        );
        return widget.maybeAnimate(builder(context));
      },
    );
  }
}
