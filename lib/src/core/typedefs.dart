import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Shared typedefs and mixins used by the responsive builders.

/// Builds a widget from screen-size data.
typedef ScreenWidgetBuilderFn<T extends Enum> = Widget Function(
  BuildContext context,
  ScreenSizeModelData<T> data,
);

/// Builds a widget from screen-size data plus a responsive value.
typedef ScreenWithValueWidgetBuilderFn<T extends Enum, V extends Object?>
    = Widget Function(
  BuildContext context,
  ScreenSizeModelDataWithValue<T, V> data,
);

/// Builds a widget from a value, with screen data and a responsive value when available.
typedef ScreenValueBuilderFn<K, T extends Enum, V extends Object?> = Widget
    Function(
  BuildContext context,
  K value, {
  ScreenSizeModelData<T>? data,
  V? responsiveValue,
});

/// Builds a widget from layout context.
typedef LayoutWidgetBuilderFn = Widget Function(BuildContext context);

/// Builds a widget from layout context and a value.
typedef LayoutValueBuilderFn<K> = Widget Function(
  BuildContext context,
  K value,
);

/// Mixin that animates child changes with an [AnimatedSwitcher] when enabled.
mixin AnimatedChildMixin {
  /// Whether child changes should animate.
  bool get animateChange;

  /// Returns [child] wrapped in an [AnimatedSwitcher] when animation is enabled.
  Widget maybeAnimate(Widget child) => animateChange
      ? AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        )
      : child;
}

bool _hasAny<T>(Iterable<T?> values) =>
    values.any((element) => element != null);

/// Returns the active orientation payload, falling back to the other orientation when needed.
R selectOrientationPayload<R>({
  required Orientation orientation,
  required R Function() portrait,
  required R Function() landscape,
}) {
  return orientation == Orientation.landscape ? landscape() : portrait();
}

/// Returns the active orientation values, falling back to the other orientation when needed.
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
