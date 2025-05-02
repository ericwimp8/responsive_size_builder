import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class LayoutSizeBuilder extends StatefulWidget {
  const LayoutSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for portrait must be provided',
        );

  final WidgetBuilder? extraLarge;

  final WidgetBuilder? large;

  final WidgetBuilder? medium;

  final WidgetBuilder? small;

  final WidgetBuilder? extraSmall;

  final Breakpoints breakpoints;

  @override
  State<LayoutSizeBuilder> createState() => _LayoutSizeBuilderState();
}

class _LayoutSizeBuilderState extends State<LayoutSizeBuilder> {
  late BreakpointsHandler<WidgetBuilder> handler =
      BreakpointsHandler<WidgetBuilder>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context);
      },
    );
  }
}

class LayoutSizeGranularBuilder extends StatefulWidget {
  const LayoutSizeGranularBuilder({
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
  State<LayoutSizeGranularBuilder> createState() => _LayoutSizeGranularState();
}

class _LayoutSizeGranularState extends State<LayoutSizeGranularBuilder> {
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
        final data = ScreenSizeModel.of<LayoutSize>(
          context,
        );
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context, data);
      },
    );
  }
}
