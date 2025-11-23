import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// MediaQuery-driven value selector (5 breakpoints) that surfaces responsive value when available.

class ScreenValueBuilder<K, V extends Object?> extends StatefulWidget {
  const ScreenValueBuilder({
    required this.builder,
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
          'At least one value must be provided',
        );

  final ScreenValueBuilderFn<K, LayoutSize, V> builder;
  final K? extraLarge;
  final K? large;
  final K? medium;
  final K? small;
  final K? extraSmall;
  final Breakpoints breakpoints;

  @override
  State<ScreenValueBuilder<K, V>> createState() =>
      _ScreenValueBuilderState<K, V>();
}

class _ScreenValueBuilderState<K, V extends Object?>
    extends State<ScreenValueBuilder<K, V>> {
  late final BreakpointsHandler<K> _handler = BreakpointsHandler<K>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final dataWithValue =
        ScreenSizeModelWithValue.maybeOf<LayoutSize, V>(context);
    final screenData = dataWithValue?.asScreenData() ??
        ScreenSizeModel.of<LayoutSize>(context);
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
