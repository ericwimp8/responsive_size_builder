import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Granular MediaQuery widget selector with responsive value (12 breakpoints).

class ScreenWithValueWidgetBuilderGranular<V extends Object?>
    extends StatefulWidget with AnimatedChildMixin {
  const ScreenWithValueWidgetBuilderGranular({
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

  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? jumboExtraLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? jumboLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? jumboNormal;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? jumboSmall;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      standardExtraLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? standardLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? standardNormal;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? standardSmall;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      compactExtraLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? compactLarge;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? compactNormal;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? compactSmall;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? tiny;
  final BreakpointsGranular breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWithValueWidgetBuilderGranular<V>> createState() =>
      _ScreenWithValueWidgetBuilderGranularState<V>();
}

class _ScreenWithValueWidgetBuilderGranularState<V extends Object?>
    extends State<ScreenWithValueWidgetBuilderGranular<V>> {
  late final BreakpointsHandlerGranular<
          ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>> _handler =
      BreakpointsHandlerGranular<
          ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>>(
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
    final data = ScreenSizeModelWithValue.of<LayoutSizeGranular, V>(context);
    final builder = _handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
