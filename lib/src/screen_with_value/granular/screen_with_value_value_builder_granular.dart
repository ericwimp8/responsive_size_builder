import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Convenience alias of [ScreenValueBuilderGranular] when a
/// [ScreenSizeWithValue] provider is present in the tree.
class ScreenWithValueValueBuilderGranular<K, V extends Object?>
    extends ScreenValueBuilderGranular<K, V> {
  const ScreenWithValueValueBuilderGranular({
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
    super.breakpoints,
    super.key,
  });
}
