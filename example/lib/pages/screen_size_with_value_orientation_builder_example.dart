import 'package:example/shared/models/layout_config.dart';
import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenWithValueWidgetBuilderOrientationExample extends StatelessWidget {
  const ScreenWithValueWidgetBuilderOrientationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSizeWithValue<LayoutSize, LayoutConfig>(
      breakpoints: Breakpoints.defaultBreakpoints,
      valueProvider: ResponsiveValue<LayoutConfig>(
        extraSmall: const LayoutConfig(columns: 1, padding: 8),
        small: const LayoutConfig(columns: 1, padding: 12),
        medium: const LayoutConfig(columns: 2, padding: 16),
        large: const LayoutConfig(columns: 3, padding: 20, showSideMenu: true),
        extraLarge:
            const LayoutConfig(columns: 4, padding: 24, showSideMenu: true),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orientation Value Builder Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const _OrientationResponsiveContent(),
      ),
    );
  }
}

class _OrientationResponsiveContent extends StatelessWidget {
  const _OrientationResponsiveContent();

  @override
  Widget build(BuildContext context) {
    return ScreenWithValueWidgetBuilderOrientation<LayoutConfig>(
      // Portrait builders - get config from data.responsiveValue
      extraSmall: (context, data) => _PortraitLayout(
        data: data,
        orientationLabel: 'Extra Small Portrait',
      ),
      small: (context, data) => _PortraitLayout(
        data: data,
        orientationLabel: 'Small Portrait',
      ),
      medium: (context, data) => _PortraitLayout(
        data: data,
        orientationLabel: 'Medium Portrait',
      ),
      large: (context, data) => _PortraitLayout(
        data: data,
        orientationLabel: 'Large Portrait',
      ),
      extraLarge: (context, data) => _PortraitLayout(
        data: data,
        orientationLabel: 'Extra Large Portrait',
      ),

      // Landscape builders - portrait uses different column layout for landscape
      extraSmallLandscape: (context, data) => _LandscapeLayout(
        data: data,
        orientationLabel: 'Extra Small Landscape',
      ),
      smallLandscape: (context, data) => _LandscapeLayout(
        data: data,
        orientationLabel: 'Small Landscape',
      ),
      mediumLandscape: (context, data) => _LandscapeLayout(
        data: data,
        orientationLabel: 'Medium Landscape',
      ),
      largeLandscape: (context, data) => _LandscapeLayout(
        data: data,
        orientationLabel: 'Large Landscape',
      ),
      extraLargeLandscape: (context, data) => _LandscapeLayout(
        data: data,
        orientationLabel: 'Extra Large Landscape',
      ),

      animateChange: true,
    );
  }
}

class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({
    required this.data,
    required this.orientationLabel,
  });

  final ScreenSizeModelDataWithValue<LayoutSize, LayoutConfig> data;
  final String orientationLabel;

  @override
  Widget build(BuildContext context) {
    // Keep same columns for portrait
    final baseConfig = data.responsiveValue;
    final config = baseConfig.copyWith(
      columns: baseConfig.columns,
    );
    return _OrientationLayout(
      config: config,
      orientationLabel: orientationLabel,
      isPortrait: true,
      screenData: data,
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({
    required this.data,
    required this.orientationLabel,
  });

  final ScreenSizeModelDataWithValue<LayoutSize, LayoutConfig> data;
  final String orientationLabel;

  @override
  Widget build(BuildContext context) {
    // For landscape, we want more columns to take advantage of wider screen
    final baseConfig = data.responsiveValue;
    final config = baseConfig.copyWith(
      columns: (baseConfig.columns * 1.5).ceil(), // More columns in landscape
    );
    return _OrientationLayout(
      config: config,
      orientationLabel: orientationLabel,
      isPortrait: false,
      screenData: data,
    );
  }
}

class _OrientationLayout extends StatelessWidget {
  const _OrientationLayout({
    required this.config,
    required this.orientationLabel,
    required this.isPortrait,
    required this.screenData,
  });

  final LayoutConfig config;
  final String orientationLabel;
  final bool isPortrait;
  final ScreenSizeModelDataWithValue<LayoutSize, LayoutConfig> screenData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header with orientation-specific information
        ScreenSizeHeader(
          sizeName: 'Orientation Builder',
          range:
              'Separate builders for portrait and landscape orientations, each optimized for their specific aspect ratio.',
          icon: isPortrait
              ? Icons.stay_current_portrait
              : Icons.stay_current_landscape,
          screenData: ScreenSizeModelData(
            breakpoints: screenData.breakpoints,
            currentBreakpoint: screenData.currentBreakpoint,
            screenSize: screenData.screenSize,
            physicalWidth: screenData.physicalWidth,
            physicalHeight: screenData.physicalHeight,
            devicePixelRatio: screenData.devicePixelRatio,
            logicalScreenWidth: screenData.logicalScreenWidth,
            logicalScreenHeight: screenData.logicalScreenHeight,
            orientation: screenData.orientation,
          ),
          columns: config.columns,
          orientation: isPortrait ? 'Portrait' : 'Landscape',
          customInfo: [
            ScreenSizeInfoItem(
              label: 'Mode',
              value: orientationLabel,
            ),
            if (config.showSideMenu)
              ScreenSizeInfoItem(
                label: 'Menu',
                value: 'Enabled',
                color: theme.colorScheme.tertiary,
              ),
          ],
        ),

        // Main content area optimized for orientation
        Expanded(
          child: isPortrait
              ? _PortraitContent(config: config)
              : _LandscapeContent(config: config),
        ),
      ],
    );
  }
}

class _PortraitContent extends StatelessWidget {
  const _PortraitContent({required this.config});

  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (config.showSideMenu) ...[
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _HorizontalMenu(config: config),
          ),
        ],
        Expanded(
          child: Padding(
            padding: config.paddingInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrientationContentHeader(
                  config: config,
                  isPortrait: true,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _OrientationGrid(
                    config: config,
                    isPortrait: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LandscapeContent extends StatelessWidget {
  const _LandscapeContent({required this.config});

  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (config.showSideMenu) ...[
          _VerticalMenu(config: config),
          const VerticalDivider(width: 1),
        ],
        Expanded(
          child: Padding(
            padding: config.paddingInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrientationContentHeader(
                  config: config,
                  isPortrait: false,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _OrientationGrid(
                    config: config,
                    isPortrait: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrientationContentHeader extends StatelessWidget {
  const _OrientationContentHeader({
    required this.config,
    required this.isPortrait,
  });

  final LayoutConfig config;
  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          isPortrait ? Icons.view_agenda : Icons.view_module,
          color: isPortrait
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${isPortrait ? "Portrait" : "Landscape"} Layout',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${config.columns} columns • Optimized for ${isPortrait ? "vertical" : "horizontal"} viewing',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrientationGrid extends StatelessWidget {
  const _OrientationGrid({required this.config, required this.isPortrait});
  final LayoutConfig config;
  final bool isPortrait;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: isPortrait ? 1.2 : 1.0,
      ),
      itemCount: config.columns * (isPortrait ? 4 : 3),
      itemBuilder: (context, index) {
        return Card(
          color: isPortrait
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
              : theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPortrait ? Icons.phone_android : Icons.tablet_mac,
                  size: 32,
                  color: isPortrait
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Item ${index + 1}',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  isPortrait ? 'Portrait' : 'Landscape',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HorizontalMenu extends StatelessWidget {
  const _HorizontalMenu({required this.config});
  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.menu, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Portrait Menu',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _HorizontalMenuItem(icon: Icons.home, label: 'Home'),
                  _HorizontalMenuItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                  ),
                  _HorizontalMenuItem(
                    icon: Icons.analytics,
                    label: 'Analytics',
                  ),
                  _HorizontalMenuItem(icon: Icons.settings, label: 'Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalMenuItem extends StatelessWidget {
  const _HorizontalMenuItem({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _VerticalMenu extends StatelessWidget {
  const _VerticalMenu({required this.config});
  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 240,
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.menu, color: theme.colorScheme.secondary),
                const SizedBox(width: 12),
                Text(
                  'Landscape Menu',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: const [
                _VerticalMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  isSelected: true,
                ),
                _VerticalMenuItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                ),
                _VerticalMenuItem(
                  icon: Icons.analytics,
                  title: 'Analytics',
                ),
                _VerticalMenuItem(
                  icon: Icons.people,
                  title: 'Users',
                ),
                _VerticalMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalMenuItem extends StatelessWidget {
  const _VerticalMenuItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
  });

  final IconData icon;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.secondary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : null,
          color: isSelected ? theme.colorScheme.secondary : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.secondary.withValues(alpha: 0.1),
      onTap: () {},
    );
  }
}
