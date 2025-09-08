import 'package:flutter/material.dart';
import 'package:responsive_size_builder/src/core/breakpoints/breakpoints.dart';
import 'package:responsive_size_builder/src/core/breakpoints/breakpoints_handler.dart';
import 'package:responsive_size_builder/src/screen_size/screen_size_data.dart';

class ValueSizeBuilder<K> extends StatefulWidget {
  const ValueSizeBuilder({
    required this.builder,
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder must be provided',
        );

  final K? extraLarge;

  final K? large;

  final K? medium;

  final K? small;

  final K? extraSmall;

  final Widget Function(BuildContext context, K value) builder;

  @override
  State<ValueSizeBuilder<K>> createState() => _ValueSizeBuilderState<K>();
}

class _ValueSizeBuilderState<K> extends State<ValueSizeBuilder<K>> {
  late final handler = BreakpointsHandler<K>(
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.screenSizeOf<LayoutSize>(context);

    final value = handler.getScreenSizeValue.call(
      screenSize: data,
    );

    return widget.builder(context, value);
  }
}
