import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

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
    print(
        'ScreenSizeBuilderGranular.build called (hashCode: ${this.hashCode})');
    final data = ScreenSizeModel.of<LayoutSizeGranular>(context);
    print('  Got data with screenSize: ${data.screenSize}');

    var child = handler.getScreenSizeValue(
      screenSize: data.screenSize,
    )(
      context,
      data,
    );
    print('  Builder function called');

    if (widget.animateChange) {
      child = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      );
    }
    return child;
  }
}
