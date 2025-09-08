import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Signature for a function that builds a widget tree based on screen size data.
///
/// The [context] parameter provides the build context for the widget.
/// The [data] parameter contains comprehensive screen size information including
/// the current breakpoint, dimensions, orientation, and device characteristics.
///
/// Used by [ScreenSizeBuilder] and [ScreenSizeBuilderGranular] to define
/// responsive widget builders that have access to detailed screen metrics.
///
/// ## Example
///
/// ```dart
/// ScreenSizeWidgetBuilder largeBuilder = (context, data) {
///   return Container(
///     width: data.logicalScreenWidth * 0.8,
///     child: Text('Large screen: ${data.screenSize}'),
///   );
/// };
/// ```
///
/// See also:
///
/// * [ScreenSizeModelData], which contains the screen size information
/// * [ScreenSizeBuilder], which uses this typedef for responsive building
/// * [WidgetBuilder], the standard Flutter widget builder signature
typedef ScreenSizeWidgetBuilder = Widget Function(
  BuildContext context,
  ScreenSizeModelData data,
);

/// A responsive widget builder that provides orientation-aware layout construction.
///
/// [ScreenSizeOrientationBuilder] creates responsive layouts by selecting
/// appropriate widget builders based on both screen size and device orientation.
/// It maintains separate sets of builders for portrait and landscape orientations,
/// allowing for optimized layouts that take advantage of different aspect ratios.
///
/// The widget automatically detects orientation changes and switches between the
/// corresponding builder sets. When [animateChange] is enabled, transitions
/// between orientations are smoothly animated.
///
/// ## Builder Selection Logic
///
/// 1. Determine current screen orientation (portrait/landscape)
/// 2. Select appropriate builder set based on orientation
/// 3. Choose specific builder based on screen size breakpoint
/// 4. Fall back to next available builder if exact match not found
///
/// ## Usage Example
///
/// ```dart
/// ScreenSizeOrientationBuilder(
///   // Portrait builders
///   small: (context) => MobilePortraitLayout(),
///   medium: (context) => TabletPortraitLayout(),
///   large: (context) => DesktopLayout(),
///
///   // Landscape builders
///   smallLandscape: (context) => MobileLandscapeLayout(),
///   mediumLandscape: (context) => TabletLandscapeLayout(),
///   largeLandscape: (context) => DesktopWideLayout(),
///
///   animateChange: true,
/// )
/// ```
///
/// ## Requirements
///
/// At least one builder must be provided for each orientation. If a specific
/// size category is not provided, the widget will fall back to the next
/// available size or throw an assertion error if none exist.
///
/// See also:
///
/// * [ScreenSizeBuilder], for simple responsive building without orientation awareness
/// * [ScreenSizeBuilderGranular], for fine-grained responsive control
/// * [Breakpoints], for configuring screen size thresholds
class ScreenSizeOrientationBuilder extends StatefulWidget {
  /// Creates a [ScreenSizeOrientationBuilder] with orientation-aware responsive builders.
  ///
  /// Separate builder functions can be provided for portrait and landscape
  /// orientations at each screen size category. The widget will automatically
  /// select the appropriate builder based on current orientation and screen size.
  ///
  /// ## Portrait Builders
  ///
  /// * [extraLarge]: Builder for extra large screens in portrait
  /// * [large]: Builder for large screens in portrait
  /// * [medium]: Builder for medium screens in portrait
  /// * [small]: Builder for small screens in portrait
  /// * [extraSmall]: Builder for extra small screens in portrait
  ///
  /// ## Landscape Builders
  ///
  /// * [extraLargeLandscape]: Builder for extra large screens in landscape
  /// * [largeLandscape]: Builder for large screens in landscape
  /// * [mediumLandscape]: Builder for medium screens in landscape
  /// * [smallLandscape]: Builder for small screens in landscape
  /// * [extraSmallLandscape]: Builder for extra small screens in landscape
  ///
  /// ## Configuration Parameters
  ///
  /// * [breakpoints]: Screen size thresholds (defaults to [Breakpoints.defaultBreakpoints])
  /// * [animateChange]: Whether to animate transitions between orientations
  /// * [key]: Optional widget key
  ///
  /// ## Validation
  ///
  /// Throws [AssertionError] if no builders are provided for either portrait
  /// or landscape orientations.
  const ScreenSizeOrientationBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.extraLargeLandscape,
    this.largeLandscape,
    this.mediumLandscape,
    this.smallLandscape,
    this.extraSmallLandscape,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  })  : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for portrait must be provided',
        ),
        assert(
          extraLargeLandscape != null ||
              largeLandscape != null ||
              mediumLandscape != null ||
              smallLandscape != null ||
              extraSmallLandscape != null,
          'At least one builder for landscape must be provided',
        );

  /// Builder function for extra large screens in portrait orientation.
  ///
  /// Used when the screen width exceeds the extra large breakpoint and the
  /// device is in portrait mode. Typically for large desktop monitors.
  final WidgetBuilder? extraLarge;

  /// Builder function for large screens in portrait orientation.
  ///
  /// Used for standard desktop and laptop screens in portrait mode, typically
  /// between the large and extra large breakpoint thresholds.
  final WidgetBuilder? large;

  /// Builder function for medium screens in portrait orientation.
  ///
  /// Used for tablet-sized screens and small laptops in portrait mode,
  /// typically between the medium and large breakpoint thresholds.
  final WidgetBuilder? medium;

  /// Builder function for small screens in portrait orientation.
  ///
  /// Used for mobile phone screens and small tablets in portrait mode,
  /// typically between the small and medium breakpoint thresholds.
  final WidgetBuilder? small;

  /// Builder function for extra small screens in portrait orientation.
  ///
  /// Used for very small screens below the small breakpoint threshold,
  /// including legacy mobile devices and specialized displays.
  final WidgetBuilder? extraSmall;

  /// Builder function for extra large screens in landscape orientation.
  ///
  /// Used when the screen width exceeds the extra large breakpoint and the
  /// device is in landscape mode. Optimized for wide desktop displays.
  final WidgetBuilder? extraLargeLandscape;

  /// Builder function for large screens in landscape orientation.
  ///
  /// Used for standard desktop and laptop screens in landscape mode,
  /// taking advantage of the wider aspect ratio for enhanced layouts.
  final WidgetBuilder? largeLandscape;

  /// Builder function for medium screens in landscape orientation.
  ///
  /// Used for tablet-sized screens in landscape mode, providing more
  /// horizontal space for multi-column layouts and enhanced navigation.
  final WidgetBuilder? mediumLandscape;

  /// Builder function for small screens in landscape orientation.
  ///
  /// Used for mobile phone screens in landscape mode, optimized for
  /// the wider but shorter aspect ratio typical of landscape phone use.
  final WidgetBuilder? smallLandscape;

  /// Builder function for extra small screens in landscape orientation.
  ///
  /// Used for very small screens in landscape mode, requiring minimal
  /// layouts that work within severe space constraints.
  final WidgetBuilder? extraSmallLandscape;

  /// Screen size breakpoints configuration.
  ///
  /// Defines the thresholds used to categorize screen sizes into different
  /// responsive categories. Defaults to [Breakpoints.defaultBreakpoints].
  final Breakpoints breakpoints;

  /// Whether transitions between orientations should be animated.
  ///
  /// When true, orientation changes trigger a smooth [AnimatedSwitcher]
  /// transition with a 300-millisecond duration. When false, orientation
  /// changes occur immediately without animation.
  final bool animateChange;

  @override
  State<ScreenSizeOrientationBuilder> createState() =>
      _ScreenSizeOrientationBuilderState();
}

/// Private state class for [ScreenSizeOrientationBuilder].
///
/// Manages orientation detection, builder handler configuration, and
/// widget tree construction based on current screen size and orientation.
class _ScreenSizeOrientationBuilderState
    extends State<ScreenSizeOrientationBuilder> {
  /// Handler for managing breakpoint-based builder selection.
  ///
  /// Reconfigured whenever orientation changes to use the appropriate
  /// set of builders (portrait or landscape).
  late BreakpointsHandler<WidgetBuilder> handler;

  /// Cached current orientation to detect changes.
  ///
  /// Used to determine when to reconfigure the handler with different
  /// builder sets. Initially null until first dependency change.
  Orientation? orientation;

  /// Responds to changes in device orientation and screen metrics.
  ///
  /// Detects orientation changes and reconfigures the breakpoints handler
  /// to use the appropriate builder set (portrait or landscape). This ensures
  /// that the correct responsive builders are available for the current
  /// device orientation.
  ///
  /// Called automatically by Flutter when MediaQuery data changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _orientation = MediaQuery.orientationOf(context);
    if (orientation != _orientation) {
      orientation = _orientation;
      if (orientation == Orientation.portrait) {
        handler = BreakpointsHandler<WidgetBuilder>(
          breakpoints: widget.breakpoints,
          extraLarge: widget.extraLarge,
          large: widget.large,
          medium: widget.medium,
          small: widget.small,
          extraSmall: widget.extraSmall,
        );
      } else {
        handler = BreakpointsHandler<WidgetBuilder>(
          breakpoints: widget.breakpoints,
          extraLarge: widget.extraLargeLandscape,
          large: widget.largeLandscape,
          medium: widget.mediumLandscape,
          small: widget.smallLandscape,
          extraSmall: widget.extraSmallLandscape,
        );
      }
    }
  }

  /// Builds the appropriate widget based on current screen size and orientation.
  ///
  /// Retrieves the current screen size from [ScreenSizeModel], selects the
  /// appropriate builder using the configured handler, and constructs the
  /// widget tree. If animateChange is enabled, wraps the result in an
  /// [AnimatedSwitcher] for smooth orientation transitions.
  ///
  /// Returns the widget tree built by the selected responsive builder.
  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.screenSizeOf<LayoutSize>(context);

    var child = handler.getScreenSizeValue(
      screenSize: data,
    )(
      context,
    );

    if (widget.animateChange) {
      child = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      );
    }
    return child;
  }
}
