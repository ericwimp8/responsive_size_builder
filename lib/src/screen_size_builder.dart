import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

typedef ScreenSizeWidgetBuilder = Widget Function(
  BuildContext context,
  ScreenSizeModelData data,
);

class ScreenSizeOrientationBuilder extends StatefulWidget {
  const ScreenSizeOrientationBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.extraLargeLandscape,
    this.largeLandscape,
    this.mediumLandscape,
    this.smallLandscape,
    this.extraSmallLandscape,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  })  : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for portrait must be provided',
        ),
        assert(
          extraLargeLandscape != null ||
              largeLandscape != null ||
              mediumLandscape != null ||
              smallLandscape != null ||
              extraSmallLandscape != null,
          'At least one builder for landscape must be provided',
        );

  final WidgetBuilder? extraLarge;
  final WidgetBuilder? large;
  final WidgetBuilder? medium;
  final WidgetBuilder? small;
  final WidgetBuilder? extraSmall;
  final WidgetBuilder? extraLargeLandscape;
  final WidgetBuilder? largeLandscape;
  final WidgetBuilder? mediumLandscape;
  final WidgetBuilder? smallLandscape;
  final WidgetBuilder? extraSmallLandscape;

  final Breakpoints breakpoints;

  final bool animateChange;
  @override
  State<ScreenSizeOrientationBuilder> createState() =>
      _ScreenSizeOrientationBuilderState();
}

class _ScreenSizeOrientationBuilderState
    extends State<ScreenSizeOrientationBuilder> {
  late BreakpointsHandler<WidgetBuilder> handler;

  Orientation? orientation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _orientation = MediaQuery.orientationOf(context);
    if (orientation != _orientation) {
      orientation = _orientation;
      if (orientation == Orientation.portrait) {
        handler = BreakpointsHandler<WidgetBuilder>(
          breakpoints: widget.breakpoints,
          extraLarge: widget.extraLarge,
          large: widget.large,
          medium: widget.medium,
          small: widget.small,
          extraSmall: widget.extraSmall,
        );
      } else {
        handler = BreakpointsHandler<WidgetBuilder>(
          breakpoints: widget.breakpoints,
          extraLarge: widget.extraLargeLandscape,
          large: widget.largeLandscape,
          medium: widget.mediumLandscape,
          small: widget.smallLandscape,
          extraSmall: widget.extraSmallLandscape,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.screenSizeOf<LayoutSize>(context);

    var child = handler.getScreenSizeValue(
      screenSize: data,
    )(
      context,
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

class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for must be provided',
        );

  final ScreenSizeWidgetBuilder? extraLarge;
  final ScreenSizeWidgetBuilder? large;
  final ScreenSizeWidgetBuilder? medium;
  final ScreenSizeWidgetBuilder? small;
  final ScreenSizeWidgetBuilder? extraSmall;

  final Breakpoints breakpoints;
  final bool animateChange;

  @override
  State<ScreenSizeBuilder> createState() => _ScreenSizeBuilderState();
}

class _ScreenSizeBuilderState extends State<ScreenSizeBuilder> {
  late BreakpointsHandler<ScreenSizeWidgetBuilder> handler =
      BreakpointsHandler<ScreenSizeWidgetBuilder>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(
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
