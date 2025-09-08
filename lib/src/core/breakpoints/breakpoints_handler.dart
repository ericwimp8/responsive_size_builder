import 'package:responsive_size_builder/responsive_size_builder.dart';

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
