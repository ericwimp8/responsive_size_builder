import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Layout-only value selector that resolves a single value of type [K] from
/// local [LayoutBuilder] constraints using 5 breakpoints.
class LayoutValueBuilder<K> extends StatefulWidget {
  const LayoutValueBuilder({
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
  final Breakpoints breakpoints;
  final bool useShortestSide;
  final LayoutValueBuilderFn<K> builder;

  @override
  State<LayoutValueBuilder<K>> createState() => _LayoutValueBuilderState<K>();
}

class _LayoutValueBuilderState<K> extends State<LayoutValueBuilder<K>> {
  late final BreakpointsHandler<K> _handler = BreakpointsHandler<K>(
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
      builder: (context, constraints) {
        final value = _handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: widget.useShortestSide,
        );
        return widget.builder(context, value);
      },
    );
  }
}
