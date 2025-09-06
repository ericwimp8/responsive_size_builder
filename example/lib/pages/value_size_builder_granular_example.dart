import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ValueSizeBuilderGranularExample extends StatelessWidget {
  const ValueSizeBuilderGranularExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenSize<LayoutSizeGranular>(
      breakpoints: BreakpointsGranular.defaultBreakpoints,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ValueSizeBuilderGranular Example'),
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
                        'ValueSizeBuilderGranular',
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
              ValueSizeBuilderGranular<double>(
                tiny: 4,
                compactSmall: 8,
                compactNormal: 12,
                compactLarge: 16,
                standardSmall: 20,
                standardNormal: 24,
                standardLarge: 28,
                standardExtraLarge: 32,
                jumboSmall: 36,
                jumboNormal: 40,
                jumboLarge: 44,
                jumboExtraLarge: 48,
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
              ValueSizeBuilderGranular<double>(
                tiny: 12,
                compactSmall: 14,
                compactNormal: 16,
                compactLarge: 18,
                standardSmall: 20,
                standardNormal: 22,
                standardLarge: 24,
                standardExtraLarge: 26,
                jumboSmall: 28,
                jumboNormal: 32,
                jumboLarge: 36,
                jumboExtraLarge: 40,
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
              ValueSizeBuilderGranular<int>(
                tiny: 1,
                compactSmall: 1,
                compactNormal: 2,
                compactLarge: 2,
                compactExtraLarge: 3,
                standardSmall: 3,
                standardNormal: 4,
                standardLarge: 5,
                standardExtraLarge: 6,
                jumboSmall: 7,
                jumboNormal: 8,
                jumboLarge: 10,
                jumboExtraLarge: 12,
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
