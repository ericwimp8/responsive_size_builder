import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Granular value builder that resolves breakpoints from local
/// `LayoutBuilder` constraints.
class LayoutValueSizeBuilderGranular<K> extends StatefulWidget {
  const LayoutValueSizeBuilderGranular({
    required this.builder,
    this.jumboExtraLarge,
    this.jumboLarge,
    this.jumboNormal,
    this.jumboSmall,
    this.standardExtraLarge,
    this.standardLarge,
    this.standardNormal,
    this.standardSmall,
    this.compactExtraLarge,
    this.compactLarge,
    this.compactNormal,
    this.compactSmall,
    this.tiny,
    this.breakpoints = BreakpointsGranular.defaultBreakpoints,
    this.useShortestSide = false,
    super.key,
  }) : assert(
          jumboExtraLarge != null ||
              jumboLarge != null ||
              jumboNormal != null ||
              jumboSmall != null ||
              standardExtraLarge != null ||
              standardLarge != null ||
              standardNormal != null ||
              standardSmall != null ||
              compactExtraLarge != null ||
              compactLarge != null ||
              compactNormal != null ||
              compactSmall != null ||
              tiny != null,
          'At least one value must be provided',
        );

  final K? jumboExtraLarge;

  final K? jumboLarge;

  final K? jumboNormal;

  final K? jumboSmall;

  final K? standardExtraLarge;

  final K? standardLarge;

  final K? standardNormal;

  final K? standardSmall;

  final K? compactExtraLarge;

  final K? compactLarge;

  final K? compactNormal;

  final K? compactSmall;

  final K? tiny;

  /// Called with the resolved value for the current constraints.
  final Widget Function(BuildContext context, K value) builder;

  /// Breakpoint configuration used to classify the constraints.
  final BreakpointsGranular breakpoints;

  /// Whether to classify using the shortest side instead of width.
  final bool useShortestSide;

  @override
  State<LayoutValueSizeBuilderGranular<K>> createState() =>
      _LayoutValueSizeBuilderGranularState<K>();
}

class _LayoutValueSizeBuilderGranularState<K>
    extends State<LayoutValueSizeBuilderGranular<K>> {
  late final handler = BreakpointsHandlerGranular<K>(
    breakpoints: widget.breakpoints,
    jumboExtraLarge: widget.jumboExtraLarge,
    jumboLarge: widget.jumboLarge,
    jumboNormal: widget.jumboNormal,
    jumboSmall: widget.jumboSmall,
    standardExtraLarge: widget.standardExtraLarge,
    standardLarge: widget.standardLarge,
    standardNormal: widget.standardNormal,
    standardSmall: widget.standardSmall,
    compactExtraLarge: widget.compactExtraLarge,
    compactLarge: widget.compactLarge,
    compactNormal: widget.compactNormal,
    compactSmall: widget.compactSmall,
    tiny: widget.tiny,
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
