import 'package:flutter/material.dart';
import 'package:responsive_size_builder/src/core/breakpoints/breakpoints.dart';
import 'package:responsive_size_builder/src/core/breakpoints/breakpoints_handler_granular.dart';
import 'package:responsive_size_builder/src/screen_size/screen_size_data.dart';

/// A responsive widget that returns values based on granular screen size breakpoints.
///
/// [ValueSizeBuilderGranular] provides fine-grained responsive control by supporting
/// thirteen breakpoint categories organized into four logical groups: jumbo, standard,
/// compact, and tiny. Unlike widget-based builders, this widget returns typed values
/// that can be used for any responsive design need.
///
/// ## Breakpoint Categories
///
/// The widget supports the full [LayoutSizeGranular] enum hierarchy:
///
/// **Jumbo Displays (Ultra-wide and High-Resolution):**
/// * [jumboExtraLarge] - 8K displays, ultra-wide monitors (4096px+)
/// * [jumboLarge] - 4K displays, large ultra-wide monitors (3841-4096px)
/// * [jumboNormal] - QHD ultra-wide displays (2561-3840px)
/// * [jumboSmall] - Standard ultra-wide monitors (1921-2560px)
///
/// **Standard Displays (Desktop and Laptop):**
/// * [standardExtraLarge] - Large laptops, desktop monitors (1281-1920px)
/// * [standardLarge] - Standard laptops (1025-1280px)
/// * [standardNormal] - Small laptops, large tablets (769-1024px)
/// * [standardSmall] - Tablets in landscape (569-768px)
///
/// **Compact Displays (Mobile and Small Tablets):**
/// * [compactExtraLarge] - Large phones, small tablets portrait (481-568px)
/// * [compactLarge] - Standard modern smartphones (431-480px)
/// * [compactNormal] - Compact phones, older flagships (361-430px)
/// * [compactSmall] - Small phones, older devices (301-360px)
///
/// **Tiny Displays (Minimal and Specialized):**
/// * [tiny] - Smartwatches, very old devices (300px and below)
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
/// * `ValueSizeBuilderGranular<Widget>` - For responsive widget selection
/// * `ValueSizeBuilderGranular<double>` - For responsive spacing or font sizes
/// * `ValueSizeBuilderGranular<int>` - For responsive column counts
/// * `ValueSizeBuilderGranular<String>` - For responsive text content
/// * Custom types - For domain-specific responsive values
///
/// ## Usage Examples
///
/// ### Responsive Spacing
/// ```dart
/// ValueSizeBuilderGranular<double>(
///   tiny: 4.0,
///   compactSmall: 8.0,
///   compactLarge: 12.0,
///   standardNormal: 16.0,
///   standardLarge: 24.0,
///   jumboSmall: 32.0,
///   builder: (context, spacing) => Padding(
///     padding: EdgeInsets.all(spacing),
///     child: MyContent(),
///   ),
/// )
/// ```
///
/// ### Responsive Column Count
/// ```dart
/// ValueSizeBuilderGranular<int>(
///   compactLarge: 1,     // Single column on mobile
///   standardNormal: 2,   // Two columns on tablets
///   standardLarge: 3,    // Three columns on desktop
///   jumboSmall: 4,       // Four columns on wide screens
///   builder: (context, columns) => GridView.count(
///     crossAxisCount: columns,
///     children: items,
///   ),
/// )
/// ```
///
/// ### Responsive Typography
/// ```dart
/// ValueSizeBuilderGranular<TextStyle>(
///   compactSmall: Theme.of(context).textTheme.bodySmall!,
///   compactLarge: Theme.of(context).textTheme.bodyMedium!,
///   standardLarge: Theme.of(context).textTheme.bodyLarge!,
///   jumboNormal: Theme.of(context).textTheme.headlineSmall!,
///   builder: (context, textStyle) => Text(
///     'Responsive Text',
///     style: textStyle,
///   ),
/// )
/// ```
///
/// ### Responsive Widget Selection
/// ```dart
/// ValueSizeBuilderGranular<Widget>(
///   compactLarge: MobileNavigation(),
///   standardNormal: TabletNavigation(),
///   standardLarge: DesktopNavigation(),
///   jumboSmall: WideDesktopNavigation(),
///   builder: (context, navigation) => navigation,
/// )
/// ```
///
/// ## Integration Requirements
///
/// This widget requires a [ScreenSize<LayoutSizeGranular>] ancestor in the widget
/// tree to function properly:
///
/// ```dart
/// MaterialApp(
///   home: ScreenSize<LayoutSizeGranular>(
///     breakpoints: BreakpointsGranular.defaultBreakpoints,
///     child: Scaffold(
///       body: ValueSizeBuilderGranular<double>(
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
/// **Group-based Strategy**: Define key values for each display group
/// ```dart
/// ValueSizeBuilderGranular<int>(
///   compactLarge: 1,      // Mobile group
///   standardNormal: 2,    // Desktop group
///   jumboSmall: 4,        // Ultra-wide group
///   // Other sizes fall back automatically
/// )
/// ```
///
/// **Progressive Enhancement**: Start minimal and add refinements
/// ```dart
/// ValueSizeBuilderGranular<EdgeInsets>(
///   compactLarge: EdgeInsets.all(8),           // Base mobile padding
///   standardLarge: EdgeInsets.all(16),         // Enhanced for desktop
///   jumboNormal: EdgeInsets.symmetric(         // Optimized for ultra-wide
///     horizontal: 64, vertical: 16
///   ),
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
/// * ScreenSizeBuilderGranular, for widget-based granular responsive design
/// * [BreakpointsHandlerGranular], the underlying breakpoint resolution logic
/// * LayoutSizeGranular, the enum defining all thirteen breakpoint categories
class ValueSizeBuilderGranular<K> extends StatefulWidget {
  /// Creates a [ValueSizeBuilderGranular] with granular breakpoint support.
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
  /// **Jumbo Display Values (Ultra-wide and High-Resolution):**
  /// * [jumboExtraLarge] - Value for 8K displays, ultra-wide monitors (4096px+)
  /// * [jumboLarge] - Value for 4K displays, large ultra-wide monitors (3841-4096px)
  /// * [jumboNormal] - Value for QHD ultra-wide displays (2561-3840px)
  /// * [jumboSmall] - Value for standard ultra-wide monitors (1921-2560px)
  ///
  /// **Standard Display Values (Desktop and Laptop):**
  /// * [standardExtraLarge] - Value for large laptops, desktop monitors (1281-1920px)
  /// * [standardLarge] - Value for standard laptops (1025-1280px)
  /// * [standardNormal] - Value for small laptops, large tablets (769-1024px)
  /// * [standardSmall] - Value for tablets in landscape (569-768px)
  ///
  /// **Compact Display Values (Mobile and Small Tablets):**
  /// * [compactExtraLarge] - Value for large phones, small tablets portrait (481-568px)
  /// * [compactLarge] - Value for standard modern smartphones (431-480px)
  /// * [compactNormal] - Value for compact phones, older flagships (361-430px)
  /// * [compactSmall] - Value for small phones, older devices (301-360px)
  ///
  /// **Tiny Display Values (Minimal and Specialized):**
  /// * [tiny] - Value for smartwatches, very old devices (300px and below)
  ///
  /// ## Value Assignment Strategies
  ///
  /// **Group-based Coverage**: Define one value per display group
  /// ```dart
  /// ValueSizeBuilderGranular<double>(
  ///   compactLarge: 8.0,     // All compact sizes use this
  ///   standardLarge: 16.0,   // All standard sizes use this
  ///   jumboSmall: 24.0,      // All jumbo sizes use this
  ///   builder: (context, spacing) => Padding(padding: EdgeInsets.all(spacing)),
  /// )
  /// ```
  ///
  /// **Selective Targeting**: Focus on specific device classes
  /// ```dart
  /// ValueSizeBuilderGranular<int>(
  ///   compactLarge: 1,           // Modern smartphones
  ///   standardNormal: 2,         // Tablets and small laptops
  ///   standardExtraLarge: 3,     // Desktop monitors
  ///   jumboNormal: 4,            // Ultra-wide displays
  ///   builder: (context, cols) => GridView.count(crossAxisCount: cols),
  /// )
  /// ```
  ///
  /// **Comprehensive Definition**: Maximum control across all categories
  /// ```dart
  /// ValueSizeBuilderGranular<EdgeInsets>(
  ///   tiny: EdgeInsets.all(2),
  ///   compactSmall: EdgeInsets.all(4),
  ///   compactNormal: EdgeInsets.all(6),
  ///   compactLarge: EdgeInsets.all(8),
  ///   compactExtraLarge: EdgeInsets.all(10),
  ///   standardSmall: EdgeInsets.all(12),
  ///   standardNormal: EdgeInsets.all(16),
  ///   standardLarge: EdgeInsets.all(20),
  ///   standardExtraLarge: EdgeInsets.all(24),
  ///   jumboSmall: EdgeInsets.all(32),
  ///   jumboNormal: EdgeInsets.all(40),
  ///   jumboLarge: EdgeInsets.all(48),
  ///   jumboExtraLarge: EdgeInsets.all(64),
  ///   builder: (context, padding) => Container(padding: padding),
  /// )
  /// ```
  ///
  /// ## Fallback Resolution
  ///
  /// When a screen size doesn't have a direct value assignment:
  /// 1. Searches smaller categories within the same group first
  /// 2. Falls back to values in smaller display groups if needed
  /// 3. Uses the last available non-null value as ultimate fallback
  ///
  /// This ensures graceful degradation and prevents runtime errors while
  /// allowing strategic value placement for optimal responsive behavior.
  ///
  /// Throws [AssertionError] if all breakpoint values are null.
  const ValueSizeBuilderGranular({
    required this.builder,
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

  /// Value to return for jumbo extra large displays.
  ///
  /// Used for 8K displays, ultra-wide monitors, and specialized high-resolution
  /// setups (typically 4096px+ wide). Supports the most complex layouts with
  /// abundant screen real estate.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller jumbo categories, then other display groups.
  final K? jumboExtraLarge;

  /// Value to return for jumbo large displays.
  ///
  /// Used for 4K displays and large ultra-wide monitors (typically 3841-4096px wide).
  /// Ideal for professional applications requiring multiple simultaneous content
  /// areas and detailed visual information.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller jumbo categories, then other display groups.
  final K? jumboLarge;

  /// Value to return for jumbo normal displays.
  ///
  /// Used for QHD ultra-wide displays (typically 2561-3840px wide). Popular
  /// among developers and designers, supports side-by-side application layouts
  /// with room for detailed toolbars and panels.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller jumbo categories, then other display groups.
  final K? jumboNormal;

  /// Value to return for jumbo small displays.
  ///
  /// Used for standard ultra-wide monitors (typically 1921-2560px wide).
  /// Common in business and gaming environments, offers expanded horizontal
  /// space for enhanced desktop productivity layouts.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller categories or other display groups.
  final K? jumboSmall;

  /// Value to return for standard extra large displays.
  ///
  /// Used for large laptops and desktop monitors (typically 1281-1920px wide).
  /// Represents the upper range of standard computer displays, supports
  /// traditional desktop interfaces with full sidebars and toolbars.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller standard categories, then other display groups.
  final K? standardExtraLarge;

  /// Value to return for standard large displays.
  ///
  /// Used for standard laptops and smaller monitors (typically 1025-1280px wide).
  /// Common in business laptops and portable workstations, requires efficient
  /// use of space with collapsible UI elements.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller standard categories, then other display groups.
  final K? standardLarge;

  /// Value to return for standard normal displays.
  ///
  /// Used for small laptops and large tablets (typically 769-1024px wide).
  /// Represents the transition zone between desktop and tablet interfaces,
  /// often requires adaptive navigation patterns.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller standard categories, then other display groups.
  final K? standardNormal;

  /// Value to return for standard small displays.
  ///
  /// Used for tablets in landscape orientation (typically 569-768px wide).
  /// Optimized for touch interaction while providing moderate screen real estate,
  /// requires touch-friendly controls and simplified navigation.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in compact categories or the tiny category.
  final K? standardSmall;

  /// Value to return for compact extra large displays.
  ///
  /// Used for large phones and small tablets in portrait (typically 481-568px wide).
  /// Represents the upper range of mobile devices, supports enhanced mobile
  /// layouts with some multi-column content possibilities.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller compact categories or the tiny category.
  final K? compactExtraLarge;

  /// Value to return for compact large displays.
  ///
  /// Used for standard modern smartphones (typically 431-480px wide). The most
  /// common category for contemporary mobile devices, optimized for one-handed
  /// use with thumb-friendly navigation and single-column layouts.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller compact categories or the tiny category.
  final K? compactLarge;

  /// Value to return for compact normal displays.
  ///
  /// Used for compact phones and older flagship devices (typically 361-430px wide).
  /// Requires careful content prioritization and efficient use of limited
  /// screen space while maintaining usability.
  ///
  /// When null, the fallback resolution will search for suitable alternatives
  /// in smaller compact categories or the tiny category.
  final K? compactNormal;

  /// Value to return for compact small displays.
  ///
  /// Used for small phones and budget devices (typically 301-360px wide).
  /// Common in entry-level smartphones, requires minimal layouts with
  /// essential functionality prioritized and careful content hierarchy.
  ///
  /// When null, the fallback resolution will search for alternatives
  /// in the tiny category or use the ultimate fallback mechanism.
  final K? compactSmall;

  /// Value to return for tiny displays.
  ///
  /// Used for minimal displays and specialized devices (typically 300px and below).
  /// Includes smartwatches, IoT displays, and very old mobile devices. Requires
  /// extremely simplified interfaces with only critical functionality exposed.
  ///
  /// This is typically the last category checked during fallback resolution,
  /// making it important for ensuring comprehensive screen size coverage.
  final K? tiny;

  /// Builder function that constructs the widget using the resolved value.
  ///
  /// This function is called with the current [BuildContext] and the resolved
  /// value of type [K] based on the current screen size. The resolved value
  /// is determined by the granular breakpoint system and fallback logic.
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
  State<ValueSizeBuilderGranular<K>> createState() =>
      _ValueSizeBuilderGranularState<K>();
}

/// Private state class for [ValueSizeBuilderGranular].
///
/// Manages the breakpoint resolution logic and widget building. This class
/// handles the integration between the granular breakpoint system and
/// Flutter's widget lifecycle.
///
/// The state creates a [BreakpointsHandlerGranular] instance that encapsulates
/// all the breakpoint resolution logic, caching, and fallback behavior. This
/// handler is initialized once and reused throughout the widget's lifetime
/// for optimal performance.
class _ValueSizeBuilderGranularState<K>
    extends State<ValueSizeBuilderGranular<K>> {
  /// Granular breakpoints handler for resolving values based on screen size.
  ///
  /// This handler contains all the breakpoint values from the widget and
  /// implements the intelligent fallback resolution logic. It's marked as
  /// `late final` because it's initialized once during the state's creation
  /// and doesn't change for the lifetime of the widget.
  ///
  /// The handler automatically maps the current screen size to the most
  /// appropriate value using the granular breakpoint system and fallback
  /// strategies defined in [BreakpointsHandlerGranular].
  late final handler = BreakpointsHandlerGranular<K>(
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

  @override
  Widget build(BuildContext context) {
    /// Retrieves the current granular screen size from the nearest [ScreenSizeModel].
    ///
    /// This method efficiently accesses only the screen size aspect of the model,
    /// ensuring that this widget only rebuilds when the screen size category changes,
    /// not when other properties like orientation or device pixel ratio change.
    ///
    /// The screen size data comes from the [ScreenSize<LayoutSizeGranular>] ancestor
    /// widget that must be present in the widget tree above this builder.
    final data = ScreenSizeModel.screenSizeOf<LayoutSizeGranular>(context);

    /// Resolves the appropriate value for the current screen size.
    ///
    /// The handler applies its granular breakpoint resolution logic to map the
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
