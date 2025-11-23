# Breaking Changes & Migration Guide

This refactor rebalances the API into a symmetric 24-wrapper matrix, removes duplicate builders, and reorganizes files. Use this document to migrate safely.

## High-Level Changes
- Naming now follows `<Source><Granularity><Payload><Orientation?>Builder`.
- Responsive-value builders are unified; the old `ValueSizeWithValueBuilder*` files were removed.
- Files live under `lib/src/{screen,screen_with_value,layout}/{standard,granular}/` and are re-exported from the package barrel.
- Orientation builders no longer require both portrait and landscape sets; they fall back to whichever is provided.

## Old -> New Class Map
- `ScreenSizeBuilder` -> `ScreenWidgetBuilder`
- `ScreenSizeBuilderGranular` -> `ScreenWidgetBuilderGranular`
- `ScreenSizeOrientationBuilder` -> `ScreenWidgetBuilderOrientation`
- `ScreenSizeWithValueBuilder` -> `ScreenWithValueWidgetBuilder`
- `ScreenSizeWithValueBuilderGranular` -> `ScreenWithValueWidgetBuilderGranular`
- `ScreenSizeWithValueOrientationBuilder` -> `ScreenWithValueWidgetBuilderOrientation`
- `ValueSizeBuilder` -> `ScreenValueBuilder`
- `ValueSizeBuilderGranular` -> `ScreenValueBuilderGranular`
- `ValueSizeWithValueBuilder*` -> **removed** (see Responsive Value Access)
- `LayoutSizeBuilder` -> `LayoutWidgetBuilder`
- `LayoutSizeBuilderGranular` -> `LayoutWidgetBuilderGranular`
- `LayoutValueSizeBuilder` -> `LayoutValueBuilder`
- `LayoutValueSizeBuilderGranular` -> `LayoutValueBuilderGranular`
- Added: orientation/value variants for every source/granularity pair.

## New Orientation Variants
- Screen: `ScreenWidgetBuilderOrientation`, `ScreenValueBuilderOrientation` (+ granular counterparts).
- ScreenWithValue: `ScreenWithValueWidgetBuilderOrientation`, `ScreenWithValueValueBuilderOrientation` (+ granular).
- Layout: `LayoutWidgetBuilderOrientation`, `LayoutValueBuilderOrientation` (+ granular).

## File & Export Notes
- Import through `package:responsive_size_builder/responsive_size_builder.dart`; it now exports only the new structure.
- Deleted files: all of `lib/src/value_size_with_value_builder/*`, old screen/screen_with_value builder files under `lib/src/screen_size/*` and `lib/src/responsive_value/*` (builder variants).

## Responsive Value Access (replacement for ValueSizeWithValueBuilder)
Wrap your subtree in `ScreenSizeWithValue<T,V>` and use `ScreenValueBuilder*` (standard/orientation/granular). Builder signature:
```dart
(BuildContext context, K value, {ScreenSizeModelData<T>? data, V? responsiveValue})
```
`responsiveValue` is non-null only when a `ScreenSizeWithValue` ancestor is present.

## Migration Steps
1. Rename classes/imports per map above; prefer barrel import to avoid path churn.
2. Replace any `ValueSizeWithValueBuilder*` usage with `ScreenValueBuilder*` inside a `ScreenSizeWithValue` provider if you need `responsiveValue`.
3. If you used orientation builders, you may now provide only one posture; the other falls back automatically.
4. Layout builders remain local-only. If you relied on screen data, switch to screen builders or pass needed data explicitly.
5. Re-run `dart format .` and `dart analyze` (already clean in repo); then `flutter test` / `flutter run example` to validate runtime.

## Concrete Migration Examples
- Widget (standard):
```diff
- ScreenSizeBuilder(
+ ScreenWidgetBuilder(
   medium: (context, data) => const Text('M'),
 )
```

- Orientation widget (granular):
```diff
- ScreenSizeOrientationBuilder(
+ ScreenWidgetBuilderGranularOrientation(
   smallLandscape: ..., small: ...,
 )
```

- Value with responsive value:
```diff
- ScreenSizeWithValueBuilder<int>(
-   medium: (context, data) => Text('${data.responsiveValue}')
- )
+ ScreenValueBuilder<int, int>(
     medium: (context, value, {responsiveValue, data}) =>
       Text('${responsiveValue ?? value}'),
   )
// wrap in ScreenSizeWithValue<LayoutSize, int>(valueProvider: ...)
```

- Layout widget:
```diff
- LayoutSizeBuilder(
+ LayoutWidgetBuilder(
   large: (context) => ..., 
 )
```

- Layout value:
```diff
- LayoutValueSizeBuilder<double>(
+ LayoutValueBuilder<double>(
   large: 20,
   builder: (context, value) => ...,
 )
```

## Behavioral Notes
- Breakpoint fallback behavior is unchanged (nearest non-null slot wins).
- `animateChange` still wraps widget outputs with `AnimatedSwitcher` (300 ms) on widget builders.
- Orientation builders reuse the available posture if the other is missing.

## Verification Checklist
- `dart format .`
- `dart analyze`
- `flutter test`
- `flutter run example`
