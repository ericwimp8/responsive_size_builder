import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Demonstrates using LayoutValueSizeBuilder to choose primitive values
/// based on parent constraints rather than global screen size.
class LayoutValueSizeBuilderExample extends StatelessWidget {
  const LayoutValueSizeBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LayoutValueSizeBuilder Example'),
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
                      'LayoutValueSizeBuilder',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selects values from layout constraints, making each panel respond to its own width.',
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
                  Expanded(
                    child: _ValuePanel(
                      title: 'Panel 1 (1/3)',
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _ValuePanel(
                      title: 'Panel 2 (2/3)',
                      backgroundColor: theme.colorScheme.secondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValuePanel extends StatelessWidget {
  const _ValuePanel({
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: LayoutValueSizeBuilder<double>(
                extraSmall: 6,
                small: 10,
                medium: 14,
                large: 20,
                extraLarge: 28,
                builder: (context, spacing) {
                  return LayoutValueSizeBuilder<int>(
                    extraSmall: 1,
                    small: 2,
                    medium: 3,
                    large: 4,
                    extraLarge: 5,
                    builder: (context, columns) {
                      return _PanelBody(
                        spacing: spacing,
                        columns: columns,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelBody extends StatelessWidget {
  const _PanelBody({
    required this.spacing,
    required this.columns,
  });

  final double spacing;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: Column(
        children: [
          ScreenSizeInfoChip(
            label: '',
            value: 'Spacing: ${spacing.toStringAsFixed(0)} | Columns: $columns',
            color: theme.colorScheme.primary,
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
                          Icons.width_normal,
                          size: 22,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${index + 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
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
