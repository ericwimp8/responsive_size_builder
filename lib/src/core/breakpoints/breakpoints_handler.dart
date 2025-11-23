import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Convenience [BaseBreakpointsHandler] wired to the 5-size [LayoutSize] enum.
class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize> {
  BreakpointsHandler({
    super.breakpoints = Breakpoints.defaultBreakpoints,
    super.onChanged,
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
  }) : assert(
          extraLarge != null ||
              large != null ||
              medium != null ||
              small != null ||
              extraSmall != null,
          'BreakpointsHandler requires at least one of the size arguments to be filled out',
        );

  final T? extraLarge;

  final T? large;

  final T? medium;

  final T? small;

  final T? extraSmall;

  /// Map of [LayoutSize] to the value used when that breakpoint is active.
  @override
  Map<LayoutSize, T?> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: extraSmall,
      };
}
