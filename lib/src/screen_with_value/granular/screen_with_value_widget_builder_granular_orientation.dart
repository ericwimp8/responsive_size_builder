import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware granular widget selector with responsive value (12 breakpoints).

class ScreenWithValueWidgetBuilderGranularOrientation<V extends Object?>
    extends StatefulWidget with AnimatedChildMixin {
  const ScreenWithValueWidgetBuilderGranularOrientation({
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
    this.jumboExtraLargeLandscape,
    this.jumboLargeLandscape,
    this.jumboNormalLandscape,
    this.jumboSmallLandscape,
    this.standardExtraLargeLandscape,
    this.standardLargeLandscape,
    this.standardNormalLandscape,
    this.standardSmallLandscape,
    this.compactExtraLargeLandscape,
    this.compactLargeLandscape,
    this.compactNormalLandscape,
    this.compactSmallLandscape,
    this.tinyLandscape,
    this.breakpoints = BreakpointsGranular.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  }) : assert(
          (jumboExtraLarge != null ||
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
                  tiny != null) ||
              (jumboExtraLargeLandscape != null ||
                  jumboLargeLandscape != null ||
                  jumboNormalLandscape != null ||
                  jumboSmallLandscape != null ||
                  standardExtraLargeLandscape != null ||
                  standardLargeLandscape != null ||
                  standardNormalLandscape != null ||
                  standardSmallLandscape != null ||
                  compactExtraLargeLandscape != null ||
                  compactLargeLandscape != null ||
                  compactNormalLandscape != null ||
                  compactSmallLandscape != null ||
                  tinyLandscape != null),
          'Provide at least one portrait or landscape builder',
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

  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      jumboExtraLargeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      jumboLargeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      jumboNormalLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      jumboSmallLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      standardExtraLargeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      standardLargeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      standardNormalLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      standardSmallLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      compactExtraLargeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      compactLargeLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      compactNormalLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?
      compactSmallLandscape;
  final ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>? tinyLandscape;

  final BreakpointsGranular breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWithValueWidgetBuilderGranularOrientation<V>> createState() =>
      _ScreenWithValueWidgetBuilderGranularOrientationState<V>();
}

class _ScreenWithValueWidgetBuilderGranularOrientationState<V extends Object?>
    extends State<ScreenWithValueWidgetBuilderGranularOrientation<V>> {
  BreakpointsHandlerGranular<
      ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>> _handlerFor(
    Orientation orientation,
  ) {
    final portrait = <LayoutSizeGranular,
        ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?>{
      LayoutSizeGranular.jumboExtraLarge: widget.jumboExtraLarge,
      LayoutSizeGranular.jumboLarge: widget.jumboLarge,
      LayoutSizeGranular.jumboNormal: widget.jumboNormal,
      LayoutSizeGranular.jumboSmall: widget.jumboSmall,
      LayoutSizeGranular.standardExtraLarge: widget.standardExtraLarge,
      LayoutSizeGranular.standardLarge: widget.standardLarge,
      LayoutSizeGranular.standardNormal: widget.standardNormal,
      LayoutSizeGranular.standardSmall: widget.standardSmall,
      LayoutSizeGranular.compactExtraLarge: widget.compactExtraLarge,
      LayoutSizeGranular.compactLarge: widget.compactLarge,
      LayoutSizeGranular.compactNormal: widget.compactNormal,
      LayoutSizeGranular.compactSmall: widget.compactSmall,
      LayoutSizeGranular.tiny: widget.tiny,
    };

    final landscape = <LayoutSizeGranular,
        ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>?>{
      LayoutSizeGranular.jumboExtraLarge: widget.jumboExtraLargeLandscape,
      LayoutSizeGranular.jumboLarge: widget.jumboLargeLandscape,
      LayoutSizeGranular.jumboNormal: widget.jumboNormalLandscape,
      LayoutSizeGranular.jumboSmall: widget.jumboSmallLandscape,
      LayoutSizeGranular.standardExtraLarge: widget.standardExtraLargeLandscape,
      LayoutSizeGranular.standardLarge: widget.standardLargeLandscape,
      LayoutSizeGranular.standardNormal: widget.standardNormalLandscape,
      LayoutSizeGranular.standardSmall: widget.standardSmallLandscape,
      LayoutSizeGranular.compactExtraLarge: widget.compactExtraLargeLandscape,
      LayoutSizeGranular.compactLarge: widget.compactLargeLandscape,
      LayoutSizeGranular.compactNormal: widget.compactNormalLandscape,
      LayoutSizeGranular.compactSmall: widget.compactSmallLandscape,
      LayoutSizeGranular.tiny: widget.tinyLandscape,
    };

    final selected = resolveOrientationValues(
      orientation: orientation,
      portrait: portrait,
      landscape: landscape,
    );

    return BreakpointsHandlerGranular<
        ScreenWithValueWidgetBuilderFn<LayoutSizeGranular, V>>(
      breakpoints: widget.breakpoints,
      jumboExtraLarge: selected[LayoutSizeGranular.jumboExtraLarge],
      jumboLarge: selected[LayoutSizeGranular.jumboLarge],
      jumboNormal: selected[LayoutSizeGranular.jumboNormal],
      jumboSmall: selected[LayoutSizeGranular.jumboSmall],
      standardExtraLarge: selected[LayoutSizeGranular.standardExtraLarge],
      standardLarge: selected[LayoutSizeGranular.standardLarge],
      standardNormal: selected[LayoutSizeGranular.standardNormal],
      standardSmall: selected[LayoutSizeGranular.standardSmall],
      compactExtraLarge: selected[LayoutSizeGranular.compactExtraLarge],
      compactLarge: selected[LayoutSizeGranular.compactLarge],
      compactNormal: selected[LayoutSizeGranular.compactNormal],
      compactSmall: selected[LayoutSizeGranular.compactSmall],
      tiny: selected[LayoutSizeGranular.tiny],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    final handler = _handlerFor(orientation);
    final data = ScreenSizeModelWithValue.of<LayoutSizeGranular, V>(context);
    final builder = handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
