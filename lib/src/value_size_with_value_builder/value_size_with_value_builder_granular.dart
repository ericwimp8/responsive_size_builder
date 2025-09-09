import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

typedef ValueSizeWithValueBuilderGranularWidgetBuilder<K> = Widget Function(
  BuildContext context,
  K value,
);

class ValueSizeWithValueBuilderGranular<K, V extends Object?>
    extends StatefulWidget {
  const ValueSizeWithValueBuilderGranular({
    required this.builder,
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

  final K? jumboExtraLarge;

  final K? jumboLarge;

  final K? jumboNormal;

  final K? jumboSmall;

  final K? standardExtraLarge;

  final K? standardLarge;

  final K? standardNormal;

  final K? standardSmall;

  final K? compactExtraLarge;

  final K? compactLarge;

  final K? compactNormal;

  final K? compactSmall;

  final K? tiny;

  final ValueSizeWithValueBuilderGranularWidgetBuilder<K> builder;

  final bool animateChange;

  @override
  State<ValueSizeWithValueBuilderGranular<K, V>> createState() =>
      _ValueSizeWithValueBuilderGranularState<K, V>();
}

class _ValueSizeWithValueBuilderGranularState<K, V extends Object?>
    extends State<ValueSizeWithValueBuilderGranular<K, V>> {
  late final handler = BreakpointsHandlerGranular<K>(
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
    final data = ScreenSizeModelWithValue.of<LayoutSizeGranular, V>(
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
