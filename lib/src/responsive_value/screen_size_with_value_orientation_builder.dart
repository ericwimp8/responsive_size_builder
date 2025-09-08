import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeWithValueOrientationBuilder<V extends Object?>
    extends StatefulWidget {
  const ScreenSizeWithValueOrientationBuilder({
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
  })  : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for portrait must be provided',
        ),
        assert(
          extraLargeLandscape != null ||
              largeLandscape != null ||
              mediumLandscape != null ||
              smallLandscape != null ||
              extraSmallLandscape != null,
          'At least one builder for landscape must be provided',
        );

  final ScreenSizeWithValueWidgetBuilder<V>? extraLarge;

  final ScreenSizeWithValueWidgetBuilder<V>? large;

  final ScreenSizeWithValueWidgetBuilder<V>? medium;

  final ScreenSizeWithValueWidgetBuilder<V>? small;

  final ScreenSizeWithValueWidgetBuilder<V>? extraSmall;

  final ScreenSizeWithValueWidgetBuilder<V>? extraLargeLandscape;

  final ScreenSizeWithValueWidgetBuilder<V>? largeLandscape;

  final ScreenSizeWithValueWidgetBuilder<V>? mediumLandscape;

  final ScreenSizeWithValueWidgetBuilder<V>? smallLandscape;

  final ScreenSizeWithValueWidgetBuilder<V>? extraSmallLandscape;

  final Breakpoints breakpoints;

  final bool animateChange;

  @override
  State<ScreenSizeWithValueOrientationBuilder<V>> createState() =>
      _ScreenSizeWithValueOrientationBuilderState<V>();
}

class _ScreenSizeWithValueOrientationBuilderState<V extends Object?>
    extends State<ScreenSizeWithValueOrientationBuilder<V>> {
  late BreakpointsHandler<ScreenSizeWithValueWidgetBuilder<V>> handler;

  Orientation? orientation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _orientation = MediaQuery.orientationOf(context);
    if (orientation != _orientation) {
      orientation = _orientation;
      if (orientation == Orientation.portrait) {
        handler = BreakpointsHandler<ScreenSizeWithValueWidgetBuilder<V>>(
          breakpoints: widget.breakpoints,
          extraLarge: widget.extraLarge,
          large: widget.large,
          medium: widget.medium,
          small: widget.small,
          extraSmall: widget.extraSmall,
        );
      } else {
        handler = BreakpointsHandler<ScreenSizeWithValueWidgetBuilder<V>>(
          breakpoints: widget.breakpoints,
          extraLarge: widget.extraLargeLandscape,
          large: widget.largeLandscape,
          medium: widget.mediumLandscape,
          small: widget.smallLandscape,
          extraSmall: widget.extraSmallLandscape,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModelWithValue.of<LayoutSize, V>(context);

    var child = handler.getScreenSizeValue(
      screenSize: data.screenSize,
    )(
      context,
      data,
    );

    if (widget.animateChange) {
      child = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      );
    }
    return child;
  }
}
