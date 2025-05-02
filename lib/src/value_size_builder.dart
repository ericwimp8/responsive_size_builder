import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';
import 'package:responsive_size_builder/src/breakpoints_handler.dart';

class ValueSizeBuilderGranular<K> extends StatefulWidget {
  const ValueSizeBuilderGranular({
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
  final Widget Function(BuildContext context, K value) builder;

  @override
  State<ValueSizeBuilderGranular<K>> createState() =>
      _ValueSizeBuilderState<K>();
}

class _ValueSizeBuilderState<K> extends State<ValueSizeBuilderGranular<K>> {
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
    final data = ScreenSizeModel.screenSizeOf<LayoutSizeGranular>(context);

    final value = handler.getScreenSizeValue.call(
      screenSize: data,
    );

    return widget.builder(context, value);
  }
}
