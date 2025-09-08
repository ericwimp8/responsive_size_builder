import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

typedef ScreenSizeWidgetBuilder = Widget Function(
  BuildContext context,
  ScreenSizeModelData data,
);

class ScreenSizeOrientationBuilder extends StatefulWidget {
  const ScreenSizeOrientationBuilder({
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

  final WidgetBuilder? extraLarge;

  final WidgetBuilder? large;

  final WidgetBuilder? medium;

  final WidgetBuilder? small;

  final WidgetBuilder? extraSmall;

  final WidgetBuilder? extraLargeLandscape;

  final WidgetBuilder? largeLandscape;

  final WidgetBuilder? mediumLandscape;

  final WidgetBuilder? smallLandscape;

  final WidgetBuilder? extraSmallLandscape;

  final Breakpoints breakpoints;

  final bool animateChange;

  @override
  State<ScreenSizeOrientationBuilder> createState() =>
      _ScreenSizeOrientationBuilderState();
}

class _ScreenSizeOrientationBuilderState
    extends State<ScreenSizeOrientationBuilder> {
  late BreakpointsHandler<WidgetBuilder> handler;

  Orientation? orientation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _orientation = MediaQuery.orientationOf(context);
    if (orientation != _orientation) {
      orientation = _orientation;
      if (orientation == Orientation.portrait) {
        handler = BreakpointsHandler<WidgetBuilder>(
          breakpoints: widget.breakpoints,
          extraLarge: widget.extraLarge,
          large: widget.large,
          medium: widget.medium,
          small: widget.small,
          extraSmall: widget.extraSmall,
        );
      } else {
        handler = BreakpointsHandler<WidgetBuilder>(
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
    final data = ScreenSizeModel.screenSizeOf<LayoutSize>(context);

    var child = handler.getScreenSizeValue(
      screenSize: data,
    )(
      context,
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
