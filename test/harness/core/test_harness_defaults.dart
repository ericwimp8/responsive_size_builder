import 'package:flutter/material.dart';

typedef TearDownRegistrar = void Function(void Function());

enum TestViewportPreset { mobile, tablet, desktop }

final class TestHarnessDefaults {
  static const Locale locale = Locale('en');
  static const double devicePixelRatio = 1;
  static const Size mobileSize = Size(390, 844);
  static const Size tabletSize = Size(900, 1200);
  static const Size desktopSize = Size(1440, 900);

  static Size sizeFor(TestViewportPreset preset) {
    return switch (preset) {
      TestViewportPreset.mobile => mobileSize,
      TestViewportPreset.tablet => tabletSize,
      TestViewportPreset.desktop => desktopSize,
    };
  }

  static ThemeData theme() => ThemeData(useMaterial3: true);
}
