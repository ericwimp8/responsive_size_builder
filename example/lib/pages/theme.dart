import 'package:flutter/material.dart';

class MaterialTheme {
  const MaterialTheme(this.textTheme);
  final TextTheme textTheme;

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5141b8),
      surfaceTint: Color(0xff5b4cc2),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6a5bd2),
      onPrimaryContainer: Color(0xfff2edff),
      secondary: Color(0xff5e5987),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd0c9fe),
      onSecondaryContainer: Color(0xff585280),
      tertiary: Color(0xff8d2c81),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffaa469b),
      onTertiaryContainer: Color(0xffffebf6),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff1c1b22),
      onSurfaceVariant: Color(0xff474553),
      outline: Color(0xff787584),
      outlineVariant: Color(0xffc9c4d5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff312f37),
      inversePrimary: Color(0xffc7bfff),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff180065),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff4331a9),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff1a1540),
      secondaryFixedDim: Color(0xffc7c0f6),
      onSecondaryFixedVariant: Color(0xff46416e),
      tertiaryFixed: Color(0xffffd7f2),
      onTertiaryFixed: Color(0xff390034),
      tertiaryFixedDim: Color(0xffffaceb),
      onTertiaryFixedVariant: Color(0xff7c1b71),
      surfaceDim: Color(0xffddd8e3),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f2fc),
      surfaceContainer: Color(0xfff1ecf7),
      surfaceContainerHigh: Color(0xffebe6f1),
      surfaceContainerHighest: Color(0xffe5e1eb),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff321a99),
      surfaceTint: Color(0xff5b4cc2),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6a5bd2),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff35305c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6d6797),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff67005f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffaa469b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff111017),
      onSurfaceVariant: Color(0xff373542),
      outline: Color(0xff53515f),
      outlineVariant: Color(0xff6e6b7a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff312f37),
      inversePrimary: Color(0xffc7bfff),
      primaryFixed: Color(0xff6a5bd2),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff5141b8),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6d6797),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff544f7d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffaa469b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff8d2c81),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc9c5cf),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f2fc),
      surfaceContainer: Color(0xffebe6f1),
      surfaceContainerHigh: Color(0xffdfdbe6),
      surfaceContainerHighest: Color(0xffd4d0da),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff27048f),
      surfaceTint: Color(0xff5b4cc2),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4634ac),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2b2651),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff494471),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff56004f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7f1e74),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2c2b38),
      outlineVariant: Color(0xff4a4755),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff312f37),
      inversePrimary: Color(0xffc7bfff),
      primaryFixed: Color(0xff4634ac),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2e1495),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff494471),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff322d58),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7f1e74),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff610059),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb7c1),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4effa),
      surfaceContainer: Color(0xffe5e1eb),
      surfaceContainerHigh: Color(0xffd7d3dd),
      surfaceContainerHighest: Color(0xffc9c5cf),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc7bfff),
      surfaceTint: Color(0xffc7bfff),
      onPrimary: Color(0xff2c0f93),
      primaryContainer: Color(0xff6a5bd2),
      onPrimaryContainer: Color(0xfff2edff),
      secondary: Color(0xffc7c0f6),
      onSecondary: Color(0xff302b56),
      secondaryContainer: Color(0xff46416e),
      onSecondaryContainer: Color(0xffb6afe3),
      tertiary: Color(0xffffaceb),
      onTertiary: Color(0xff5d0056),
      tertiaryContainer: Color(0xffaa469b),
      onTertiaryContainer: Color(0xffffebf6),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff14121a),
      onSurface: Color(0xffe5e1eb),
      onSurfaceVariant: Color(0xffc9c4d5),
      outline: Color(0xff928f9f),
      outlineVariant: Color(0xff474553),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e1eb),
      inversePrimary: Color(0xff5b4cc2),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff180065),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff4331a9),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff1a1540),
      secondaryFixedDim: Color(0xffc7c0f6),
      onSecondaryFixedVariant: Color(0xff46416e),
      tertiaryFixed: Color(0xffffd7f2),
      onTertiaryFixed: Color(0xff390034),
      tertiaryFixedDim: Color(0xffffaceb),
      onTertiaryFixedVariant: Color(0xff7c1b71),
      surfaceDim: Color(0xff14121a),
      surfaceBright: Color(0xff3a3840),
      surfaceContainerLowest: Color(0xff0e0d14),
      surfaceContainerLow: Color(0xff1c1b22),
      surfaceContainer: Color(0xff201f26),
      surfaceContainerHigh: Color(0xff2a2931),
      surfaceContainerHighest: Color(0xff35343c),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffded8ff),
      surfaceTint: Color(0xffc7bfff),
      onPrimary: Color(0xff210081),
      primaryContainer: Color(0xff8e80f9),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffded8ff),
      onSecondary: Color(0xff25204a),
      secondaryContainer: Color(0xff918bbd),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffcef0),
      onTertiary: Color(0xff4a0044),
      tertiaryContainer: Color(0xffd46ac1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff14121a),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdfdaeb),
      outline: Color(0xffb4b0c0),
      outlineVariant: Color(0xff928e9e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e1eb),
      inversePrimary: Color(0xff4432aa),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff0e0048),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff321a99),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff100935),
      secondaryFixedDim: Color(0xffc7c0f6),
      onSecondaryFixedVariant: Color(0xff35305c),
      tertiaryFixed: Color(0xffffd7f2),
      onTertiaryFixed: Color(0xff270024),
      tertiaryFixedDim: Color(0xffffaceb),
      onTertiaryFixedVariant: Color(0xff67005f),
      surfaceDim: Color(0xff14121a),
      surfaceBright: Color(0xff45434c),
      surfaceContainerLowest: Color(0xff07070d),
      surfaceContainerLow: Color(0xff1e1d24),
      surfaceContainer: Color(0xff28272f),
      surfaceContainerHigh: Color(0xff33323a),
      surfaceContainerHighest: Color(0xff3e3d45),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff3edff),
      surfaceTint: Color(0xffc7bfff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc3bbff),
      onPrimaryContainer: Color(0xff090038),
      secondary: Color(0xfff3edff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc4bcf1),
      onSecondaryContainer: Color(0xff0a0330),
      tertiary: Color(0xffffeaf6),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffa5eb),
      onTertiaryContainer: Color(0xff1d001a),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff14121a),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff3edff),
      outlineVariant: Color(0xffc5c0d1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e1eb),
      inversePrimary: Color(0xff4432aa),
      primaryFixed: Color(0xffe4dfff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc7bfff),
      onPrimaryFixedVariant: Color(0xff0e0048),
      secondaryFixed: Color(0xffe4dfff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc7c0f6),
      onSecondaryFixedVariant: Color(0xff100935),
      tertiaryFixed: Color(0xffffd7f2),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffaceb),
      onTertiaryFixedVariant: Color(0xff270024),
      surfaceDim: Color(0xff14121a),
      surfaceBright: Color(0xff514f57),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f26),
      surfaceContainer: Color(0xff312f37),
      surfaceContainerHigh: Color(0xff3c3a43),
      surfaceContainerHighest: Color(0xff47464e),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
