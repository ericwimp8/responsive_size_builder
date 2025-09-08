import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

typedef ScreenSizeWithValueWidgetBuilder<V extends Object?> = Widget Function(
  BuildContext context,
  ScreenSizeModelDataWithValue<LayoutSize, V> data,
);

class ScreenSizeWithValueBuilder<V extends Object?> extends StatefulWidget {
  const ScreenSizeWithValueBuilder({
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

  final ScreenSizeWithValueWidgetBuilder<V>? extraLarge;

  final ScreenSizeWithValueWidgetBuilder<V>? large;

  final ScreenSizeWithValueWidgetBuilder<V>? medium;

  final ScreenSizeWithValueWidgetBuilder<V>? small;

  final ScreenSizeWithValueWidgetBuilder<V>? extraSmall;

  final Breakpoints breakpoints;

  final bool animateChange;

  @override
  State<ScreenSizeWithValueBuilder<V>> createState() =>
      _ScreenSizeWithValueBuilderState<V>();
}

class _ScreenSizeWithValueBuilderState<V extends Object?>
    extends State<ScreenSizeWithValueBuilder<V>> {
  late BreakpointsHandler<ScreenSizeWithValueWidgetBuilder<V>> handler =
      BreakpointsHandler<ScreenSizeWithValueWidgetBuilder<V>>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModelWithValue.of<LayoutSize, V>(
      context,
    );

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
