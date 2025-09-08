import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ValueSizeBuilderExample extends StatelessWidget {
  const ValueSizeBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenSize<LayoutSize>(
      breakpoints: Breakpoints.defaultBreakpoints,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ValueSizeBuilder Example'),
          backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'ValueSizeBuilder',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Returns different values (not widgets) based on screen size. '
                        'Resize to see spacing, font sizes, and column counts change.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Example 1: Responsive Spacing
              ValueSizeBuilder<double>(
                extraSmall: 4,
                small: 8,
                medium: 16,
                large: 24,
                extraLarge: 32,
                builder: (context, spacing) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(spacing),
                      child: Column(
                        children: [
                          Text(
                            'Responsive Padding',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ScreenSizeInfoChip(
                            label: '',
                            value: 'Padding: ${spacing.toStringAsFixed(0)}px',
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Example 2: Responsive Font Size
              ValueSizeBuilder<double>(
                extraSmall: 12,
                small: 14,
                medium: 18,
                large: 22,
                extraLarge: 28,
                builder: (context, fontSize) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Responsive Font Size',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This text adapts to screen size',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: fontSize,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ScreenSizeInfoChip(
                            label: '',
                            value:
                                'Font Size: ${fontSize.toStringAsFixed(0)}px',
                            color: theme.colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Example 3: Responsive Column Count
              ValueSizeBuilder<int>(
                extraSmall: 1,
                small: 1,
                medium: 2,
                large: 4,
                extraLarge: 6,
                builder: (context, columns) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Responsive Grid Columns',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ScreenSizeInfoChip(
                            label: '',
                            value: 'Columns: $columns',
                            color: theme.colorScheme.tertiary,
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: columns * 2,
                            itemBuilder: (context, index) {
                              return Card(
                                color: theme.colorScheme.surface,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.widgets,
                                        size: 24,
                                        color: theme.colorScheme.tertiary,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${index + 1}',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.tertiary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
