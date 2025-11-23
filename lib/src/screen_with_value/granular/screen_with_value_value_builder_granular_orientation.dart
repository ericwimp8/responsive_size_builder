import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware alias of [ScreenValueBuilderGranularOrientation] when a
/// [ScreenSizeWithValue] provider is present in the tree.
class ScreenWithValueValueBuilderGranularOrientation<K, V extends Object?>
    extends ScreenValueBuilderGranularOrientation<K, V> {
  const ScreenWithValueValueBuilderGranularOrientation({
    required super.builder,
    super.jumboExtraLarge,
    super.jumboLarge,
    super.jumboNormal,
    super.jumboSmall,
    super.standardExtraLarge,
    super.standardLarge,
    super.standardNormal,
    super.standardSmall,
    super.compactExtraLarge,
    super.compactLarge,
    super.compactNormal,
    super.compactSmall,
    super.tiny,
    super.jumboExtraLargeLandscape,
    super.jumboLargeLandscape,
    super.jumboNormalLandscape,
    super.jumboSmallLandscape,
    super.standardExtraLargeLandscape,
    super.standardLargeLandscape,
    super.standardNormalLandscape,
    super.standardSmallLandscape,
    super.compactExtraLargeLandscape,
    super.compactLargeLandscape,
    super.compactNormalLandscape,
    super.compactSmallLandscape,
    super.tinyLandscape,
    super.breakpoints,
    super.key,
  });
}
