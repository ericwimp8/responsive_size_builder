import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class LayoutSizeBuilderGranular extends StatefulWidget {
  const LayoutSizeBuilderGranular({
    this.breakpoints = BreakpointsGranular.defaultBreakpoints,
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
    super.key,
  });

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

  final BreakpointsGranular breakpoints;

  @override
  State<LayoutSizeBuilderGranular> createState() => _LayoutSizeGranularState();
}

class _LayoutSizeGranularState extends State<LayoutSizeBuilderGranular> {
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
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Retrieve comprehensive screen size data from the ancestor ScreenSize widget
        // This provides additional context beyond just the layout constraints
        final data = ScreenSizeModel.of<LayoutSize>(
          context,
        );

        // Get the appropriate widget builder based on current constraints
        // and invoke it with both context and screen size data for enhanced decision making
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context, data);
      },
    );
  }
}
