// ignore_for_file: unreachable_from_main, unused_element

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

Color randomColor() {
  return Color(math.Random().nextInt(0xffffffff)).withAlpha(0xff);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenSize(
      breakpoints: BreakpointsGranular.defaultBreakpoints,
      child: ScreenSize(
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
            ),
          ),
          _Card(
            title: 'Screen Size Builder Granular',
            child: ScreenSizeBuilderGranular(
              jumboExtraLarge: (context) => Content(
                title: 'Jumbo Extra Large',
              ),
              jumboLarge: (context) => Content(
                title: 'Jumbo Large',
              ),
              jumboNormal: (context) => Content(
                title: 'Jumbo Normal',
              ),
              jumboSmall: (context) => Content(
                title: 'Jumbo Small',
              ),
              standardExtraLarge: (context) => Content(
                title: 'Standard Extra Large',
              ),
              standardLarge: (context) => Content(
                title: 'Standard Large',
              ),
              standardNormal: (context) => Content(
                title: 'Standard Normal',
              ),
              standardSmall: (context) => Content(
                title: 'Standard Small',
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
                    jumboExtraLarge: (context) => Content(
                      title: 'Jumbo Extra Large Layout Granular One',
                    ),
                    jumboLarge: (context) => Content(
                      title: 'Jumbo Large Layout Granular One',
                    ),
                    jumboNormal: (context) => Content(
                      title: 'Jumbo Normal Layout Granular One',
                    ),
                    jumboSmall: (context) => Content(
                      title: 'Jumbo Small Layout Granular One',
                    ),
                    standardExtraLarge: (context) => Content(
                      title: 'Standard Extra Large Layout Granular One',
                    ),
                    standardLarge: (context) => Content(
                      title: 'Standard Large Layout Granular One',
                    ),
                    standardNormal: (context) => Content(
                      title: 'Standard Normal Layout Granular One',
                    ),
                    standardSmall: (context) => Content(
                      title: 'Standard Small Layout Granular One',
                    ),
                    compactExtraLarge: (context) => Content(
                      title: 'Compact Extra Large Layout Granular One',
                    ),
                    compactLarge: (context) => Content(
                      title: 'Compact Large Layout Granular One',
                    ),
                    compactNormal: (context) => Content(
                      title: 'Compact Normal Layout Granular One',
                    ),
                    compactSmall: (context) => Content(
                      title: 'Compact Small Layout Granular One',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _Card(
                  title: 'Layout Size Builder Granular Two',
                  child: LayoutSizeGranularBuilder(
                    jumboExtraLarge: (context) => Content(
                      title: 'Jumbo Extra Large Layout Granular Two',
                    ),
                    jumboLarge: (context) => Content(
                      title: 'Jumbo Large Layout Granular Two',
                    ),
                    jumboNormal: (context) => Content(
                      title: 'Jumbo Normal Layout Granular Two',
                    ),
                    jumboSmall: (context) => Content(
                      title: 'Jumbo Small Layout Granular Two',
                    ),
                    standardExtraLarge: (context) => Content(
                      title: 'Standard Extra Large Layout Granular Two',
                    ),
                    standardLarge: (context) => Content(
                      title: 'Standard Large Layout Granular Two',
                    ),
                    standardNormal: (context) => Content(
                      title: 'Standard Normal Layout Granular Two',
                    ),
                    standardSmall: (context) => Content(
                      title: 'Standard Small Layout Granular Two',
                    ),
                    compactExtraLarge: (context) => Content(
                      title: 'Compact Extra Large Layout Granular Two',
                    ),
                    compactLarge: (context) => Content(
                      title: 'Compact Large Layout Granular Two',
                    ),
                    compactNormal: (context) => Content(
                      title: 'Compact Normal Layout Granular Two',
                    ),
                    compactSmall: (context) => Content(
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
  late final color = randomColor();
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
