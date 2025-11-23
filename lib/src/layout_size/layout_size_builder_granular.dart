import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Layout-only widget selector using 12 granular breakpoints derived from
/// local [LayoutBuilder] constraints.
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

  final WidgetBuilder? jumboExtraLarge;

  final WidgetBuilder? jumboLarge;

  final WidgetBuilder? jumboNormal;

  final WidgetBuilder? jumboSmall;

  final WidgetBuilder? standardExtraLarge;

  final WidgetBuilder? standardLarge;

  final WidgetBuilder? standardNormal;

  final WidgetBuilder? standardSmall;

  final WidgetBuilder? compactExtraLarge;

  final WidgetBuilder? compactLarge;

  final WidgetBuilder? compactNormal;

  final WidgetBuilder? compactSmall;

  /// Breakpoints used to classify the layout constraints.
  final BreakpointsGranular breakpoints;

  @override
  State<LayoutSizeBuilderGranular> createState() => _LayoutSizeGranularState();
}

class _LayoutSizeGranularState extends State<LayoutSizeBuilderGranular> {
  late BreakpointsHandlerGranular<WidgetBuilder> handler =
      BreakpointsHandlerGranular<WidgetBuilder>(
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
        // Get the appropriate widget builder based on current constraints
        // and invoke it with both context and screen size data for enhanced decision making
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context);
      },
    );
  }
}
