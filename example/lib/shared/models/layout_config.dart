import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart'
    show ResponsiveValue, ScreenSizeWithValueBuilder;

/// Configuration model for responsive layouts containing padding and column information.
///
/// [LayoutConfig] provides a structured way to define responsive layout parameters
/// that adapt to different screen sizes. It encapsulates both padding values for
/// spacing and column counts for grid layouts, making it ideal for use with
/// ResponsiveValue builders.
///
/// ## Usage with ResponsiveValue
///
/// ```dart
/// final layoutProvider = ResponsiveValue<LayoutConfig>(
///   extraLarge: LayoutConfig(columns: 4, padding: 32.0, showSideMenu: true),
///   large: LayoutConfig(columns: 3, padding: 24.0, showSideMenu: true),
///   medium: LayoutConfig(columns: 2, padding: 16.0, showSideMenu: false),
///   small: LayoutConfig(columns: 1, padding: 8.0, showSideMenu: false),
/// );
/// ```
///
/// ## Layout Adaptation
///
/// The configuration automatically adapts layouts based on available screen space:
/// - **Large screens**: Multi-column grids with side menus
/// - **Medium screens**: Reduced columns, no side menu
/// - **Small screens**: Single column lists for optimal mobile experience
///
/// See also:
///
/// * [ResponsiveValue], for creating responsive layout configurations
/// * [ScreenSizeWithValueBuilder], for building widgets with layout configs
@immutable
class LayoutConfig {
  /// Creates a [LayoutConfig] with the specified layout parameters.
  ///
  /// Parameters:
  /// * [columns] - Number of columns for grid layouts (must be positive)
  /// * [padding] - Padding value in logical pixels (must be non-negative)
  /// * [showSideMenu] - Whether to display a side menu for this layout
  const LayoutConfig({
    required this.columns,
    required this.padding,
    this.showSideMenu = false,
  })  : assert(columns > 0, 'Column count must be positive'),
        assert(padding >= 0, 'Padding must be non-negative');

  /// Number of columns for grid layouts.
  ///
  /// Determines how many columns will be used when displaying content in a grid.
  /// For small screens, this is typically 1 to create a list-like experience.
  /// For larger screens, this can be 2, 3, 4, or more to make efficient use of space.
  final int columns;

  /// Padding value in logical pixels.
  ///
  /// Applied as uniform padding around content areas. Larger screens typically
  /// use larger padding values to prevent content from appearing too close to
  /// screen edges on wide displays.
  final double padding;

  /// Whether to show a side menu for this screen size.
  ///
  /// Larger screens have space for persistent navigation menus, while smaller
  /// screens should hide them to maximize content area. This flag helps determine
  /// when to show or hide navigation elements.
  final bool showSideMenu;

  /// Creates an [EdgeInsets] object from the padding value.
  ///
  /// Convenience method that converts the padding double value into a
  /// Flutter [EdgeInsets.all] for easy use with padding widgets.
  ///
  /// Returns [EdgeInsets.all] with the configured padding value.
  EdgeInsets get paddingInsets => EdgeInsets.all(padding);

  /// Determines if this configuration should use a grid layout.
  ///
  /// Returns true if the column count is greater than 1, indicating that
  /// a grid layout would be more appropriate than a list layout.
  bool get useGridLayout => columns > 1;

  /// Creates a copy of this [LayoutConfig] with optionally updated values.
  ///
  /// Allows selective modification of configuration properties while
  /// preserving others. Useful for creating variations of a base configuration.
  ///
  /// Example:
  /// ```dart
  /// final baseConfig = LayoutConfig(columns: 2, padding: 16.0);
  /// final mobileConfig = baseConfig.copyWith(columns: 1, padding: 8.0);
  /// ```
  LayoutConfig copyWith({
    int? columns,
    double? padding,
    bool? showSideMenu,
  }) {
    return LayoutConfig(
      columns: columns ?? this.columns,
      padding: padding ?? this.padding,
      showSideMenu: showSideMenu ?? this.showSideMenu,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LayoutConfig &&
        other.columns == columns &&
        other.padding == padding &&
        other.showSideMenu == showSideMenu;
  }

  @override
  int get hashCode => Object.hash(columns, padding, showSideMenu);

  @override
  String toString() {
    return 'LayoutConfig(columns: $columns, padding: $padding, showSideMenu: $showSideMenu)';
  }
}
