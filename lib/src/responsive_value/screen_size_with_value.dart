import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Top-level widget that exposes both screen metrics and a breakpoint-derived
/// responsive value via [ScreenSizeModelWithValue].
class ScreenSizeWithValue<T extends Enum, V extends Object?>
    extends StatefulWidget {
  const ScreenSizeWithValue({
    required this.breakpoints,
    required this.valueProvider,
    required this.child,
    this.testView,
    this.useShortestSide = false,
    super.key,
  });

  final Widget child;

  final BaseBreakpoints<T> breakpoints;

  final BaseResponsiveValue<T, V> valueProvider;

  final FlutterView? testView;

  /// Whether to classify using the shortest side instead of width.
  final bool useShortestSide;

  @override
  State<ScreenSizeWithValue<T, V>> createState() =>
      _ScreenSizeWithValueState<T, V>();
}

class _ScreenSizeWithValueState<T extends Enum, V extends Object?>
    extends State<ScreenSizeWithValue<T, V>> {
  T _getScreenSize(double size) {
    final entries = widget.breakpoints.values.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in entries) {
      if (size >= entry.value) {
        return entry.key;
      }
    }
    return entries.last.key;
  }

  ScreenSizeModelDataWithValue<T, V> updateMetrics(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final orientation = mq.orientation;
    final screenSize = widget.useShortestSide
        ? _getScreenSize(size.shortestSide)
        : _getScreenSize(size.width);

    // Calculate responsive value based on current screen size
    final responsiveValue = widget.valueProvider.getScreenSizeValue(
      screenSize: screenSize,
    );

    return ScreenSizeModelDataWithValue(
      breakpoints: widget.breakpoints,
      currentBreakpoint: widget.breakpoints.values[screenSize]!,
      screenSize: screenSize,
      physicalWidth: view.physicalSize.width,
      physicalHeight: view.physicalSize.height,
      devicePixelRatio: view.devicePixelRatio,
      logicalScreenWidth: size.width,
      logicalScreenHeight: size.height,
      orientation: orientation,
      responsiveValue: responsiveValue,
    );
  }

  late final view =
      widget.testView ?? WidgetsBinding.instance.platformDispatcher.views.first;

  @override
  Widget build(BuildContext context) {
    final newData = updateMetrics(context);
    return ScreenSizeModelWithValue<T, V>(
      data: newData,
      child: widget.child,
    );
  }
}

class ScreenSizeModelWithValue<T extends Enum, V extends Object?>
    extends InheritedModel<ScreenSizeAspect> {
  const ScreenSizeModelWithValue({
    required super.child,
    required this.data,
    super.key,
  });

  final ScreenSizeModelDataWithValue<T, V> data;

  @override
  bool updateShouldNotify(ScreenSizeModelWithValue<T, V> oldWidget) {
    final shouldUpdate = data != oldWidget.data;
    return shouldUpdate;
  }

  static ScreenSizeModelDataWithValue<K, V>
      of<K extends Enum, V extends Object?>(
    BuildContext context,
  ) {
    final model =
        InheritedModel.inheritFrom<ScreenSizeModelWithValue<K, V>>(context);
    if (model == null) {
      throw FlutterError('''
ScreenSizeModelWithValue<$K, $V> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSizeWithValue widget 
   (e.g., ScreenSizeWithValue<LayoutSize, int>(...)).
2. You are requesting the correct type parameters <$K, $V>.

The context used to look up ScreenSizeModelWithValue was:
  $context
''');
    }
    return model.data;
  }

  /// Like [of] but returns null when no model is found.
  static ScreenSizeModelDataWithValue<K, V>?
      maybeOf<K extends Enum, V extends Object?>(
    BuildContext context,
  ) {
    return InheritedModel.inheritFrom<ScreenSizeModelWithValue<K, V>>(context)
        ?.data;
  }

  static V responsiveValueOf<K extends Enum, V extends Object?>(
    BuildContext context,
  ) {
    final model = InheritedModel.inheritFrom<ScreenSizeModelWithValue<K, V>>(
      context,
      aspect: ScreenSizeAspect.screenSize,
    );

    if (model == null) {
      throw FlutterError('''
ScreenSizeModelWithValue<$K, $V> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSizeWithValue widget 
   (e.g., ScreenSizeWithValue<LayoutSize, int>(...)).
2. You are requesting the correct type parameters <$K, $V>.

The context used to look up ScreenSizeModelWithValue was:
  $context
''');
    }

    return model.data.responsiveValue;
  }

  static K screenSizeOf<K extends Enum>(
    BuildContext context,
  ) {
    final model =
        InheritedModel.inheritFrom<ScreenSizeModelWithValue<K, Object?>>(
      context,
      aspect: ScreenSizeAspect.screenSize,
    );

    if (model == null) {
      throw FlutterError('''
ScreenSizeModelWithValue<$K> not found. Please ensure that the app is wrapped in 
ScreenSizeWithValue and the appropriate type parameter is being used.
''');
    }

    return model.data.screenSize;
  }

  @override
  bool updateShouldNotifyDependent(
    ScreenSizeModelWithValue<T, V> oldWidget,
    Set<ScreenSizeAspect> dependencies,
  ) {
    // Check if screen size or responsive value changed for screenSize aspect
    if (dependencies.contains(ScreenSizeAspect.screenSize)) {
      if (oldWidget.data.screenSize != data.screenSize ||
          oldWidget.data.responsiveValue != data.responsiveValue) {
        return true;
      }
    }

    // Check for any other changes for other aspect
    if (oldWidget.data != data &&
        dependencies.contains(ScreenSizeAspect.other)) {
      return true;
    }

    return false;
  }
}

@immutable
class ScreenSizeModelDataWithValue<K extends Enum, V extends Object?> {
  const ScreenSizeModelDataWithValue({
    required this.breakpoints,
    required this.currentBreakpoint,
    required this.screenSize,
    required this.physicalWidth,
    required this.physicalHeight,
    required this.devicePixelRatio,
    required this.logicalScreenWidth,
    required this.logicalScreenHeight,
    required this.orientation,
    required this.responsiveValue,
  });

  final double currentBreakpoint;
  final BaseBreakpoints<K> breakpoints;
  final double devicePixelRatio;
  final V responsiveValue;
  final K screenSize;

  final double physicalWidth;

  final double physicalHeight;

  final double logicalScreenWidth;

  final double logicalScreenHeight;

  final Orientation orientation;

  /// True when the resolved platform is a desktop platform.
  bool get isDesktopDevice => kIsDesktopDevice;

  /// True when the resolved platform is a touch-first mobile platform.
  bool get isTouchDevice => kIsTouchDevice;

  /// True when the app is running on the web.
  bool get isWeb => kIsWeb;

  @override
  String toString() {
    return 'ScreenSizeModelDataWithValue(breakpoints: $breakpoints, currentBreakpoint: $currentBreakpoint, screenSize: $screenSize, physicalWidth: $physicalWidth, physicalHeight: $physicalHeight, devicePixelRatio: $devicePixelRatio, logicalScreenWidth: $logicalScreenWidth, logicalScreenHeight: $logicalScreenHeight, orientation: $orientation, responsiveValue: $responsiveValue)';
  }

  /// Returns a [ScreenSizeModelData] view of this object for APIs that only
  /// expect screen metrics without the responsive value.
  ScreenSizeModelData<K> asScreenData() {
    return ScreenSizeModelData<K>(
      breakpoints: breakpoints,
      currentBreakpoint: currentBreakpoint,
      screenSize: screenSize,
      physicalWidth: physicalWidth,
      physicalHeight: physicalHeight,
      devicePixelRatio: devicePixelRatio,
      logicalScreenWidth: logicalScreenWidth,
      logicalScreenHeight: logicalScreenHeight,
      orientation: orientation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScreenSizeModelDataWithValue<K, V> &&
        other.breakpoints == breakpoints &&
        other.currentBreakpoint == currentBreakpoint &&
        other.screenSize == screenSize &&
        other.physicalWidth == physicalWidth &&
        other.physicalHeight == physicalHeight &&
        other.devicePixelRatio == devicePixelRatio &&
        other.logicalScreenWidth == logicalScreenWidth &&
        other.logicalScreenHeight == logicalScreenHeight &&
        other.orientation == orientation &&
        other.responsiveValue == responsiveValue;
  }

  @override
  int get hashCode {
    return Object.hash(
      breakpoints,
      currentBreakpoint,
      screenSize,
      physicalWidth,
      physicalHeight,
      devicePixelRatio,
      logicalScreenWidth,
      logicalScreenHeight,
      orientation,
      responsiveValue,
    );
  }
}
