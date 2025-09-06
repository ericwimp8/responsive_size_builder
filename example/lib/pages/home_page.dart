import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../shared/widgets/screen_size_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          title: const Text('Responsive Size Builder Examples'),
          centerTitle: true,
          backgroundColor: theme.colorScheme.inversePrimary,
        ),
        body: ScreenSizeBuilder(
          extraSmall: (context, data) => _ResponsiveLayout(
            data: data,
            backgroundColor: theme.colorScheme.surface,
            columns: 1,
          ),
          small: (context, data) => _ResponsiveLayout(
            data: data,
            backgroundColor: theme.colorScheme.surface,
            columns: 1,
          ),
          medium: (context, data) => _ResponsiveLayout(
            data: data,
            backgroundColor: theme.colorScheme.surface,
            columns: 2,
          ),
          large: (context, data) => _ResponsiveLayout(
            data: data,
            backgroundColor: theme.colorScheme.surface,
            columns: 3,
          ),
          extraLarge: (context, data) => _ResponsiveLayout(
            data: data,
            backgroundColor: theme.colorScheme.surface,
            columns: 3,
          ),
        ),
      ),
    );
  }
}

class _ResponsiveLayout extends StatelessWidget {
  const _ResponsiveLayout({
    required this.data,
    required this.backgroundColor,
    required this.columns,
  });

  final ScreenSizeModelData data;
  final Color backgroundColor;
  final int columns;

  static const List<_ExampleData> _examples = [
    _ExampleData(
      title: 'ScreenSizeBuilder',
      subtitle: 'Basic responsive builder with 5 breakpoints',
      icon: Icons.view_quilt,
      route: '/screen-size-builder',
    ),
    _ExampleData(
      title: 'ScreenSizeOrientationBuilder',
      subtitle: 'Orientation-aware responsive layouts',
      icon: Icons.screen_rotation,
      route: '/screen-size-orientation-builder',
    ),
    _ExampleData(
      title: 'ScreenSizeBuilderGranular',
      subtitle: 'Fine-grained control with 13 breakpoints',
      icon: Icons.dashboard_customize,
      route: '/screen-size-builder-granular',
    ),
    _ExampleData(
      title: 'LayoutSizeBuilder',
      subtitle: 'Constraint-based responsive layouts',
      icon: Icons.view_compact,
      route: '/layout-size-builder',
    ),
    _ExampleData(
      title: 'ValueSizeBuilderGranular',
      subtitle: 'Responsive values with granular control',
      icon: Icons.straighten,
      route: '/value-size-builder-granular',
    ),
    _ExampleData(
      title: 'ScreenSizeWithValue',
      subtitle: 'Combine screen size with responsive values',
      icon: Icons.tune,
      route: '/screen-size-with-value',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = columns == 1 ? 16.0 : 20.0;

    return ColoredBox(
      color: backgroundColor,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(padding),
            sliver: SliverToBoxAdapter(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Responsive Size Builder Package',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: padding / 2),
                      Text(
                        'A Flutter package for building responsive layouts based on screen size. '
                        'Explore the examples below to see different responsive features in action.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: padding / 2),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ScreenSizeInfoChip(
                            label: 'Width',
                            value:
                                '${data.logicalScreenWidth.toStringAsFixed(0)}px',
                          ),
                          ScreenSizeInfoChip(
                            label: 'Columns',
                            value: columns.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: columns == 1 ? 4.5 : 3.0,
                crossAxisSpacing: padding / 2,
                mainAxisSpacing: padding / 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _ExampleTile(
                    title: _examples[index].title,
                    subtitle: _examples[index].subtitle,
                    icon: _examples[index].icon,
                    route: _examples[index].route,
                    isCompact: columns > 1,
                  );
                },
                childCount: _examples.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleData {
  const _ExampleData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.isCompact = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isCompact) {
      return Card(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 28,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
