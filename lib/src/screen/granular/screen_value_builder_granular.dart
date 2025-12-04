import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Granular MediaQuery-driven value selector (12 breakpoints) with optional responsive value exposure.

class ScreenValueBuilderGranular<K, V extends Object?> extends StatefulWidget {
  const ScreenValueBuilderGranular({
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
  final BreakpointsGranular breakpoints;

  @override
  State<ScreenValueBuilderGranular<K, V>> createState() =>
      _ScreenValueBuilderGranularState<K, V>();
}

class _ScreenValueBuilderGranularState<K, V extends Object?>
    extends State<ScreenValueBuilderGranular<K, V>> {
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
  void didUpdateWidget(ScreenValueBuilderGranular<K, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handler = _createHandler();
  }

  @override
  Widget build(BuildContext context) {
    final dataWithValue =
        ScreenSizeModelWithValue.maybeOf<LayoutSizeGranular, V>(context);
    final screenData = dataWithValue?.asScreenData() ??
        ScreenSizeModel.of<LayoutSizeGranular>(context);
    final screenSize = screenData.screenSize;

    final value = _handler.getScreenSizeValue(screenSize: screenSize);

    return widget.builder(
      context,
      value,
      data: screenData,
      responsiveValue: dataWithValue?.responsiveValue,
    );
  }
}
