import 'package:example/pages/home_page.dart';
import 'package:example/pages/layout_size_builder_example.dart';
import 'package:example/pages/layout_value_size_builder_example.dart';
import 'package:example/pages/screen_size_builder_example.dart';
import 'package:example/pages/screen_size_builder_granular_example.dart';
import 'package:example/pages/screen_size_orientation_builder_example.dart';
import 'package:example/pages/screen_size_with_value_builder_example.dart';
import 'package:example/pages/screen_size_with_value_example.dart';
import 'package:example/pages/screen_size_with_value_granular_builder_example.dart';
import 'package:example/pages/screen_size_with_value_orientation_builder_example.dart';
import 'package:example/pages/theme.dart';
import 'package:example/pages/value_size_builder_example.dart';
import 'package:example/pages/value_size_builder_granular_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const textTheme = TextTheme();
    const materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Responsive Size Builder Demo',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/screen-size-builder': (context) => const ScreenSizeBuilderExample(),
        '/screen-size-orientation-builder': (context) =>
            const ScreenSizeOrientationBuilderExample(),
        '/screen-size-builder-granular': (context) =>
            const ScreenSizeBuilderGranularExample(),
        '/layout-size-builder': (context) => const LayoutSizeBuilderExample(),
        '/layout-value-size-builder': (context) =>
            const LayoutValueSizeBuilderExample(),
        '/value-size-builder': (context) => const ValueSizeBuilderExample(),
        '/value-size-builder-granular': (context) =>
            const ValueSizeBuilderGranularExample(),
        '/screen-size-with-value': (context) =>
            const ScreenSizeWithValueExample(),
        '/screen-size-with-value-builder': (context) =>
            const ScreenSizeWithValueBuilderExample(),
        '/screen-size-with-value-granular-builder': (context) =>
            const ScreenSizeWithValueBuilderGranularExample(),
        '/screen-size-with-value-orientation-builder': (context) =>
            const ScreenSizeWithValueOrientationBuilderExample(),
      },
    );
  }
}
