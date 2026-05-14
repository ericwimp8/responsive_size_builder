import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Layout-only value selector that resolves a single value of type [K] from
/// local [LayoutBuilder] constraints using 5 breakpoints.
class LayoutValueBuilder<K> extends StatefulWidget {
  /// Creates a layout-aware value selector builder with optional per-breakpoint values.
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

  /// Value used when layout width/height maps to an extra-large breakpoint.
  final K? extraLarge;

  /// Value used when layout width/height maps to a large breakpoint.
  final K? large;

  /// Value used when layout width/height maps to a medium breakpoint.
  final K? medium;

  /// Value used when layout width/height maps to a small breakpoint.
  final K? small;

  /// Value used when layout width/height maps to an extra-small breakpoint.
  final K? extraSmall;

  /// Breakpoints used to classify the current layout size.
  final Breakpoints breakpoints;

  /// Whether to resolve breakpoints using the shortest constraint side.
  final bool useShortestSide;

  /// Builds the widget tree using the resolved breakpoint value.
  final LayoutValueBuilderFn<K> builder;

  @override
  State<LayoutValueBuilder<K>> createState() => _LayoutValueBuilderState<K>();
}

class _LayoutValueBuilderState<K> extends State<LayoutValueBuilder<K>> {
  late BreakpointsHandler<K> _handler = _createHandler();

  BreakpointsHandler<K> _createHandler() {
    return BreakpointsHandler<K>(
      breakpoints: widget.breakpoints,
      extraLarge: widget.extraLarge,
      large: widget.large,
      medium: widget.medium,
      small: widget.small,
      extraSmall: widget.extraSmall,
    );
  }

  @override
  void didUpdateWidget(LayoutValueBuilder<K> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handler = _createHandler();
  }

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
