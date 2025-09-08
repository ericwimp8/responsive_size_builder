import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class LayoutSizeBuilder extends StatefulWidget {
  const LayoutSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for portrait must be provided',
        );

  final WidgetBuilder? extraLarge;

  final WidgetBuilder? large;

  final WidgetBuilder? medium;

  final WidgetBuilder? small;

  final WidgetBuilder? extraSmall;

  final Breakpoints breakpoints;

  @override
  State<LayoutSizeBuilder> createState() => _LayoutSizeBuilderState();
}

class _LayoutSizeBuilderState extends State<LayoutSizeBuilder> {
  late BreakpointsHandler<WidgetBuilder> handler =
      BreakpointsHandler<WidgetBuilder>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Get the appropriate widget builder based on current constraints
        // and invoke it with the current context
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context);
      },
    );
  }
}
