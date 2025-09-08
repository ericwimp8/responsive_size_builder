import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A responsive widget builder that creates layouts based on screen size breakpoints.
///
/// [ScreenSizeBuilder] provides a simple and flexible way to build responsive
/// user interfaces that adapt to different screen sizes. It uses the standard
/// five-category breakpoint system and provides comprehensive screen size data
/// to each builder function.
///
/// Unlike [ScreenSizeOrientationBuilder], this widget uses the same builders
/// for both portrait and landscape orientations, making it ideal for layouts
/// that adapt primarily to screen size rather than orientation.
///
/// ## Builder Selection Process
///
/// 1. Determines current screen size using configured breakpoints
/// 2. Selects the builder for the current size category
/// 3. Falls back to next available builder if exact match not provided
/// 4. Provides comprehensive [ScreenSizeModelData] to the selected builder
///
/// ## Usage Example
///
/// ```dart
/// ScreenSizeBuilder(
///   extraSmall: (context, data) => MobileLayout(
///     screenWidth: data.logicalScreenWidth,
///     isPortrait: data.orientation == Orientation.portrait,
///   ),
///   small: (context, data) => MobileLayout(),
///   medium: (context, data) => TabletLayout(),
///   large: (context, data) => DesktopLayout(),
///   extraLarge: (context, data) => DesktopLayout(expanded: true),
///   animateChange: true,
/// )
/// ```
///
/// ## Data Access
///
/// Each builder receives a [ScreenSizeModelData] object containing:
/// - Current screen size category
/// - Physical and logical dimensions
/// - Device pixel ratio and orientation
/// - Platform-specific flags (isDesktop, isTouch, isWeb)
///
/// See also:
///
/// * [ScreenSizeOrientationBuilder], for orientation-aware responsive building
/// * [ScreenSizeBuilderGranular], for fine-grained responsive control
/// * [ScreenSizeWidgetBuilder], the builder function signature
/// * [ScreenSizeModelData], the data provided to builders
class ScreenSizeBuilder extends StatefulWidget {
  /// Creates a [ScreenSizeBuilder] with responsive builders for different screen sizes.
  ///
  /// At least one builder must be provided. Builders are selected based on the
  /// current screen size as determined by the configured breakpoints. If a
  /// specific size category builder is not provided, the widget will fall back
  /// to the next available size or throw an assertion error if none exist.
  ///
  /// ## Builder Parameters
  ///
  /// * [extraLarge]: Builder for screens above the extra large breakpoint
  /// * [large]: Builder for screens above the large breakpoint
  /// * [medium]: Builder for screens above the medium breakpoint
  /// * [small]: Builder for screens above the small breakpoint
  /// * [extraSmall]: Builder for screens below the small breakpoint
  ///
  /// ## Configuration Parameters
  ///
  /// * [breakpoints]: Screen size thresholds (defaults to [Breakpoints.defaultBreakpoints])
  /// * [animateChange]: Whether to animate transitions between sizes
  /// * [key]: Optional widget key
  ///
  /// ## Validation
  ///
  /// Throws [AssertionError] if no builders are provided for any size category.
  const ScreenSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for must be provided',
        );

  /// Builder function for extra large screens.
  ///
  /// Invoked when the screen width exceeds the extra large breakpoint,
  /// typically for large desktop monitors and ultra-wide displays.
  /// Receives [ScreenSizeModelData] with detailed screen information.
  final ScreenSizeWidgetBuilder? extraLarge;

  /// Builder function for large screens.
  ///
  /// Invoked for standard desktop and laptop screens, typically between
  /// the large and extra large breakpoint thresholds. Ideal for traditional
  /// desktop layouts with sidebars and toolbars.
  final ScreenSizeWidgetBuilder? large;

  /// Builder function for medium screens.
  ///
  /// Invoked for tablet-sized screens and small laptops, typically between
  /// the medium and large breakpoint thresholds. Often requires simplified
  /// layouts with collapsible navigation.
  final ScreenSizeWidgetBuilder? medium;

  /// Builder function for small screens.
  ///
  /// Invoked for mobile phone screens and small tablets, typically between
  /// the small and medium breakpoint thresholds. Requires mobile-optimized
  /// layouts with single-column designs.
  final ScreenSizeWidgetBuilder? small;

  /// Builder function for extra small screens.
  ///
  /// Invoked for very small screens below the small breakpoint threshold,
  /// including legacy mobile devices. Requires minimal layouts with
  /// essential content only.
  final ScreenSizeWidgetBuilder? extraSmall;

  /// Screen size breakpoints configuration.
  ///
  /// Defines the thresholds used to categorize screen sizes. Each threshold
  /// represents the minimum width required for that size category.
  /// Defaults to [Breakpoints.defaultBreakpoints].
  final Breakpoints breakpoints;

  /// Whether transitions between different screen sizes should be animated.
  ///
  /// When true, screen size changes trigger a smooth [AnimatedSwitcher]
  /// transition with a 300-millisecond duration. Useful for smooth transitions
  /// when users resize browser windows or rotate devices.
  final bool animateChange;

  @override
  State<ScreenSizeBuilder> createState() => _ScreenSizeBuilderState();
}

/// Private state class for [ScreenSizeBuilder].
///
/// Manages breakpoint-based builder selection and widget tree construction
/// with access to comprehensive screen size data.
class _ScreenSizeBuilderState extends State<ScreenSizeBuilder> {
  /// Handler for managing breakpoint-based builder selection.
  ///
  /// Configured with all provided builders and the specified breakpoints
  /// configuration. Responsible for selecting the appropriate builder
  /// based on current screen size and handling fallback logic.
  late BreakpointsHandler<ScreenSizeWidgetBuilder> handler =
      BreakpointsHandler<ScreenSizeWidgetBuilder>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  /// Builds the appropriate widget based on current screen size.
  ///
  /// Retrieves comprehensive screen size data from [ScreenSizeModel], selects
  /// the appropriate builder using the configured handler, and constructs the
  /// widget tree. The selected builder receives both the build context and
  /// detailed screen size information.
  ///
  /// If animateChange is enabled, wraps the result in an [AnimatedSwitcher]
  /// for smooth transitions when screen size changes.
  ///
  /// Returns the widget tree built by the selected responsive builder.
  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(
      context,
    );

    var child = handler.getScreenSizeValue(
      screenSize: data.screenSize,
    )(
      context,
      data,
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
