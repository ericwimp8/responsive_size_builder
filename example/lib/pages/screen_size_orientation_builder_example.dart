import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../shared/widgets/screen_size_header.dart';

class ScreenSizeOrientationBuilderExample extends StatelessWidget {
  const ScreenSizeOrientationBuilderExample({super.key});

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
          title: const Text('ScreenSizeOrientationBuilder Example'),
          backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: ScreenSizeOrientationBuilder(
          // Portrait builders
          small: (context) => _PortraitLayout(
            title: 'Small Portrait',
            backgroundColor: theme.colorScheme.errorContainer,
            columns: 1,
            icon: Icons.stay_current_portrait,
          ),
          medium: (context) => _PortraitLayout(
            title: 'Medium Portrait',
            backgroundColor: theme.colorScheme.tertiaryContainer,
            columns: 2,
            icon: Icons.tablet,
          ),
          large: (context) => _PortraitLayout(
            title: 'Large Portrait',
            backgroundColor: theme.colorScheme.secondaryContainer,
            columns: 3,
            icon: Icons.desktop_windows,
          ),
          extraLarge: (context) => _PortraitLayout(
            title: 'Extra Large Portrait',
            backgroundColor: theme.colorScheme.primaryContainer,
            columns: 4,
            icon: Icons.tv,
          ),
          // Landscape builders
          smallLandscape: (context) => _LandscapeLayout(
            title: 'Small Landscape',
            backgroundColor: theme.colorScheme.error,
            columns: 2,
            icon: Icons.stay_current_landscape,
          ),
          mediumLandscape: (context) => _LandscapeLayout(
            title: 'Medium Landscape',
            backgroundColor: theme.colorScheme.tertiary,
            columns: 3,
            icon: Icons.tablet_android,
          ),
          largeLandscape: (context) => _LandscapeLayout(
            title: 'Large Landscape',
            backgroundColor: theme.colorScheme.secondary,
            columns: 4,
            icon: Icons.laptop,
          ),
          extraLargeLandscape: (context) => _LandscapeLayout(
            title: 'Extra Large Landscape',
            backgroundColor: theme.colorScheme.primary,
            columns: 5,
            icon: Icons.desktop_mac,
          ),
          animateChange: true,
        ),
      ),
    );
  }
}

class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({
    required this.title,
    required this.backgroundColor,
    required this.columns,
    required this.icon,
  });

  final String title;
  final Color backgroundColor;
  final int columns;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Column(
        children: [
          ScreenSizeHeader(
            sizeName: title,
            orientation: 'Portrait Mode',
            icon: icon,
          ),
          Expanded(
            child: _Grid(columns: columns, isPortrait: true),
          ),
        ],
      ),
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({
    required this.title,
    required this.backgroundColor,
    required this.columns,
    required this.icon,
  });

  final String title;
  final Color backgroundColor;
  final int columns;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Row(
        children: [
          SizedBox(
            width: 250,
            child: ScreenSizeHeader(
              sizeName: title,
              orientation: 'Landscape Mode',
              icon: icon,
              isFullHeight: true,
            ),
          ),
          Expanded(
            child: _Grid(columns: columns, isPortrait: false),
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.columns,
    required this.isPortrait,
  });

  final int columns;
  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: isPortrait ? 1 : 1.5,
        ),
        itemCount: columns * 4,
        itemBuilder: (context, index) {
          return Card(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPortrait ? Icons.portrait : Icons.landscape,
                    size: 32,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Item ${index + 1}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
