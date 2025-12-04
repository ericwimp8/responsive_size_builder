import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// LayoutBuilder-driven widget selector (12 granular breakpoints, local constraints only).

class LayoutWidgetBuilderGranular extends StatefulWidget
    with AnimatedChildMixin {
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

  final BreakpointsGranular breakpoints;
  final bool useShortestSide;
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
