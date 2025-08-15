import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A responsive widget that provides screen size information to its child widgets.
///
/// [ScreenSize] monitors screen dimensions and breakpoints, making this data
/// available to descendant widgets through [ScreenSizeModel]. It automatically
/// updates when the screen size changes, allowing widgets to adapt their layout
/// responsively.
///
/// The type parameter [T] must extend [Enum] and represents the layout size
/// categories (e.g., [LayoutSize] or [LayoutSizeGranular]).
///
/// {@tool snippet}
/// This example shows how to wrap your app with [ScreenSize] to enable
/// responsive features:
///
/// ```dart
/// ScreenSize<LayoutSize>(
///   breakpoints: Breakpoints(),
///   child: MaterialApp(
///     home: MyHomePage(),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ScreenSizeModel], which provides the screen size data to child widgets
///  * [Breakpoints], for defining responsive breakpoints
///  * [BreakpointsGranular], for more granular breakpoint control
class ScreenSize<T extends Enum> extends StatefulWidget {
  /// Creates a [ScreenSize] widget.
  ///
  /// The [breakpoints] parameter defines the screen size thresholds used to
  /// determine the current layout category.
  ///
  /// The [child] parameter is the widget subtree that will have access to
  /// screen size data.
  ///
  /// The [testView] parameter allows injection of a custom [FlutterView] for
  /// testing purposes. When null, uses the platform's primary view.
  ///
  /// The [useShortestSide] parameter determines whether to use the shortest
  /// side of the screen for breakpoint calculations instead of width. This is
  /// useful for handling device orientation changes consistently.
  const ScreenSize({
    required this.breakpoints,
    required this.child,
    this.testView,
    this.useShortestSide = false,
    super.key,
  });
  /// The widget below this widget in the tree.
  final Widget child;

  /// The breakpoints configuration that defines screen size categories.
  final BaseBreakpoints<T> breakpoints;

  /// Optional view for testing purposes.
  ///
  /// When provided, this view's dimensions will be used instead of the
  /// platform's primary view. This is primarily useful for unit testing.
  final FlutterView? testView;

  /// Whether to use the shortest side for breakpoint calculations.
  ///
  /// When true, uses [Size.shortestSide] instead of [Size.width] to determine
  /// the current breakpoint. This ensures consistent behavior across device
  /// orientations.
  final bool useShortestSide;
  @override
  State<ScreenSize<T>> createState() => _ScreenSizeState<T>();
}

/// The private state class for [ScreenSize].
///
/// Handles screen size calculations and provides the computed data to
/// descendant widgets through [ScreenSizeModel].
class _ScreenSizeState<T extends Enum> extends State<ScreenSize<T>> {
  /// Determines the appropriate screen size category for the given dimension.
  ///
  /// Iterates through the breakpoints in descending order and returns the
  /// first category whose threshold the [size] meets or exceeds.
  ///
  /// The [size] parameter represents the screen dimension to evaluate,
  /// typically width or shortest side depending on [useShortestSide].
  ///
  /// Returns the smallest breakpoint category if the size doesn't meet any
  /// threshold.
  T _getScreenSize(double size) {
    final entries = widget.breakpoints.values.entries;
    for (final entry in entries) {
      if (size >= entry.value) {
        return entry.key;
      }
    }

    return entries.last.key;
  }

  /// Updates screen size metrics based on the current context.
  ///
  /// Gathers screen dimensions, orientation, and device characteristics from
  /// [MediaQuery] and the platform view, then calculates the appropriate
  /// screen size category using the configured breakpoints.
  ///
  /// The [context] parameter provides access to [MediaQuery] data.
  ///
  /// Returns a [ScreenSizeModelData] object containing all computed metrics.
  ScreenSizeModelData<T> updateMetrics(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final orientation = mq.orientation;
    final screenSize = widget.useShortestSide
        ? _getScreenSize(size.shortestSide)
        : _getScreenSize(size.width);

    return ScreenSizeModelData(
      breakpoints: widget.breakpoints,
      currentBreakpoint: widget.breakpoints.values[screenSize]!,
      screenSize: screenSize,
      physicalWidth: view.physicalSize.width,
      physicalHeight: view.physicalSize.height,
      devicePixelRatio: view.devicePixelRatio,
      logicalScreenWidth: size.width,
      logicalScreenHeight: size.height,
      orientation: orientation,
    );
  }

  /// The view used for obtaining physical screen metrics.
  ///
  /// Uses [testView] if provided (for testing), otherwise defaults to the
  /// platform's primary view.
  late final view =
      widget.testView ?? WidgetsBinding.instance.platformDispatcher.views.first;

  @override
  Widget build(BuildContext context) {
    return ScreenSizeModel<T>(
      data: updateMetrics(context),
      child: widget.child,
    );
  }
}

/// An [InheritedModel] that provides screen size data to descendant widgets.
///
/// [ScreenSizeModel] efficiently propagates screen size information down the
/// widget tree using Flutter's inherited widget mechanism. It only notifies
/// dependent widgets when specific aspects of the screen size data change,
/// optimizing rebuild performance.
///
/// Widgets can access this data using [ScreenSizeModel.of] for complete data
/// or [ScreenSizeModel.screenSizeOf] for just the current screen size category.
///
/// See also:
///
///  * [ScreenSize], which creates and manages this model
///  * [ScreenSizeModelData], which contains the actual screen size data
///  * [ScreenSizeAspect], which defines which data changes trigger rebuilds
class ScreenSizeModel<T extends Enum> extends InheritedModel<ScreenSizeAspect> {
  /// Creates a [ScreenSizeModel].
  ///
  /// The [data] parameter contains all screen size information that will be
  /// made available to descendant widgets.
  ///
  /// The [child] parameter is the widget subtree that will have access to
  /// this screen size data.
  const ScreenSizeModel({
    required super.child,
    required this.data,
    super.key,
  });

  /// The screen size data provided by this model.
  final ScreenSizeModelData<T> data;

  @override
  bool updateShouldNotify(ScreenSizeModel oldWidget) {
    return data != oldWidget.data;
  }

  /// Obtains the complete screen size data from the nearest [ScreenSizeModel].
  ///
  /// This method provides access to all screen size information including
  /// breakpoints, current category, dimensions, and device characteristics.
  ///
  /// The type parameter [K] must match the enum type used by the ancestor
  /// [ScreenSize] widget.
  ///
  /// The [context] parameter is used to locate the nearest [ScreenSizeModel]
  /// ancestor.
  ///
  /// Throws a [FlutterError] if no [ScreenSizeModel] of type [K] is found in
  /// the widget tree above this context.
  ///
  /// {@tool snippet}
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final screenData = ScreenSizeModel.of<LayoutSize>(context);
  ///   return Text('Current: ${screenData.screenSize}');
  /// }
  /// ```
  /// {@end-tool}
  static ScreenSizeModelData<K> of<K extends Enum>(
    BuildContext context,
  ) {
    final model = InheritedModel.inheritFrom<ScreenSizeModel<K>>(context);
    if (model == null) {
      throw FlutterError('''
ScreenSizeModel<$K> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSize widget 
   (e.g., ScreenSize<LayoutSize>(...) or ScreenSize<LayoutSizeGranular>(...)).
2. You are requesting the correct type parameter <$K>.

The context used to look up ScreenSizeModel was:
  $context
''');
    }
    return model.data;
  }

  /// Obtains just the current screen size category from the nearest [ScreenSizeModel].
  ///
  /// This optimized method only depends on the screen size aspect, so widgets
  /// using this method will only rebuild when the screen size category changes,
  /// not when other properties like orientation change.
  ///
  /// The type parameter [K] must match the enum type used by the ancestor
  /// [ScreenSize] widget.
  ///
  /// The [context] parameter is used to locate the nearest [ScreenSizeModel]
  /// ancestor.
  ///
  /// Returns the current screen size category (e.g., [LayoutSize.large]).
  ///
  /// Throws a [FlutterError] if no [ScreenSizeModel] of type [K] is found in
  /// the widget tree above this context.
  ///
  /// {@tool snippet}
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final size = ScreenSizeModel.screenSizeOf<LayoutSize>(context);
  ///   return size == LayoutSize.large ? LargeLayout() : SmallLayout();
  /// }
  /// ```
  /// {@end-tool}
  static K screenSizeOf<K extends Enum>(
    BuildContext context,
  ) {
    final model = InheritedModel.inheritFrom<ScreenSizeModel<K>>(
      context,
      aspect: ScreenSizeAspect.screenSize,
    );
    if (model == null) {
      throw FlutterError('''
ScreenSizeModel<$K> not found, please ensure that the app is wrapped in ScreenSize and 
the appropriate builder widget is being used.
ScreenSize<LayoutSizeGranular> will require ScreenSizeBuilderGranularGranular
ScreenSize<LayoutSize> will require ScreenSizeBuilderGranular
''');
    }

    return InheritedModel.inheritFrom<ScreenSizeModel<K>>(
      context,
      aspect: ScreenSizeAspect.screenSize,
    )!
        .data
        .screenSize;
  }

  /// Determines whether dependent widgets should be notified of changes.
  ///
  /// This method optimizes rebuilds by only notifying widgets that depend on
  /// aspects of the data that have actually changed.
  ///
  /// The [oldWidget] parameter contains the previous screen size data.
  ///
  /// The [dependencies] parameter contains the set of aspects that dependent
  /// widgets are listening to.
  ///
  /// Returns true if any of the aspects in [dependencies] have changed.
  @override
  bool updateShouldNotifyDependent(
    ScreenSizeModel<T> oldWidget,
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

/// Immutable data class containing comprehensive screen size information.
///
/// [ScreenSizeModelData] holds all the metrics and characteristics related to
/// the current screen size, including breakpoints, dimensions, device type,
/// and orientation. This data is computed by [ScreenSize] and provided to
/// descendant widgets through [ScreenSizeModel].
///
/// The type parameter [K] represents the enum type used for screen size
/// categories (e.g., [LayoutSize] or [LayoutSizeGranular]).
@immutable
class ScreenSizeModelData<K extends Enum> {
  /// Creates a [ScreenSizeModelData] with the specified screen metrics.
  ///
  /// All parameters are required and represent various aspects of the current
  /// screen size and device characteristics.
  const ScreenSizeModelData({
    required this.breakpoints,
    required this.currentBreakpoint,
    required this.screenSize,
    required this.physicalWidth,
    required this.physicalHeight,
    required this.devicePixelRatio,
    required this.logicalScreenWidth,
    required this.logicalScreenHeight,
    required this.orientation,
  });
  /// The breakpoints configuration used to determine screen size categories.
  final BaseBreakpoints<K> breakpoints;

  /// The numerical threshold for the current screen size category.
  ///
  /// This represents the minimum width (or shortest side) required to be
  /// classified as the current [screenSize] category.
  final double currentBreakpoint;

  /// The current screen size category.
  ///
  /// This enum value represents which breakpoint category the current screen
  /// dimensions fall into (e.g., [LayoutSize.large]).
  final K screenSize;

  /// The physical width of the screen in device pixels.
  ///
  /// This is the actual pixel count of the display hardware.
  final double physicalWidth;

  /// The physical height of the screen in device pixels.
  ///
  /// This is the actual pixel count of the display hardware.
  final double physicalHeight;

  /// The ratio of physical pixels to logical pixels.
  ///
  /// This represents the density of the display. A value of 2.0 means that
  /// each logical pixel is represented by 4 physical pixels (2x2).
  final double devicePixelRatio;

  /// The logical width of the screen.
  ///
  /// This is the width in logical pixels, which accounts for device pixel
  /// density and is the coordinate system used by Flutter widgets.
  final double logicalScreenWidth;

  /// The logical height of the screen.
  ///
  /// This is the height in logical pixels, which accounts for device pixel
  /// density and is the coordinate system used by Flutter widgets.
  final double logicalScreenHeight;

  /// The current orientation of the device.
  ///
  /// This indicates whether the device is in portrait or landscape mode.
  final Orientation orientation;

  /// Whether this device is a desktop platform.
  ///
  /// Returns true for Windows, macOS, and Linux platforms.
  bool get isDesktopDevcie => kIsDesktopDevice;

  /// Whether this device supports touch input.
  ///
  /// Returns true for Android and iOS platforms.
  bool get isTouchDevice => kIsTouchDevice;

  /// Whether the app is running on the web platform.
  ///
  /// Returns true when running in a web browser.
  bool get isWeb => kIsWeb;

  @override
  String toString() {
    return 'ScreenSizeModelData(breakpoints: $breakpoints, currentBreakpoint: $currentBreakpoint, screenSize: $screenSize, physicalWidth: $physicalWidth, physicalHeight: $physicalHeight, devicePixelRatio: $devicePixelRatio, logicalScreenWidth: $logicalScreenWidth, logicalScreenHeight: $logicalScreenHeight)';
  }
}

/// Enum defining which aspects of screen size data can trigger widget rebuilds.
///
/// [ScreenSizeAspect] is used with [InheritedModel] to optimize performance by
/// allowing widgets to depend only on specific aspects of the screen size data.
/// This prevents unnecessary rebuilds when unrelated data changes.
///
/// See also:
///
///  * [ScreenSizeModel.updateShouldNotifyDependent], which uses these aspects
///  * [ScreenSizeModel.screenSizeOf], which depends only on [screenSize]
enum ScreenSizeAspect {
  /// The screen size category aspect.
  ///
  /// Widgets depending on this aspect will only rebuild when the screen size
  /// category changes (e.g., from [LayoutSize.medium] to [LayoutSize.large]).
  screenSize,

  /// All other aspects of screen size data.
  ///
  /// Widgets depending on this aspect will rebuild when any property other
  /// than the screen size category changes (orientation, dimensions, etc.).
  other,
}
