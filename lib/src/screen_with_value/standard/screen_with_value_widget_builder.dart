import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// MediaQuery-driven widget selector that also provides a responsive value (5 breakpoints).

class ScreenWithValueWidgetBuilder<V extends Object?> extends StatefulWidget
    with AnimatedChildMixin {
  const ScreenWithValueWidgetBuilder({
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

  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? extraLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? large;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? medium;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? small;
  final ScreenWithValueWidgetBuilderFn<LayoutSize, V>? extraSmall;
  final Breakpoints breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWithValueWidgetBuilder<V>> createState() =>
      _ScreenWithValueWidgetBuilderState<V>();
}

class _ScreenWithValueWidgetBuilderState<V extends Object?>
    extends State<ScreenWithValueWidgetBuilder<V>> {
  late final BreakpointsHandler<ScreenWithValueWidgetBuilderFn<LayoutSize, V>>
      _handler =
      BreakpointsHandler<ScreenWithValueWidgetBuilderFn<LayoutSize, V>>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModelWithValue.of<LayoutSize, V>(context);
    final builder = _handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
