import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeBuilderGranular extends StatefulWidget {
  const ScreenSizeBuilderGranular({
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

  final ScreenSizeWidgetBuilder? jumboExtraLarge;

  final ScreenSizeWidgetBuilder? jumboLarge;

  final ScreenSizeWidgetBuilder? jumboNormal;

  final ScreenSizeWidgetBuilder? jumboSmall;

  final ScreenSizeWidgetBuilder? standardExtraLarge;

  final ScreenSizeWidgetBuilder? standardLarge;

  final ScreenSizeWidgetBuilder? standardNormal;

  final ScreenSizeWidgetBuilder? standardSmall;

  final ScreenSizeWidgetBuilder? compactExtraLarge;

  final ScreenSizeWidgetBuilder? compactLarge;

  final ScreenSizeWidgetBuilder? compactNormal;

  final ScreenSizeWidgetBuilder? compactSmall;

  final ScreenSizeWidgetBuilder? tiny;

  final bool animateChange;

  final BreakpointsGranular breakpoints;

  @override
  State<ScreenSizeBuilderGranular> createState() =>
      _ScreenSizeBuilderGranularState();
}

class _ScreenSizeBuilderGranularState extends State<ScreenSizeBuilderGranular> {
  late BreakpointsHandlerGranular<ScreenSizeWidgetBuilder> handler =
      BreakpointsHandlerGranular<ScreenSizeWidgetBuilder>(
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
