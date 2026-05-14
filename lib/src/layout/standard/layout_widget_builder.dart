import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// LayoutBuilder-driven widget selector using 5 breakpoints and local constraints.
class LayoutWidgetBuilder extends StatefulWidget with AnimatedChildMixin {
  /// Creates a layout-aware widget builder with optional per-breakpoint builders.
  const LayoutWidgetBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.useShortestSide = false,
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

  final LayoutWidgetBuilderFn? extraLarge;
  final LayoutWidgetBuilderFn? large;
  final LayoutWidgetBuilderFn? medium;
  final LayoutWidgetBuilderFn? small;
  final LayoutWidgetBuilderFn? extraSmall;

  /// Breakpoints used to map local constraints to layout buckets.
  final Breakpoints breakpoints;

  /// Whether to classify layout size using the shortest side of the constraints.
  final bool useShortestSide;

  /// Whether to animate transitions between resolved builders.
  @override
  final bool animateChange;

  @override
  State<LayoutWidgetBuilder> createState() => _LayoutWidgetBuilderState();
}

class _LayoutWidgetBuilderState extends State<LayoutWidgetBuilder> {
  late BreakpointsHandler<LayoutWidgetBuilderFn> _handler = _createHandler();

  BreakpointsHandler<LayoutWidgetBuilderFn> _createHandler() {
    return BreakpointsHandler<LayoutWidgetBuilderFn>(
      breakpoints: widget.breakpoints,
      extraLarge: widget.extraLarge,
      large: widget.large,
      medium: widget.medium,
      small: widget.small,
      extraSmall: widget.extraSmall,
    );
  }

  @override
  void didUpdateWidget(LayoutWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handler = _createHandler();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final builder = _handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: widget.useShortestSide,
        );
        return widget.maybeAnimate(builder(context));
      },
    );
  }
}
