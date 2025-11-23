import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Convenience alias of [ScreenValueBuilder] when a [ScreenSizeWithValue]
/// provider is present in the tree.
class ScreenWithValueValueBuilder<K, V extends Object?>
    extends ScreenValueBuilder<K, V> {
  const ScreenWithValueValueBuilder({
    required super.builder,
    super.extraLarge,
    super.large,
    super.medium,
    super.small,
    super.extraSmall,
    super.breakpoints,
    super.key,
  });
}
