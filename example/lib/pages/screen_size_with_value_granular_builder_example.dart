import 'package:flutter/material.dart';

import 'package:example/shared/models/layout_config.dart';
import 'package:example/shared/widgets/category_chip.dart';
import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeWithValueBuilderGranularExample extends StatelessWidget {
  const ScreenSizeWithValueBuilderGranularExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSizeWithValue<LayoutSizeGranular, LayoutConfig>(
      breakpoints: BreakpointsGranular.defaultBreakpoints,
      valueProvider: ResponsiveValueGranular<LayoutConfig>(
        tiny: const LayoutConfig(columns: 1, padding: 4),
        compactSmall: const LayoutConfig(columns: 1, padding: 6),
        compactNormal: const LayoutConfig(columns: 1, padding: 8),
        compactLarge: const LayoutConfig(columns: 1, padding: 10),
        compactExtraLarge: const LayoutConfig(columns: 1, padding: 12),
        standardSmall: const LayoutConfig(columns: 2, padding: 14),
        standardNormal: const LayoutConfig(columns: 2, padding: 16),
        standardLarge:
            const LayoutConfig(columns: 3, padding: 20, showSideMenu: true),
        standardExtraLarge:
            const LayoutConfig(columns: 3, padding: 24, showSideMenu: true),
        jumboSmall:
            const LayoutConfig(columns: 4, padding: 28, showSideMenu: true),
        jumboNormal:
            const LayoutConfig(columns: 5, padding: 32, showSideMenu: true),
        jumboLarge:
            const LayoutConfig(columns: 6, padding: 36, showSideMenu: true),
        jumboExtraLarge:
            const LayoutConfig(columns: 8, padding: 40, showSideMenu: true),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Granular Value Builder Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const _GranularResponsiveContent(),
      ),
    );
  }
}

class _GranularResponsiveContent extends StatelessWidget {
  const _GranularResponsiveContent();

  @override
  Widget build(BuildContext context) {
    final config = ScreenSizeModelWithValue.responsiveValueOf<
        LayoutSizeGranular, LayoutConfig>(context);
    return _GranularLayout(config: config);
  }
}

class _GranularGrid extends StatelessWidget {
  const _GranularGrid({required this.config, required this.category});
  final LayoutConfig config;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: config.columns * 4,
      itemBuilder: (context, index) {
        return Card(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.grid_view,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  'Item ${index + 1}',
                  style: theme.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  category,
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

class _GranularList extends StatelessWidget {
  const _GranularList({required this.config, required this.category});
  final LayoutConfig config;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          color: theme.colorScheme.surfaceContainerHighest,
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            dense: config.padding < 10,
            leading: CircleAvatar(
              radius: config.padding < 10 ? 16 : 20,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: config.padding < 10 ? 12 : 14,
                ),
              ),
            ),
            title: Text(
              'Item ${index + 1}',
              style: config.padding < 10
                  ? theme.textTheme.bodyMedium
                  : theme.textTheme.titleMedium,
            ),
            subtitle: Text(
              '$category display • ${config.padding.toInt()}px padding',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: config.padding < 10 ? 14 : 16,
            ),
          ),
        );
      },
    );
  }
}

class _GranularSideMenu extends StatelessWidget {
  const _GranularSideMenu({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_open, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Granular Menu',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CategoryChip(category: category),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: const [
                _GranularMenuTile(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  subtitle: 'Overview',
                  isSelected: true,
                ),
                _GranularMenuTile(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  subtitle: 'Data insights',
                ),
                _GranularMenuTile(
                  icon: Icons.people,
                  title: 'Users',
                  subtitle: 'Management',
                ),
                _GranularMenuTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Configuration',
                ),
                _GranularMenuTile(
                  icon: Icons.help,
                  title: 'Help',
                  subtitle: 'Documentation',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GranularMenuTile extends StatelessWidget {
  const _GranularMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : null,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.7)
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      onTap: () {},
    );
  }
}

class _GranularLayout extends StatelessWidget {
  const _GranularLayout({required this.config});

  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenData =
        ScreenSizeModelWithValue.of<LayoutSizeGranular, LayoutConfig>(context);

    // Determine the category based on screen size
    final categoryLabel = _getCategoryLabel(screenData.screenSize);
    final sizeLabel = screenData.screenSize.toString().split('.').last;

    return Column(
      children: [
        // Header with granular screen information
        ScreenSizeHeader(
          sizeName: 'Granular Value Builder',
          range:
              'Fine-grained responsive control with 13 breakpoint categories organized into 4 logical groups.',
          category: categoryLabel,
          screenData: ScreenSizeModelData<LayoutSizeGranular>(
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
          customInfo: [
            ScreenSizeInfoItem(
              label: 'Size',
              value: sizeLabel,
              color: theme.colorScheme.secondary,
            ),
            ScreenSizeInfoItem(
              label: 'Padding',
              value: '${config.padding.toInt()}px',
              color: theme.colorScheme.error,
            ),
            if (config.showSideMenu)
              ScreenSizeInfoItem(
                label: 'Menu',
                value: 'Yes',
                color: theme.colorScheme.primary,
              ),
          ],
        ),

        // Main responsive content
        Expanded(
          child: Row(
            children: [
              if (config.showSideMenu) ...[
                _GranularSideMenu(category: categoryLabel),
                const VerticalDivider(width: 1),
              ],
              Expanded(
                child: Padding(
                  padding: config.paddingInsets,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContentHeader(config: config, category: categoryLabel),
                      const SizedBox(height: 16),
                      Expanded(
                        child: config.useGridLayout
                            ? _GranularGrid(
                                config: config,
                                category: categoryLabel,
                              )
                            : _GranularList(
                                config: config,
                                category: categoryLabel,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCategoryLabel(LayoutSizeGranular size) {
    switch (size) {
      case LayoutSizeGranular.tiny:
        return 'Tiny';
      case LayoutSizeGranular.compactSmall:
      case LayoutSizeGranular.compactNormal:
      case LayoutSizeGranular.compactLarge:
      case LayoutSizeGranular.compactExtraLarge:
        return 'Compact';
      case LayoutSizeGranular.standardSmall:
      case LayoutSizeGranular.standardNormal:
      case LayoutSizeGranular.standardLarge:
      case LayoutSizeGranular.standardExtraLarge:
        return 'Standard';
      case LayoutSizeGranular.jumboSmall:
      case LayoutSizeGranular.jumboNormal:
      case LayoutSizeGranular.jumboLarge:
      case LayoutSizeGranular.jumboExtraLarge:
        return 'Jumbo';
    }
  }
}

class _ContentHeader extends StatelessWidget {
  const _ContentHeader({
    required this.config,
    required this.category,
  });

  final LayoutConfig config;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          _getCategoryIcon(category),
          color: _getCategoryColor(context, category),
          size: 32,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$category Display',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                config.useGridLayout
                    ? '${config.columns}-column grid layout'
                    : 'Single-column list layout',
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

  Color _getCategoryColor(BuildContext context, String category) {
    final theme = Theme.of(context);
    switch (category.toLowerCase()) {
      case 'tiny':
        return theme.colorScheme.error;
      case 'compact':
        return theme.colorScheme.secondary;
      case 'standard':
        return theme.colorScheme.primary;
      case 'jumbo':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.outline;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tiny':
        return Icons.phone_android;
      case 'compact':
        return Icons.tablet_mac;
      case 'standard':
        return Icons.laptop_mac;
      case 'jumbo':
        return Icons.desktop_mac;
      default:
        return Icons.device_unknown;
    }
  }
}
