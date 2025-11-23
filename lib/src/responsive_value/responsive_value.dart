import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Base class for computing a breakpoint-aware responsive value independent
/// of widgets or layout.
abstract class BaseResponsiveValue<T extends Enum, V extends Object?>
    extends BaseBreakpointsHandler<V, T> {
  BaseResponsiveValue({
    required super.breakpoints,
    required Map<T, V?> values,
  }) : _values = values;

  final Map<T, V?> _values;

  @override
  Map<T, V?> get values => _values;
}

/// Simple breakpoint-based value resolver for the 5-size [LayoutSize] enum.
class ResponsiveValue<V extends Object?>
    extends BaseResponsiveValue<LayoutSize, V> {
  ResponsiveValue({
    Breakpoints breakpoints = Breakpoints.defaultBreakpoints,
    V? extraLarge,
    V? large,
    V? medium,
    V? small,
    V? extraSmall,
  })  : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'ResponsiveValue requires at least one of the size arguments to be filled out',
        ),
        super(
          breakpoints: breakpoints,
          values: {
            LayoutSize.extraLarge: extraLarge,
            LayoutSize.large: large,
            LayoutSize.medium: medium,
            LayoutSize.small: small,
            LayoutSize.extraSmall: extraSmall,
          },
        );
}

/// Granular breakpoint-based value resolver for the 12-size
/// [LayoutSizeGranular] enum.
class ResponsiveValueGranular<V extends Object?>
    extends BaseResponsiveValue<LayoutSizeGranular, V> {
  ResponsiveValueGranular({
    BreakpointsGranular breakpoints = BreakpointsGranular.defaultBreakpoints,
    V? jumboExtraLarge,
    V? jumboLarge,
    V? jumboNormal,
    V? jumboSmall,
    V? standardExtraLarge,
    V? standardLarge,
    V? standardNormal,
    V? standardSmall,
    V? compactExtraLarge,
    V? compactLarge,
    V? compactNormal,
    V? compactSmall,
    V? tiny,
  })  : assert(
          jumboExtraLarge != null ||
              jumboLarge != null ||
              jumboNormal != null ||
              jumboSmall != null ||
              standardExtraLarge != null ||
              standardLarge != null ||
              standardNormal != null ||
              standardSmall != null ||
              compactExtraLarge != null ||
              compactLarge != null ||
              compactNormal != null ||
              compactSmall != null ||
              tiny != null,
          'ResponsiveValueGranular requires at least one of the size arguments to be filled out',
        ),
        super(
          breakpoints: breakpoints,
          values: {
            LayoutSizeGranular.jumboExtraLarge: jumboExtraLarge,
            LayoutSizeGranular.jumboLarge: jumboLarge,
            LayoutSizeGranular.jumboNormal: jumboNormal,
            LayoutSizeGranular.jumboSmall: jumboSmall,
            LayoutSizeGranular.standardExtraLarge: standardExtraLarge,
            LayoutSizeGranular.standardLarge: standardLarge,
            LayoutSizeGranular.standardNormal: standardNormal,
            LayoutSizeGranular.standardSmall: standardSmall,
            LayoutSizeGranular.compactExtraLarge: compactExtraLarge,
            LayoutSizeGranular.compactLarge: compactLarge,
            LayoutSizeGranular.compactNormal: compactNormal,
            LayoutSizeGranular.compactSmall: compactSmall,
            LayoutSizeGranular.tiny: tiny,
          },
        );
}
