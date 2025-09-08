import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
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
          'At least one builder for must be provided',
        );

  final ScreenSizeWidgetBuilder? extraLarge;

  final ScreenSizeWidgetBuilder? large;

  final ScreenSizeWidgetBuilder? medium;

  final ScreenSizeWidgetBuilder? small;

  final ScreenSizeWidgetBuilder? extraSmall;

  final Breakpoints breakpoints;

  final bool animateChange;

  @override
  State<ScreenSizeBuilder> createState() => _ScreenSizeBuilderState();
}

class _ScreenSizeBuilderState extends State<ScreenSizeBuilder> {
  late BreakpointsHandler<ScreenSizeWidgetBuilder> handler =
      BreakpointsHandler<ScreenSizeWidgetBuilder>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(
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
