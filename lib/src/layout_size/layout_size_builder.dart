import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A responsive layout builder that selects appropriate widgets based on screen size constraints.
///
/// [LayoutSizeBuilder] uses Flutter's [LayoutBuilder] to access [BoxConstraints] and
/// determines the appropriate widget to display based on the available width. Unlike
/// [ScreenSizeBuilder] which depends on the overall screen size, this builder responds
/// to the actual layout constraints of its containing widget, making it ideal for
/// components that need to adapt within specific areas of the screen.
///
/// The builder requires at least one size category to be provided and uses the
/// standard five-tier [LayoutSize] system: extraLarge, large, medium, small, and extraSmall.
///
/// ## Responsive Behavior
///
/// The widget evaluates constraints in descending order and falls back to the next
/// available smaller size if a specific size category is not provided:
///
/// * **extraLarge**: For constraints >= 1200px width (configurable)
/// * **large**: For constraints >= 950px width (configurable)
/// * **medium**: For constraints >= 600px width (configurable)
/// * **small**: For constraints >= 200px width (configurable)
/// * **extraSmall**: For all remaining constraints
///
/// ## Layout Constraint Context
///
/// This builder is particularly useful when:
/// * Building components that appear in sidebars or panels with varying widths
/// * Creating responsive cards or tiles within grids
/// * Adapting content within constrained containers
/// * Building reusable components that work across different layout contexts
///
/// {@tool snippet}
/// Basic usage with multiple breakpoints:
///
/// ```dart
/// LayoutSizeBuilder(
///   extraLarge: (context) => WideDesktopLayout(),
///   large: (context) => DesktopLayout(),
///   medium: (context) => TabletLayout(),
///   small: (context) => MobileLayout(),
///   // extraSmall will fall back to small if not provided
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Custom breakpoints for specific use cases:
///
/// ```dart
/// LayoutSizeBuilder(
///   breakpoints: Breakpoints(
///     extraLarge: 1400,  // Wider threshold for content-heavy layouts
///     large: 1100,
///     medium: 768,       // Common tablet breakpoint
///     small: 480,        // Large phone breakpoint
///   ),
///   large: (context) => MultiColumnLayout(),
///   medium: (context) => TwoColumnLayout(),
///   small: (context) => SingleColumnLayout(),
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Minimal configuration with fallback:
///
/// ```dart
/// LayoutSizeBuilder(
///   large: (context) => DesktopSidebar(),
///   small: (context) => MobileDrawer(),
///   // medium and extraLarge will fall back to large
///   // extraSmall will fall back to small
/// )
/// ```
/// {@end-tool}
///
/// ## Fallback Strategy
///
/// When a specific size category is not provided, the builder uses an intelligent
/// fallback system:
///
/// 1. Look for the exact size match
/// 2. If not found, search smaller size categories in order
/// 3. If still not found, use the last non-null builder provided
///
/// This ensures that your widget always has something to display while allowing
/// for selective implementation of only the breakpoints you need.
///
/// ## Performance Considerations
///
/// - Uses [LayoutBuilder] which rebuilds when constraints change
/// - Internal [BreakpointsHandler] caches the current selection to avoid redundant calculations
/// - Only rebuilds when actual constraint changes occur, not on every frame
///
/// See also:
///
///  * [ScreenSizeBuilder], for responsive layouts based on overall screen size
///  * [LayoutSizeBuilderGranular], for more granular layout constraint control
///  * [BreakpointsHandler], the underlying logic for breakpoint resolution
class LayoutSizeBuilder extends StatefulWidget {
  /// Creates a [LayoutSizeBuilder] with the specified widget builders for different constraint sizes.
  ///
  /// At least one size category builder must be provided. The builder will use the most
  /// appropriate available builder based on the current layout constraints, falling back
  /// to smaller sizes when larger ones are not available.
  ///
  /// ## Parameters
  ///
  /// All builder parameters are optional, but at least one must be provided:
  ///
  /// * [extraLarge]: Builder for extra large constraints (default >= 1200px)
  /// * [large]: Builder for large constraints (default >= 950px)
  /// * [medium]: Builder for medium constraints (default >= 600px)
  /// * [small]: Builder for small constraints (default >= 200px)
  /// * [extraSmall]: Builder for extra small constraints (< 200px)
  ///
  /// The [breakpoints] parameter allows customization of the size thresholds.
  /// If not provided, uses [Breakpoints.defaultBreakpoints].
  ///
  /// ## Example
  ///
  /// ```dart
  /// LayoutSizeBuilder(
  ///   large: (context) => WideContentLayout(),
  ///   medium: (context) => StandardContentLayout(),
  ///   small: (context) => CompactContentLayout(),
  ///   breakpoints: Breakpoints(
  ///     large: 1024,
  ///     medium: 768,
  ///     small: 480,
  ///   ),
  /// )
  /// ```
  ///
  /// Throws [AssertionError] if no builders are provided.
  const LayoutSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder for portrait must be provided',
        );

  /// Widget builder for extra large layout constraints.
  ///
  /// Called when the available width meets or exceeds the extraLarge breakpoint
  /// threshold (default 1200px). Typically used for wide desktop layouts with
  /// multiple columns, sidebars, and complex UI arrangements.
  ///
  /// If null, the builder falls back to [large], then smaller sizes as available.
  final WidgetBuilder? extraLarge;

  /// Widget builder for large layout constraints.
  ///
  /// Called when the available width meets or exceeds the large breakpoint
  /// threshold (default 950px) but is below [extraLarge]. Suitable for standard
  /// desktop layouts with sidebars and multi-panel interfaces.
  ///
  /// If null, the builder falls back to [medium], then smaller sizes as available.
  final WidgetBuilder? large;

  /// Widget builder for medium layout constraints.
  ///
  /// Called when the available width meets or exceeds the medium breakpoint
  /// threshold (default 600px) but is below [large]. Ideal for tablet layouts
  /// and simplified desktop interfaces.
  ///
  /// If null, the builder falls back to [small], then [extraSmall] as available.
  final WidgetBuilder? medium;

  /// Widget builder for small layout constraints.
  ///
  /// Called when the available width meets or exceeds the small breakpoint
  /// threshold (default 200px) but is below [medium]. Designed for mobile
  /// phone layouts and narrow containers.
  ///
  /// If null, the builder falls back to [extraSmall] if available.
  final WidgetBuilder? small;

  /// Widget builder for extra small layout constraints.
  ///
  /// Called when the available width is below the small breakpoint threshold
  /// (default 200px). Used for very constrained layouts, legacy devices, or
  /// minimal UI presentations.
  ///
  /// If null and no other builders are available, this represents the ultimate
  /// fallback in the size hierarchy.
  final WidgetBuilder? extraSmall;

  /// The breakpoints configuration that defines size category thresholds.
  ///
  /// Specifies the minimum width thresholds for each layout size category.
  /// Uses [Breakpoints.defaultBreakpoints] if not provided, which defines:
  /// * extraLarge: 1200px
  /// * large: 950px
  /// * medium: 600px
  /// * small: 200px
  ///
  /// Custom breakpoints can be provided to match specific design requirements
  /// or to align with design system specifications.
  final Breakpoints breakpoints;

  @override
  State<LayoutSizeBuilder> createState() => _LayoutSizeBuilderState();
}

/// Private state class for [LayoutSizeBuilder].
///
/// Manages the breakpoints handler and coordinate with [LayoutBuilder] to
/// respond to constraint changes and select the appropriate widget builder.
class _LayoutSizeBuilderState extends State<LayoutSizeBuilder> {
  /// The breakpoints handler that manages size category selection and fallback logic.
  ///
  /// Initialized with the widget's breakpoints configuration and builder functions.
  /// Uses generic type [WidgetBuilder] to handle the function signatures for
  /// responsive widget construction.
  late BreakpointsHandler<WidgetBuilder> handler =
      BreakpointsHandler<WidgetBuilder>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Get the appropriate widget builder based on current constraints
        // and invoke it with the current context
        return handler.getLayoutSizeValue(
          constraints: constraints,
        )(context);
      },
    );
  }
}
