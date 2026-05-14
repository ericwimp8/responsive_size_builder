import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// MediaQuery-driven widget selector using 5 breakpoints.
/// Selects one of the supplied builders from [LayoutSize] based on the current
/// screen size and can animate changes between them.
class ScreenWidgetBuilder extends StatefulWidget with AnimatedChildMixin {
  /// Creates a responsive widget builder for the current media query width.
  const ScreenWidgetBuilder({
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
          'At least one builder must be provided',
        );

  /// Builder used for the extra-large [LayoutSize] bucket.
  final ScreenWidgetBuilderFn<LayoutSize>? extraLarge;

  /// Builder used for the large [LayoutSize] bucket.
  final ScreenWidgetBuilderFn<LayoutSize>? large;

  /// Builder used for the medium [LayoutSize] bucket.
  final ScreenWidgetBuilderFn<LayoutSize>? medium;

  /// Builder used for the small [LayoutSize] bucket.
  final ScreenWidgetBuilderFn<LayoutSize>? small;

  /// Builder used for the extra-small [LayoutSize] bucket.
  final ScreenWidgetBuilderFn<LayoutSize>? extraSmall;

  /// Breakpoints used to map screen width to [LayoutSize] buckets.
  final Breakpoints breakpoints;
  @override
  final bool animateChange;

  @override
  State<ScreenWidgetBuilder> createState() => _ScreenWidgetBuilderState();
}

class _ScreenWidgetBuilderState extends State<ScreenWidgetBuilder> {
  late BreakpointsHandler<ScreenWidgetBuilderFn<LayoutSize>> _handler =
      _createHandler();

  BreakpointsHandler<ScreenWidgetBuilderFn<LayoutSize>> _createHandler() {
    return BreakpointsHandler<ScreenWidgetBuilderFn<LayoutSize>>(
      breakpoints: widget.breakpoints,
      extraLarge: widget.extraLarge,
      large: widget.large,
      medium: widget.medium,
      small: widget.small,
      extraSmall: widget.extraSmall,
    );
  }

  @override
  void didUpdateWidget(ScreenWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handler = _createHandler();
  }

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(context);
    final builder = _handler.getScreenSizeValue(screenSize: data.screenSize);
    return widget.maybeAnimate(builder(context, data));
  }
}
