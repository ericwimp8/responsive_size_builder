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

  final Widget Function(BuildContext context)? extraLarge;

  final Widget Function(BuildContext context)? large;

  final Widget Function(BuildContext context)? medium;

  final Widget Function(BuildContext context)? small;

  final Widget Function(BuildContext context)? extraSmall;

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

  final BreakpointsGranular breakpoints;
  @override
  State<LayoutSizeGranularBuilder> createState() => _LayoutSizeGranularState();
}

class _LayoutSizeGranularState extends State<LayoutSizeGranularBuilder> {
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
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context);
      },
    );
  }
}
