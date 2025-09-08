import 'package:flutter/material.dart';

/// A chip widget that displays a category with color-coded styling based on screen size categories.
///
/// The [CategoryChip] provides consistent visual representation for different
/// screen size categories (tiny, compact, standard, jumbo) with appropriate
/// color schemes for each category type.
class CategoryChip extends StatelessWidget {
  /// Creates a [CategoryChip] with the specified category.
  ///
  /// The [category] parameter determines both the display text and the color scheme.
  /// Supported categories are: 'tiny', 'compact', 'standard', 'jumbo'.
  /// Any other category will use the default primary color scheme.
  const CategoryChip({
    required this.category,
    super.key,
  });

  /// The category name to display and use for color determination.
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color categoryColor;
    switch (category.toLowerCase()) {
      case 'tiny':
        categoryColor = theme.colorScheme.surfaceTint;
      case 'compact':
        categoryColor = theme.colorScheme.error;
      case 'standard':
        categoryColor = theme.colorScheme.primary;
      case 'jumbo':
        categoryColor = theme.colorScheme.secondary;
      default:
        categoryColor = theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.2),
        border: Border.all(color: categoryColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: categoryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
