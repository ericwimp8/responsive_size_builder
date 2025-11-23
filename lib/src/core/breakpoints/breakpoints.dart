import 'package:flutter/foundation.dart';

/// Base contract for a breakpoint configuration mapping enum values to
/// logical pixel thresholds.
abstract class BaseBreakpoints<T extends Enum> {
  const BaseBreakpoints();

  /// Map from the enum breakpoint to the minimum logical pixel size
  /// (typically width) required for that breakpoint.
  Map<T, double> get values;
}

/// Simple breakpoint set for the common 5-size layout model.
@immutable
class Breakpoints implements BaseBreakpoints<LayoutSize> {
  const Breakpoints({
    this.extraLarge = 1200.0,
    this.large = 950.0,
    this.medium = 600.0,
    this.small = 200.0,
  }) : assert(
          extraLarge > large && large > medium && medium > small && small >= 0,
          'Breakpoints must be in decending order and larger than or equal to 0.',
        );

  /// Minimum logical width for [LayoutSize.extraLarge].
  final double extraLarge;

  /// Minimum logical width for [LayoutSize.large].
  final double large;

  /// Minimum logical width for [LayoutSize.medium].
  final double medium;

  /// Minimum logical width for [LayoutSize.small].
  final double small;

  /// Default breakpoint configuration used by all standard builders.
  static const defaultBreakpoints = Breakpoints();

  @override
  Map<LayoutSize, double> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: -1,
      };

  @override
  String toString() {
    return 'Breakpoints(extraLarge: $extraLarge, large: $large, medium: $medium, small: $small)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Breakpoints &&
        other.extraLarge == extraLarge &&
        other.large == large &&
        other.medium == medium &&
        other.small == small;
  }

  @override
  int get hashCode => Object.hash(extraLarge, large, medium, small);

  Breakpoints copyWith({
    double? extraLarge,
    double? large,
    double? medium,
    double? small,
  }) {
    return Breakpoints(
      extraLarge: extraLarge ?? this.extraLarge,
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
    );
  }
}

/// More granular breakpoint set with 12 sizes spanning jumbo, standard and
/// compact device classes.
@immutable
class BreakpointsGranular implements BaseBreakpoints<LayoutSizeGranular> {
  const BreakpointsGranular({
    this.jumboExtraLarge = 4096.0,
    this.jumboLarge = 3840.0,
    this.jumboNormal = 2560.0,
    this.jumboSmall = 1920.0,
    this.standardExtraLarge = 1280.0,
    this.standardLarge = 1024.0,
    this.standardNormal = 768.0,
    this.standardSmall = 568.0,
    this.compactExtraLarge = 480.0,
    this.compactLarge = 430.0,
    this.compactNormal = 360.0,
    this.compactSmall = 300.0,
  }) : assert(
          jumboExtraLarge > jumboLarge &&
              jumboLarge > jumboNormal &&
              jumboNormal > jumboSmall &&
              jumboSmall > standardExtraLarge &&
              standardExtraLarge > standardLarge &&
              standardLarge > standardNormal &&
              standardNormal > standardSmall &&
              standardSmall > compactExtraLarge &&
              compactExtraLarge > compactLarge &&
              compactLarge > compactNormal &&
              compactNormal > compactSmall &&
              compactSmall >= 0,
          'Breakpoints must be in decending order and larger than or equal to 0',
        );

  final double jumboExtraLarge;

  final double jumboLarge;

  final double jumboNormal;

  final double jumboSmall;

  final double standardExtraLarge;

  final double standardLarge;

  final double standardNormal;

  final double standardSmall;

  final double compactExtraLarge;

  final double compactLarge;

  final double compactNormal;

  final double compactSmall;

  /// Default breakpoint configuration used by all granular builders.
  static const defaultBreakpoints = BreakpointsGranular();

  @override
  Map<LayoutSizeGranular, double> get values => {
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
        LayoutSizeGranular.tiny: -1,
      };

  BreakpointsGranular copyWith({
    double? jumboExtraLarge,
    double? jumboLarge,
    double? jumboNormal,
    double? jumboSmall,
    double? standardExtraLarge,
    double? standardLarge,
    double? standardNormal,
    double? standardSmall,
    double? compactExtraLarge,
    double? compactLarge,
    double? compactNormal,
    double? compactSmall,
  }) {
    return BreakpointsGranular(
      jumboExtraLarge: jumboExtraLarge ?? this.jumboExtraLarge,
      jumboLarge: jumboLarge ?? this.jumboLarge,
      jumboNormal: jumboNormal ?? this.jumboNormal,
      jumboSmall: jumboSmall ?? this.jumboSmall,
      standardExtraLarge: standardExtraLarge ?? this.standardExtraLarge,
      standardLarge: standardLarge ?? this.standardLarge,
      standardNormal: standardNormal ?? this.standardNormal,
      standardSmall: standardSmall ?? this.standardSmall,
      compactExtraLarge: compactExtraLarge ?? this.compactExtraLarge,
      compactLarge: compactLarge ?? this.compactLarge,
      compactNormal: compactNormal ?? this.compactNormal,
      compactSmall: compactSmall ?? this.compactSmall,
    );
  }

  @override
  String toString() {
    return 'BreakpointsGranular(jumboExtraLarge: $jumboExtraLarge, jumboLarge: $jumboLarge, jumboNormal: $jumboNormal, jumboSmall: $jumboSmall, standardExtraLarge: $standardExtraLarge, standardLarge: $standardLarge, standardNormal: $standardNormal, standardSmall: $standardSmall, compactExtraLarge: $compactExtraLarge, compactLarge: $compactLarge, compactNormal: $compactNormal, compactSmall: $compactSmall)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BreakpointsGranular &&
        other.jumboExtraLarge == jumboExtraLarge &&
        other.jumboLarge == jumboLarge &&
        other.jumboNormal == jumboNormal &&
        other.jumboSmall == jumboSmall &&
        other.standardExtraLarge == standardExtraLarge &&
        other.standardLarge == standardLarge &&
        other.standardNormal == standardNormal &&
        other.standardSmall == standardSmall &&
        other.compactExtraLarge == compactExtraLarge &&
        other.compactLarge == compactLarge &&
        other.compactNormal == compactNormal &&
        other.compactSmall == compactSmall;
  }

  @override
  int get hashCode => Object.hash(
        jumboExtraLarge.hashCode,
        jumboLarge.hashCode,
        jumboNormal.hashCode,
        jumboSmall.hashCode,
        standardExtraLarge.hashCode,
        standardLarge.hashCode,
        standardNormal.hashCode,
        standardSmall.hashCode,
        compactExtraLarge.hashCode,
        compactLarge.hashCode,
        compactNormal.hashCode,
        compactSmall.hashCode,
      );
}

enum LayoutSize {
  /// Very wide layouts such as large desktop windows.
  extraLarge,

  /// Large layouts, e.g. landscape tablets or medium desktop windows.
  large,

  /// Medium layouts such as portrait tablets or large phones.
  medium,

  /// Small layouts (typical phone width).
  small,

  /// Extra small layouts below [Breakpoints.small].
  extraSmall,
}

enum LayoutSizeGranular {
  /// Largest "jumbo" layout (e.g. ultra-wide monitors).
  jumboExtraLarge,

  /// Large jumbo layout.
  jumboLarge,

  /// Normal jumbo layout.
  jumboNormal,

  /// Small jumbo layout.
  jumboSmall,

  /// Extra large standard layout.
  standardExtraLarge,

  /// Large standard layout.
  standardLarge,

  /// Normal standard layout.
  standardNormal,

  /// Small standard layout.
  standardSmall,

  /// Extra large compact layout.
  compactExtraLarge,

  /// Large compact layout.
  compactLarge,

  /// Normal compact layout.
  compactNormal,

  /// Small compact layout.
  compactSmall,

  /// Below the smallest compact breakpoint.
  tiny,
}
