import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// MediaQuery-driven widget selector using 5 breakpoints.

class ScreenWidgetBuilder extends StatefulWidget with AnimatedChildMixin {
  const ScreenWidgetBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder must be provided',
        );

  final ScreenWidgetBuilderFn<LayoutSize>? extraLarge;
  final ScreenWidgetBuilderFn<LayoutSize>? large;
  final ScreenWidgetBuilderFn<LayoutSize>? medium;
  final ScreenWidgetBuilderFn<LayoutSize>? small;
  final ScreenWidgetBuilderFn<LayoutSize>? extraSmall;
  final Breakpoints breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWidgetBuilder> createState() => _ScreenWidgetBuilderState();
}

class _ScreenWidgetBuilderState extends State<ScreenWidgetBuilder> {
  late final BreakpointsHandler<ScreenWidgetBuilderFn<LayoutSize>> _handler =
      BreakpointsHandler<ScreenWidgetBuilderFn<LayoutSize>>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(context);
    final builder = _handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
