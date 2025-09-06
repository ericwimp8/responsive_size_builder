import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A responsive widget that provides screen size information and responsive values to its child widgets.
///
/// [ScreenSizeWithValue] extends the functionality of [ScreenSize] by adding support for
/// responsive values that automatically change based on screen size breakpoints.
///
/// The type parameter [T] must extend [Enum] and represents the layout size
/// categories (e.g., [LayoutSize] or [LayoutSizeGranular]).
///
/// The type parameter [V] represents the type of the responsive value
/// (e.g., int for column count, double for spacing).
///
/// {@tool snippet}
/// This example shows how to use [ScreenSizeWithValue] with responsive column counts:
///
/// ```dart
/// ScreenSizeWithValue<LayoutSize, int>(
///   breakpoints: Breakpoints.defaultBreakpoints,
///   valueProvider: ResponsiveValue<int>(
///     extraLarge: 4,
///     large: 3,
///     medium: 2,
///     small: 1,
///   ),
///   child: MaterialApp(
///     home: MyHomePage(),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ScreenSize], the standard version without responsive values
///  * [ResponsiveValue], for defining responsive values with standard breakpoints
///  * [ResponsiveValueGranular], for defining responsive values with granular breakpoints
class ScreenSizeWithValue<T extends Enum, V extends Object?>
    extends StatefulWidget {
  /// Creates a [ScreenSizeWithValue] widget.
  ///
  /// The [breakpoints] parameter defines the screen size thresholds used to
  /// determine the current layout category.
  ///
  /// The [valueProvider] parameter provides values that change based on screen size.
  /// It must have at least one non-null value.
  ///
  /// The [child] parameter is the widget subtree that will have access to
  /// screen size data and responsive values.
  ///
  /// The [testView] parameter allows injection of a custom [FlutterView] for
  /// testing purposes. When null, uses the platform's primary view.
  ///
  /// The [useShortestSide] parameter determines whether to use the shortest
  /// side of the screen for breakpoint calculations instead of width.
  const ScreenSizeWithValue({
    required this.breakpoints,
    required this.valueProvider,
    required this.child,
    this.testView,
    this.useShortestSide = false,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The breakpoints configuration that defines screen size categories.
  final BaseBreakpoints<T> breakpoints;

  /// Provider for responsive values that change with screen size.
  ///
  /// The provider's getScreenSizeValue method will be called during updateMetrics
  /// to calculate a value based on the current breakpoint.
  ///
  /// The provider must have at least one non-null value, otherwise a StateError
  /// will be thrown when the value is calculated.
  final BaseResponsiveValue<T, V> valueProvider;

  /// Optional custom [FlutterView] for testing purposes.
  ///
  /// When null, the widget uses the platform's primary view to obtain
  /// physical screen metrics.
  final FlutterView? testView;

  /// Whether to use the shortest side for breakpoint calculations.
  ///
  /// When true, uses [Size.shortestSide] instead of [Size.width] to determine
  /// the current breakpoint. This ensures consistent behavior across device
  /// orientations.
  final bool useShortestSide;

  @override
  State<ScreenSizeWithValue<T, V>> createState() =>
      _ScreenSizeWithValueState<T, V>();
}

/// The private state class for [ScreenSizeWithValue].
class _ScreenSizeWithValueState<T extends Enum, V extends Object?>
    extends State<ScreenSizeWithValue<T, V>> {
  /// Determines the appropriate screen size category for the given dimension.
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

  /// Calculates and updates all screen size metrics and responsive value.
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

  /// The view used for obtaining physical screen metrics.
  late final view =
      widget.testView ?? WidgetsBinding.instance.platformDispatcher.views.first;

  @override
  Widget build(BuildContext context) {
    return ScreenSizeModelWithValue<T, V>(
      data: updateMetrics(context),
      child: widget.child,
    );
  }
}

/// An [InheritedModel] that provides screen size data with responsive values.
///
/// [ScreenSizeModelWithValue] extends the functionality of [ScreenSizeModel]
/// by including responsive values that change based on screen size.
class ScreenSizeModelWithValue<T extends Enum, V extends Object?>
    extends InheritedModel<ScreenSizeAspect> {
  /// Creates a [ScreenSizeModelWithValue].
  const ScreenSizeModelWithValue({
    required super.child,
    required this.data,
    super.key,
  });

  /// The screen size data with responsive value.
  final ScreenSizeModelDataWithValue<T, V> data;

  @override
  bool updateShouldNotify(ScreenSizeModelWithValue<T, V> oldWidget) {
    return data != oldWidget.data;
  }

  /// Obtains the complete screen size data with responsive value.
  ///
  /// Throws a [FlutterError] if no [ScreenSizeModelWithValue] is found.
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

  /// Returns only the responsive value from the nearest [ScreenSizeModelWithValue].
  ///
  /// This method provides direct access to the responsive value without triggering
  /// rebuilds for other data changes. It will rebuild only when the screen size
  /// category changes (which may cause the responsive value to change).
  ///
  /// Throws a [FlutterError] if no [ScreenSizeModelWithValue] is found.
  ///
  /// Example:
  /// ```dart
  /// final columns = ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, int>(context);
  /// return GridView(crossAxisCount: columns, ...);
  /// ```
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

  /// Returns only the screen size category.
  ///
  /// Similar to [ScreenSizeModel.screenSizeOf] but for [ScreenSizeWithValue].
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
    if (oldWidget.data.screenSize != data.screenSize &&
        dependencies.contains(ScreenSizeAspect.screenSize)) {
      return true;
    } else if (oldWidget.data != data &&
        dependencies.contains(ScreenSizeAspect.other)) {
      return true;
    }

    return false;
  }
}

/// Data class containing screen size information with a responsive value.
///
/// Extends the standard screen size metrics with a responsive value that
/// changes based on screen size breakpoints.
@immutable
class ScreenSizeModelDataWithValue<K extends Enum, V extends Object?> {
  /// Creates a [ScreenSizeModelDataWithValue] with the specified metrics and value.
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

  /// The breakpoints configuration used to determine screen size categories.
  final BaseBreakpoints<K> breakpoints;

  /// The numerical threshold for the current screen size category.
  final double currentBreakpoint;

  /// The current screen size category.
  final K screenSize;

  /// The physical width of the screen in device pixels.
  final double physicalWidth;

  /// The physical height of the screen in device pixels.
  final double physicalHeight;

  /// The ratio of physical pixels to logical pixels.
  final double devicePixelRatio;

  /// The logical width of the screen.
  final double logicalScreenWidth;

  /// The logical height of the screen.
  final double logicalScreenHeight;

  /// The current orientation of the device.
  final Orientation orientation;

  /// The responsive value for the current screen size.
  ///
  /// This value is calculated by the [BaseResponsiveValue] provider
  /// based on the current screen size category.
  final V responsiveValue;

  /// Whether this device is a desktop platform.
  bool get isDesktopDevice => kIsDesktopDevice;

  /// Whether this device supports touch input.
  bool get isTouchDevice => kIsTouchDevice;

  /// Whether the app is running on the web platform.
  bool get isWeb => kIsWeb;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenSizeModelDataWithValue<K, V> &&
          runtimeType == other.runtimeType &&
          breakpoints == other.breakpoints &&
          currentBreakpoint == other.currentBreakpoint &&
          screenSize == other.screenSize &&
          physicalWidth == other.physicalWidth &&
          physicalHeight == other.physicalHeight &&
          devicePixelRatio == other.devicePixelRatio &&
          logicalScreenWidth == other.logicalScreenWidth &&
          logicalScreenHeight == other.logicalScreenHeight &&
          orientation == other.orientation &&
          responsiveValue == other.responsiveValue;

  @override
  int get hashCode =>
      breakpoints.hashCode ^
      currentBreakpoint.hashCode ^
      screenSize.hashCode ^
      physicalWidth.hashCode ^
      physicalHeight.hashCode ^
      devicePixelRatio.hashCode ^
      logicalScreenWidth.hashCode ^
      logicalScreenHeight.hashCode ^
      orientation.hashCode ^
      responsiveValue.hashCode;

  @override
  String toString() {
    return 'ScreenSizeModelDataWithValue(breakpoints: $breakpoints, currentBreakpoint: $currentBreakpoint, screenSize: $screenSize, physicalWidth: $physicalWidth, physicalHeight: $physicalHeight, devicePixelRatio: $devicePixelRatio, logicalScreenWidth: $logicalScreenWidth, logicalScreenHeight: $logicalScreenHeight, orientation: $orientation, responsiveValue: $responsiveValue)';
  }
}
