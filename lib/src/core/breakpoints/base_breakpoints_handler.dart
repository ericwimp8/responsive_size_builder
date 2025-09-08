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
