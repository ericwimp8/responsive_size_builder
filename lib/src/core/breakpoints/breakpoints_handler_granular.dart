import 'package:responsive_size_builder/responsive_size_builder.dart';

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
