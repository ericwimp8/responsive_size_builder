// ignore_for_file: unreachable_from_main, unused_element

import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenSize<LayoutSizeGranular>(
      breakpoints: BreakpointsGranular.defaultBreakpoints,
      child: ScreenSize<LayoutSize>(
        breakpoints: Breakpoints.defaultBreakpoints,
        child: MaterialApp(
          title: 'Responsive Size Builder Demo',
          theme: ThemeData(
            listTileTheme: ListTileThemeData(
              tileColor: Colors.purple.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: const Text('Screen Size Builder'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const ScreenSizeBuilderDemo(),
                    ),
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

class ScreenSizeBuilderDemo extends StatelessWidget {
  const ScreenSizeBuilderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _Card(
            title: 'Screen Size Builder',
            child: ScreenSizeBuilder(
              extraLarge: (context, data) => Content(
                title: 'Extra Large',
              ),
              large: (context, data) => Content(
                title: 'Large',
              ),
              medium: (context, data) => Content(
                title: 'Medium',
              ),
              small: (context, data) => Content(
                title: 'Small',
              ),
              extraSmall: (context, data) => Content(
                title: 'Extra Small',
              ),
            ),
          ),
          _Card(
            title: 'Screen Size Builder Granular',
            child: ScreenSizeBuilderGranular(
              jumboExtraLarge: (context, data) => Content(
                title: 'Jumbo Extra Large',
              ),
              jumboLarge: (context, data) => Content(
                title: 'Jumbo Large',
              ),
              jumboNormal: (context, data) => Content(
                title: 'Jumbo Normal',
              ),
              jumboSmall: (context, data) => Content(
                title: 'Jumbo Small',
              ),
              standardExtraLarge: (context, data) => Content(
                title: 'Standard Extra Large',
              ),
              standardLarge: (context, data) => Content(
                title: 'Standard Large',
              ),
              standardNormal: (context, data) => Content(
                title: 'Standard Normal',
              ),
              standardSmall: (context, data) => Content(
                title: 'Standard Small',
              ),
              compactExtraLarge: (context, data) => Content(
                title: 'Compact Extra Large',
              ),
              compactLarge: (context, data) => Content(
                title: 'Compact Large',
              ),
              compactNormal: (context, data) => Content(
                title: 'Compact Normal',
              ),
              compactSmall: (context, data) => Content(
                title: 'Compact Small',
              ),
            ),
          ),
          _Card(
            title: 'Screen Size Orientation Builder',
            child: ScreenSizeOrientationBuilder(
              extraLarge: (context) => Content(
                title: 'Extra Large',
              ),
              large: (context) => Content(
                title: 'Large',
              ),
              medium: (context) => Content(
                title: 'Medium',
              ),
              small: (context) => Content(
                title: 'Small',
              ),
              extraSmall: (context) => Content(
                title: 'Extra Small',
              ),
              extraLargeLandscape: (context) => Content(
                title: 'Extra Large LandScape',
              ),
              largeLandscape: (context) => Content(
                title: 'Large LandScape',
              ),
              mediumLandscape: (context) => Content(
                title: 'Medium LandScape',
              ),
              smallLandscape: (context) => Content(
                title: 'Small LandScape',
              ),
              extraSmallLandscape: (context) => Content(
                title: 'Extra Small LandScape',
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _Card(
                  title: 'Layout Size Builder',
                  child: LayoutSizeBuilder(
                    extraLarge: (context) => Content(
                      title: 'Extra Large Layout One',
                    ),
                    large: (context) => Content(
                      title: 'Large Layout One',
                    ),
                    medium: (context) => Content(
                      title: 'Medium Layout One',
                    ),
                    small: (context) => Content(
                      title: 'Small Layout One',
                    ),
                    extraSmall: (context) => Content(
                      title: 'Extra Small Layout One',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _Card(
                  title: 'Layout Size Builder',
                  child: LayoutSizeBuilder(
                    extraLarge: (context) => Content(
                      title: 'Extra Large Layout Two',
                    ),
                    large: (context) => Content(
                      title: 'Large Layout Two',
                    ),
                    medium: (context) => Content(
                      title: 'Medium Layout Two',
                    ),
                    small: (context) => Content(
                      title: 'Small Layout Two',
                    ),
                    extraSmall: (context) => Content(
                      title: 'Extra Small Layout Two',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _Card(
                  title: 'Layout Size Builder Granular One',
                  child: LayoutSizeGranularBuilder(
                    jumboExtraLarge: (context, data) => Content(
                      title: 'Jumbo Extra Large Layout Granular One',
                    ),
                    jumboLarge: (context, data) => Content(
                      title: 'Jumbo Large Layout Granular One',
                    ),
                    jumboNormal: (context, data) => Content(
                      title: 'Jumbo Normal Layout Granular One',
                    ),
                    jumboSmall: (context, data) => Content(
                      title: 'Jumbo Small Layout Granular One',
                    ),
                    standardExtraLarge: (context, data) => Content(
                      title: 'Standard Extra Large Layout Granular One',
                    ),
                    standardLarge: (context, data) => Content(
                      title: 'Standard Large Layout Granular One',
                    ),
                    standardNormal: (context, data) => Content(
                      title: 'Standard Normal Layout Granular One',
                    ),
                    standardSmall: (context, data) => Content(
                      title: 'Standard Small Layout Granular One',
                    ),
                    compactExtraLarge: (context, data) => Content(
                      title: 'Compact Extra Large Layout Granular One',
                    ),
                    compactLarge: (context, data) => Content(
                      title: 'Compact Large Layout Granular One',
                    ),
                    compactNormal: (context, data) => Content(
                      title: 'Compact Normal Layout Granular One',
                    ),
                    compactSmall: (context, data) => Content(
                      title: 'Compact Small Layout Granular One',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _Card(
                  title: 'Layout Size Builder Granular Two',
                  child: LayoutSizeGranularBuilder(
                    jumboExtraLarge: (context, data) => Content(
                      title: 'Jumbo Extra Large Layout Granular Two',
                    ),
                    jumboLarge: (context, data) => Content(
                      title: 'Jumbo Large Layout Granular Two',
                    ),
                    jumboNormal: (context, data) => Content(
                      title: 'Jumbo Normal Layout Granular Two',
                    ),
                    jumboSmall: (context, data) => Content(
                      title: 'Jumbo Small Layout Granular Two',
                    ),
                    standardExtraLarge: (context, data) => Content(
                      title: 'Standard Extra Large Layout Granular Two',
                    ),
                    standardLarge: (context, data) => Content(
                      title: 'Standard Large Layout Granular Two',
                    ),
                    standardNormal: (context, data) => Content(
                      title: 'Standard Normal Layout Granular Two',
                    ),
                    standardSmall: (context, data) => Content(
                      title: 'Standard Small Layout Granular Two',
                    ),
                    compactExtraLarge: (context, data) => Content(
                      title: 'Compact Extra Large Layout Granular Two',
                    ),
                    compactLarge: (context, data) => Content(
                      title: 'Compact Large Layout Granular Two',
                    ),
                    compactNormal: (context, data) => Content(
                      title: 'Compact Normal Layout Granular Two',
                    ),
                    compactSmall: (context, data) => Content(
                      title: 'Compact Small Layout Granular Two',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  Content({required this.title, Key? key}) : super(key: key ?? ValueKey(title));
  final String title;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        widget.title,
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
