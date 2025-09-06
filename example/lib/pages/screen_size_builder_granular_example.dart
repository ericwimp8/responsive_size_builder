import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeBuilderGranularExample extends StatelessWidget {
  const ScreenSizeBuilderGranularExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenSize<LayoutSizeGranular>(
      breakpoints: BreakpointsGranular.defaultBreakpoints,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ScreenSizeBuilderGranular Example'),
          backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: ScreenSizeBuilderGranular(
          // Tiny
          tiny: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Tiny',
            backgroundColor: theme.colorScheme.surfaceContainerLowest,
            columns: 1,
            range: '< 300px',
          ),
          // Compact
          compactSmall: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Compact Small',
            backgroundColor: theme.colorScheme.errorContainer,
            columns: 1,
            range: '300-360px',
          ),
          compactNormal: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Compact Normal',
            backgroundColor: theme.colorScheme.error.withValues(alpha: 0.2),
            columns: 2,
            range: '360-430px',
          ),
          compactLarge: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Compact Large',
            backgroundColor: theme.colorScheme.error.withValues(alpha: 0.4),
            columns: 2,
            range: '430-480px',
          ),
          compactExtraLarge: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Compact XL',
            backgroundColor: theme.colorScheme.error.withValues(alpha: 0.6),
            columns: 2,
            range: '480-568px',
          ),
          // Standard
          standardSmall: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Standard Small',
            backgroundColor: theme.colorScheme.primaryContainer,
            columns: 3,
            range: '568-768px',
          ),
          standardNormal: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Standard Normal',
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            columns: 3,
            range: '768-1024px',
          ),
          standardLarge: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Standard Large',
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.4),
            columns: 4,
            range: '1024-1280px',
          ),
          standardExtraLarge: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Standard XL',
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.6),
            columns: 4,
            range: '1280-1920px',
          ),
          // Jumbo
          jumboSmall: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Jumbo Small',
            backgroundColor: theme.colorScheme.secondaryContainer,
            columns: 5,
            range: '1920-2560px',
          ),
          jumboNormal: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Jumbo Normal',
            backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.2),
            columns: 6,
            range: '2560-3840px',
          ),
          jumboLarge: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Jumbo Large',
            backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.4),
            columns: 7,
            range: '3840-4096px',
          ),
          jumboExtraLarge: (context, data) => _LayoutBuilder(
            data: data,
            sizeName: 'Jumbo XL',
            backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.6),
            columns: 8,
            range: '> 4096px',
          ),
        ),
      ),
    );
  }
}

class _LayoutBuilder extends StatelessWidget {
  const _LayoutBuilder({
    required this.data,
    required this.sizeName,
    required this.backgroundColor,
    required this.columns,
    required this.range,
  });

  final ScreenSizeModelData data;
  final String sizeName;
  final Color backgroundColor;
  final int columns;
  final String range;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Determine category color
    Color categoryColor;
    String category;
    if (sizeName.startsWith('Tiny')) {
      categoryColor = theme.colorScheme.surfaceTint;
      category = 'Tiny';
    } else if (sizeName.startsWith('Compact')) {
      categoryColor = theme.colorScheme.error;
      category = 'Compact';
    } else if (sizeName.startsWith('Standard')) {
      categoryColor = theme.colorScheme.primary;
      category = 'Standard';
    } else {
      categoryColor = theme.colorScheme.secondary;
      category = 'Jumbo';
    }

    return ColoredBox(
      color: backgroundColor,
      child: Column(
        children: [
          ScreenSizeHeader(
            sizeName: sizeName,
            range: range,
            screenData: data,
            category: category,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: columns * 3,
                itemBuilder: (context, index) {
                  return Card(
                    color: categoryColor.withValues(alpha: 0.1),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grid_view,
                            size: 32,
                            color: categoryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${index + 1}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: categoryColor,
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
          ),
        ],
      ),
    );
  }
}
