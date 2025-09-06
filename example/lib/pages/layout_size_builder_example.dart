import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import 'package:example/shared/widgets/screen_size_header.dart';

class LayoutSizeBuilderExample extends StatelessWidget {
  const LayoutSizeBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('LayoutSizeBuilder Example'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'LayoutSizeBuilder',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Responds to parent constraints, not screen size. '
                      'Try resizing the panels below to see how each adapts independently.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Left panel - 1/3 width
                  Expanded(
                    child: _Panel(
                      title: 'Panel 1 (1/3)',
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right panel - 2/3 width
                  Expanded(
                    flex: 2,
                    child: _Panel(
                      title: 'Panel 2 (2/3)',
                      backgroundColor: theme.colorScheme.secondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom panel - full width
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: _Panel(
                title: 'Panel 3 (Full Width)',
                backgroundColor: theme.colorScheme.tertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.backgroundColor,
  });

  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: LayoutSizeBuilder(
                small: (context) => _Content(
                  size: 'Small',
                  columns: 1,
                  color: theme.colorScheme.error,
                ),
                medium: (context) => _Content(
                  size: 'Medium',
                  columns: 2,
                  color: theme.colorScheme.tertiary,
                ),
                large: (context) => _Content(
                  size: 'Large',
                  columns: 3,
                  color: theme.colorScheme.secondary,
                ),
                extraLarge: (context) => _Content(
                  size: 'Extra Large',
                  columns: 4,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.size,
    required this.columns,
    required this.color,
  });

  final String size;
  final int columns;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ScreenSizeInfoChip(
            label: '',
            value: size,
            color: color,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: columns * 2,
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.widgets,
                          size: 24,
                          color: color,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${index + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
