import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

typedef ValueSizeWithValueWidgetBuilder<K> = Widget Function(
  BuildContext context,
  K value,
);

class ValueSizeWithValueBuilder<K, V extends Object?> extends StatefulWidget {
  const ValueSizeWithValueBuilder({
    required this.builder,
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
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

  final K? extraLarge;

  final K? large;

  final K? medium;

  final K? small;

  final K? extraSmall;

  final ValueSizeWithValueWidgetBuilder<K> builder;

  final bool animateChange;

  @override
  State<ValueSizeWithValueBuilder<K, V>> createState() =>
      _ValueSizeWithValueBuilderState<K, V>();
}

class _ValueSizeWithValueBuilderState<K, V extends Object?>
    extends State<ValueSizeWithValueBuilder<K, V>> {
  late final handler = BreakpointsHandler<K>(
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModelWithValue.of<LayoutSize, V>(
      context,
    );

    final value = handler.getScreenSizeValue.call(
      screenSize: data.screenSize,
    );

    var child = widget.builder(context, value);

    if (widget.animateChange) {
      child = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      );
    }

    return child;
  }
}
