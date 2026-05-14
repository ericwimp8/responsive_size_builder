import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenWidgetBuilderExample extends StatelessWidget {
  const ScreenWidgetBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenSize<LayoutSize>(
      breakpoints: const Breakpoints(
        small: 600,
        medium: 950,
        large: 1200,
        extraLarge: 1400,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ScreenWidgetBuilder Example'),
          backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: ScreenWidgetBuilder(
          extraSmall: (context, data) => _ResponsiveLayout(
            data: data,
            sizeName: 'Extra Small',
            backgroundColor: theme.colorScheme.errorContainer,
            columns: 1,
            breakpointRange: 'Width < 360px',
          ),
          small: (context, data) => _ResponsiveLayout(
            data: data,
            sizeName: 'Small',
            backgroundColor: theme.colorScheme.tertiaryContainer,
            columns: 2,
            breakpointRange: '360px ≤ Width < 600px',
          ),
          medium: (context, data) => _ResponsiveLayout(
            data: data,
            sizeName: 'Medium',
            backgroundColor: theme.colorScheme.secondaryContainer,
            columns: 3,
            breakpointRange: '600px ≤ Width < 950px',
          ),
          large: (context, data) => _ResponsiveLayout(
            data: data,
            sizeName: 'Large',
            backgroundColor: theme.colorScheme.primaryContainer,
            columns: 4,
            breakpointRange: '950px ≤ Width < 1200px',
          ),
          extraLarge: (context, data) => _ResponsiveLayout(
            data: data,
            sizeName: 'Extra Large',
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            columns: 5,
            breakpointRange: 'Width ≥ 1200px',
          ),
        ),
      ),
    );
  }
}

class _ResponsiveLayout extends StatelessWidget {
  const _ResponsiveLayout({
    required this.data,
    required this.sizeName,
    required this.backgroundColor,
    required this.columns,
    required this.breakpointRange,
  });

  final ScreenSizeModelData data;
  final String sizeName;
  final Color backgroundColor;
  final int columns;
  final String breakpointRange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: backgroundColor,
      child: Column(
        children: [
          ScreenSizeHeader(
            sizeName: 'Current: $sizeName',
            range: breakpointRange,
            screenData: data,
            columns: columns,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: columns * 3,
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.widgets,
                            size: 40,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
