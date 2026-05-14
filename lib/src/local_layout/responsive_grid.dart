import 'package:flutter/widgets.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A width-aware grid that fills the available horizontal space.
///
/// The layout calculates a column count from [minChildWidth], then lays
/// children out in rows with equal-width columns. Incomplete final rows keep
/// the same column grid so children stay aligned with previous rows.
class ResponsiveGrid extends StatelessWidget {
  /// Creates a responsive grid that fills the available horizontal space.
  const ResponsiveGrid({
    required this.children,
    this.minChildWidth = 180,
    this.spacing = 8,
    this.runSpacing = 12,
    super.key,
  })  : assert(minChildWidth > 0, 'minChildWidth must be greater than zero.'),
        assert(spacing >= 0, 'spacing must not be negative.'),
        assert(runSpacing >= 0, 'runSpacing must not be negative.');

  /// The widgets to arrange in the responsive grid.
  final List<Widget> children;

  /// The minimum preferred width for each child.
  final double minChildWidth;

  /// Horizontal gap between children in the same row.
  final double spacing;

  /// Vertical gap between grid rows.
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutConstraintsWrapper(
      builder: (context, child) => child,
      child: ResponsiveGridBase(
        minChildWidth: minChildWidth,
        spacing: spacing,
        runSpacing: runSpacing,
        children: children,
      ),
    );
  }
}

/// Constraint-provider variant of [ResponsiveGrid].
///
/// Use this inside an existing [LayoutConstraintsWrapper] when adding a nested
/// [LayoutBuilder] would conflict with intrinsic sizing in the surrounding
/// widget tree.
class ResponsiveGridBase extends StatelessWidget {
  /// Creates a responsive grid that reads constraints from the surrounding
  /// [LayoutConstraintsWrapper].
  const ResponsiveGridBase({
    required this.children,
    this.minChildWidth = 180,
    this.spacing = 8,
    this.runSpacing = 12,
    super.key,
  })  : assert(minChildWidth > 0, 'minChildWidth must be greater than zero.'),
        assert(spacing >= 0, 'spacing must not be negative.'),
        assert(runSpacing >= 0, 'runSpacing must not be negative.');

  /// The widgets to arrange in the responsive grid.
  final List<Widget> children;

  /// The minimum preferred width for each child.
  final double minChildWidth;

  /// Horizontal gap between children in the same row.
  final double spacing;

  /// Vertical gap between grid rows.
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    final constraints = LayoutConstraintsProvider.of(context);
    if (constraints == null) {
      throw FlutterError(
        'ResponsiveGridBase must be used within a LayoutConstraintsWrapper.',
      );
    }

    final availableWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : (minChildWidth * children.length) + (spacing * (children.length - 1));
    final columns = (availableWidth / minChildWidth).floor().clamp(
          1,
          children.length,
        );

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final rowChildren = children.skip(i).take(columns).toList();

      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < columns; j++) ...[
                if (j < rowChildren.length)
                  Expanded(child: rowChildren[j])
                else
                  const Expanded(child: SizedBox.shrink()),
                if (j < columns - 1) SizedBox(width: spacing),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          rows[i],
          if (i < rows.length - 1) SizedBox(height: runSpacing),
        ],
      ],
    );
  }
}
