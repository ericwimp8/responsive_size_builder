import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Abstract base class for responsive values that change based on screen size breakpoints.
///
/// This class extends [BaseBreakpointsHandler] to inherit sophisticated fallback
/// logic and caching behavior. It enables responsive values that automatically
/// change based on the current screen size breakpoint.
///
/// The provider must have at least one non-null value. If all values are null,
/// [getScreenSizeValue] will throw a [StateError] when called.
///
/// This base class allows for custom enum types and breakpoint configurations,
/// providing maximum flexibility for advanced use cases.
///
/// For standard use cases, prefer using [ResponsiveValue] or [ResponsiveValueGranular]
/// which provide type-safe named parameters for common breakpoint configurations.
///
/// Example of custom implementation:
/// ```dart
/// class CustomResponsiveValue<V> extends BaseResponsiveValue<CustomEnum, V> {
///   CustomResponsiveValue({
///     required CustomBreakpoints breakpoints,
///     required Map<CustomEnum, V?> values,
///   }) : super(breakpoints: breakpoints, values: values);
/// }
/// ```
abstract class BaseResponsiveValue<T extends Enum, V extends Object?>
    extends BaseBreakpointsHandler<V, T> {
  /// Creates a [BaseResponsiveValue] with the specified breakpoints and values.
  ///
  /// The [breakpoints] parameter must match the type used by the [ScreenSize] widget.
  /// The [values] map should contain entries for each breakpoint category, though
  /// null values are permitted to enable fallback behavior.
  ///
  /// At least one non-null value must be provided.
  BaseResponsiveValue({
    required super.breakpoints,
    required Map<T, V?> values,
  }) : _values = values;

  final Map<T, V?> _values;

  @override
  Map<T, V?> get values => _values;
}

/// Standard responsive value implementation for five-category breakpoints.
///
/// This class provides a concrete implementation of [BaseResponsiveValue] that
/// works with the standard [LayoutSize] enum and [Breakpoints] configuration.
/// It offers a balanced approach to responsive values, suitable for most
/// applications that need values to adapt across desktop, tablet, and mobile devices.
///
/// ## Size Categories
///
/// The implementation supports five breakpoint categories:
/// * `extraLarge` - Large desktop monitors and wide-screen displays (1200px+)
/// * `large` - Standard desktop and laptop screens (951-1200px)
/// * `medium` - Tablets and smaller laptops (601-950px)
/// * `small` - Mobile phones and tablets in portrait (201-600px)
/// * `extraSmall` - Very small screens and legacy devices (≤200px)
///
/// ## Value Assignment Strategy
///
/// At least one size category must have a non-null value to ensure
/// fallback resolution can always find a suitable result.
///
/// Common assignment patterns:
/// * **Mobile-first**: Define small and medium, let others fall back
/// * **Desktop-centric**: Define large and extraLarge, with mobile fallbacks
/// * **Comprehensive**: Define values for all relevant size categories
///
/// ## Usage Examples
///
/// ### Column Count
/// ```dart
/// final columnProvider = ResponsiveValue<int>(
///   extraLarge: 4,
///   large: 3,
///   medium: 2,
///   small: 1,
///   extraSmall: 1,
/// );
/// ```
///
/// ### Spacing Values
/// ```dart
/// final spacingProvider = ResponsiveValue<double>(
///   small: 8.0,
///   medium: 16.0,
///   large: 24.0,
///   extraLarge: 32.0,
/// );
/// ```
///
/// ### Complex Configuration Objects
/// ```dart
/// final configProvider = ResponsiveValue<LayoutConfig>(
///   small: LayoutConfig(columns: 1, spacing: 8),
///   medium: LayoutConfig(columns: 2, spacing: 16),
///   large: LayoutConfig(columns: 3, spacing: 24),
/// );
/// ```
///
/// ## Fallback Behavior
///
/// When a specific size category has a null value, the fallback logic
/// searches for suitable alternatives:
/// 1. Look for values in smaller size categories
/// 2. Use the last available non-null value as a final fallback
///
/// See also:
///
/// * [BaseResponsiveValue], the abstract base class
/// * [ResponsiveValueGranular], for more fine-grained breakpoint control
/// * [LayoutSize], the enum defining the five size categories
/// * [Breakpoints], the configuration class for threshold values
class ResponsiveValue<V extends Object?>
    extends BaseResponsiveValue<LayoutSize, V> {
  /// Creates a [ResponsiveValue] with values for standard breakpoint categories.
  ///
  /// At least one size parameter must be non-null to ensure the value provider
  /// can always resolve to a value. The [breakpoints] parameter defines the pixel
  /// thresholds for each size category.
  ///
  /// Parameters:
  /// * `extraLarge` - Value for large desktop monitors and wide-screen displays
  /// * `large` - Value for standard desktop and laptop screens
  /// * `medium` - Value for tablets and smaller laptops
  /// * `small` - Value for mobile phones and tablets in portrait
  /// * `extraSmall` - Value for very small screens and legacy devices
  /// * `breakpoints` - Pixel thresholds for size categories (defaults to [Breakpoints.defaultBreakpoints])
  ///
  /// Example:
  /// ```dart
  /// ResponsiveValue<int>(
  ///   extraLarge: 4,
  ///   large: 3,
  ///   medium: 2,
  ///   small: 1,
  ///   extraSmall: 1,
  /// )
  /// ```
  ResponsiveValue({
    Breakpoints breakpoints = Breakpoints.defaultBreakpoints,
    V? extraLarge,
    V? large,
    V? medium,
    V? small,
    V? extraSmall,
  })  : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'ResponsiveValue requires at least one of the size arguments to be filled out',
        ),
        super(
          breakpoints: breakpoints,
          values: {
            LayoutSize.extraLarge: extraLarge,
            LayoutSize.large: large,
            LayoutSize.medium: medium,
            LayoutSize.small: small,
            LayoutSize.extraSmall: extraSmall,
          },
        );
}

/// Granular responsive value implementation for thirteen-category breakpoints.
///
/// This class provides a comprehensive implementation of [BaseResponsiveValue]
/// that works with the granular [LayoutSizeGranular] enum and [BreakpointsGranular]
/// configuration. It offers fine-grained control over responsive values,
/// enabling precise value adaptation across the full spectrum of device sizes.
///
/// ## Category Groups
///
/// The implementation organizes breakpoints into four logical groups:
///
/// ### Jumbo Displays (Ultra-wide and High-Resolution)
/// * `jumboExtraLarge` - 8K displays, ultra-wide monitors (4096px+)
/// * `jumboLarge` - 4K displays, large ultra-wide monitors (3841-4096px)
/// * `jumboNormal` - QHD ultra-wide displays (2561-3840px)
/// * `jumboSmall` - Standard ultra-wide monitors (1921-2560px)
///
/// ### Standard Displays (Desktop and Laptop)
/// * `standardExtraLarge` - Large laptops, desktop monitors (1281-1920px)
/// * `standardLarge` - Standard laptops (1025-1280px)
/// * `standardNormal` - Small laptops, large tablets (769-1024px)
/// * `standardSmall` - Tablets in landscape (569-768px)
///
/// ### Compact Displays (Mobile and Small Tablets)
/// * `compactExtraLarge` - Large phones, small tablets portrait (481-568px)
/// * `compactLarge` - Standard modern smartphones (431-480px)
/// * `compactNormal` - Compact phones, older flagships (361-430px)
/// * `compactSmall` - Small phones, older devices (301-360px)
///
/// ### Tiny Displays (Minimal and Specialized)
/// * `tiny` - Smartwatches, very old devices (300px and below)
///
/// ## Use Cases
///
/// This granular system excels in scenarios requiring:
/// * **Enterprise Applications**: Supporting diverse hardware environments
/// * **Design Systems**: Requiring precise responsive behavior specifications
/// * **Content Management**: Needing optimal layouts across all device types
/// * **Multi-Platform Apps**: Targeting everything from smartwatches to ultra-wide monitors
///
/// ## Usage Examples
///
/// ### Column Layout Adaptation
/// ```dart
/// final columnProvider = ResponsiveValueGranular<int>(
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
/// ### Group-based Assignment
/// ```dart
/// final layoutProvider = ResponsiveValueGranular<String>(
///   compactLarge: "mobile",      // All compact sizes fall back to this
///   standardLarge: "desktop",    // All standard sizes fall back to this
///   jumboSmall: "ultra-wide",    // All jumbo sizes fall back to this
/// );
/// ```
///
/// ## Fallback Resolution
///
/// When a specific size category has a null value, the fallback logic:
/// 1. Searches through smaller size categories in the same group
/// 2. Searches through smaller groups if needed
/// 3. Uses the last available non-null value as final fallback
///
/// See also:
///
/// * [BaseResponsiveValue], the abstract base class
/// * [ResponsiveValue], for simpler five-category breakpoints
/// * [LayoutSizeGranular], the enum defining the thirteen size categories
/// * [BreakpointsGranular], the configuration class for granular thresholds
class ResponsiveValueGranular<V extends Object?>
    extends BaseResponsiveValue<LayoutSizeGranular, V> {
  /// Creates a [ResponsiveValueGranular] with values for granular breakpoint categories.
  ///
  /// At least one size parameter must be non-null to ensure the value provider
  /// can always resolve to a value. The [breakpoints] parameter defines the pixel
  /// thresholds for each granular size category.
  ///
  /// Parameters:
  ///
  /// **Jumbo Display Values (Ultra-wide and High-Resolution):**
  /// * `jumboExtraLarge` - Value for 8K displays and ultra-wide monitors
  /// * `jumboLarge` - Value for 4K displays and large ultra-wide monitors
  /// * `jumboNormal` - Value for QHD ultra-wide displays
  /// * `jumboSmall` - Value for standard ultra-wide monitors
  ///
  /// **Standard Display Values (Desktop and Laptop):**
  /// * `standardExtraLarge` - Value for large laptops and desktop monitors
  /// * `standardLarge` - Value for standard laptops
  /// * `standardNormal` - Value for small laptops and large tablets
  /// * `standardSmall` - Value for tablets in landscape orientation
  ///
  /// **Compact Display Values (Mobile and Small Tablets):**
  /// * `compactExtraLarge` - Value for large phones and small tablets in portrait
  /// * `compactLarge` - Value for standard modern smartphones
  /// * `compactNormal` - Value for compact phones and older flagships
  /// * `compactSmall` - Value for small phones and older devices
  ///
  /// **Tiny Display Values (Minimal and Specialized):**
  /// * `tiny` - Value for smartwatches and very old devices
  ///
  /// **Configuration:**
  /// * `breakpoints` - Granular pixel thresholds (defaults to [BreakpointsGranular.defaultBreakpoints])
  ResponsiveValueGranular({
    BreakpointsGranular breakpoints = BreakpointsGranular.defaultBreakpoints,
    V? jumboExtraLarge,
    V? jumboLarge,
    V? jumboNormal,
    V? jumboSmall,
    V? standardExtraLarge,
    V? standardLarge,
    V? standardNormal,
    V? standardSmall,
    V? compactExtraLarge,
    V? compactLarge,
    V? compactNormal,
    V? compactSmall,
    V? tiny,
  })  : assert(
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
          'ResponsiveValueGranular requires at least one of the size arguments to be filled out',
        ),
        super(
          breakpoints: breakpoints,
          values: {
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
          },
        );
}
