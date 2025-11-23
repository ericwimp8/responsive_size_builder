import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Orientation-aware alias of [ScreenValueBuilderOrientation] when a
/// [ScreenSizeWithValue] provider is present in the tree.
class ScreenWithValueValueBuilderOrientation<K, V extends Object?>
    extends ScreenValueBuilderOrientation<K, V> {
  const ScreenWithValueValueBuilderOrientation({
    required super.builder,
    super.extraLarge,
    super.large,
    super.medium,
    super.small,
    super.extraSmall,
    super.extraLargeLandscape,
    super.largeLandscape,
    super.mediumLandscape,
    super.smallLandscape,
    super.extraSmallLandscape,
    super.breakpoints,
    super.key,
  });
}
