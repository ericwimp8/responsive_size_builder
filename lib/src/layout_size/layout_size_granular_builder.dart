import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A granular responsive layout builder that provides fine-tuned widget selection based on layout constraints.
///
/// [LayoutSizeBuilderGranular] extends the responsive capabilities of [LayoutSizeBuilder]
/// by offering thirteen distinct size categories organized into logical groups. This
/// granular system enables precise layout adaptation across the full spectrum of
/// device sizes and constraint scenarios.
///
/// Unlike [LayoutSizeBuilder]'s five-category system, this builder uses [LayoutSizeGranular]
/// with categories spanning from ultra-wide monitors (jumbo) to smartwatches (tiny),
/// providing unprecedented control over responsive behavior in constrained layouts.
///
/// ## Size Category Groups
///
/// The builder organizes size categories into four logical groups:
///
/// ### Jumbo Categories (Ultra-wide Displays)
/// * **jumboExtraLarge**: >= 4096px (8K displays, ultra-wide monitors)
/// * **jumboLarge**: >= 3840px (4K displays, large ultra-wide)
/// * **jumboNormal**: >= 2560px (QHD ultra-wide displays)
/// * **jumboSmall**: >= 1920px (Standard ultra-wide monitors)
///
/// ### Standard Categories (Desktop/Laptop Displays)
/// * **standardExtraLarge**: >= 1280px (Large laptops, monitors)
/// * **standardLarge**: >= 1024px (Standard laptops)
/// * **standardNormal**: >= 768px (Small laptops, large tablets)
/// * **standardSmall**: >= 568px (Tablets in landscape)
///
/// ### Compact Categories (Mobile/Small Tablet Displays)
/// * **compactExtraLarge**: >= 480px (Large phones, small tablets)
/// * **compactLarge**: >= 430px (Standard modern phones)
/// * **compactNormal**: >= 360px (Compact phones)
/// * **compactSmall**: >= 300px (Small phones)
///
/// ### Tiny Category (Minimal Displays)
/// * **tiny**: < 300px (Smartwatches, very old devices)
///
/// ## Layout Constraint Context
///
/// This granular builder excels in scenarios requiring precise layout control:
/// * Complex dashboard components with multiple layout variations
/// * Content management interfaces supporting diverse screen types
/// * Design systems requiring fine-grained responsive behavior
/// * Components that appear across wildly different constraint environments
///
/// {@tool snippet}
/// Comprehensive layout adaptation:
///
/// ```dart
/// LayoutSizeBuilderGranular(
///   jumboExtraLarge: (context, data) => UltraWideWorkspaceLayout(),
///   jumboLarge: (context, data) => MultiPanelDesktopLayout(),
///   standardLarge: (context, data) => StandardDesktopLayout(),
///   standardNormal: (context, data) => TabletLandscapeLayout(),
///   compactLarge: (context, data) => ModernMobileLayout(),
///   compactNormal: (context, data) => CompactMobileLayout(),
///   tiny: (context, data) => MinimalLayout(),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Grouped fallback strategy:
///
/// ```dart
/// LayoutSizeBuilderGranular(
///   // Jumbo group - for ultra-wide scenarios
///   jumboLarge: (context, data) => UltraWideLayout(),
///
///   // Standard group - for desktop scenarios
///   standardLarge: (context, data) => DesktopLayout(),
///
///   // Compact group - for mobile scenarios
///   compactLarge: (context, data) => MobileLayout(),
/// )
/// ```
/// {@end-tool}
///
/// ## Enhanced Builder Signature
///
/// Unlike [LayoutSizeBuilder], granular builders receive additional context:
/// * [BuildContext] for widget tree access
/// * [ScreenSizeModelData] containing comprehensive screen size information
///
/// This enables builders to make more informed layout decisions based on device
/// characteristics, orientation, and physical display properties.
///
/// ## Performance Considerations
///
/// - Uses [LayoutBuilder] with constraint-based rebuilding
/// - Requires [ScreenSize] ancestor widget for screen size data
/// - [BreakpointsHandlerGranular] provides efficient size category resolution
/// - Caching prevents redundant calculations during constraint changes
///
/// ## Custom Breakpoints
///
/// The default granular breakpoints cover common device sizes, but can be
/// customized for specific use cases:
///
/// ```dart
/// LayoutSizeBuilderGranular(
///   breakpoints: BreakpointsGranular(
///     jumboExtraLarge: 5120,  // Support 5K displays
///     standardNormal: 800,    // Adjust tablet threshold
///     compactLarge: 414,      // iPhone Pro Max width
///   ),
///   // ... builders
/// )
/// ```
///
/// See also:
///
///  * [LayoutSizeBuilder], for simpler five-category layout constraints
///  * [ScreenSizeBuilderGranular], for granular screen-size-based layouts
///  * [ValueSizeBuilderGranular], for granular constraint-based value selection
///  * [BreakpointsGranular], the breakpoints configuration for this builder
class LayoutSizeBuilderGranular extends StatefulWidget {
  /// Creates a [LayoutSizeBuilderGranular] with granular widget builders for different constraint sizes.
  ///
  /// Unlike [LayoutSizeBuilder], this constructor doesn't require any builders to be
  /// provided, as the granular system provides extensive fallback options across
  /// thirteen size categories. However, providing at least a few key builders is
  /// recommended for meaningful responsive behavior.
  ///
  /// ## Builder Categories
  ///
  /// **Jumbo Display Builders** (Ultra-wide and High-res):
  /// * [jumboExtraLarge]: For 8K displays and ultra-wide monitors (>= 4096px)
  /// * [jumboLarge]: For 4K displays and large ultra-wide (>= 3840px)
  /// * [jumboNormal]: For QHD ultra-wide displays (>= 2560px)
  /// * [jumboSmall]: For standard ultra-wide monitors (>= 1920px)
  ///
  /// **Standard Display Builders** (Desktop and Laptop):
  /// * [standardExtraLarge]: For large laptops and monitors (>= 1280px)
  /// * [standardLarge]: For standard laptops (>= 1024px)
  /// * [standardNormal]: For small laptops and large tablets (>= 768px)
  /// * [standardSmall]: For tablets in landscape (>= 568px)
  ///
  /// **Compact Display Builders** (Mobile and Small Tablet):
  /// * [compactExtraLarge]: For large phones and small tablets (>= 480px)
  /// * [compactLarge]: For standard modern phones (>= 430px)
  /// * [compactNormal]: For compact phones (>= 360px)
  /// * [compactSmall]: For small phones (>= 300px)
  ///
  /// The [breakpoints] parameter customizes size thresholds using
  /// [BreakpointsGranular.defaultBreakpoints] by default.
  ///
  /// ## Example
  ///
  /// ```dart
  /// LayoutSizeBuilderGranular(
  ///   jumboLarge: (context, data) => UltraWideWorkspace(),
  ///   standardLarge: (context, data) => DesktopInterface(),
  ///   compactLarge: (context, data) => MobileInterface(),
  ///   breakpoints: BreakpointsGranular(
  ///     standardLarge: 1200,
  ///     compactLarge: 414,
  ///   ),
  /// )
  /// ```
  const LayoutSizeBuilderGranular({
    this.breakpoints = BreakpointsGranular.defaultBreakpoints,
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
    super.key,
  });

  /// Widget builder for jumbo extra large layout constraints.
  ///
  /// Called for ultra-wide displays and 8K monitors with constraints >= 4096px.
  /// Ideal for complex multi-panel professional interfaces with abundant screen
  /// real estate. Supports the most sophisticated layout arrangements.
  final ScreenSizeWidgetBuilder? jumboExtraLarge;

  /// Widget builder for jumbo large layout constraints.
  ///
  /// Called for 4K displays and large ultra-wide monitors with constraints >= 3840px.
  /// Suitable for high-resolution professional workstations and content creation
  /// environments requiring detailed multi-window layouts.
  final ScreenSizeWidgetBuilder? jumboLarge;

  /// Widget builder for jumbo normal layout constraints.
  ///
  /// Called for QHD ultra-wide displays with constraints >= 2560px. Common in
  /// developer and designer setups, supporting side-by-side application layouts
  /// with room for detailed toolbars and panels.
  final ScreenSizeWidgetBuilder? jumboNormal;

  /// Widget builder for jumbo small layout constraints.
  ///
  /// Called for standard ultra-wide monitors with constraints >= 1920px. Enables
  /// enhanced productivity layouts with expanded horizontal workspace while
  /// maintaining standard vertical resolution.
  final ScreenSizeWidgetBuilder? jumboSmall;

  /// Widget builder for standard extra large layout constraints.
  ///
  /// Called for large laptops and desktop monitors with constraints >= 1280px.
  /// Supports traditional desktop interfaces with full sidebars, toolbars, and
  /// multi-column content arrangements.
  final ScreenSizeWidgetBuilder? standardExtraLarge;

  /// Widget builder for standard large layout constraints.
  ///
  /// Called for standard laptops and smaller monitors with constraints >= 1024px.
  /// Requires efficient space utilization with collapsible UI elements and
  /// streamlined layouts for business and portable workstations.
  final ScreenSizeWidgetBuilder? standardLarge;

  /// Widget builder for standard normal layout constraints.
  ///
  /// Called for small laptops and large tablets with constraints >= 768px.
  /// Represents the transition between desktop and tablet interfaces, often
  /// requiring adaptive navigation patterns and touch-friendly elements.
  final ScreenSizeWidgetBuilder? standardNormal;

  /// Widget builder for standard small layout constraints.
  ///
  /// Called for tablets in landscape orientation with constraints >= 568px.
  /// Optimized for touch interaction while providing moderate screen real estate.
  /// Suitable for 10-12" tablets and hybrid devices.
  final ScreenSizeWidgetBuilder? standardSmall;

  /// Widget builder for compact extra large layout constraints.
  ///
  /// Called for large phones and small tablets in portrait with constraints >= 480px.
  /// Represents the upper range of mobile devices, supporting enhanced mobile
  /// layouts with some multi-column content possibilities.
  final ScreenSizeWidgetBuilder? compactExtraLarge;

  /// Widget builder for compact large layout constraints.
  ///
  /// Called for standard modern smartphones with constraints >= 430px. The most
  /// common mobile category, optimized for one-handed use with thumb-friendly
  /// navigation and single-column layouts.
  final ScreenSizeWidgetBuilder? compactLarge;

  /// Widget builder for compact normal layout constraints.
  ///
  /// Called for compact phones and older flagship devices with constraints >= 360px.
  /// Requires careful content prioritization and efficient use of limited screen
  /// space while maintaining usability standards.
  final ScreenSizeWidgetBuilder? compactNormal;

  /// Widget builder for compact small layout constraints.
  ///
  /// Called for small phones and budget devices with constraints >= 300px.
  /// Demands minimal layouts with essential functionality prioritized and careful
  /// consideration of content hierarchy and touch targets.
  final ScreenSizeWidgetBuilder? compactSmall;

  /// The granular breakpoints configuration defining thirteen size category thresholds.
  ///
  /// Specifies minimum width thresholds for each granular layout size category.
  /// Uses [BreakpointsGranular.defaultBreakpoints] by default, providing comprehensive
  /// coverage from ultra-wide monitors (4096px+) to tiny displays (300px-).
  ///
  /// Custom breakpoints enable fine-tuning for specific design requirements:
  /// * Content-heavy applications needing precise control
  /// * Enterprise environments with diverse hardware
  /// * Design systems requiring granular responsive behavior
  final BreakpointsGranular breakpoints;

  @override
  State<LayoutSizeBuilderGranular> createState() => _LayoutSizeGranularState();
}

/// Private state class for [LayoutSizeBuilderGranular].
///
/// Manages the granular breakpoints handler and coordinates with [LayoutBuilder]
/// to respond to constraint changes across thirteen size categories. Also handles
/// integration with [ScreenSizeModel] to provide enhanced builder context.
class _LayoutSizeGranularState extends State<LayoutSizeBuilderGranular> {
  /// The granular breakpoints handler that manages thirteen size categories and fallback logic.
  ///
  /// Initialized with the widget's granular breakpoints configuration and all
  /// builder functions. Uses generic type [ScreenSizeWidgetBuilder] to handle
  /// the enhanced function signatures that receive screen size data.
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
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Retrieve comprehensive screen size data from the ancestor ScreenSize widget
        // This provides additional context beyond just the layout constraints
        final data = ScreenSizeModel.of<LayoutSize>(
          context,
        );

        // Get the appropriate widget builder based on current constraints
        // and invoke it with both context and screen size data for enhanced decision making
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context, data);
      },
    );
  }
}
