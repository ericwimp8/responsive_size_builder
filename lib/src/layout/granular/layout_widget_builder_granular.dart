import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Builds a widget from local [LayoutBuilder] constraints using the 12-size
/// granular scale.
class LayoutWidgetBuilderGranular extends StatefulWidget
    with AnimatedChildMixin {
  /// Creates a granular layout-aware widget builder.
  const LayoutWidgetBuilderGranular({
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
    this.animateChange = false,
    super.key,
  });

  final LayoutWidgetBuilderFn? jumboExtraLarge;
  final LayoutWidgetBuilderFn? jumboLarge;
  final LayoutWidgetBuilderFn? jumboNormal;
  final LayoutWidgetBuilderFn? jumboSmall;
  final LayoutWidgetBuilderFn? standardExtraLarge;
  final LayoutWidgetBuilderFn? standardLarge;
  final LayoutWidgetBuilderFn? standardNormal;
  final LayoutWidgetBuilderFn? standardSmall;
  final LayoutWidgetBuilderFn? compactExtraLarge;
  final LayoutWidgetBuilderFn? compactLarge;
  final LayoutWidgetBuilderFn? compactNormal;
  final LayoutWidgetBuilderFn? compactSmall;
  final LayoutWidgetBuilderFn? tiny;

  /// Granular breakpoints used to map local constraints to layout buckets.
  final BreakpointsGranular breakpoints;

  /// Whether to classify layout size using the shortest side of the
  /// constraints.
  final bool useShortestSide;

  /// Whether to animate transitions between resolved builders.
  @override
  final bool animateChange;

  @override
  State<LayoutWidgetBuilderGranular> createState() =>
      _LayoutWidgetBuilderGranularState();
}

class _LayoutWidgetBuilderGranularState
    extends State<LayoutWidgetBuilderGranular> {
  late BreakpointsHandlerGranular<LayoutWidgetBuilderFn> _handler =
      _createHandler();

  BreakpointsHandlerGranular<LayoutWidgetBuilderFn> _createHandler() {
    return BreakpointsHandlerGranular<LayoutWidgetBuilderFn>(
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
  void didUpdateWidget(LayoutWidgetBuilderGranular oldWidget) {
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
