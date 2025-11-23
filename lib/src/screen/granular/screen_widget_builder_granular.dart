import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// MediaQuery-driven widget selector using 12 granular breakpoints.

class ScreenWidgetBuilderGranular extends StatefulWidget
    with AnimatedChildMixin {
  const ScreenWidgetBuilderGranular({
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
    this.animateChange = false,
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
          'At least one builder must be provided',
        );

  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboExtraLarge;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboLarge;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboNormal;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboSmall;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardExtraLarge;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardLarge;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardNormal;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardSmall;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactExtraLarge;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactLarge;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactNormal;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactSmall;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? tiny;
  final BreakpointsGranular breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWidgetBuilderGranular> createState() =>
      _ScreenWidgetBuilderGranularState();
}

class _ScreenWidgetBuilderGranularState
    extends State<ScreenWidgetBuilderGranular> {
  late final BreakpointsHandlerGranular<
          ScreenWidgetBuilderFn<LayoutSizeGranular>> _handler =
      BreakpointsHandlerGranular<ScreenWidgetBuilderFn<LayoutSizeGranular>>(
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
    final data = ScreenSizeModel.of<LayoutSizeGranular>(context);
    final builder = _handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
