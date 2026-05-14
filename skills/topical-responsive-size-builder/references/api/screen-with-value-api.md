# Screen With Value API

Use screen-with-value APIs when a full-window breakpoint should also provide a
shared responsive value to a subtree.

## Provide shared responsive config

`ScreenSizeWithValue`

Use `ScreenSizeWithValue<LayoutSize, T>` when multiple descendants need the same
responsive value object.

Good fits:
- `LayoutConfig(columns, padding, showSideMenu)`
- pane count and pane spacing
- navigation mode
- density or component sizing model
- values that must stay consistent across nested widgets

```dart
ScreenSizeWithValue<LayoutSize, LayoutConfig>(
  breakpoints: Breakpoints.defaultBreakpoints,
  valueProvider: ResponsiveValue<LayoutConfig>(
    extraSmall: const LayoutConfig(columns: 1, padding: 12),
    medium: const LayoutConfig(columns: 2, padding: 16),
    large: const LayoutConfig(
      columns: 3,
      padding: 24,
      showSideMenu: true,
    ),
  ),
  child: const FeatureShell(),
)
```

Prefer this over repeated value builders when the values represent one coherent
layout contract.

## Define breakpoint values

`ResponsiveValue`

Use `ResponsiveValue<T>` to map standard `LayoutSize` breakpoints to one value
type.

```dart
final valueProvider = ResponsiveValue<LayoutConfig>(
  extraSmall: const LayoutConfig(columns: 1, padding: 12),
  medium: const LayoutConfig(columns: 2, padding: 16),
  large: const LayoutConfig(columns: 3, padding: 24),
);
```

Design the value type as plain layout data. Good fields include `columns`,
`padding`, `showSideMenu`, `contentMaxWidth`, `layoutMode`, and `paneCount`.

Avoid putting widget instances in the config. If the whole tree changes, use a
widget builder and keep the shared value as data.

Use `ResponsiveValueGranular<T>` when the shared value needs
`LayoutSizeGranular`.

## Read shared value data

`ScreenSizeModelWithValue`

Use `responsiveValueOf` when a descendant only needs the resolved config value.

```dart
final config =
    ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, LayoutConfig>(
  context,
);
```

Use `of` when the widget needs both screen metrics and the responsive value.

```dart
final data = ScreenSizeModelWithValue.of<LayoutSize, LayoutConfig>(context);
final config = data.responsiveValue;
final width = data.logicalScreenWidth;
```

Use `breakpointOf` when the widget only needs the breakpoint enum and should not
care about the value type.

```dart
final breakpoint = ScreenSizeModelWithValue.breakpointOf<LayoutSize>(context);
```

## Branch with shared value data

`ScreenWithValueWidgetBuilder`

Use `ScreenWithValueWidgetBuilder<T>` when each breakpoint renders a different
widget branch and each branch also needs the shared value.

```dart
ScreenWithValueWidgetBuilder<LayoutConfig>(
  small: (context, data) => CompactLayout(config: data.responsiveValue),
  large: (context, data) => WideLayout(config: data.responsiveValue),
)
```

Use this instead of separately reading `ScreenSizeModelWithValue` inside every
branch when the branch callback naturally owns the layout decision.

## Resolve values with a provider present

`ScreenWithValueValueBuilder`

Use `ScreenWithValueValueBuilder` when a value builder should run inside a
`ScreenSizeWithValue` subtree and may need the provider's `responsiveValue`.

It aliases the screen value builder shape for code that is intentionally using a
screen-with-value provider.

Use granular or orientation variants only when the selected API name includes
`Granular` or `Orientation` and the behavior really needs that extra axis.

## Source anchors

`lib/src/responsive_value/screen_size_with_value.dart`

Check these source files when behavior matters:
- `lib/src/responsive_value/screen_size_with_value.dart`
- `lib/src/responsive_value/responsive_value.dart`
- `lib/src/screen_with_value/standard/screen_with_value_widget_builder.dart`
- `lib/src/screen_with_value/standard/screen_with_value_value_builder.dart`
- `lib/src/screen_with_value/granular/screen_with_value_widget_builder_granular.dart`
- `lib/src/screen_with_value/granular/screen_with_value_value_builder_granular.dart`
- `example/lib/pages/screen_size_with_value_example.dart`
- `example/lib/pages/screen_size_with_value_builder_example.dart`
- `example/lib/shared/models/layout_config.dart`
