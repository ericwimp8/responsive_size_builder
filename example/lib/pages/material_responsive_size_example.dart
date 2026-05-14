import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class MaterialResponsiveSizeExample extends StatelessWidget {
  const MaterialResponsiveSizeExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final breakpoint =
        ScreenSizeModelWithValue.breakpointOf<MaterialWindowSizeClass>(context);
    final values = ScreenSizeModelWithValue.responsiveValueOf<
        MaterialWindowSizeClass, MaterialResponsiveValues>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MaterialResponsiveSize'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: EdgeInsets.all(values.pageMargin),
        children: [
          Text(
            'Material 3 preset',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This page reads Material window size classes and responsive values from MaterialResponsiveSize.',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: values.paneSpacing),
          ResponsiveSectionRow(
            minSectionWidth: 280,
            spacing: values.paneSpacing,
            runSpacing: values.paneSpacing,
            sections: [
              _ValueCard(
                title: 'Window class',
                value: breakpoint.name,
                icon: Icons.splitscreen,
              ),
              _ValueCard(
                title: 'Page margin',
                value: '${values.pageMargin.toStringAsFixed(0)}dp',
                icon: Icons.padding,
              ),
              _ValueCard(
                title: 'Pane spacing',
                value: '${values.paneSpacing.toStringAsFixed(0)}dp',
                icon: Icons.space_bar,
              ),
            ],
          ),
          SizedBox(height: values.paneSpacing),
          ResponsiveGrid(
            minChildWidth: 220,
            spacing: 12,
            runSpacing: 12,
            children: [
              _ValueCard(
                title: 'Recommended panes',
                value: values.recommendedPaneCount.toString(),
                icon: Icons.view_column,
              ),
              _ValueCard(
                title: 'Max panes',
                value: values.maxPaneCount.toString(),
                icon: Icons.dashboard,
              ),
              _ValueCard(
                title: 'Fixed pane width',
                value: values.fixedPaneWidth == null
                    ? 'none'
                    : '${values.fixedPaneWidth!.toStringAsFixed(0)}dp',
                icon: Icons.width_full,
              ),
              _ValueCard(
                title: 'Side sheet max',
                value: values.sideSheetMaxWidth == null
                    ? 'none'
                    : '${values.sideSheetMaxWidth!.toStringAsFixed(0)}dp',
                icon: Icons.vertical_split,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ConstantsCard(values: values),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstantsCard extends StatelessWidget {
  const _ConstantsCard({required this.values});

  final MaterialResponsiveValues values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Material constants',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const _ConstantRow(
              label: 'Minimum touch target',
              value: MaterialResponsiveValues.minimumTouchTarget,
            ),
            const _ConstantRow(
              label: 'Minimum pointer target',
              value: MaterialResponsiveValues.minimumPointerTarget,
            ),
            const _ConstantRow(
              label: 'Padding step',
              value: MaterialResponsiveValues.paddingStep,
            ),
            const _ConstantRow(
              label: 'Bottom sheet max width',
              value: MaterialResponsiveValues.bottomSheetMaxWidth,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstantRow extends StatelessWidget {
  const _ConstantRow({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            '${value.toStringAsFixed(0)}dp',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
