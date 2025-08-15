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

/// A responsive widget builder with fine-grained screen size control using granular breakpoints.
///
/// [ScreenSizeBuilderGranular] provides the most comprehensive responsive
/// building system in the package, supporting thirteen distinct screen size
/// categories organized into four logical groups: jumbo, standard, compact,
/// and tiny. This granular approach enables precise layout control across
/// the full spectrum of modern devices.
///
/// ## Screen Size Categories
///
/// ### Jumbo Displays (Ultra-wide and High-Resolution)
/// - **jumboExtraLarge**: 8K displays, ultra-wide monitors (4096px+)
/// - **jumboLarge**: 4K displays, large ultra-wide monitors (3841-4096px)
/// - **jumboNormal**: QHD ultra-wide displays (2561-3840px)
/// - **jumboSmall**: Standard ultra-wide monitors (1921-2560px)
///
/// ### Standard Displays (Desktop and Laptop)
/// - **standardExtraLarge**: Large laptops, desktop monitors (1281-1920px)
/// - **standardLarge**: Standard laptops (1025-1280px)
/// - **standardNormal**: Small laptops, large tablets (769-1024px)
/// - **standardSmall**: Tablets in landscape (569-768px)
///
/// ### Compact Displays (Mobile and Small Tablet)
/// - **compactExtraLarge**: Large phones, small tablets portrait (481-568px)
/// - **compactLarge**: Standard modern smartphones (431-480px)
/// - **compactNormal**: Compact phones, older flagships (361-430px)
/// - **compactSmall**: Small phones, older devices (301-360px)
///
/// ### Tiny Displays (Minimal and Specialized)
/// - **tiny**: Smartwatches, very old devices (300px and below)
///
/// ## Usage Example
///
/// ```dart
/// ScreenSizeBuilderGranular(
///   // Ultra-wide displays
///   jumboExtraLarge: (context, data) => MultiPanelDesktopLayout(),
///   jumboLarge: (context, data) => WideDesktopLayout(),
///
///   // Standard displays
///   standardLarge: (context, data) => StandardDesktopLayout(),
///   standardNormal: (context, data) => TabletLayout(),
///
///   // Mobile displays
///   compactLarge: (context, data) => ModernMobileLayout(),
///   compactNormal: (context, data) => StandardMobileLayout(),
///
///   // Minimal displays
///   tiny: (context, data) => MinimalLayout(),
///
///   animateChange: true,
/// )
/// ```
///
/// ## Use Cases
///
/// This granular system is ideal for:
/// - Enterprise applications supporting diverse hardware environments
/// - Design systems requiring precise responsive behavior
/// - Applications with complex UI requirements across device types
/// - Content management systems with varied layout needs
///
/// ## Performance Considerations
///
/// While providing extensive flexibility, consider the maintenance overhead
/// of supporting thirteen different layout variations. For simpler applications,
/// [ScreenSizeBuilder] may be more appropriate.
///
/// See also:
///
/// * [ScreenSizeBuilder], for simpler five-category responsive building
/// * [BreakpointsGranular], for configuring granular breakpoint thresholds
/// * [LayoutSizeGranular], the enum defining the thirteen size categories
class ScreenSizeBuilderGranular extends StatefulWidget {
  /// Creates a [ScreenSizeBuilderGranular] with granular responsive builders.
  ///
  /// At least one builder must be provided across all thirteen size categories.
  /// Builders are selected based on the current screen size as determined by
  /// granular breakpoints. If a specific size category builder is not provided,
  /// the widget will fall back to the next available size.
  ///
  /// ## Jumbo Display Builders
  ///
  /// * [jumboExtraLarge]: Builder for 8K displays and ultra-wide monitors
  /// * [jumboLarge]: Builder for 4K displays and large ultra-wide monitors
  /// * [jumboNormal]: Builder for QHD ultra-wide displays
  /// * [jumboSmall]: Builder for standard ultra-wide monitors
  ///
  /// ## Standard Display Builders
  ///
  /// * [standardExtraLarge]: Builder for large laptops and desktop monitors
  /// * [standardLarge]: Builder for standard laptops
  /// * [standardNormal]: Builder for small laptops and large tablets
  /// * [standardSmall]: Builder for tablets in landscape orientation
  ///
  /// ## Compact Display Builders
  ///
  /// * [compactExtraLarge]: Builder for large phones and small tablets in portrait
  /// * [compactLarge]: Builder for standard modern smartphones
  /// * [compactNormal]: Builder for compact phones and older flagships
  /// * [compactSmall]: Builder for small phones and older devices
  ///
  /// ## Tiny Display Builder
  ///
  /// * [tiny]: Builder for smartwatches and minimal displays
  ///
  /// ## Configuration Parameters
  ///
  /// * [breakpoints]: Granular breakpoint thresholds (defaults to [BreakpointsGranular.defaultBreakpoints])
  /// * [animateChange]: Whether to animate transitions between sizes
  /// * [key]: Optional widget key
  ///
  /// ## Validation
  ///
  /// Throws [AssertionError] if no builders are provided for any size category.
  const ScreenSizeBuilderGranular({
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
    this.breakpoints = BreakpointsGranular.defaultBreakpoints,
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

  /// Builder function for jumbo extra large displays.
  ///
  /// Invoked for 8K displays and ultra-wide monitors exceeding 4096px.
  /// Ideal for complex multi-panel layouts with abundant screen real estate.
  final ScreenSizeWidgetBuilder? jumboExtraLarge;

  /// Builder function for jumbo large displays.
  ///
  /// Invoked for 4K displays and large ultra-wide monitors (3841-4096px).
  /// Suitable for professional workstations and high-end gaming setups.
  final ScreenSizeWidgetBuilder? jumboLarge;

  /// Builder function for jumbo normal displays.
  ///
  /// Invoked for QHD ultra-wide displays (2561-3840px). Common among
  /// developers and designers requiring side-by-side application layouts.
  final ScreenSizeWidgetBuilder? jumboNormal;

  /// Builder function for jumbo small displays.
  ///
  /// Invoked for standard ultra-wide monitors (1921-2560px). Popular
  /// in business and gaming environments for enhanced productivity.
  final ScreenSizeWidgetBuilder? jumboSmall;

  /// Builder function for standard extra large displays.
  ///
  /// Invoked for large laptops and desktop monitors (1281-1920px).
  /// Supports traditional desktop interfaces with full sidebars and toolbars.
  final ScreenSizeWidgetBuilder? standardExtraLarge;

  /// Builder function for standard large displays.
  ///
  /// Invoked for standard laptops and smaller monitors (1025-1280px).
  /// Requires efficient use of space with streamlined layouts.
  final ScreenSizeWidgetBuilder? standardLarge;

  /// Builder function for standard normal displays.
  ///
  /// Invoked for small laptops and large tablets (769-1024px).
  /// Represents the transition zone between desktop and tablet interfaces.
  final ScreenSizeWidgetBuilder? standardNormal;

  /// Builder function for standard small displays.
  ///
  /// Invoked for tablets in landscape orientation (569-768px).
  /// Optimized for touch interaction with moderate screen real estate.
  final ScreenSizeWidgetBuilder? standardSmall;

  /// Builder function for compact extra large displays.
  ///
  /// Invoked for large phones and small tablets in portrait (481-568px).
  /// Supports enhanced mobile layouts with some multi-column content.
  final ScreenSizeWidgetBuilder? compactExtraLarge;

  /// Builder function for compact large displays.
  ///
  /// Invoked for standard modern smartphones (431-480px). The most common
  /// category for contemporary mobile devices with thumb-friendly navigation.
  final ScreenSizeWidgetBuilder? compactLarge;

  /// Builder function for compact normal displays.
  ///
  /// Invoked for compact phones and older flagship devices (361-430px).
  /// Requires careful content prioritization within limited space.
  final ScreenSizeWidgetBuilder? compactNormal;

  /// Builder function for compact small displays.
  ///
  /// Invoked for small phones and budget devices (301-360px).
  /// Requires minimal layouts with essential functionality prioritized.
  final ScreenSizeWidgetBuilder? compactSmall;

  /// Builder function for tiny displays.
  ///
  /// Invoked for smartwatches, IoT displays, and very old mobile devices
  /// (300px and below). Requires extremely simplified interfaces.
  final ScreenSizeWidgetBuilder? tiny;

  /// Whether transitions between different screen sizes should be animated.
  ///
  /// When true, screen size changes trigger a smooth [AnimatedSwitcher]
  /// transition with a 300-millisecond duration. Particularly useful for
  /// applications that may be resized across multiple granular categories.
  final bool animateChange;

  /// Granular breakpoints configuration.
  ///
  /// Defines the thirteen thresholds used to categorize screen sizes into
  /// granular categories. Each threshold represents the minimum width required
  /// for that size category. Defaults to [BreakpointsGranular.defaultBreakpoints].
  final BreakpointsGranular breakpoints;

  @override
  State<ScreenSizeBuilderGranular> createState() =>
      _ScreenSizeBuilderGranularState();
}

/// Private state class for [ScreenSizeBuilderGranular].
///
/// Manages granular breakpoint-based builder selection and widget tree
/// construction with access to comprehensive screen size data across
/// thirteen distinct size categories.
class _ScreenSizeBuilderGranularState extends State<ScreenSizeBuilderGranular> {
  /// Handler for managing granular breakpoint-based builder selection.
  ///
  /// Configured with all provided builders across the thirteen granular
  /// size categories and the specified granular breakpoints configuration.
  /// Responsible for selecting the appropriate builder based on current
  /// screen size and handling complex fallback logic across categories.
  late BreakpointsHandlerGranular<ScreenSizeWidgetBuilder> handler =
      BreakpointsHandlerGranular<ScreenSizeWidgetBuilder>(
    breakpoints: widget.breakpoints,
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

  /// Builds the appropriate widget based on current granular screen size.
  ///
  /// Retrieves comprehensive granular screen size data from [ScreenSizeModel],
  /// selects the appropriate builder from the thirteen available categories
  /// using the configured handler, and constructs the widget tree. The selected
  /// builder receives both the build context and detailed screen size information
  /// with granular size categorization.
  ///
  /// If animateChange is enabled, wraps the result in an [AnimatedSwitcher]
  /// for smooth transitions when screen size changes between granular categories.
  ///
  /// Returns the widget tree built by the selected granular responsive builder.
  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSizeGranular>(context);

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
