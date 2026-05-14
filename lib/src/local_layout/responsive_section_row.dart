import 'package:flutter/widgets.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A width-aware layout that keeps sections in a row when they fit and stacks
/// them when the available width is too narrow.
class ResponsiveSectionRow extends StatelessWidget {
  /// Creates a row that keeps sections side by side when they fit.
  const ResponsiveSectionRow({
    required this.sections,
    this.minSectionWidth = 250,
    this.spacing = 8,
    this.runSpacing = 16,
    this.useIntrinsicHeight = false,
    super.key,
  })  : assert(
          minSectionWidth > 0,
          'minSectionWidth must be greater than zero.',
        ),
        assert(spacing >= 0, 'spacing must not be negative.'),
        assert(runSpacing >= 0, 'runSpacing must not be negative.');

  /// The widgets to arrange.
  final List<Widget> sections;

  /// The minimum preferred width for each section before stacking.
  final double minSectionWidth;

  /// Horizontal gap between sections in row layout.
  final double spacing;

  /// Vertical gap between sections in stacked layout.
  final double runSpacing;

  /// Whether row layout should equalize section heights.
  final bool useIntrinsicHeight;

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) return const SizedBox.shrink();
    if (sections.length == 1) return sections.first;

    return LayoutConstraintsWrapper(
      builder: (context, child) => child,
      child: ResponsiveSectionRowBase(
        sections: sections,
        minSectionWidth: minSectionWidth,
        spacing: spacing,
        runSpacing: runSpacing,
        useIntrinsicHeight: useIntrinsicHeight,
      ),
    );
  }
}

/// A [ResponsiveSectionRow] variant that reads constraints from [LayoutConstraintsWrapper].
class ResponsiveSectionRowBase extends StatelessWidget {
  /// Creates a constraint-driven row that reads width from [LayoutConstraintsWrapper].
  const ResponsiveSectionRowBase({
    required this.sections,
    this.minSectionWidth = 250,
    this.spacing = 8,
    this.runSpacing = 16,
    this.dividerBuilder,
    this.columnDividerBuilder,
    this.useIntrinsicHeight = false,
    super.key,
  })  : assert(
          minSectionWidth > 0,
          'minSectionWidth must be greater than zero.',
        ),
        assert(spacing >= 0, 'spacing must not be negative.'),
        assert(runSpacing >= 0, 'runSpacing must not be negative.');

  /// The widgets to arrange.
  final List<Widget> sections;

  /// The minimum preferred width for each section before stacking.
  final double minSectionWidth;

  /// Horizontal gap between sections in row layout.
  final double spacing;

  /// Vertical gap between sections in stacked layout.
  final double runSpacing;

  /// Optional divider inserted between sections in row layout.
  final WidgetBuilder? dividerBuilder;

  /// Optional divider inserted between sections in stacked layout.
  final WidgetBuilder? columnDividerBuilder;

  /// Whether row layout should equalize section heights.
  final bool useIntrinsicHeight;

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) return const SizedBox.shrink();
    if (sections.length == 1) return sections.first;

    final constraints = LayoutConstraintsProvider.of(context);
    if (constraints == null) {
      throw FlutterError(
        'ResponsiveSectionRowBase must be used within a '
        'LayoutConstraintsWrapper.',
      );
    }

    final totalSpacing = spacing * (sections.length - 1);
    final requiredWidth = (minSectionWidth * sections.length) + totalSpacing;
    final useRow =
        !constraints.maxWidth.isFinite || constraints.maxWidth >= requiredWidth;

    if (useRow) {
      final divider = dividerBuilder;
      final row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            Expanded(child: sections[i]),
            if (i < sections.length - 1)
              divider != null ? divider(context) : SizedBox(width: spacing),
          ],
        ],
      );

      return useIntrinsicHeight ? IntrinsicHeight(child: row) : row;
    }

    final divider = columnDividerBuilder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          sections[i],
          if (i < sections.length - 1)
            divider != null ? divider(context) : SizedBox(height: runSpacing),
        ],
      ],
    );
  }
}
