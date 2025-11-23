import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Value builder that resolves the active breakpoint from local
/// `LayoutBuilder` constraints instead of global `ScreenSize` data.
class LayoutValueSizeBuilder<K> extends StatefulWidget {
  const LayoutValueSizeBuilder({
    required this.builder,
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.useShortestSide = false,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one value must be provided',
        );

  final K? extraLarge;

  final K? large;

  final K? medium;

  final K? small;

  final K? extraSmall;

  /// Called with the resolved value for the current constraints.
  final Widget Function(BuildContext context, K value) builder;

  /// Breakpoint configuration used to classify the constraints.
  final Breakpoints breakpoints;

  /// Whether to classify using the shortest side instead of width.
  final bool useShortestSide;

  @override
  State<LayoutValueSizeBuilder<K>> createState() =>
      _LayoutValueSizeBuilderState<K>();
}

class _LayoutValueSizeBuilderState<K> extends State<LayoutValueSizeBuilder<K>> {
  late final handler = BreakpointsHandler<K>(
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
        final value = handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: widget.useShortestSide,
        );

        return widget.builder(context, value);
      },
    );
  }
}
