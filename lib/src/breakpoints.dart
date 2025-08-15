import 'package:flutter/foundation.dart';

/// Abstract base class that defines the contract for responsive layout breakpoints.
///
/// Breakpoints are threshold values used to determine appropriate layouts for
/// different screen sizes in responsive design. This class provides a common
/// interface for all breakpoint implementations within the responsive_size_builder
/// package.
///
/// The generic type parameter [T] must extend [Enum] and represents the layout
/// size categories that this breakpoint system supports.
///
/// ## Implementation Requirements
///
/// Implementations must provide a [values] map that associates each layout size
/// category with its corresponding breakpoint threshold in logical pixels.
/// Typically, breakpoint values should be arranged in descending order, with
/// larger screen sizes having higher threshold values.
///
/// ## Usage Example
///
/// ```dart
/// class CustomBreakpoints extends BaseBreakpoints<LayoutSize> {
///   const CustomBreakpoints({
///     this.desktop = 1200.0,
///     this.tablet = 768.0,
///     this.mobile = 480.0,
///   });
///
///   final double desktop;
///   final double tablet;
///   final double mobile;
///
///   @override
///   Map<LayoutSize, double> get values => {
///     LayoutSize.extraLarge: desktop,
///     LayoutSize.large: desktop,
///     LayoutSize.medium: tablet,
///     LayoutSize.small: mobile,
///     LayoutSize.extraSmall: -1, // Catch-all for smallest sizes
///   };
/// }
/// ```
///
/// See also:
///
/// * [Breakpoints], the standard implementation with 5 size categories
/// * [BreakpointsGranular], the granular implementation with 13 size categories
/// * [LayoutSize], the enum for standard layout size categories
/// * [LayoutSizeGranular], the enum for granular layout size categories
abstract class BaseBreakpoints<T extends Enum> {
  /// Creates a new [BaseBreakpoints] instance.
  const BaseBreakpoints();

  /// Map of layout size categories to their corresponding breakpoint thresholds.
  ///
  /// Each key represents a layout size category from the enum type [T], and each
  /// value represents the minimum screen width in logical pixels required to
  /// trigger that layout size.
  ///
  /// The returned map should include all possible values of the enum [T], even
  /// if some are assigned special values like -1 to indicate catch-all categories.
  Map<T, double> get values;
}

/// Standard breakpoint configuration for responsive layouts with five size categories.
///
/// This class provides a practical implementation of [BaseBreakpoints] that
/// divides screen sizes into five distinct categories, suitable for most
/// responsive design scenarios. The breakpoints follow common web design
/// conventions and provide good coverage for typical device sizes.
///
/// ## Size Categories
///
/// The breakpoints define the following size ranges:
///
/// * **extraLarge**: Screens wider than 1200px (large desktops, wide monitors)
/// * **large**: Screens 951-1200px wide (standard desktops, laptops)
/// * **medium**: Screens 601-950px wide (tablets, small laptops)
/// * **small**: Screens 201-600px wide (mobile phones, small tablets)
/// * **extraSmall**: Screens 200px and below (handled with -1 threshold)
///
/// ## Default Values
///
/// The default breakpoints are designed to work well across a wide range of
/// devices and follow responsive design best practices:
///
/// * extraLarge: 1200px
/// * large: 950px
/// * medium: 600px
/// * small: 200px
///
/// ## Customization
///
/// Custom breakpoint values can be specified during construction to match
/// specific design requirements:
///
/// ```dart
/// // Custom breakpoints for a content-heavy application
/// final customBreakpoints = Breakpoints(
///   extraLarge: 1400,
///   large: 1024,
///   medium: 768,
///   small: 480,
/// );
/// ```
///
/// ## Validation
///
/// All breakpoint values must be in descending order and non-negative.
/// An [AssertionError] will be thrown during construction if this constraint
/// is violated.
///
/// See also:
///
/// * [BaseBreakpoints], the abstract base class
/// * [BreakpointsGranular], for more fine-grained size control
/// * [LayoutSize], the enum defining the five size categories
@immutable
class Breakpoints implements BaseBreakpoints<LayoutSize> {
  /// Creates a new [Breakpoints] instance with the specified threshold values.
  ///
  /// All parameters represent minimum screen widths in logical pixels for their
  /// respective size categories. The [extraLarge] parameter sets the threshold
  /// for the largest size category, while [small] sets the threshold for the
  /// smallest non-extraSmall category.
  ///
  /// ## Parameters
  ///
  /// * [extraLarge]: Minimum width for extra large screens (default: 1200px)
  /// * [large]: Minimum width for large screens (default: 950px)
  /// * [medium]: Minimum width for medium screens (default: 600px)
  /// * [small]: Minimum width for small screens (default: 200px)
  ///
  /// ## Validation
  ///
  /// Throws [AssertionError] if breakpoints are not in descending order or if
  /// any value is negative.
  const Breakpoints({
    this.extraLarge = 1200.0,
    this.large = 950.0,
    this.medium = 600.0,
    this.small = 200.0,
  }) : assert(
          extraLarge > large && large > medium && medium > small && small >= 0,
          'Breakpoints must be in decending order and larger than or equal to 0.',
        );

  /// Minimum screen width in logical pixels for extra large layout category.
  ///
  /// Screens at or above this width will be classified as [LayoutSize.extraLarge].
  /// Typically used for large desktop monitors and wide-screen displays.
  final double extraLarge;

  /// Minimum screen width in logical pixels for large layout category.
  ///
  /// Screens at or above this width but below [extraLarge] will be classified
  /// as [LayoutSize.large]. Typically used for standard desktop and laptop screens.
  final double large;

  /// Minimum screen width in logical pixels for medium layout category.
  ///
  /// Screens at or above this width but below [large] will be classified
  /// as [LayoutSize.medium]. Typically used for tablets and small laptops.
  final double medium;

  /// Minimum screen width in logical pixels for small layout category.
  ///
  /// Screens at or above this width but below [medium] will be classified
  /// as [LayoutSize.small]. Typically used for mobile phones and small tablets.
  final double small;

  /// Default breakpoint configuration optimized for common device sizes.
  ///
  /// Provides a sensible set of breakpoints that work well across a wide range
  /// of devices and screen sizes. These values follow responsive design best
  /// practices and are suitable for most applications.
  static const defaultBreakpoints = Breakpoints();

  /// Map of layout size categories to their corresponding breakpoint thresholds.
  ///
  /// The [LayoutSize.extraSmall] category uses -1 as a special value to indicate
  /// it serves as a catch-all for screens smaller than the [small] threshold.
  @override
  Map<LayoutSize, double> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: -1,
      };

  /// Returns a string representation of this breakpoints configuration.
  ///
  /// Includes all four primary breakpoint values in a readable format.
  @override
  String toString() {
    return 'Breakpoints(extraLarge: $extraLarge, large: $large, medium: $medium, small: $small)';
  }

  /// Whether this breakpoints configuration is equal to [other].
  ///
  /// Two [Breakpoints] instances are considered equal if all their threshold
  /// values match exactly.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Breakpoints &&
        other.extraLarge == extraLarge &&
        other.large == large &&
        other.medium == medium &&
        other.small == small;
  }

  /// Hash code for this breakpoints configuration.
  ///
  /// Computed from all four breakpoint threshold values.
  @override
  int get hashCode => Object.hash(extraLarge, large, medium, small);

  /// Creates a copy of this breakpoints configuration with the specified changes.
  ///
  /// Returns a new [Breakpoints] instance with the same values as this one,
  /// except for any parameters that are explicitly provided. This method is
  /// useful for creating variations of existing breakpoint configurations.
  ///
  /// ## Parameters
  ///
  /// * [extraLarge]: New threshold for extra large screens, or null to keep current
  /// * [large]: New threshold for large screens, or null to keep current
  /// * [medium]: New threshold for medium screens, or null to keep current
  /// * [small]: New threshold for small screens, or null to keep current
  ///
  /// ## Example
  ///
  /// ```dart
  /// final baseBreakpoints = Breakpoints();
  /// final customBreakpoints = baseBreakpoints.copyWith(
  ///   large: 1024,
  ///   medium: 768,
  /// );
  /// ```
  Breakpoints copyWith({
    double? extraLarge,
    double? large,
    double? medium,
    double? small,
  }) {
    return Breakpoints(
      extraLarge: extraLarge ?? this.extraLarge,
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
    );
  }
}

/// Granular breakpoint configuration for responsive layouts with thirteen size categories.
///
/// This class provides an advanced implementation of [BaseBreakpoints] that
/// divides screen sizes into thirteen distinct categories, organized into four
/// logical groups. This granular approach enables precise layout control across
/// the full spectrum of device sizes, from ultra-wide monitors to smartwatches.
///
/// ## Size Groups and Categories
///
/// The breakpoints are organized into four groups with multiple sub-categories:
///
/// ### Jumbo Sizes (Ultra-wide and High-Resolution Displays)
/// * **jumboExtraLarge**: 4096px+ (8K displays, ultra-wide monitors)
/// * **jumboLarge**: 3841-4096px (4K displays, large ultra-wide monitors)
/// * **jumboNormal**: 2561-3840px (QHD ultra-wide, large 4K displays)
/// * **jumboSmall**: 1921-2560px (Standard ultra-wide, large desktop monitors)
///
/// ### Standard Sizes (Desktop and Laptop Displays)
/// * **standardExtraLarge**: 1281-1920px (Large laptops, standard monitors)
/// * **standardLarge**: 1025-1280px (Standard laptops, small monitors)
/// * **standardNormal**: 769-1024px (Small laptops, large tablets)
/// * **standardSmall**: 569-768px (Tablets in landscape, small laptops)
///
/// ### Compact Sizes (Mobile and Small Tablet Displays)
/// * **compactExtraLarge**: 481-568px (Large phones, small tablets portrait)
/// * **compactLarge**: 431-480px (Standard modern phones)
/// * **compactNormal**: 361-430px (Compact phones, older flagships)
/// * **compactSmall**: 301-360px (Small phones, older devices)
///
/// ### Tiny Sizes (Minimal and Specialized Displays)
/// * **tiny**: 300px and below (smartwatches, very old devices)
///
/// ## Use Cases
///
/// This granular system is ideal for:
/// * Applications with complex UI requirements across device types
/// * Content-heavy applications needing precise layout control
/// * Enterprise applications supporting diverse hardware environments
/// * Design systems requiring fine-grained responsive behavior
///
/// ## Custom Configuration
///
/// ```dart
/// // Configuration optimized for a content management system
/// final cmsBreakpoints = BreakpointsGranular(
///   jumboExtraLarge: 5120,  // Support for 5K displays
///   standardNormal: 800,    // Adjust tablet breakpoint
///   compactLarge: 414,      // iPhone Pro Max width
/// );
/// ```
///
/// ## Validation
///
/// All breakpoint values must be in strictly descending order with no gaps.
/// An [AssertionError] will be thrown if this constraint is violated.
///
/// See also:
///
/// * [BaseBreakpoints], the abstract base class
/// * [Breakpoints], for simpler five-category breakpoints
/// * [LayoutSizeGranular], the enum defining the thirteen size categories
@immutable
class BreakpointsGranular implements BaseBreakpoints<LayoutSizeGranular> {
  /// Creates a new [BreakpointsGranular] instance with the specified threshold values.
  ///
  /// All parameters represent minimum screen widths in logical pixels for their
  /// respective size categories. The values must be provided in descending order
  /// to ensure proper size categorization.
  ///
  /// ## Parameter Groups
  ///
  /// **Jumbo Display Thresholds:**
  /// * [jumboExtraLarge]: Ultra-wide and 8K displays (default: 4096px)
  /// * [jumboLarge]: 4K displays and large ultra-wide (default: 3840px)
  /// * [jumboNormal]: QHD ultra-wide displays (default: 2560px)
  /// * [jumboSmall]: Standard ultra-wide monitors (default: 1920px)
  ///
  /// **Standard Display Thresholds:**
  /// * [standardExtraLarge]: Large laptops and monitors (default: 1280px)
  /// * [standardLarge]: Standard laptops (default: 1024px)
  /// * [standardNormal]: Small laptops and large tablets (default: 768px)
  /// * [standardSmall]: Tablets and small laptops (default: 568px)
  ///
  /// **Compact Display Thresholds:**
  /// * [compactExtraLarge]: Large phones and small tablets (default: 480px)
  /// * [compactLarge]: Standard modern phones (default: 430px)
  /// * [compactNormal]: Compact phones (default: 360px)
  /// * [compactSmall]: Small phones (default: 300px)
  ///
  /// ## Validation
  ///
  /// Throws [AssertionError] if any breakpoint value is greater than or equal
  /// to the previous (larger) category, or if the smallest value is negative.
  const BreakpointsGranular({
    this.jumboExtraLarge = 4096.0,
    this.jumboLarge = 3840.0,
    this.jumboNormal = 2560.0,
    this.jumboSmall = 1920.0,
    this.standardExtraLarge = 1280.0,
    this.standardLarge = 1024.0,
    this.standardNormal = 768.0,
    this.standardSmall = 568.0,
    this.compactExtraLarge = 480.0,
    this.compactLarge = 430.0,
    this.compactNormal = 360.0,
    this.compactSmall = 300.0,
  }) : assert(
          jumboExtraLarge > jumboLarge &&
              jumboLarge > jumboNormal &&
              jumboNormal > jumboSmall &&
              jumboSmall > standardExtraLarge &&
              standardExtraLarge > standardLarge &&
              standardLarge > standardNormal &&
              standardNormal > standardSmall &&
              standardSmall > compactExtraLarge &&
              compactExtraLarge > compactLarge &&
              compactLarge > compactNormal &&
              compactNormal > compactSmall &&
              compactSmall >= 0,
          'Breakpoints must be in decending order and larger than or equal to 0',
        );

  /// Minimum width threshold for jumbo extra large displays.
  ///
  /// Screens at or above this width are classified as [LayoutSizeGranular.jumboExtraLarge].
  /// Typically used for 8K displays, ultra-wide monitors, and specialized high-resolution setups.
  final double jumboExtraLarge;

  /// Minimum width threshold for jumbo large displays.
  ///
  /// Screens at or above this width but below [jumboExtraLarge] are classified as
  /// [LayoutSizeGranular.jumboLarge]. Typically used for 4K displays and large ultra-wide monitors.
  final double jumboLarge;

  /// Minimum width threshold for jumbo normal displays.
  ///
  /// Screens at or above this width but below [jumboLarge] are classified as
  /// [LayoutSizeGranular.jumboNormal]. Typically used for QHD ultra-wide displays.
  final double jumboNormal;

  /// Minimum width threshold for jumbo small displays.
  ///
  /// Screens at or above this width but below [jumboNormal] are classified as
  /// [LayoutSizeGranular.jumboSmall]. Typically used for standard ultra-wide monitors.
  final double jumboSmall;

  /// Minimum width threshold for standard extra large displays.
  ///
  /// Screens at or above this width but below [jumboSmall] are classified as
  /// [LayoutSizeGranular.standardExtraLarge]. Typically used for large laptops and monitors.
  final double standardExtraLarge;

  /// Minimum width threshold for standard large displays.
  ///
  /// Screens at or above this width but below [standardExtraLarge] are classified as
  /// [LayoutSizeGranular.standardLarge]. Typically used for standard laptops.
  final double standardLarge;

  /// Minimum width threshold for standard normal displays.
  ///
  /// Screens at or above this width but below [standardLarge] are classified as
  /// [LayoutSizeGranular.standardNormal]. Typically used for small laptops and large tablets.
  final double standardNormal;

  /// Minimum width threshold for standard small displays.
  ///
  /// Screens at or above this width but below [standardNormal] are classified as
  /// [LayoutSizeGranular.standardSmall]. Typically used for tablets in landscape orientation.
  final double standardSmall;

  /// Minimum width threshold for compact extra large displays.
  ///
  /// Screens at or above this width but below [standardSmall] are classified as
  /// [LayoutSizeGranular.compactExtraLarge]. Typically used for large phones and small tablets in portrait.
  final double compactExtraLarge;

  /// Minimum width threshold for compact large displays.
  ///
  /// Screens at or above this width but below [compactExtraLarge] are classified as
  /// [LayoutSizeGranular.compactLarge]. Typically used for standard modern smartphones.
  final double compactLarge;

  /// Minimum width threshold for compact normal displays.
  ///
  /// Screens at or above this width but below [compactLarge] are classified as
  /// [LayoutSizeGranular.compactNormal]. Typically used for compact phones and older flagships.
  final double compactNormal;

  /// Minimum width threshold for compact small displays.
  ///
  /// Screens at or above this width but below [compactNormal] are classified as
  /// [LayoutSizeGranular.compactSmall]. Typically used for small phones and older devices.
  final double compactSmall;

  /// Default granular breakpoint configuration covering the full device spectrum.
  ///
  /// Provides comprehensive breakpoints optimized for modern device ecosystem,
  /// from ultra-wide monitors to smartwatches. These values are based on common
  /// device resolutions and responsive design best practices.
  static const defaultBreakpoints = BreakpointsGranular();

  /// Map of granular layout size categories to their corresponding breakpoint thresholds.
  ///
  /// The [LayoutSizeGranular.tiny] category uses -1 as a special value to indicate
  /// it serves as a catch-all for screens smaller than the [compactSmall] threshold.
  @override
  Map<LayoutSizeGranular, double> get values => {
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
        LayoutSizeGranular.tiny: -1,
      };

  /// Creates a copy of this granular breakpoints configuration with the specified changes.
  ///
  /// Returns a new [BreakpointsGranular] instance with the same values as this one,
  /// except for any parameters that are explicitly provided. This method enables
  /// easy customization of specific breakpoint categories while preserving others.
  ///
  /// ## Parameter Categories
  ///
  /// **Jumbo Display Adjustments:**
  /// * [jumboExtraLarge]: New threshold for ultra-wide displays
  /// * [jumboLarge]: New threshold for 4K displays
  /// * [jumboNormal]: New threshold for QHD ultra-wide
  /// * [jumboSmall]: New threshold for standard ultra-wide
  ///
  /// **Standard Display Adjustments:**
  /// * [standardExtraLarge]: New threshold for large laptops
  /// * [standardLarge]: New threshold for standard laptops
  /// * [standardNormal]: New threshold for small laptops
  /// * [standardSmall]: New threshold for tablets
  ///
  /// **Compact Display Adjustments:**
  /// * [compactExtraLarge]: New threshold for large phones
  /// * [compactLarge]: New threshold for standard phones
  /// * [compactNormal]: New threshold for compact phones
  /// * [compactSmall]: New threshold for small phones
  ///
  /// ## Example
  ///
  /// ```dart
  /// final baseBreakpoints = BreakpointsGranular();
  /// final customBreakpoints = baseBreakpoints.copyWith(
  ///   standardLarge: 1200,    // Adjust laptop threshold
  ///   compactLarge: 414,      // Match iPhone Pro Max
  /// );
  /// ```
  BreakpointsGranular copyWith({
    double? jumboExtraLarge,
    double? jumboLarge,
    double? jumboNormal,
    double? jumboSmall,
    double? standardExtraLarge,
    double? standardLarge,
    double? standardNormal,
    double? standardSmall,
    double? compactExtraLarge,
    double? compactLarge,
    double? compactNormal,
    double? compactSmall,
  }) {
    return BreakpointsGranular(
      jumboExtraLarge: jumboExtraLarge ?? this.jumboExtraLarge,
      jumboLarge: jumboLarge ?? this.jumboLarge,
      jumboNormal: jumboNormal ?? this.jumboNormal,
      jumboSmall: jumboSmall ?? this.jumboSmall,
      standardExtraLarge: standardExtraLarge ?? this.standardExtraLarge,
      standardLarge: standardLarge ?? this.standardLarge,
      standardNormal: standardNormal ?? this.standardNormal,
      standardSmall: standardSmall ?? this.standardSmall,
      compactExtraLarge: compactExtraLarge ?? this.compactExtraLarge,
      compactLarge: compactLarge ?? this.compactLarge,
      compactNormal: compactNormal ?? this.compactNormal,
      compactSmall: compactSmall ?? this.compactSmall,
    );
  }

  /// Returns a string representation of this granular breakpoints configuration.
  ///
  /// Includes all twelve primary breakpoint values organized by category group.
  @override
  String toString() {
    return 'BreakpointsGranular(jumboExtraLarge: $jumboExtraLarge, jumboLarge: $jumboLarge, jumboNormal: $jumboNormal, jumboSmall: $jumboSmall, standardExtraLarge: $standardExtraLarge, standardLarge: $standardLarge, standardNormal: $standardNormal, standardSmall: $standardSmall, compactExtraLarge: $compactExtraLarge, compactLarge: $compactLarge, compactNormal: $compactNormal, compactSmall: $compactSmall)';
  }

  /// Whether this granular breakpoints configuration is equal to [other].
  ///
  /// Two [BreakpointsGranular] instances are considered equal if all their
  /// threshold values match exactly across all twelve breakpoint categories.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BreakpointsGranular &&
        other.jumboExtraLarge == jumboExtraLarge &&
        other.jumboLarge == jumboLarge &&
        other.jumboNormal == jumboNormal &&
        other.jumboSmall == jumboSmall &&
        other.standardExtraLarge == standardExtraLarge &&
        other.standardLarge == standardLarge &&
        other.standardNormal == standardNormal &&
        other.standardSmall == standardSmall &&
        other.compactExtraLarge == compactExtraLarge &&
        other.compactLarge == compactLarge &&
        other.compactNormal == compactNormal &&
        other.compactSmall == compactSmall;
  }

  /// Hash code for this granular breakpoints configuration.
  ///
  /// Computed from all twelve breakpoint threshold values across all categories.
  @override
  int get hashCode => Object.hash(
        jumboExtraLarge.hashCode,
        jumboLarge.hashCode,
        jumboNormal.hashCode,
        jumboSmall.hashCode,
        standardExtraLarge.hashCode,
        standardLarge.hashCode,
        standardNormal.hashCode,
        standardSmall.hashCode,
        compactExtraLarge.hashCode,
        compactLarge.hashCode,
        compactNormal.hashCode,
        compactSmall.hashCode,
      );
}

/// Enumeration of standard responsive layout size categories.
///
/// This enum defines five distinct size categories that represent common
/// breakpoints in responsive web and mobile design. Each category corresponds
/// to typical device classes and viewport ranges, providing a balanced approach
/// to responsive layout management.
///
/// ## Size Categories
///
/// The categories are designed to match common device types and usage patterns:
///
/// * [extraLarge]: Large desktop monitors and wide-screen displays
/// * [large]: Standard desktop and laptop screens
/// * [medium]: Tablets and smaller laptops in landscape orientation
/// * [small]: Mobile phones and tablets in portrait orientation
/// * [extraSmall]: Very small screens and legacy devices
///
/// ## Usage Context
///
/// These size categories are used in conjunction with [Breakpoints] to create
/// responsive layouts that adapt appropriately to different screen sizes. The
/// specific pixel thresholds are defined by the breakpoints configuration, while
/// this enum provides the semantic categories.
///
/// ## Design Rationale
///
/// The five-category system strikes a balance between simplicity and flexibility,
/// covering the most common responsive design scenarios without excessive complexity.
/// For applications requiring more granular control, consider using [LayoutSizeGranular].
///
/// ## Example Usage
///
/// ```dart
/// Widget buildLayout(LayoutSize size) {
///   switch (size) {
///     case LayoutSize.extraLarge:
///       return DesktopLayout();
///     case LayoutSize.large:
///       return DesktopLayout(compact: true);
///     case LayoutSize.medium:
///       return TabletLayout();
///     case LayoutSize.small:
///     case LayoutSize.extraSmall:
///       return MobileLayout();
///   }
/// }
/// ```
///
/// See also:
///
/// * [Breakpoints], which defines pixel thresholds for these categories
/// * [LayoutSizeGranular], for more fine-grained size control
/// * [BreakpointsGranular], which uses the granular size categories
enum LayoutSize {
  /// Layout category for large desktop monitors and wide-screen displays.
  ///
  /// Typically used for screens wider than 1200 pixels, including large desktop
  /// monitors, ultra-wide displays, and multi-monitor setups. This category
  /// accommodates the most spacious layouts with multiple columns and complex UI.
  extraLarge,

  /// Layout category for standard desktop and laptop screens.
  ///
  /// Typically used for screens between 951-1200 pixels wide, including standard
  /// desktop monitors, laptops, and smaller desktop displays. Suitable for
  /// traditional desktop layouts with sidebars and multiple content areas.
  large,

  /// Layout category for tablets and smaller laptops.
  ///
  /// Typically used for screens between 601-950 pixels wide, including tablets
  /// in landscape orientation, small laptops, and netbooks. Often requires
  /// simplified layouts with collapsible navigation.
  medium,

  /// Layout category for mobile phones and tablets in portrait.
  ///
  /// Typically used for screens between 201-600 pixels wide, including most
  /// smartphones, tablets in portrait orientation, and small devices. Requires
  /// single-column layouts and mobile-optimized navigation patterns.
  small,

  /// Layout category for very small screens and legacy devices.
  ///
  /// Typically used for screens 200 pixels wide and below, including very old
  /// mobile devices, smartwatches, and specialized displays. Requires minimal
  /// layouts with essential content only.
  extraSmall,
}

/// Enumeration of granular responsive layout size categories with thirteen distinct levels.
///
/// This enum provides a comprehensive classification system for screen sizes,
/// offering fine-grained control over responsive layouts across the full spectrum
/// of modern devices. The categories are organized into four logical groups that
/// represent different classes of displays and usage contexts.
///
/// ## Category Groups
///
/// ### Jumbo Group: Ultra-Wide and High-Resolution Displays
/// Designed for professional workstations, gaming setups, and specialized displays:
/// * [jumboExtraLarge]: 8K displays, ultra-wide monitors (4096px+)
/// * [jumboLarge]: 4K displays, large ultra-wide monitors (3841-4096px)
/// * [jumboNormal]: QHD ultra-wide displays (2561-3840px)
/// * [jumboSmall]: Standard ultra-wide monitors (1921-2560px)
///
/// ### Standard Group: Desktop and Laptop Displays
/// Covers traditional computer displays and larger tablets:
/// * [standardExtraLarge]: Large laptops, desktop monitors (1281-1920px)
/// * [standardLarge]: Standard laptops (1025-1280px)
/// * [standardNormal]: Small laptops, large tablets (769-1024px)
/// * [standardSmall]: Tablets in landscape (569-768px)
///
/// ### Compact Group: Mobile and Small Tablet Displays
/// Optimized for handheld devices and portrait orientations:
/// * [compactExtraLarge]: Large phones, small tablets portrait (481-568px)
/// * [compactLarge]: Standard modern smartphones (431-480px)
/// * [compactNormal]: Compact phones, older flagships (361-430px)
/// * [compactSmall]: Small phones, older devices (301-360px)
///
/// ### Tiny Group: Minimal and Specialized Displays
/// For extremely constrained display environments:
/// * [tiny]: Smartwatches, very old devices (300px and below)
///
/// ## Design Philosophy
///
/// This granular system acknowledges the diverse ecosystem of modern devices
/// and provides sufficient categories to handle edge cases while maintaining
/// logical groupings. Each group represents a distinct interaction paradigm:
///
/// * **Jumbo**: Multi-window, complex interfaces with abundant space
/// * **Standard**: Traditional desktop interfaces with sidebars and toolbars
/// * **Compact**: Touch-optimized interfaces with simplified navigation
/// * **Tiny**: Minimal interfaces with essential functionality only
///
/// ## Use Cases
///
/// This enum is particularly valuable for:
/// * Enterprise applications supporting diverse hardware environments
/// * Design systems requiring precise responsive behavior
/// * Applications with complex UI requirements across device types
/// * Content management systems with varied layout needs
///
/// ## Performance Considerations
///
/// While this system provides extensive flexibility, consider the maintenance
/// overhead of supporting thirteen different layout variations. For simpler
/// applications, [LayoutSize] may be more appropriate.
///
/// ## Example Usage
///
/// ```dart
/// Widget buildAdaptiveLayout(LayoutSizeGranular size) {
///   return switch (size) {
///     // Jumbo displays: Complex multi-panel layouts
///     LayoutSizeGranular.jumboExtraLarge ||
///     LayoutSizeGranular.jumboLarge => MultiPanelDesktopLayout(),
///     
///     // Standard displays: Traditional desktop layouts
///     LayoutSizeGranular.standardExtraLarge ||
///     LayoutSizeGranular.standardLarge => DesktopLayout(),
///     
///     // Compact displays: Mobile-optimized layouts
///     LayoutSizeGranular.compactLarge ||
///     LayoutSizeGranular.compactNormal => MobileLayout(),
///     
///     // Handle other cases...
///     _ => DefaultLayout(),
///   };
/// }
/// ```
///
/// See also:
///
/// * [BreakpointsGranular], which defines pixel thresholds for these categories
/// * [LayoutSize], for simpler five-category responsive design
/// * [Breakpoints], which uses the standard size categories
enum LayoutSizeGranular {
  /// Layout category for 8K displays and ultra-wide monitors.
  ///
  /// Represents the largest available display real estate, typically found in
  /// professional workstations, high-end gaming setups, and specialized display
  /// configurations. Supports the most complex multi-panel layouts.
  jumboExtraLarge,

  /// Layout category for 4K displays and large ultra-wide monitors.
  ///
  /// Common in professional environments, content creation setups, and premium
  /// desktop configurations. Ideal for applications requiring multiple simultaneous
  /// content areas and detailed visual information.
  jumboLarge,

  /// Layout category for QHD ultra-wide displays.
  ///
  /// Represents high-resolution wide-screen monitors popular among developers,
  /// designers, and power users. Supports side-by-side application layouts
  /// with room for detailed toolbars and panels.
  jumboNormal,

  /// Layout category for standard ultra-wide monitors.
  ///
  /// Common in business and gaming environments, these displays offer expanded
  /// horizontal space while maintaining standard vertical resolution. Suitable
  /// for enhanced desktop productivity layouts.
  jumboSmall,

  /// Layout category for large laptops and desktop monitors.
  ///
  /// Represents the upper range of standard computer displays, including 15-17"
  /// laptops and mid-range desktop monitors. Supports traditional desktop
  /// interfaces with full sidebars and toolbars.
  standardExtraLarge,

  /// Layout category for standard laptops and smaller monitors.
  ///
  /// Common in business laptops, portable workstations, and budget desktop
  /// setups. Requires efficient use of space with collapsible UI elements
  /// and streamlined layouts.
  standardLarge,

  /// Layout category for small laptops and large tablets.
  ///
  /// Represents the transition zone between desktop and tablet interfaces,
  /// including netbooks, ultrabooks, and large tablets in landscape mode.
  /// Often requires adaptive navigation patterns.
  standardNormal,

  /// Layout category for tablets in landscape orientation.
  ///
  /// Optimized for touch interaction while providing moderate screen real estate.
  /// Common in 10-12" tablets and hybrid devices. Requires touch-friendly
  /// controls and simplified navigation.
  standardSmall,

  /// Layout category for large phones and small tablets in portrait.
  ///
  /// Represents the upper range of mobile devices, including large smartphones
  /// and 7-8" tablets in portrait orientation. Supports enhanced mobile layouts
  /// with some multi-column content.
  compactExtraLarge,

  /// Layout category for standard modern smartphones.
  ///
  /// The most common category for contemporary mobile devices, including flagship
  /// phones and mid-range smartphones. Optimized for one-handed use with
  /// thumb-friendly navigation and single-column layouts.
  compactLarge,

  /// Layout category for compact phones and older flagship devices.
  ///
  /// Represents smaller smartphones and older premium devices. Requires careful
  /// content prioritization and efficient use of limited screen space while
  /// maintaining usability.
  compactNormal,

  /// Layout category for small phones and budget devices.
  ///
  /// Common in entry-level smartphones and older devices. Requires minimal
  /// layouts with essential functionality prioritized and careful consideration
  /// of content hierarchy.
  compactSmall,

  /// Layout category for minimal displays and specialized devices.
  ///
  /// Represents smartwatches, IoT displays, very old mobile devices, and other
  /// constrained environments. Requires extremely simplified interfaces with
  /// only critical functionality exposed.
  tiny,
}
