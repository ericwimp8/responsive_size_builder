import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Shared typedefs and small mixins used across all responsive builders.

/// Widget builder that receives full screen size data.
typedef ScreenWidgetBuilderFn<T extends Enum> = Widget Function(
  BuildContext context,
  ScreenSizeModelData<T> data,
);

/// Widget builder that receives screen size data plus a responsive value.
typedef ScreenWithValueWidgetBuilderFn<T extends Enum, V extends Object?>
    = Widget Function(
  BuildContext context,
  ScreenSizeModelDataWithValue<T, V> data,
);

/// Value builder that may also receive screen data and responsive value when available.
typedef ScreenValueBuilderFn<K, T extends Enum, V extends Object?> = Widget
    Function(
  BuildContext context,
  K value, {
  ScreenSizeModelData<T>? data,
  V? responsiveValue,
});

/// Layout-oriented widget builder.
typedef LayoutWidgetBuilderFn = Widget Function(BuildContext context);

/// Layout-oriented value builder.
typedef LayoutValueBuilderFn<K> = Widget Function(
  BuildContext context,
  K value,
);

/// Mixin to optionally wrap children in an [AnimatedSwitcher].
mixin AnimatedChildMixin {
  bool get animateChange;

  Widget maybeAnimate(Widget child) => animateChange
      ? AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        )
      : child;
}

bool _hasAny<T>(Iterable<T?> values) =>
    values.any((element) => element != null);

/// Picks the orientation-specific payload, falling back to the other orientation
/// when the preferred one has no non-null entries.
R selectOrientationPayload<R>({
  required Orientation orientation,
  required R Function() portrait,
  required R Function() landscape,
}) {
  return orientation == Orientation.landscape ? landscape() : portrait();
}

/// Helper used by orientation builders to decide which set of breakpoint values
/// to use when one orientation is missing.
Map<K, V?> resolveOrientationValues<K extends Enum, V>({
  required Orientation orientation,
  required Map<K, V?> portrait,
  required Map<K, V?> landscape,
}) {
  final hasPortrait = _hasAny(portrait.values);
  final hasLandscape = _hasAny(landscape.values);

  if (orientation == Orientation.landscape) {
    if (hasLandscape) return landscape;
    if (hasPortrait) return portrait;
  } else {
    if (hasPortrait) return portrait;
    if (hasLandscape) return landscape;
  }

  throw FlutterError(
    'At least one breakpoint value must be provided for portrait or landscape.',
  );
}
