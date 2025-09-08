import 'package:example/shared/models/layout_config.dart';
import 'package:example/shared/widgets/screen_size_header.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSizeWithValueExample extends StatelessWidget {
  const ScreenSizeWithValueExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Example using ScreenSizeWithValue with LayoutConfig
    return ScreenSizeWithValue<LayoutSize, LayoutConfig>(
      breakpoints: const Breakpoints(
        small: 600,
        medium: 950,
        large: 1200,
        extraLarge: 1400,
      ),
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
          title: const Text('ScreenSizeWithValue Example'),
          backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: const _BodyContent(),
      ),
    );
  }
}

class _BodyContent extends StatelessWidget {
  const _BodyContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Access the responsive layout config from anywhere in the widget tree
    final layoutConfig =
        ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, LayoutConfig>(
      context,
    );
    final screenData =
        ScreenSizeModelWithValue.of<LayoutSize, LayoutConfig>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'ScreenSizeWithValue + LayoutConfig',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Demonstrates responsive layouts with LayoutConfig model. '
                    'Shows grids/lists and side menus based on screen size.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ScreenSizeInfoChip(
                        label: 'Screen Size',
                        value: screenData.screenSize.toString().split('.').last,
                        color: theme.colorScheme.primary,
                      ),
                      ScreenSizeInfoChip(
                        label: 'Columns',
                        value: layoutConfig.columns.toString(),
                        color: theme.colorScheme.secondary,
                      ),
                      ScreenSizeInfoChip(
                        label: 'Layout',
                        value: layoutConfig.useGridLayout ? 'Grid' : 'List',
                        color: theme.colorScheme.secondary,
                      ),
                      ScreenSizeInfoChip(
                        label: 'Side Menu',
                        value: layoutConfig.showSideMenu ? 'Yes' : 'No',
                        color: theme.colorScheme.tertiary,
                      ),
                      ScreenSizeInfoChip(
                        label: 'Width',
                        value:
                            '${screenData.logicalScreenWidth.toStringAsFixed(0)}px',
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              if (layoutConfig.showSideMenu) ...[
                const _SideMenu(),
                const VerticalDivider(width: 1),
              ],
              Expanded(
                child: Padding(
                  padding: layoutConfig.paddingInsets,
                  child: Column(
                    children: [
                      Text(
                        layoutConfig.useGridLayout
                            ? 'Grid with ${layoutConfig.columns} columns'
                            : 'List Layout',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: layoutConfig.useGridLayout
                            ? _ResponsiveGrid(config: layoutConfig)
                            : _ResponsiveList(config: layoutConfig),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Demonstrate nested access to responsive value
        const _NestedExample(),
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
      itemCount: config.columns * 4,
      itemBuilder: (context, index) {
        return Card(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard,
                  size: 32,
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
      itemCount: 12,
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
            title: Text('Item ${index + 1}'),
            subtitle: const Text('List item for mobile/small screens'),
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
      width: 280,
      color: theme.colorScheme.surfaceContainerLow,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.menu, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Side Navigation',
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
                  title: 'Home',
                  isSelected: true,
                ),
                _SideMenuTile(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                ),
                _SideMenuTile(
                  icon: Icons.analytics,
                  title: 'Analytics',
                ),
                _SideMenuTile(
                  icon: Icons.people,
                  title: 'Users',
                ),
                _SideMenuTile(
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

class _NestedExample extends StatelessWidget {
  const _NestedExample();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Access responsive layout config from deeply nested widget
    final layoutConfig =
        ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, LayoutConfig>(
      context,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This nested widget accesses the layout config: ${layoutConfig.columns} columns, '
                  '${layoutConfig.padding}px padding, side menu: ${layoutConfig.showSideMenu ? "enabled" : "disabled"}. '
                  'The LayoutConfig is available anywhere in the widget tree below ScreenSizeWithValue.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
