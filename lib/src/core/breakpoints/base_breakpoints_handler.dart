import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Base helper that resolves breakpoint-aware values for either screen or
/// layout constraints.
abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  BaseBreakpointsHandler({required this.breakpoints, this.onChanged});

  /// Called whenever the resolved screen size enum changes.
  final void Function(K)? onChanged;

  /// Breakpoint configuration used to classify sizes.
  final BaseBreakpoints<K> breakpoints;

  /// Last resolved value for the current [screenSizeCache].
  T? currentValue;

  /// Cached screen size used to determine when to recompute [currentValue].
  K? screenSizeCache;

  /// Map of breakpoint enum to value for that breakpoint.
  Map<K, T?> get values;

  /// Returns the value for the current layout constraints using the configured
  /// [breakpoints].
  ///
  /// When [useShortestSide] is true, classification is based on the shortest
  /// side of the box instead of width.
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

  /// Returns the value corresponding to [screenSize], applying fallback rules
  /// when a breakpoint has no explicit value.
  ///
  /// If the exact breakpoint has no value, the next non-null value at or below
  /// the current index is used. As a final fallback, the last non-null value
  /// in [values] is returned.
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

  /// Computes the enum entry for a given logical [size] in pixels.
  ///
  /// The first entry whose configured breakpoint value is less than or equal
  /// to [size] is returned; otherwise the last entry is used.
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
