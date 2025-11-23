import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware value selector (5 breakpoints) with responsive value passthrough when present.

class ScreenValueBuilderOrientation<K, V extends Object?>
    extends StatefulWidget {
  const ScreenValueBuilderOrientation({
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

  final ScreenValueBuilderFn<K, LayoutSize, V> builder;
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

  @override
  State<ScreenValueBuilderOrientation<K, V>> createState() =>
      _ScreenValueBuilderOrientationState<K, V>();
}

class _ScreenValueBuilderOrientationState<K, V extends Object?>
    extends State<ScreenValueBuilderOrientation<K, V>> {
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
    final dataWithValue =
        ScreenSizeModelWithValue.maybeOf<LayoutSize, V>(context);
    final screenData = dataWithValue?.asScreenData() ??
        ScreenSizeModel.of<LayoutSize>(context);
    final screenSize = screenData.screenSize;

    final value = handler.getScreenSizeValue(screenSize: screenSize);

    return widget.builder(
      context,
      value,
      data: screenData,
      responsiveValue: dataWithValue?.responsiveValue,
    );
  }
}
