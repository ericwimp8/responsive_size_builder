import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware granular LayoutBuilder widget selector (12 breakpoints).

class LayoutWidgetBuilderGranularOrientation extends StatefulWidget
    with AnimatedChildMixin {
  const LayoutWidgetBuilderGranularOrientation({
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

  final LayoutWidgetBuilderFn? jumboExtraLargeLandscape;
  final LayoutWidgetBuilderFn? jumboLargeLandscape;
  final LayoutWidgetBuilderFn? jumboNormalLandscape;
  final LayoutWidgetBuilderFn? jumboSmallLandscape;
  final LayoutWidgetBuilderFn? standardExtraLargeLandscape;
  final LayoutWidgetBuilderFn? standardLargeLandscape;
  final LayoutWidgetBuilderFn? standardNormalLandscape;
  final LayoutWidgetBuilderFn? standardSmallLandscape;
  final LayoutWidgetBuilderFn? compactExtraLargeLandscape;
  final LayoutWidgetBuilderFn? compactLargeLandscape;
  final LayoutWidgetBuilderFn? compactNormalLandscape;
  final LayoutWidgetBuilderFn? compactSmallLandscape;
  final LayoutWidgetBuilderFn? tinyLandscape;

  final BreakpointsGranular breakpoints;
  final bool useShortestSide;
  @override
  final bool animateChange;

  @override
  State<LayoutWidgetBuilderGranularOrientation> createState() =>
      _LayoutWidgetBuilderGranularOrientationState();
}

class _LayoutWidgetBuilderGranularOrientationState
    extends State<LayoutWidgetBuilderGranularOrientation> {
  BreakpointsHandlerGranular<LayoutWidgetBuilderFn> _handlerFor(
    Orientation orientation,
  ) {
    final portrait = <LayoutSizeGranular, LayoutWidgetBuilderFn?>{
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

    final landscape = <LayoutSizeGranular, LayoutWidgetBuilderFn?>{
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

    return BreakpointsHandlerGranular<LayoutWidgetBuilderFn>(
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final builder = handler.getLayoutSizeValue(
          constraints: constraints,
          useShortestSide: widget.useShortestSide,
        );
        return widget.maybeAnimate(builder(context));
      },
    );
  }
}
