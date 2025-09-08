import 'package:example/shared/models/layout_config.dart';
import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeWithValueBuilderExample extends StatelessWidget {
  const ScreenSizeWithValueBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSizeWithValue<LayoutSize, LayoutConfig>(
      breakpoints: Breakpoints.defaultBreakpoints,
      valueProvider: ResponsiveValue<LayoutConfig>(
        extraSmall: const LayoutConfig(columns: 1, padding: 8),
        small: const LayoutConfig(columns: 1, padding: 12),
        medium: const LayoutConfig(columns: 2, padding: 16),
        large: const LayoutConfig(columns: 3, padding: 24, showSideMenu: true),
        extraLarge:
            const LayoutConfig(columns: 4, padding: 32, showSideMenu: true),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ScreenSizeWithValueBuilder Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const _ResponsiveContent(),
      ),
    );
  }
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) {
    return ScreenSizeWithValueBuilder<LayoutConfig>(
      // Each builder now gets the LayoutConfig from the ScreenSizeWithValue provider
      extraSmall: (context, data) => _LayoutWidget(
        data: data,
        screenSizeLabel: 'Extra Small Screen',
      ),
      small: (context, data) => _LayoutWidget(
        data: data,
        screenSizeLabel: 'Small Screen',
      ),
      medium: (context, data) => _LayoutWidget(
        data: data,
        screenSizeLabel: 'Medium Screen',
      ),
      large: (context, data) => _LayoutWidget(
        data: data,
        screenSizeLabel: 'Large Screen',
      ),
      extraLarge: (context, data) => _LayoutWidget(
        data: data,
        screenSizeLabel: 'Extra Large Screen',
      ),
      animateChange: true,
    );
  }
}

class _LayoutWidget extends StatelessWidget {
  const _LayoutWidget({
    required this.data,
    required this.screenSizeLabel,
  });

  final ScreenSizeModelDataWithValue<LayoutSize, LayoutConfig> data;
  final String screenSizeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = data.responsiveValue;

    return Column(
      children: [
        // Header with screen information
        ScreenSizeHeader(
          sizeName: 'ScreenSizeWithValueBuilder',
          range:
              'Each screen size has its own builder function with access to screen data and responsive values.',
          screenData: ScreenSizeModelData(
            breakpoints: data.breakpoints,
            currentBreakpoint: data.currentBreakpoint,
            screenSize: data.screenSize,
            physicalWidth: data.physicalWidth,
            physicalHeight: data.physicalHeight,
            devicePixelRatio: data.devicePixelRatio,
            logicalScreenWidth: data.logicalScreenWidth,
            logicalScreenHeight: data.logicalScreenHeight,
            orientation: data.orientation,
          ),
          columns: config.columns,
          customInfo: [
            ScreenSizeInfoItem(
              label: 'Screen Size',
              value: screenSizeLabel,
              color: theme.colorScheme.primary,
            ),
            ScreenSizeInfoItem(
              label: 'Padding',
              value: '${config.padding.toInt()}px',
              color: theme.colorScheme.tertiary,
            ),
            if (config.showSideMenu)
              ScreenSizeInfoItem(
                label: 'Side Menu',
                value: 'Enabled',
                color: theme.colorScheme.error,
              ),
          ],
        ),

        // Main content area with responsive layout
        Expanded(
          child: Row(
            children: [
              if (config.showSideMenu) ...[
                const _SideMenu(),
                const VerticalDivider(width: 1),
              ],
              Expanded(
                child: Padding(
                  padding: config.paddingInsets,
                  child: Column(
                    children: [
                      Text(
                        config.useGridLayout
                            ? 'Grid Layout (${config.columns} columns)'
                            : 'List Layout',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: config.useGridLayout
                            ? _ResponsiveGrid(config: config)
                            : _ResponsiveList(config: config),
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
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({required this.config});
  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: config.columns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: config.columns * 3,
      itemBuilder: (context, index) {
        return Card(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.widgets,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Grid ${index + 1}',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  '${config.columns} cols',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ResponsiveList extends StatelessWidget {
  const _ResponsiveList({required this.config});
  final LayoutConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Card(
          color: theme.colorScheme.surfaceContainerHighest,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                '${index + 1}',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
            ),
            title: Text('List Item ${index + 1}'),
            subtitle: Text(
              'Mobile-optimized list with ${config.padding.toInt()}px padding',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 250,
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.dashboard, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Desktop Menu',
                  style: theme.textTheme.titleLarge?.copyWith(
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
                _SideMenuTile(
                  icon: Icons.home,
                  title: 'Overview',
                  isSelected: true,
                ),
                _SideMenuTile(
                  icon: Icons.build,
                  title: 'Builders',
                ),
                _SideMenuTile(
                  icon: Icons.view_quilt,
                  title: 'Responsive',
                ),
                _SideMenuTile(
                  icon: Icons.phone_android,
                  title: 'Mobile',
                ),
                _SideMenuTile(
                  icon: Icons.computer,
                  title: 'Desktop',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SideMenuTile extends StatelessWidget {
  const _SideMenuTile({
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
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : null,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      onTap: () {},
    );
  }
}
