import 'package:flutter/material.dart';
import 'package:responsive_size_builder/src/core/breakpoints/breakpoints.dart';
import 'package:responsive_size_builder/src/core/breakpoints/breakpoints_handler.dart';
import 'package:responsive_size_builder/src/screen_size/screen_size_data.dart';

/// A responsive widget that returns values based on standard screen size breakpoints.
///
/// [ValueSizeBuilder] provides responsive control using five breakpoint categories
/// that cover the complete spectrum of device sizes: extraLarge, large, medium, small,
/// and extraSmall. Unlike widget-based builders, this widget returns typed values
/// that can be used for any responsive design need.
///
/// ## Breakpoint Categories
///
/// The widget supports the [LayoutSize] enum hierarchy:
///
/// * [extraLarge] - Large desktop monitors and wide-screen displays (1200px+)
/// * [large] - Standard desktop and laptop screens (951-1200px)
/// * [medium] - Tablets and smaller laptops (601-950px)
/// * [small] - Mobile phones and tablets in portrait (201-600px)
/// * [extraSmall] - Very small screens and legacy devices (d200px)
///
/// ## Value Resolution Strategy
///
/// When the current screen size doesn't have a directly assigned value, the widget
/// uses intelligent fallback logic:
/// 1. **Direct Match**: Return the value configured for the exact screen size
/// 2. **Fallback Search**: Look for values in smaller breakpoint categories
/// 3. **Last Resort**: Return the last available non-null value
///
/// ## Generic Type Parameter
///
/// The type parameter [K] allows this widget to work with any value type:
/// * `ValueSizeBuilder<Widget>` - For responsive widget selection
/// * `ValueSizeBuilder<double>` - For responsive spacing or font sizes
/// * `ValueSizeBuilder<int>` - For responsive column counts
/// * `ValueSizeBuilder<String>` - For responsive text content
/// * Custom types - For domain-specific responsive values
///
/// ## Usage Examples
///
/// ### Responsive Spacing
/// ```dart
/// ValueSizeBuilder<double>(
///   extraSmall: 4.0,
///   small: 8.0,
///   medium: 16.0,
///   large: 24.0,
///   extraLarge: 32.0,
///   builder: (context, spacing) => Padding(
///     padding: EdgeInsets.all(spacing),
///     child: MyContent(),
///   ),
/// )
/// ```
///
/// ### Responsive Column Count
/// ```dart
/// ValueSizeBuilder<int>(
///   small: 1,        // Single column on mobile
///   medium: 2,       // Two columns on tablets
///   large: 3,        // Three columns on desktop
///   extraLarge: 4,   // Four columns on wide screens
///   builder: (context, columns) => GridView.count(
///     crossAxisCount: columns,
///     children: items,
///   ),
/// )
/// ```
///
/// ### Responsive Typography
/// ```dart
/// ValueSizeBuilder<TextStyle>(
///   small: Theme.of(context).textTheme.bodySmall!,
///   medium: Theme.of(context).textTheme.bodyMedium!,
///   large: Theme.of(context).textTheme.bodyLarge!,
///   extraLarge: Theme.of(context).textTheme.headlineSmall!,
///   builder: (context, textStyle) => Text(
///     'Responsive Text',
///     style: textStyle,
///   ),
/// )
/// ```
///
/// ### Responsive Widget Selection
/// ```dart
/// ValueSizeBuilder<Widget>(
///   small: MobileNavigation(),
///   medium: TabletNavigation(),
///   large: DesktopNavigation(),
///   extraLarge: WideDesktopNavigation(),
///   builder: (context, navigation) => navigation,
/// )
/// ```
///
/// ## Integration Requirements
///
/// This widget requires a [ScreenSize<LayoutSize>] ancestor in the widget
/// tree to function properly:
///
/// ```dart
/// MaterialApp(
///   home: ScreenSize<LayoutSize>(
///     breakpoints: Breakpoints.defaultBreakpoints,
///     child: Scaffold(
///       body: ValueSizeBuilder<double>(
///         // ... breakpoint values
///         builder: (context, value) => MyWidget(spacing: value),
///       ),
///     ),
///   ),
/// )
/// ```
///
/// ## Design Patterns
///
/// **Mobile-first Strategy**: Start with small screens and enhance
/// ```dart
/// ValueSizeBuilder<int>(
///   small: 1,       // Base mobile layout
///   medium: 2,      // Enhanced for tablets
///   large: 3,       // Desktop optimization
///   // extraLarge falls back to large
/// )
/// ```
///
/// **Desktop-first Strategy**: Start with desktop and simplify
/// ```dart
/// ValueSizeBuilder<EdgeInsets>(
///   extraLarge: EdgeInsets.all(32),  // Full desktop padding
///   large: EdgeInsets.all(24),       // Standard desktop
///   medium: EdgeInsets.all(16),      // Tablet simplification
///   small: EdgeInsets.all(8),        // Mobile minimal
/// )
/// ```
///
/// ## Performance Considerations
///
/// * Uses intelligent caching to avoid redundant calculations
/// * Only rebuilds when screen size category changes
/// * Minimal memory footprint with lazy value resolution
/// * Efficient fallback resolution with early termination
///
/// ## Error Handling
///
/// * Requires at least one non-null breakpoint value (enforced by assertion)
/// * Gracefully handles missing values through fallback resolution
/// * Provides clear error messages for integration issues
/// * Maintains type safety through generic constraints
///
/// See also:
///
/// * ScreenSizeBuilder, for widget-based responsive design with standard breakpoints
/// * [BreakpointsHandler], the underlying breakpoint resolution logic
/// * LayoutSize, the enum defining all five breakpoint categories
class ValueSizeBuilder<K> extends StatefulWidget {
  /// Creates a [ValueSizeBuilder] with standard breakpoint support.
  ///
  /// The [builder] function receives the resolved value and builds the widget.
  /// At least one breakpoint value must be non-null to ensure proper fallback
  /// resolution. The widget automatically selects the most appropriate value
  /// based on the current screen size and fallback logic.
  ///
  /// ## Parameters
  ///
  /// **Builder Function:**
  /// * [builder] - Required function that receives the resolved value and context
  ///
  /// **Breakpoint Values:**
  /// * [extraLarge] - Value for large desktop monitors and wide-screen displays (1200px+)
  /// * [large] - Value for standard desktop and laptop screens (951-1200px)
  /// * [medium] - Value for tablets and smaller laptops (601-950px)
  /// * [small] - Value for mobile phones and tablets in portrait (201-600px)
  /// * [extraSmall] - Value for very small screens and legacy devices (d200px)
  ///
  /// ## Value Assignment Strategies
  ///
  /// **Mobile-first Approach**: Focus on smaller screens first
  /// ```dart
  /// ValueSizeBuilder<double>(
  ///   small: 8.0,      // Base mobile value
  ///   medium: 16.0,    // Tablet enhancement
  ///   large: 24.0,     // Desktop optimization
  ///   // extraLarge will fall back to large value
  ///   builder: (context, spacing) => Padding(padding: EdgeInsets.all(spacing)),
  /// )
  /// ```
  ///
  /// **Desktop-first Approach**: Start with desktop and simplify
  /// ```dart
  /// ValueSizeBuilder<int>(
  ///   extraLarge: 4,   // Maximum columns for wide screens
  ///   large: 3,        // Standard desktop columns
  ///   medium: 2,       // Tablet columns
  ///   small: 1,        // Single mobile column
  ///   builder: (context, cols) => GridView.count(crossAxisCount: cols),
  /// )
  /// ```
  ///
  /// **Comprehensive Coverage**: Define values for all breakpoints
  /// ```dart
  /// ValueSizeBuilder<EdgeInsets>(
  ///   extraSmall: EdgeInsets.all(2),
  ///   small: EdgeInsets.all(8),
  ///   medium: EdgeInsets.all(16),
  ///   large: EdgeInsets.all(24),
  ///   extraLarge: EdgeInsets.all(32),
  ///   builder: (context, padding) => Container(padding: padding),
  /// )
  /// ```
  ///
  /// ## Fallback Resolution
  ///
  /// When a screen size doesn't have a direct value assignment:
  /// 1. Searches smaller categories first (large � medium � small � extraSmall)
  /// 2. Uses the last available non-null value as ultimate fallback
  ///
  /// This ensures graceful degradation and prevents runtime errors while
  /// allowing strategic value placement for optimal responsive behavior.
  ///
  /// Throws [AssertionError] if all breakpoint values are null.
  const ValueSizeBuilder({
    required this.builder,
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    super.key,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'At least one builder must be provided',
        );

  /// Value to return for extra large screen sizes.
  ///
  /// Used for large desktop monitors and wide-screen displays (typically 1200px+ wide).
  /// Common use cases include multi-column layouts, comprehensive dashboards,
  /// and desktop applications with extensive UI chrome.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller size categories.
  final K? extraLarge;

  /// Value to return for large screen sizes.
  ///
  /// Used for standard desktop and laptop screens (typically 951-1200px wide).
  /// Suitable for traditional desktop layouts with sidebars, toolbars, and
  /// multiple content areas.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller size categories.
  final K? large;

  /// Value to return for medium screen sizes.
  ///
  /// Used for tablets and smaller laptops (typically 601-950px wide). Often
  /// requires simplified layouts with collapsible navigation and adaptive
  /// content organization.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller size categories.
  final K? medium;

  /// Value to return for small screen sizes.
  ///
  /// Used for mobile phones and tablets in portrait orientation (typically
  /// 201-600px wide). Requires single-column layouts and mobile-optimized
  /// navigation patterns.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in the extraSmall category or use the last resort fallback.
  final K? small;

  /// Value to return for extra small screen sizes.
  ///
  /// Used for very small screens and legacy devices (typically 200px wide and below).
  /// Requires minimal layouts with essential content only.
  ///
  /// This is typically the last category checked during fallback resolution,
  /// making it important for ensuring all screen sizes have appropriate values.
  ///
  /// When null, the handler will use its last resort fallback mechanism.
  final K? extraSmall;

  /// Builder function that constructs the widget using the resolved value.
  ///
  /// This function is called with the current [BuildContext] and the resolved
  /// value of type [K] based on the current screen size. The resolved value
  /// is determined by the standard breakpoint system and fallback logic.
  ///
  /// The function should return a [Widget] that utilizes the provided value
  /// to create a responsive user interface appropriate for the current screen size.
  ///
  /// ## Parameters
  ///
  /// * `context` - The build context for accessing theme, media query, and other services
  /// * `value` - The resolved value based on current screen size and breakpoint configuration
  ///
  /// ## Example Usage
  ///
  /// ```dart
  /// builder: (context, spacing) {
  ///   return Padding(
  ///     padding: EdgeInsets.all(spacing),
  ///     child: Column(
  ///       children: [
  ///         Text('Responsive spacing: $spacing'),
  ///         MyContent(),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  final Widget Function(BuildContext context, K value) builder;

  @override
  State<ValueSizeBuilder<K>> createState() => _ValueSizeBuilderState<K>();
}

/// Private state class for [ValueSizeBuilder].
///
/// Manages the breakpoint resolution logic and widget building. This class
/// handles the integration between the standard breakpoint system and
/// Flutter's widget lifecycle.
///
/// The state creates a [BreakpointsHandler] instance that encapsulates
/// all the breakpoint resolution logic, caching, and fallback behavior. This
/// handler is initialized once and reused throughout the widget's lifetime
/// for optimal performance.
class _ValueSizeBuilderState<K> extends State<ValueSizeBuilder<K>> {
  /// Standard breakpoints handler for resolving values based on screen size.
  ///
  /// This handler contains all the breakpoint values from the widget and
  /// implements the intelligent fallback resolution logic. It's marked as
  /// `late final` because it's initialized once during the state's creation
  /// and doesn't change for the lifetime of the widget.
  ///
  /// The handler automatically maps the current screen size to the most
  /// appropriate value using the standard breakpoint system and fallback
  /// strategies defined in [BreakpointsHandler].
  late final handler = BreakpointsHandler<K>(
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    /// Retrieves the current standard screen size from the nearest [ScreenSizeModel].
    ///
    /// This method efficiently accesses only the screen size aspect of the model,
    /// ensuring that this widget only rebuilds when the screen size category changes,
    /// not when other properties like orientation or device pixel ratio change.
    ///
    /// The screen size data comes from the [ScreenSize<LayoutSize>] ancestor
    /// widget that must be present in the widget tree above this builder.
    final data = ScreenSizeModel.screenSizeOf<LayoutSize>(context);

    /// Resolves the appropriate value for the current screen size.
    ///
    /// The handler applies its standard breakpoint resolution logic to map the
    /// current screen size category to the most suitable configured value. This
    /// includes intelligent fallback resolution when the exact screen size
    /// doesn't have a directly configured value.
    ///
    /// The resolved value is guaranteed to be non-null due to the assertion
    /// in the widget constructor that ensures at least one breakpoint value
    /// is provided, combined with the handler's fallback mechanisms.
    final value = handler.getScreenSizeValue.call(
      screenSize: data,
    );

    /// Builds the widget using the resolved value.
    ///
    /// Calls the user-provided builder function with the current context and
    /// the resolved value. The builder receives a concrete value of type [K]
    /// that represents the most appropriate responsive value for the current
    /// screen size category.
    return widget.builder(context, value);
  }
}
