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
