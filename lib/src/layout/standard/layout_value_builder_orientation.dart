import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware layout-only value selector that resolves a single value
/// of type [K] from local [LayoutBuilder] constraints using 5 breakpoints.
class LayoutValueBuilderOrientation<K> extends StatefulWidget {
  const LayoutValueBuilderOrientation({
    required this.builder,
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
          'Provide at least one portrait or landscape value',
        );

  final LayoutValueBuilderFn<K> builder;
  final K? extraLarge;
  final K? large;
  final K? medium;
  final K? small;
  final K? extraSmall;

  final K? extraLargeLandscape;
  final K? largeLandscape;
  final K? mediumLandscape;
  final K? smallLandscape;
  final K? extraSmallLandscape;

  final Breakpoints breakpoints;
  final bool useShortestSide;

  @override
  State<LayoutValueBuilderOrientation<K>> createState() =>
      _LayoutValueBuilderOrientationState<K>();
}

class _LayoutValueBuilderOrientationState<K>
    extends State<LayoutValueBuilderOrientation<K>> {
  BreakpointsHandler<K> _handlerFor(Orientation orientation) {
    final portrait = <LayoutSize, K?>{
      LayoutSize.extraLarge: widget.extraLarge,
      LayoutSize.large: widget.large,
      LayoutSize.medium: widget.medium,
      LayoutSize.small: widget.small,
      LayoutSize.extraSmall: widget.extraSmall,
    };
    final landscape = <LayoutSize, K?>{
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

    return BreakpointsHandler<K>(
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
        final value = handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: widget.useShortestSide,
        );
        return widget.builder(context, value);
      },
    );
  }
}
