import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Convenience [BaseBreakpointsHandler] wired to the 12-size
/// [LayoutSizeGranular] enum.
class BreakpointsHandlerGranular<T>
    extends BaseBreakpointsHandler<T, LayoutSizeGranular> {
  BreakpointsHandlerGranular({
    super.breakpoints = BreakpointsGranular.defaultBreakpoints,
    super.onChanged,
    this.jumboExtraLarge,
    this.jumboLarge,
    this.jumboNormal,
    this.jumboSmall,
    this.standardExtraLarge,
    this.standardLarge,
    this.standardNormal,
    this.standardSmall,
    this.compactExtraLarge,
    this.compactLarge,
    this.compactNormal,
    this.compactSmall,
    this.tiny,
  }) : assert(
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
          'BreakpointsHandlerGranular requires at least one of the size arguments to be filled out',
        );

  final T? jumboExtraLarge;

  final T? jumboLarge;

  final T? jumboNormal;

  final T? jumboSmall;

  final T? standardExtraLarge;

  final T? standardLarge;

  final T? standardNormal;

  final T? standardSmall;

  final T? compactExtraLarge;

  final T? compactLarge;

  final T? compactNormal;

  final T? compactSmall;

  final T? tiny;

  /// Map of [LayoutSizeGranular] to the value used when that breakpoint
  /// is active.
  @override
  Map<LayoutSizeGranular, T?> get values => {
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
      };
}
