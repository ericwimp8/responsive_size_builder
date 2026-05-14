import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Material 3 window size classes.
enum MaterialWindowSizeClass {
  /// Window widths smaller than 600dp.
  compact,

  /// Window widths from 600dp to 839dp.
  medium,

  /// Window widths from 840dp to 1199dp.
  expanded,

  /// Window widths from 1200dp to 1599dp.
  large,

  /// Window widths 1600dp and larger.
  extraLarge,
}

/// Material 3 breakpoint configuration for window width classes.
@immutable
class MaterialBreakpoints implements BaseBreakpoints<MaterialWindowSizeClass> {
  /// Creates Material 3 breakpoint thresholds for window width classes.
  const MaterialBreakpoints({
    this.extraLarge = 1600,
    this.large = 1200,
    this.expanded = 840,
    this.medium = 600,
  }) : assert(
          extraLarge > large && large > expanded && expanded > medium,
          'MaterialBreakpoints must be in descending order.',
        );

  /// Minimum logical width for [MaterialWindowSizeClass.extraLarge].
  final double extraLarge;

  /// Minimum logical width for [MaterialWindowSizeClass.large].
  final double large;

  /// Minimum logical width for [MaterialWindowSizeClass.expanded].
  final double expanded;

  /// Minimum logical width for [MaterialWindowSizeClass.medium].
  final double medium;

  /// Material 3 default window size class breakpoints.
  static const defaultBreakpoints = MaterialBreakpoints();

  @override
  Map<MaterialWindowSizeClass, double> get values => {
        MaterialWindowSizeClass.extraLarge: extraLarge,
        MaterialWindowSizeClass.large: large,
        MaterialWindowSizeClass.expanded: expanded,
        MaterialWindowSizeClass.medium: medium,
        MaterialWindowSizeClass.compact: -1,
      };

  @override
  String toString() {
    return 'MaterialBreakpoints(extraLarge: $extraLarge, large: $large, expanded: $expanded, medium: $medium)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MaterialBreakpoints &&
        other.extraLarge == extraLarge &&
        other.large == large &&
        other.expanded == expanded &&
        other.medium == medium;
  }

  @override
  int get hashCode => Object.hash(extraLarge, large, expanded, medium);
}

/// Material 3 responsive layout values for a window size class.
@immutable
class MaterialResponsiveValues {
  /// Creates Material 3 responsive layout values for a window size class.
  const MaterialResponsiveValues({
    required this.pageMargin,
    required this.paneSpacing,
    required this.recommendedPaneCount,
    required this.maxPaneCount,
    this.fixedPaneWidth,
    this.sideSheetMaxWidth,
  });

  /// Left and right margin for the main body region.
  final double pageMargin;

  /// Spacer width between panes.
  final double paneSpacing;

  /// Pane count Material recommends for the current window size class.
  final int recommendedPaneCount;

  /// Maximum pane count Material supports for the current window size class.
  final int maxPaneCount;

  /// Default fixed pane width where Material specifies one.
  final double? fixedPaneWidth;

  /// Default maximum side-sheet width where Material specifies one.
  final double? sideSheetMaxWidth;

  /// Material padding step. Padding is measured in increments of 4dp.
  static const paddingStep = 4.0;

  /// Minimum touch target size for touchscreen interaction.
  static const minimumTouchTarget = 48.0;

  /// Minimum pointer target size for pointer-device interaction.
  static const minimumPointerTarget = 44.0;

  /// Minimum space between targets.
  static const targetSpacing = 8.0;

  /// Maximum width for bottom sheets before large-screen margins apply.
  static const bottomSheetMaxWidth = 640.0;

  /// Side/top margin used by bottom sheets above 640dp window width.
  static const bottomSheetLargeScreenMargin = 56.0;

  /// Default top margin for bottom sheets.
  static const bottomSheetTopMargin = 72.0;

  /// Minimum basic dialog width.
  static const dialogMinWidth = 280.0;

  /// Maximum dialog width.
  static const dialogMaxWidth = 560.0;

  /// Standard dialog padding.
  static const dialogPadding = 24.0;

  /// Search container minimum width.
  static const searchContainerMinWidth = 360.0;

  /// Search container maximum width.
  static const searchContainerMaxWidth = 720.0;

  /// Search bar height.
  static const searchBarHeight = 56.0;

  /// Docked search minimum height.
  static const searchDockedMinHeight = 240.0;

  /// Docked search maximum height as a fraction of screen height.
  static const searchDockedMaxHeightFraction = 2 / 3;

  /// Search app bar width threshold before it grows at half available width.
  static const searchAppBarMinExpandedWidth = 312.0;

  /// Compact snackbar minimum height.
  static const snackbarCompactMinHeight = 48.0;

  /// Compact snackbar maximum height.
  static const snackbarCompactMaxHeight = 64.0;

  /// Minimum circular progress indicator size.
  static const progressCircularMinSize = 24.0;

  /// Maximum circular progress indicator size.
  static const progressCircularMaxSize = 240.0;

  /// Minimum linear progress indicator width.
  static const progressLinearMinWidth = 40.0;

  /// Minimum horizontal padding for linear progress indicators.
  static const progressLinearEndPadding = 4.0;

  /// Minimum horizontal floating toolbar margin.
  static const toolbarHorizontalMargin = 16.0;

  /// Minimum vertical floating toolbar margin.
  static const toolbarVerticalMargin = 24.0;

  /// Minimum small carousel item width.
  static const carouselSmallItemMinWidth = 40.0;

  /// Maximum small carousel item width.
  static const carouselSmallItemMaxWidth = 56.0;

  /// Maximum comfortable text carousel items in compact windows.
  static const carouselCompactMaxTextItems = 3;

  @override
  String toString() {
    return 'MaterialResponsiveValues(pageMargin: $pageMargin, paneSpacing: $paneSpacing, recommendedPaneCount: $recommendedPaneCount, maxPaneCount: $maxPaneCount, fixedPaneWidth: $fixedPaneWidth, sideSheetMaxWidth: $sideSheetMaxWidth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MaterialResponsiveValues &&
        other.pageMargin == pageMargin &&
        other.paneSpacing == paneSpacing &&
        other.recommendedPaneCount == recommendedPaneCount &&
        other.maxPaneCount == maxPaneCount &&
        other.fixedPaneWidth == fixedPaneWidth &&
        other.sideSheetMaxWidth == sideSheetMaxWidth;
  }

  @override
  int get hashCode {
    return Object.hash(
      pageMargin,
      paneSpacing,
      recommendedPaneCount,
      maxPaneCount,
      fixedPaneWidth,
      sideSheetMaxWidth,
    );
  }
}

/// Material 3 responsive values for the current window size class.
class MaterialResponsiveValue extends BaseResponsiveValue<
    MaterialWindowSizeClass, MaterialResponsiveValues> {
  /// Creates a provider for Material 3 responsive values.
  MaterialResponsiveValue({
    MaterialBreakpoints breakpoints = MaterialBreakpoints.defaultBreakpoints,
  }) : super(
          breakpoints: breakpoints,
          values: {
            MaterialWindowSizeClass.extraLarge: const MaterialResponsiveValues(
              pageMargin: 24,
              paneSpacing: 24,
              recommendedPaneCount: 3,
              maxPaneCount: 3,
              fixedPaneWidth: 412,
              sideSheetMaxWidth: 400,
            ),
            MaterialWindowSizeClass.large: const MaterialResponsiveValues(
              pageMargin: 24,
              paneSpacing: 24,
              recommendedPaneCount: 2,
              maxPaneCount: 2,
              fixedPaneWidth: 412,
              sideSheetMaxWidth: 400,
            ),
            MaterialWindowSizeClass.expanded: const MaterialResponsiveValues(
              pageMargin: 24,
              paneSpacing: 24,
              recommendedPaneCount: 2,
              maxPaneCount: 2,
              fixedPaneWidth: 360,
            ),
            MaterialWindowSizeClass.medium: const MaterialResponsiveValues(
              pageMargin: 24,
              paneSpacing: 24,
              recommendedPaneCount: 1,
              maxPaneCount: 2,
            ),
            MaterialWindowSizeClass.compact: const MaterialResponsiveValues(
              pageMargin: 16,
              paneSpacing: 24,
              recommendedPaneCount: 1,
              maxPaneCount: 1,
            ),
          },
        );
}

/// Wraps a subtree with Material 3 window size classes and responsive values.
class MaterialResponsiveSize extends StatelessWidget {
  /// Creates a widget that exposes Material responsive values to its subtree.
  const MaterialResponsiveSize({
    required this.child,
    this.breakpoints = MaterialBreakpoints.defaultBreakpoints,
    this.valueProvider,
    this.testView,
    this.useShortestSide = false,
    super.key,
  });

  /// Child subtree that can read Material responsive values.
  final Widget child;

  /// Material breakpoint configuration.
  final MaterialBreakpoints breakpoints;

  /// Optional override for Material responsive values.
  final MaterialResponsiveValue? valueProvider;

  /// Optional test view used by widget tests.
  final FlutterView? testView;

  /// Whether to classify using the shortest side instead of width.
  final bool useShortestSide;

  @override
  Widget build(BuildContext context) {
    return ScreenSizeWithValue<MaterialWindowSizeClass,
        MaterialResponsiveValues>(
      breakpoints: breakpoints,
      valueProvider: valueProvider ??
          MaterialResponsiveValue(
            breakpoints: breakpoints,
          ),
      testView: testView,
      useShortestSide: useShortestSide,
      child: child,
    );
  }
}
