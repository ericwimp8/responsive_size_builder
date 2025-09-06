import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeWithValueExample extends StatelessWidget {
  const ScreenSizeWithValueExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Example using ScreenSizeWithValue with column count
    return ScreenSizeWithValue<LayoutSize, int>(
      breakpoints: const Breakpoints(
        small: 600,
        medium: 950,
        large: 1200,
        extraLarge: 1400,
      ),
      valueProvider: ResponsiveValue<int>(
        extraSmall: 1,
        small: 2,
        medium: 3,
        large: 4,
        extraLarge: 5,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ScreenSizeWithValue Example'),
          backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: const _BodyContent(),
      ),
    );
  }
}

class _BodyContent extends StatelessWidget {
  const _BodyContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Access the responsive value from anywhere in the widget tree
    final columns =
        ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, int>(context);
    final screenData = ScreenSizeModelWithValue.of<LayoutSize, int>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'ScreenSizeWithValue',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Combines ScreenSize wrapper with ResponsiveValue provider. '
                    'The column count is available throughout the widget tree.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ScreenSizeInfoChip(
                        label: 'Screen Size',
                        value: screenData.screenSize.toString().split('.').last,
                        color: theme.colorScheme.primary,
                      ),
                      ScreenSizeInfoChip(
                        label: 'Columns',
                        value: columns.toString(),
                        color: theme.colorScheme.secondary,
                      ),
                      ScreenSizeInfoChip(
                        label: 'Width',
                        value:
                            '${screenData.logicalScreenWidth.toStringAsFixed(0)}px',
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Grid with $columns columns',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _ResponsiveGrid(columns: columns),
                ),
              ],
            ),
          ),
        ),
        // Demonstrate nested access to responsive value
        const _NestedExample(),
      ],
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({required this.columns});
  final int columns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: columns * 4,
      itemBuilder: (context, index) {
        return Card(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Item ${index + 1}',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NestedExample extends StatelessWidget {
  const _NestedExample();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Access responsive value from deeply nested widget
    final columns =
        ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, int>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This nested widget accesses the responsive column count: $columns. '
                  'The value is available anywhere in the widget tree below ScreenSizeWithValue.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
