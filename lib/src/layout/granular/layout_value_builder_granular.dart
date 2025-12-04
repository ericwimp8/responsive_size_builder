import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Layout-only value selector that resolves a single value of type [K] from
/// local [LayoutBuilder] constraints using the 12-size
/// [LayoutSizeGranular] enum.
class LayoutValueBuilderGranular<K> extends StatefulWidget {
  const LayoutValueBuilderGranular({
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

  final BreakpointsGranular breakpoints;
  final bool useShortestSide;
  final LayoutValueBuilderFn<K> builder;

  @override
  State<LayoutValueBuilderGranular<K>> createState() =>
      _LayoutValueBuilderGranularState<K>();
}

class _LayoutValueBuilderGranularState<K>
    extends State<LayoutValueBuilderGranular<K>> {
  late BreakpointsHandlerGranular<K> _handler = _createHandler();

  BreakpointsHandlerGranular<K> _createHandler() {
    return BreakpointsHandlerGranular<K>(
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
  }

  @override
  void didUpdateWidget(LayoutValueBuilderGranular<K> oldWidget) {
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
