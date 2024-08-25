import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  BaseBreakpointsHandler({required this.breakpoints, this.onChanged});

  final void Function(K)? onChanged;

  final BaseBreakpoints<K> breakpoints;

  T? currentValue;

  K? screenSizeCache;

  Map<K, T?> get values;

  T getLayoutSizeValue({
    required BoxConstraints constraints,
    bool useShortestSide = false,
  }) {
    late double dimension;
    final layoutWidth = constraints.maxWidth;
    final layoutHeight = constraints.maxHeight;
    if (useShortestSide) {
      dimension = layoutWidth < layoutHeight ? layoutWidth : layoutHeight;
    } else {
      dimension = constraints.maxWidth;
    }

    return getScreenSizeValue(screenSize: getScreenSize(dimension));
  }

  T getScreenSizeValue({required K screenSize}) {
    final currentSceenSize = screenSize;
    if (screenSizeCache == currentSceenSize && currentValue != null) {
      return currentValue!;
    }

    onChanged?.call(currentSceenSize);

    screenSizeCache = currentSceenSize;

    var callback = values[screenSizeCache];
    if (callback != null) {
      currentValue = callback;
      return callback;
    }

    final index = breakpoints.values.keys.toList().indexOf(screenSizeCache!);
    final validCallbacks = values.values.toList().sublist(index);
    callback = validCallbacks.firstWhere(
      (element) => element != null,
      orElse: () => null,
    );

    if (callback != null) {
      currentValue = callback;
      return callback;
    }

    callback = values.values.lastWhere((element) => element != null);
    currentValue = callback;
    return callback!;
  }

  K getScreenSize(double size) {
    final entries = breakpoints.values.entries;
    for (final entry in entries) {
      if (size >= entry.value) {
        return entry.key;
      }
    }

    return entries.last.key;
  }
}

class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize> {
  BreakpointsHandler({
    super.breakpoints = Breakpoints.defaultBreakpoints,
    super.onChanged,
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'BreakpointsHandler requires at least one of the size arguments to be filled out',
        );

  final T? extraLarge;

  final T? large;

  final T? medium;

  final T? small;

  final T? extraSmall;

  @override
  Map<LayoutSize, T?> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: extraSmall,
      };
}

class BreakpointsHandlerGranular<T>
    extends BaseBreakpointsHandler<T, LayoutSizeGranular> {
  BreakpointsHandlerGranular({
    super.breakpoints = BreakpointsGranular.defaultBreakpoints,
    super.onChanged,
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
          'BreakpointsHandlerGranular requires at least one of the size arguments to be filled out',
        );

  final T? jumboExtraLarge;
  final T? jumboLarge;
  final T? jumboNormal;
  final T? jumboSmall;
  final T? standardExtraLarge;
  final T? standardLarge;
  final T? standardNormal;
  final T? standardSmall;
  final T? compactExtraLarge;
  final T? compactLarge;
  final T? compactNormal;
  final T? compactSmall;
  final T? tiny;
  @override
  Map<LayoutSizeGranular, T?> get values => {
        LayoutSizeGranular.jumboExtraLarge: jumboExtraLarge,
        LayoutSizeGranular.jumboLarge: jumboLarge,
        LayoutSizeGranular.jumboNormal: jumboNormal,
        LayoutSizeGranular.jumboSmall: jumboSmall,
        LayoutSizeGranular.standardExtraLarge: standardExtraLarge,
        LayoutSizeGranular.standardLarge: standardLarge,
        LayoutSizeGranular.standardNormal: standardNormal,
        LayoutSizeGranular.standardSmall: standardSmall,
        LayoutSizeGranular.compactExtraLarge: compactExtraLarge,
        LayoutSizeGranular.compactLarge: compactLarge,
        LayoutSizeGranular.compactNormal: compactNormal,
        LayoutSizeGranular.compactSmall: compactSmall,
        LayoutSizeGranular.tiny: tiny,
      };
}
