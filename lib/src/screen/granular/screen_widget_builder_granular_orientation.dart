import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware granular screen widget selector (12 breakpoints).

class ScreenWidgetBuilderGranularOrientation extends StatefulWidget
    with AnimatedChildMixin {
  const ScreenWidgetBuilderGranularOrientation({
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

  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboExtraLargeLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboLargeLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboNormalLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? jumboSmallLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardExtraLargeLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardLargeLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardNormalLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? standardSmallLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactExtraLargeLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactLargeLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactNormalLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? compactSmallLandscape;
  final ScreenWidgetBuilderFn<LayoutSizeGranular>? tinyLandscape;

  final BreakpointsGranular breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWidgetBuilderGranularOrientation> createState() =>
      _ScreenWidgetBuilderGranularOrientationState();
}

class _ScreenWidgetBuilderGranularOrientationState
    extends State<ScreenWidgetBuilderGranularOrientation> {
  BreakpointsHandlerGranular<ScreenWidgetBuilderFn<LayoutSizeGranular>>
      _handlerFor(Orientation orientation) {
    final portraitValues =
        <LayoutSizeGranular, ScreenWidgetBuilderFn<LayoutSizeGranular>?>{
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

    final landscapeValues =
        <LayoutSizeGranular, ScreenWidgetBuilderFn<LayoutSizeGranular>?>{
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
      portrait: portraitValues,
      landscape: landscapeValues,
    );

    return BreakpointsHandlerGranular<
        ScreenWidgetBuilderFn<LayoutSizeGranular>>(
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
    final data = ScreenSizeModel.of<LayoutSizeGranular>(context);
    final builder = handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
