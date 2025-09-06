import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Abstract base class that handles responsive breakpoint calculations and value resolution.
///
/// This class provides the core logic for mapping screen dimensions to appropriate
/// values based on predefined breakpoints. It serves as the foundation for both
/// standard and granular breakpoint handling systems.
///
/// The class uses two generic type parameters:
/// * [T] - The type of values to be returned for each breakpoint
/// * [K] - The enum type representing breakpoint categories (must extend [Enum])
///
/// ## Core Functionality
///
/// The handler performs three primary operations:
/// 1. **Screen Size Detection**: Converts pixel dimensions to breakpoint categories
/// 2. **Value Resolution**: Maps breakpoint categories to configured values
/// 3. **Fallback Logic**: Provides sensible defaults when exact matches aren't available
///
/// ## Caching and Performance
///
/// The handler implements intelligent caching to optimize performance:
/// * Caches the last calculated screen size to avoid redundant calculations
/// * Stores the current resolved value for quick access
/// * Only recalculates when screen dimensions change
///
/// ## Value Resolution Strategy
///
/// When resolving values for a given screen size, the handler follows this priority:
/// 1. Direct match - Return value configured for the exact screen size
/// 2. Fallback search - Look for the first available value in smaller sizes
/// 3. Last resort - Return the last available value from any configured size
///
/// ## Usage Pattern
///
/// Implementations typically:
/// 1. Define available values for each breakpoint category
/// 2. Use [getLayoutSizeValue] for Flutter widget constraints
/// 3. Use [getScreenSizeValue] for direct screen size calculations
/// 4. Handle change notifications through the [onChanged] callback
///
/// ## Example Implementation
///
/// ```dart
/// class CustomHandler extends BaseBreakpointsHandler<Widget, LayoutSize> {
///   CustomHandler({
///     this.mobile,
///     this.desktop,
///     required super.breakpoints,
///   });
///
///   final Widget? mobile;
///   final Widget? desktop;
///
///   @override
///   Map<LayoutSize, Widget?> get values => {
///     LayoutSize.small: mobile,
///     LayoutSize.large: desktop,
///     // ... other mappings
///   };
/// }
/// ```
///
/// See also:
///
/// * [BreakpointsHandler], the standard implementation with [LayoutSize]
/// * [BreakpointsHandlerGranular], the granular implementation with [LayoutSizeGranular]
/// * [BaseBreakpoints], which defines the breakpoint threshold values
abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  /// Creates a new [BaseBreakpointsHandler] with the specified configuration.
  ///
  /// The [breakpoints] parameter defines the threshold values for each breakpoint
  /// category, while the optional [onChanged] callback is invoked whenever the
  /// screen size category changes.
  ///
  /// ## Parameters
  ///
  /// * [breakpoints] - Configuration defining pixel thresholds for each category
  /// * [onChanged] - Optional callback invoked when screen size category changes
  ///
  /// ## Change Notifications
  ///
  /// The [onChanged] callback is particularly useful for:
  /// * Updating UI state when breakpoints change
  /// * Triggering analytics events for different screen sizes
  /// * Debugging responsive behavior during development
  /// * Coordinating with other responsive components
  BaseBreakpointsHandler({required this.breakpoints, this.onChanged});

  /// Optional callback invoked when the screen size category changes.
  ///
  /// This callback is called whenever [getScreenSizeValue] or [getLayoutSizeValue]
  /// detects a change in the current screen size category. It receives the new
  /// screen size category as its parameter.
  ///
  /// The callback is invoked before value resolution occurs, allowing listeners
  /// to react to breakpoint changes in real-time.
  ///
  /// ## Usage Examples
  ///
  /// ```dart
  /// // Log breakpoint changes for debugging
  /// BreakpointsHandler(
  ///   onChanged: (size) => print('Screen size changed to: $size'),
  ///   // ... other parameters
  /// );
  ///
  /// // Update application state
  /// BreakpointsHandler(
  ///   onChanged: (size) => appState.currentBreakpoint = size,
  ///   // ... other parameters
  /// );
  /// ```
  final void Function(K)? onChanged;

  /// Breakpoint configuration defining threshold values for each screen size category.
  ///
  /// This configuration maps each breakpoint category to its minimum pixel width
  /// threshold. The handler uses these thresholds to determine which category
  /// a given screen dimension falls into.
  ///
  /// The breakpoints configuration remains constant throughout the handler's
  /// lifetime and should be chosen based on the target device ecosystem and
  /// design requirements.
  final BaseBreakpoints<K> breakpoints;

  /// Cached value from the most recent breakpoint resolution.
  ///
  /// This field stores the result of the last successful value resolution,
  /// enabling quick return for repeated queries with the same screen size.
  /// The cache is invalidated whenever the screen size category changes.
  ///
  /// The value is null when no resolution has occurred or when no suitable
  /// value could be found for any breakpoint category.
  T? currentValue;

  /// Cached screen size category from the most recent calculation.
  ///
  /// This field stores the breakpoint category calculated during the last
  /// call to [getScreenSizeValue] or [getLayoutSizeValue]. It enables the
  /// handler to avoid redundant calculations when the screen size hasn't changed.
  ///
  /// The cache is compared against newly calculated screen sizes to determine
  /// whether [currentValue] needs to be recalculated and whether [onChanged]
  /// should be invoked.
  K? screenSizeCache;

  /// Map of breakpoint categories to their corresponding values.
  ///
  /// This abstract getter must be implemented by subclasses to define which
  /// value should be returned for each breakpoint category. The map should
  /// include entries for all possible values of the enum type [K].
  ///
  /// Values can be null to indicate that no specific value is configured for
  /// a particular breakpoint category. The handler's fallback logic will
  /// attempt to find suitable alternatives when null values are encountered.
  ///
  /// ## Implementation Guidelines
  ///
  /// * Include all enum values as keys for completeness
  /// * Use null values strategically to enable fallback behavior
  /// * Consider the fallback resolution order when designing the value map
  ///
  /// ## Example
  ///
  /// ```dart
  /// @override
  /// Map<LayoutSize, Widget?> get values => {
  ///   LayoutSize.extraLarge: desktopWidget,
  ///   LayoutSize.large: desktopWidget,
  ///   LayoutSize.medium: tabletWidget,
  ///   LayoutSize.small: mobileWidget,
  ///   LayoutSize.extraSmall: mobileWidget,
  /// };
  /// ```
  Map<K, T?> get values;

  /// Resolves the appropriate value based on Flutter layout constraints.
  ///
  /// This method is the primary interface for integrating with Flutter's layout
  /// system. It extracts dimensional information from [BoxConstraints] and
  /// determines the appropriate value based on the current breakpoint configuration.
  ///
  /// ## Parameters
  ///
  /// * [constraints] - Flutter layout constraints containing available space
  /// * [useShortestSide] - Whether to use the shortest dimension for calculation
  ///
  /// ## Dimension Selection
  ///
  /// By default, the method uses the maximum width from the constraints. When
  /// [useShortestSide] is true, it uses the smaller of width and height. This
  /// is useful for creating truly responsive layouts that adapt to both
  /// orientation changes and different aspect ratios.
  ///
  /// ## Integration with Flutter Widgets
  ///
  /// This method is typically called from within Flutter widget build methods:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return LayoutBuilder(
  ///     builder: (context, constraints) {
  ///       final widget = handler.getLayoutSizeValue(constraints: constraints);
  ///       return widget;
  ///     },
  ///   );
  /// }
  /// ```
  ///
  /// ## Orientation Considerations
  ///
  /// When [useShortestSide] is false (default):
  /// * Portrait orientation: Uses screen width
  /// * Landscape orientation: Uses screen width (typically larger)
  ///
  /// When [useShortestSide] is true:
  /// * Portrait orientation: Uses screen width (shorter side)
  /// * Landscape orientation: Uses screen height (shorter side)
  ///
  /// Returns the resolved value for the current layout constraints.
  ///
  /// Throws [StateError] if no suitable value can be found for any breakpoint.
  T getLayoutSizeValue({
    required BoxConstraints constraints,
    bool useShortestSide = false,
  }) {
    late double dimension;
    final layoutWidth = constraints.maxWidth;
    final layoutHeight = constraints.maxHeight;
    if (useShortestSide) {
      dimension = layoutWidth < layoutHeight ? layoutWidth : layoutHeight;
    } else {
      dimension = constraints.maxWidth;
    }

    return getScreenSizeValue(screenSize: getScreenSize(dimension));
  }

  /// Resolves the appropriate value for a given screen size category.
  ///
  /// This method implements the core value resolution logic, mapping breakpoint
  /// categories to configured values using intelligent fallback strategies.
  /// It handles caching, change notifications, and graceful degradation when
  /// exact matches aren't available.
  ///
  /// ## Resolution Strategy
  ///
  /// The method follows a three-tier resolution strategy:
  ///
  /// 1. **Direct Match**: Returns the exact value configured for [screenSize]
  /// 2. **Fallback Search**: Searches smaller breakpoint categories for available values
  /// 3. **Last Resort**: Returns the last non-null value from any category
  ///
  /// ## Caching Behavior
  ///
  /// The method implements intelligent caching to optimize performance:
  /// * Returns cached [currentValue] if [screenSize] matches [screenSizeCache]
  /// * Updates cache and triggers [onChanged] callback when screen size changes
  /// * Invalidates cache whenever a new screen size is detected
  ///
  /// ## Change Notifications
  ///
  /// The [onChanged] callback is invoked whenever the screen size category
  /// changes, regardless of whether the resolved value changes. This ensures
  /// consistent notification behavior for responsive UI updates.
  ///
  /// ## Fallback Logic Detail
  ///
  /// When no direct match is found, the method:
  /// 1. Identifies the position of [screenSize] in the breakpoint hierarchy
  /// 2. Searches through smaller (subsequent) breakpoint categories
  /// 3. Returns the first non-null value found in this search
  /// 4. Falls back to the last configured non-null value if no match is found
  ///
  /// ## Error Handling
  ///
  /// The method is designed to always return a value when at least one non-null
  /// value is configured in [values]. It will throw a [StateError] only if all
  /// configured values are null, which indicates a configuration problem.
  ///
  /// ## Parameters
  ///
  /// * [screenSize] - The breakpoint category to resolve a value for
  ///
  /// Returns the resolved value for the specified screen size category.
  ///
  /// Throws [StateError] if no non-null values are configured in [values].
  T getScreenSizeValue({required K screenSize}) {
    final currentSceenSize = screenSize;
    if (screenSizeCache == currentSceenSize && currentValue != null) {
      return currentValue!;
    }

    onChanged?.call(currentSceenSize);

    screenSizeCache = currentSceenSize;

    var callback = values[screenSizeCache];
    if (callback != null) {
      currentValue = callback;
      return callback;
    }

    final index = breakpoints.values.keys.toList().indexOf(screenSizeCache!);
    final validCallbacks = values.values.toList().sublist(index);
    callback = validCallbacks.firstWhere(
      (element) => element != null,
      orElse: () => null,
    );

    if (callback != null) {
      currentValue = callback;
      return callback;
    }

    callback = values.values.lastWhere((element) => element != null);
    currentValue = callback;
    return callback!;
  }

  /// Determines the breakpoint category for a given pixel dimension.
  ///
  /// This method maps a pixel measurement to the appropriate breakpoint category
  /// by comparing it against the configured threshold values. It implements the
  /// core logic for translating continuous pixel values into discrete breakpoint
  /// categories.
  ///
  /// ## Algorithm
  ///
  /// The method iterates through the breakpoint thresholds in order and returns
  /// the first category where the [size] meets or exceeds the threshold value.
  /// This implements a "greater than or equal to" matching strategy.
  ///
  /// ## Threshold Comparison
  ///
  /// For a size to match a breakpoint category, it must be greater than or equal
  /// to that category's threshold value. This means:
  /// * A 1200px screen matches "large" if the large threshold is 1200px
  /// * A 1199px screen would match the next smaller category
  ///
  /// ## Fallback Behavior
  ///
  /// If no thresholds are met (i.e., the [size] is smaller than all configured
  /// thresholds), the method returns the last entry in the breakpoints map.
  /// This typically corresponds to the smallest breakpoint category.
  ///
  /// ## Special Values
  ///
  /// Some breakpoint configurations use special threshold values:
  /// * -1 or other negative values typically indicate catch-all categories
  /// * 0 might be used for minimal or default categories
  ///
  /// The method handles these appropriately by following the iteration order
  /// defined in the breakpoints configuration.
  ///
  /// ## Performance Considerations
  ///
  /// The method performs a linear search through the breakpoint entries. For
  /// typical breakpoint configurations (5-13 entries), this is highly efficient.
  /// The entries are processed in the order defined by the breakpoints map.
  ///
  /// ## Parameters
  ///
  /// * [size] - The pixel dimension to categorize (typically width)
  ///
  /// Returns the breakpoint category that [size] falls into.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // With default breakpoints: {extraLarge: 1200, large: 950, medium: 600, small: 200}
  /// getScreenSize(1400);  // Returns LayoutSize.extraLarge
  /// getScreenSize(1000);  // Returns LayoutSize.large
  /// getScreenSize(700);   // Returns LayoutSize.medium
  /// getScreenSize(100);   // Returns LayoutSize.extraSmall (fallback)
  /// ```
  K getScreenSize(double size) {
    final entries = breakpoints.values.entries;
    for (final entry in entries) {
      if (size >= entry.value) {
        return entry.key;
      }
    }

    return entries.last.key;
  }
}

/// Standard breakpoint handler for responsive layouts with five size categories.
///
/// This class provides a concrete implementation of [BaseBreakpointsHandler] that
/// works with the standard [LayoutSize] enum and [Breakpoints] configuration.
/// It offers a balanced approach to responsive design, suitable for most
/// applications that need to adapt across desktop, tablet, and mobile devices.
///
/// ## Size Categories
///
/// The handler supports five breakpoint categories:
/// * [extraLarge] - Large desktop monitors and wide-screen displays (1200px+)
/// * [large] - Standard desktop and laptop screens (951-1200px)
/// * [medium] - Tablets and smaller laptops (601-950px)
/// * [small] - Mobile phones and tablets in portrait (201-600px)
/// * [extraSmall] - Very small screens and legacy devices (≤200px)
///
/// ## Value Assignment Strategy
///
/// The handler requires at least one size category to have a non-null value,
/// ensuring that fallback resolution can always find a suitable result. This
/// prevents runtime errors and guarantees predictable behavior.
///
/// Common assignment patterns:
/// * **Mobile-first**: Define small and medium, let others fall back
/// * **Desktop-centric**: Define large and extraLarge, with mobile fallbacks
/// * **Comprehensive**: Define values for all relevant size categories
///
/// ## Usage Examples
///
/// ### Widget-based Responsive Design
/// ```dart
/// final handler = BreakpointsHandler<Widget>(
///   small: MobileLayout(),
///   medium: TabletLayout(),
///   large: DesktopLayout(),
///   extraLarge: WideDesktopLayout(),
/// );
///
/// Widget build(BuildContext context) {
///   return LayoutBuilder(
///     builder: (context, constraints) {
///       return handler.getLayoutSizeValue(constraints: constraints);
///     },
///   );
/// }
/// ```
///
/// ### Value-based Responsive Design
/// ```dart
/// final spacingHandler = BreakpointsHandler<double>(
///   small: 8.0,
///   medium: 16.0,
///   large: 24.0,
///   extraLarge: 32.0,
/// );
///
/// double getResponsiveSpacing(BoxConstraints constraints) {
///   return spacingHandler.getLayoutSizeValue(constraints: constraints);
/// }
/// ```
///
/// ### Custom Breakpoints
/// ```dart
/// final customBreakpoints = Breakpoints(
///   extraLarge: 1440,  // Accommodate larger monitors
///   large: 1024,       // Standard laptop size
///   medium: 768,       // Tablet breakpoint
///   small: 480,        // Mobile breakpoint
/// );
///
/// final handler = BreakpointsHandler<int>(
///   breakpoints: customBreakpoints,
///   small: 1,          // Single column
///   medium: 2,         // Two columns
///   large: 3,          // Three columns
///   extraLarge: 4,     // Four columns
/// );
/// ```
///
/// ## Change Notifications
///
/// ```dart
/// final handler = BreakpointsHandler<Widget>(
///   onChanged: (size) {
///     print('Breakpoint changed to: $size');
///     // Update app state, trigger animations, etc.
///   },
///   // ... value assignments
/// );
/// ```
///
/// ## Performance Characteristics
///
/// * **Caching**: Avoids recalculation when screen size hasn't changed
/// * **Lazy Evaluation**: Only calculates values when requested
/// * **Minimal Overhead**: Simple enum-based categorization
/// * **Memory Efficient**: Stores only current state and configuration
///
/// ## Design Patterns
///
/// The handler works well with several responsive design patterns:
/// * **Progressive Enhancement**: Start with mobile and enhance for larger screens
/// * **Graceful Degradation**: Start with desktop and simplify for smaller screens
/// * **Adaptive Design**: Distinct layouts for each major breakpoint category
/// * **Hybrid Approach**: Mix different strategies for different UI components
///
/// See also:
///
/// * [BaseBreakpointsHandler], the abstract base class
/// * [BreakpointsHandlerGranular], for more fine-grained breakpoint control
/// * [LayoutSize], the enum defining the five size categories
/// * [Breakpoints], the configuration class for threshold values
class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize> {
  /// Creates a new [BreakpointsHandler] with the specified values and configuration.
  ///
  /// At least one size parameter must be non-null to ensure the handler can
  /// always resolve to a value. The [breakpoints] parameter defines the pixel
  /// thresholds for each size category, while [onChanged] provides optional
  /// change notifications.
  ///
  /// ## Parameters
  ///
  /// **Size Value Assignments:**
  /// * [extraLarge] - Value for large desktop monitors and wide-screen displays
  /// * [large] - Value for standard desktop and laptop screens
  /// * [medium] - Value for tablets and smaller laptops
  /// * [small] - Value for mobile phones and tablets in portrait
  /// * [extraSmall] - Value for very small screens and legacy devices
  ///
  /// **Configuration:**
  /// * [breakpoints] - Pixel thresholds for size categories (defaults to [Breakpoints.defaultBreakpoints])
  /// * [onChanged] - Optional callback invoked when breakpoint category changes
  ///
  /// ## Value Assignment Guidelines
  ///
  /// **Minimum Requirement**: At least one size parameter must be non-null.
  ///
  /// **Common Patterns**:
  /// * **Mobile-first**: Assign [small] and [medium], rely on fallback for larger sizes
  /// * **Desktop-first**: Assign [large] and [extraLarge], with mobile fallbacks
  /// * **Tablet-centric**: Focus on [medium] with fallbacks in both directions
  /// * **Comprehensive**: Assign values for all relevant breakpoints
  ///
  /// ## Fallback Behavior
  ///
  /// When a specific size category has a null value, the handler's fallback
  /// logic will search for suitable alternatives:
  /// 1. Look for values in smaller size categories
  /// 2. Use the last available non-null value as a final fallback
  ///
  /// ## Example Configurations
  ///
  /// ```dart
  /// // Mobile-first approach
  /// BreakpointsHandler<Widget>(
  ///   small: MobileWidget(),
  ///   medium: TabletWidget(),
  ///   // large and extraLarge will fall back to TabletWidget
  /// );
  ///
  /// // Comprehensive coverage
  /// BreakpointsHandler<double>(
  ///   extraSmall: 4.0,
  ///   small: 8.0,
  ///   medium: 16.0,
  ///   large: 24.0,
  ///   extraLarge: 32.0,
  /// );
  ///
  /// // Custom breakpoints
  /// BreakpointsHandler<int>(
  ///   breakpoints: Breakpoints(large: 1440, medium: 1024),
  ///   medium: 2,
  ///   large: 3,
  /// );
  /// ```
  ///
  /// Throws [AssertionError] if all size parameters are null.
  BreakpointsHandler({
    super.breakpoints = Breakpoints.defaultBreakpoints,
    super.onChanged,
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'BreakpointsHandler requires at least one of the size arguments to be filled out',
        );

  /// Value to return for extra large screen sizes.
  ///
  /// This value is used for large desktop monitors and wide-screen displays,
  /// typically screens wider than 1200 pixels (configurable via [breakpoints]).
  /// Common use cases include multi-column layouts, comprehensive dashboards,
  /// and desktop applications with extensive UI chrome.
  ///
  /// When null, the handler's fallback logic will search for suitable
  /// alternatives in smaller size categories.
  final T? extraLarge;

  /// Value to return for large screen sizes.
  ///
  /// This value is used for standard desktop and laptop screens, typically
  /// screens between 951-1200 pixels wide (configurable via [breakpoints]).
  /// Suitable for traditional desktop layouts with sidebars, toolbars, and
  /// multiple content areas.
  ///
  /// When null, the handler's fallback logic will search for suitable
  /// alternatives in smaller size categories.
  final T? large;

  /// Value to return for medium screen sizes.
  ///
  /// This value is used for tablets and smaller laptops, typically screens
  /// between 601-950 pixels wide (configurable via [breakpoints]). Often
  /// requires simplified layouts with collapsible navigation and adaptive
  /// content organization.
  ///
  /// When null, the handler's fallback logic will search for suitable
  /// alternatives in smaller size categories.
  final T? medium;

  /// Value to return for small screen sizes.
  ///
  /// This value is used for mobile phones and tablets in portrait orientation,
  /// typically screens between 201-600 pixels wide (configurable via [breakpoints]).
  /// Requires single-column layouts and mobile-optimized navigation patterns.
  ///
  /// When null, the handler's fallback logic will search for suitable
  /// alternatives in the extraSmall category or use the last resort fallback.
  final T? small;

  /// Value to return for extra small screen sizes.
  ///
  /// This value is used for very small screens and legacy devices, typically
  /// screens 200 pixels wide and below (configurable via [breakpoints]).
  /// Requires minimal layouts with essential content only.
  ///
  /// This is typically the last category checked during fallback resolution,
  /// making it important for ensuring all screen sizes have appropriate values.
  ///
  /// When null, the handler will use its last resort fallback mechanism.
  final T? extraSmall;

  /// Map of layout size categories to their corresponding values.
  ///
  /// This implementation maps each [LayoutSize] enum value to its corresponding
  /// field value, enabling the base class resolution logic to function properly.
  /// The map is used by [getScreenSizeValue] to resolve appropriate values
  /// based on screen size calculations.
  ///
  /// The returned map includes all five standard layout size categories,
  /// preserving null values where no specific value was configured. This
  /// allows the fallback logic to operate correctly.
  @override
  Map<LayoutSize, T?> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: extraSmall,
      };
}

/// Granular breakpoint handler for responsive layouts with thirteen size categories.
///
/// This class provides a comprehensive implementation of [BaseBreakpointsHandler]
/// that works with the granular [LayoutSizeGranular] enum and [BreakpointsGranular]
/// configuration. It offers fine-grained control over responsive behavior,
/// enabling precise layout adaptation across the full spectrum of device sizes.
///
/// ## Category Groups
///
/// The handler organizes breakpoints into four logical groups:
///
/// ### Jumbo Displays (Ultra-wide and High-Resolution)
/// * [jumboExtraLarge] - 8K displays, ultra-wide monitors (4096px+)
/// * [jumboLarge] - 4K displays, large ultra-wide monitors (3841-4096px)
/// * [jumboNormal] - QHD ultra-wide displays (2561-3840px)
/// * [jumboSmall] - Standard ultra-wide monitors (1921-2560px)
///
/// ### Standard Displays (Desktop and Laptop)
/// * [standardExtraLarge] - Large laptops, desktop monitors (1281-1920px)
/// * [standardLarge] - Standard laptops (1025-1280px)
/// * [standardNormal] - Small laptops, large tablets (769-1024px)
/// * [standardSmall] - Tablets in landscape (569-768px)
///
/// ### Compact Displays (Mobile and Small Tablets)
/// * [compactExtraLarge] - Large phones, small tablets portrait (481-568px)
/// * [compactLarge] - Standard modern smartphones (431-480px)
/// * [compactNormal] - Compact phones, older flagships (361-430px)
/// * [compactSmall] - Small phones, older devices (301-360px)
///
/// ### Tiny Displays (Minimal and Specialized)
/// * [tiny] - Smartwatches, very old devices (300px and below)
///
/// ## Use Cases
///
/// This granular system excels in scenarios requiring:
/// * **Enterprise Applications**: Supporting diverse hardware environments
/// * **Design Systems**: Requiring precise responsive behavior specifications
/// * **Content Management**: Needing optimal layouts across all device types
/// * **Multi-Platform Apps**: Targeting everything from smartwatches to ultra-wide monitors
/// * **Accessibility Compliance**: Ensuring usability across extreme screen sizes
///
/// ## Design Strategy
///
/// The granular approach enables several advanced design strategies:
///
/// **Progressive Enhancement by Group:**
/// ```dart
/// BreakpointsHandlerGranular<Widget>(
///   // Compact group: mobile-optimized layouts
///   compactLarge: MobileLayout(),
///   compactNormal: MobileLayout(density: 'high'),
///
///   // Standard group: traditional responsive layouts
///   standardNormal: TabletLayout(),
///   standardLarge: DesktopLayout(sidebar: false),
///
///   // Jumbo group: take advantage of extra space
///   jumboSmall: DesktopLayout(panels: 3),
///   jumboLarge: DesktopLayout(panels: 4, toolbars: 'extensive'),
/// );
/// ```
///
/// **Density-Based Adaptation:**
/// ```dart
/// BreakpointsHandlerGranular<double>(
///   // Tiny displays: minimal spacing
///   tiny: 2.0,
///
///   // Compact displays: touch-friendly spacing
///   compactSmall: 4.0,
///   compactNormal: 6.0,
///   compactLarge: 8.0,
///
///   // Standard displays: comfortable spacing
///   standardSmall: 12.0,
///   standardNormal: 16.0,
///   standardLarge: 20.0,
///
///   // Jumbo displays: generous spacing
///   jumboSmall: 32.0,
///   jumboLarge: 48.0,
/// );
/// ```
///
/// ## Performance Considerations
///
/// While offering extensive flexibility, consider these factors:
/// * **Maintenance Overhead**: Supporting thirteen variations requires more effort
/// * **Design Complexity**: More breakpoints mean more design decisions
/// * **Testing Surface**: Increased combinations to validate
/// * **Bundle Size**: More layout code if using widget-based values
///
/// For simpler applications, [BreakpointsHandler] may be more appropriate.
///
/// ## Fallback Strategies
///
/// The granular system supports sophisticated fallback strategies:
/// * **Group-based Fallbacks**: Define one value per group, let others fall back
/// * **Selective Coverage**: Target specific device classes precisely
/// * **Progressive Definition**: Start minimal and add refinements
///
/// ## Integration Examples
///
/// ### Column Layout Adaptation
/// ```dart
/// final columnHandler = BreakpointsHandlerGranular<int>(
///   tiny: 1,
///   compactSmall: 1,
///   compactNormal: 1,
///   compactLarge: 1,
///   compactExtraLarge: 2,
///   standardSmall: 2,
///   standardNormal: 3,
///   standardLarge: 3,
///   standardExtraLarge: 4,
///   jumboSmall: 4,
///   jumboNormal: 5,
///   jumboLarge: 6,
///   jumboExtraLarge: 8,
/// );
/// ```
///
/// ### Typography Scale
/// ```dart
/// final fontSizeHandler = BreakpointsHandlerGranular<double>(
///   tiny: 10.0,
///   compactSmall: 12.0,
///   compactNormal: 14.0,
///   compactLarge: 16.0,
///   compactExtraLarge: 16.0,
///   standardSmall: 16.0,
///   standardNormal: 18.0,
///   standardLarge: 20.0,
///   standardExtraLarge: 22.0,
///   jumboSmall: 24.0,
///   jumboNormal: 28.0,
///   jumboLarge: 32.0,
///   jumboExtraLarge: 36.0,
/// );
/// ```
///
/// See also:
///
/// * [BaseBreakpointsHandler], the abstract base class
/// * [BreakpointsHandler], for simpler five-category breakpoints
/// * [LayoutSizeGranular], the enum defining the thirteen size categories
/// * [BreakpointsGranular], the configuration class for granular thresholds
class BreakpointsHandlerGranular<T>
    extends BaseBreakpointsHandler<T, LayoutSizeGranular> {
  /// Creates a new [BreakpointsHandlerGranular] with the specified values and configuration.
  ///
  /// At least one size parameter must be non-null to ensure the handler can
  /// always resolve to a value. The [breakpoints] parameter defines the pixel
  /// thresholds for each granular size category, while [onChanged] provides
  /// optional change notifications.
  ///
  /// ## Parameters
  ///
  /// **Jumbo Display Values (Ultra-wide and High-Resolution):**
  /// * [jumboExtraLarge] - Value for 8K displays and ultra-wide monitors
  /// * [jumboLarge] - Value for 4K displays and large ultra-wide monitors
  /// * [jumboNormal] - Value for QHD ultra-wide displays
  /// * [jumboSmall] - Value for standard ultra-wide monitors
  ///
  /// **Standard Display Values (Desktop and Laptop):**
  /// * [standardExtraLarge] - Value for large laptops and desktop monitors
  /// * [standardLarge] - Value for standard laptops
  /// * [standardNormal] - Value for small laptops and large tablets
  /// * [standardSmall] - Value for tablets in landscape orientation
  ///
  /// **Compact Display Values (Mobile and Small Tablets):**
  /// * [compactExtraLarge] - Value for large phones and small tablets in portrait
  /// * [compactLarge] - Value for standard modern smartphones
  /// * [compactNormal] - Value for compact phones and older flagships
  /// * [compactSmall] - Value for small phones and older devices
  ///
  /// **Tiny Display Values (Minimal and Specialized):**
  /// * [tiny] - Value for smartwatches and very old devices
  ///
  /// **Configuration:**
  /// * [breakpoints] - Granular pixel thresholds (defaults to [BreakpointsGranular.defaultBreakpoints])
  /// * [onChanged] - Optional callback invoked when breakpoint category changes
  ///
  /// ## Value Assignment Strategies
  ///
  /// **Minimum Requirement**: At least one size parameter must be non-null.
  ///
  /// **Common Patterns**:
  ///
  /// * **Group-based Assignment**: Define one value per group, rely on fallbacks
  ///   ```dart
  ///   BreakpointsHandlerGranular(
  ///     compactLarge: mobileValue,     // All compact sizes fall back to this
  ///     standardLarge: desktopValue,   // All standard sizes fall back to this
  ///     jumboSmall: ultraWideValue,    // All jumbo sizes fall back to this
  ///   );
  ///   ```
  ///
  /// * **Progressive Enhancement**: Start with key breakpoints and add refinements
  ///   ```dart
  ///   BreakpointsHandlerGranular(
  ///     compactLarge: mobileLayout,
  ///     standardNormal: tabletLayout,
  ///     standardLarge: desktopLayout,
  ///     jumboSmall: wideDesktopLayout,
  ///     // Add more specific values as needed
  ///   );
  ///   ```
  ///
  /// * **Comprehensive Coverage**: Define values for all or most categories
  ///   ```dart
  ///   BreakpointsHandlerGranular(
  ///     tiny: minimalSpacing,
  ///     compactSmall: compactSpacing,
  ///     compactNormal: normalMobileSpacing,
  ///     // ... define all categories for complete control
  ///   );
  ///   ```
  ///
  /// ## Fallback Resolution
  ///
  /// When a specific size category has a null value, the handler follows its
  /// fallback logic:
  /// 1. Search through smaller size categories in the same group
  /// 2. Search through smaller groups if needed
  /// 3. Use the last available non-null value as final fallback
  ///
  /// ## Performance vs. Precision Trade-offs
  ///
  /// Consider these factors when choosing how many categories to define:
  /// * **High Precision**: Define most categories for fine-tuned control
  /// * **Maintenance Balance**: Define key categories with strategic fallbacks
  /// * **Simple Approach**: Define 3-4 key categories, similar to standard handler
  ///
  /// ## Example Configurations
  ///
  /// ```dart
  /// // Minimal but effective coverage
  /// BreakpointsHandlerGranular<Widget>(
  ///   compactLarge: MobileWidget(),
  ///   standardNormal: TabletWidget(),
  ///   standardLarge: DesktopWidget(),
  ///   jumboSmall: WideDesktopWidget(),
  /// );
  ///
  /// // Typography scaling across all sizes
  /// BreakpointsHandlerGranular<TextTheme>(
  ///   tiny: tinyTextTheme,
  ///   compactSmall: mobileTextTheme,
  ///   compactLarge: largeMobileTextTheme,
  ///   standardNormal: tabletTextTheme,
  ///   standardLarge: desktopTextTheme,
  ///   jumboNormal: largeDesktopTextTheme,
  ///   jumboExtraLarge: ultraWideTextTheme,
  /// );
  /// ```
  ///
  /// Throws [AssertionError] if all size parameters are null.
  BreakpointsHandlerGranular({
    super.breakpoints = BreakpointsGranular.defaultBreakpoints,
    super.onChanged,
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
          'BreakpointsHandlerGranular requires at least one of the size arguments to be filled out',
        );

  /// Value to return for jumbo extra large displays.
  ///
  /// Used for 8K displays, ultra-wide monitors, and specialized high-resolution
  /// setups (typically 4096px+ wide). Supports the most complex multi-panel
  /// layouts with abundant screen real estate.
  final T? jumboExtraLarge;

  /// Value to return for jumbo large displays.
  ///
  /// Used for 4K displays and large ultra-wide monitors (typically 3841-4096px wide).
  /// Ideal for professional applications requiring multiple simultaneous content
  /// areas and detailed visual information.
  final T? jumboLarge;

  /// Value to return for jumbo normal displays.
  ///
  /// Used for QHD ultra-wide displays (typically 2561-3840px wide). Popular
  /// among developers and designers, supports side-by-side application layouts
  /// with room for detailed toolbars and panels.
  final T? jumboNormal;

  /// Value to return for jumbo small displays.
  ///
  /// Used for standard ultra-wide monitors (typically 1921-2560px wide).
  /// Common in business and gaming environments, offers expanded horizontal
  /// space for enhanced desktop productivity layouts.
  final T? jumboSmall;

  /// Value to return for standard extra large displays.
  ///
  /// Used for large laptops and desktop monitors (typically 1281-1920px wide).
  /// Represents the upper range of standard computer displays, supports
  /// traditional desktop interfaces with full sidebars and toolbars.
  final T? standardExtraLarge;

  /// Value to return for standard large displays.
  ///
  /// Used for standard laptops and smaller monitors (typically 1025-1280px wide).
  /// Common in business laptops and portable workstations, requires efficient
  /// use of space with collapsible UI elements.
  final T? standardLarge;

  /// Value to return for standard normal displays.
  ///
  /// Used for small laptops and large tablets (typically 769-1024px wide).
  /// Represents the transition zone between desktop and tablet interfaces,
  /// often requires adaptive navigation patterns.
  final T? standardNormal;

  /// Value to return for standard small displays.
  ///
  /// Used for tablets in landscape orientation (typically 569-768px wide).
  /// Optimized for touch interaction while providing moderate screen real estate,
  /// requires touch-friendly controls and simplified navigation.
  final T? standardSmall;

  /// Value to return for compact extra large displays.
  ///
  /// Used for large phones and small tablets in portrait (typically 481-568px wide).
  /// Represents the upper range of mobile devices, supports enhanced mobile
  /// layouts with some multi-column content possibilities.
  final T? compactExtraLarge;

  /// Value to return for compact large displays.
  ///
  /// Used for standard modern smartphones (typically 431-480px wide). The most
  /// common category for contemporary mobile devices, optimized for one-handed
  /// use with thumb-friendly navigation and single-column layouts.
  final T? compactLarge;

  /// Value to return for compact normal displays.
  ///
  /// Used for compact phones and older flagship devices (typically 361-430px wide).
  /// Requires careful content prioritization and efficient use of limited
  /// screen space while maintaining usability.
  final T? compactNormal;

  /// Value to return for compact small displays.
  ///
  /// Used for small phones and budget devices (typically 301-360px wide).
  /// Common in entry-level smartphones, requires minimal layouts with
  /// essential functionality prioritized and careful content hierarchy.
  final T? compactSmall;

  /// Value to return for tiny displays.
  ///
  /// Used for minimal displays and specialized devices (typically 300px and below).
  /// Includes smartwatches, IoT displays, and very old mobile devices. Requires
  /// extremely simplified interfaces with only critical functionality exposed.
  final T? tiny;

  /// Map of granular layout size categories to their corresponding values.
  ///
  /// This implementation maps each [LayoutSizeGranular] enum value to its
  /// corresponding field value, enabling the base class resolution logic to
  /// function properly across all thirteen breakpoint categories.
  ///
  /// The returned map includes all granular layout size categories organized
  /// by their logical groups (jumbo, standard, compact, tiny), preserving
  /// null values where no specific value was configured. This allows the
  /// sophisticated fallback logic to operate correctly across the full
  /// spectrum of device sizes.
  ///
  /// The map is used by [getScreenSizeValue] to resolve appropriate values
  /// based on granular screen size calculations, enabling precise responsive
  /// behavior across all supported breakpoint categories.
  @override
  Map<LayoutSizeGranular, T?> get values => {
        LayoutSizeGranular.jumboExtraLarge: jumboExtraLarge,
        LayoutSizeGranular.jumboLarge: jumboLarge,
        LayoutSizeGranular.jumboNormal: jumboNormal,
        LayoutSizeGranular.jumboSmall: jumboSmall,
        LayoutSizeGranular.standardExtraLarge: standardExtraLarge,
        LayoutSizeGranular.standardLarge: standardLarge,
        LayoutSizeGranular.standardNormal: standardNormal,
        LayoutSizeGranular.standardSmall: standardSmall,
        LayoutSizeGranular.compactExtraLarge: compactExtraLarge,
        LayoutSizeGranular.compactLarge: compactLarge,
        LayoutSizeGranular.compactNormal: compactNormal,
        LayoutSizeGranular.compactSmall: compactSmall,
        LayoutSizeGranular.tiny: tiny,
      };
}
