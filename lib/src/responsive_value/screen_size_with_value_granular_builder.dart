import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

typedef ScreenSizeWithValueBuilderGranularWidgetBuilder<V extends Object?>
    = Widget Function(
  BuildContext context,
  ScreenSizeModelDataWithValue<LayoutSizeGranular, V> data,
);

class ScreenSizeWithValueBuilderGranular<V extends Object?>
    extends StatefulWidget {
  const ScreenSizeWithValueBuilderGranular({
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

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? jumboExtraLarge;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? jumboLarge;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? jumboNormal;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? jumboSmall;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? standardExtraLarge;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? standardLarge;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? standardNormal;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? standardSmall;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? compactExtraLarge;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? compactLarge;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? compactNormal;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? compactSmall;

  final ScreenSizeWithValueBuilderGranularWidgetBuilder<V>? tiny;

  final bool animateChange;

  final BreakpointsGranular breakpoints;

  @override
  State<ScreenSizeWithValueBuilderGranular<V>> createState() =>
      _ScreenSizeWithValueBuilderGranularState<V>();
}

class _ScreenSizeWithValueBuilderGranularState<V extends Object?>
    extends State<ScreenSizeWithValueBuilderGranular<V>> {
  late BreakpointsHandlerGranular<
          ScreenSizeWithValueBuilderGranularWidgetBuilder<V>> handler =
      BreakpointsHandlerGranular<
          ScreenSizeWithValueBuilderGranularWidgetBuilder<V>>(
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
    final data = ScreenSizeModelWithValue.of<LayoutSizeGranular, V>(
      context,
    );

    var child = handler.getScreenSizeValue(
      screenSize: data.screenSize,
    )(
      context,
      data,
    );

    if (widget.animateChange) {
      child = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      );
    }

    return child;
  }
}
