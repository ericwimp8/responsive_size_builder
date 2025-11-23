import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware granular value selector (12 breakpoints) with optional responsive value passthrough.

class ScreenValueBuilderGranularOrientation<K, V extends Object?>
    extends StatefulWidget {
  const ScreenValueBuilderGranularOrientation({
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
          'Provide at least one portrait or landscape value',
        );

  final ScreenValueBuilderFn<K, LayoutSizeGranular, V> builder;

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

  final K? jumboExtraLargeLandscape;
  final K? jumboLargeLandscape;
  final K? jumboNormalLandscape;
  final K? jumboSmallLandscape;
  final K? standardExtraLargeLandscape;
  final K? standardLargeLandscape;
  final K? standardNormalLandscape;
  final K? standardSmallLandscape;
  final K? compactExtraLargeLandscape;
  final K? compactLargeLandscape;
  final K? compactNormalLandscape;
  final K? compactSmallLandscape;
  final K? tinyLandscape;

  final BreakpointsGranular breakpoints;

  @override
  State<ScreenValueBuilderGranularOrientation<K, V>> createState() =>
      _ScreenValueBuilderGranularOrientationState<K, V>();
}

class _ScreenValueBuilderGranularOrientationState<K, V extends Object?>
    extends State<ScreenValueBuilderGranularOrientation<K, V>> {
  BreakpointsHandlerGranular<K> _handlerFor(Orientation orientation) {
    final portrait = <LayoutSizeGranular, K?>{
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

    final landscape = <LayoutSizeGranular, K?>{
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

    return BreakpointsHandlerGranular<K>(
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
    final dataWithValue =
        ScreenSizeModelWithValue.maybeOf<LayoutSizeGranular, V>(context);
    final screenData = dataWithValue?.asScreenData() ??
        ScreenSizeModel.of<LayoutSizeGranular>(context);
    final screenSize = screenData.screenSize;

    final value = handler.getScreenSizeValue(screenSize: screenSize);

    return widget.builder(
      context,
      value,
      data: screenData,
      responsiveValue: dataWithValue?.responsiveValue,
    );
  }
}
