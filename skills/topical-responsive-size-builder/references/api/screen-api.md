# Screen API

Use screen APIs when the full app/window width owns the responsive decision.

## Wrap screen-owned behavior

`ScreenSize`

Wrap a route, page, shell, or major subtree in `ScreenSize<LayoutSize>` when
children should classify against `MediaQuery` width.

Good fits:
- page-level navigation changes
- full page list/grid changes
- route shell changes
- major content regions that should all use the same breakpoint

```dart
ScreenSize<LayoutSize>(
  breakpoints: Breakpoints.defaultBreakpoints,
  child: const OrdersPage(),
)
```

Use custom `Breakpoints` at the owner boundary when the product has its own
screen tiers.

Do not use `ScreenSize` just because a reusable component needs to adapt. If the
component may be placed in a narrow parent on a wide screen, use layout APIs.

## Read screen data

`ScreenSizeModel`

Use `ScreenSizeModel.of` when a descendant needs screen metrics and the resolved
breakpoint.

```dart
final data = ScreenSizeModel.of<LayoutSize>(context);
final width = data.logicalScreenWidth;
```

Use `breakpointOf` when only the resolved breakpoint matters.

```dart
final breakpoint = ScreenSizeModel.breakpointOf<LayoutSize>(context);
```

Use `breakpointOf` to avoid depending on every raw metric change.

## Branch screen-owned widget structure

`ScreenWidgetBuilder`

Use `ScreenWidgetBuilder` when different screen sizes need materially different
widget structures.

Good fits:
- compact navigation vs rail/sidebar navigation
- single-column page vs master-detail page
- list layout vs multi-column dashboard
- different route body composition for phone and desktop widths

```dart
ScreenWidgetBuilder(
  extraSmall: (context, data) => const CompactPage(),
  medium: (context, data) => const MediumPage(),
  large: (context, data) => const WidePage(),
)
```

The builder receives `ScreenSizeModelData<LayoutSize>`.

Provide only breakpoints that need distinct behavior. Missing values resolve
through package fallback behavior.

## Resolve screen-owned values

`ScreenValueBuilder`

Use `ScreenValueBuilder` when screen width owns the decision but only one value
changes.

Good fits:
- page padding
- grid columns
- content max width
- toolbar density
- icon size

```dart
ScreenValueBuilder<int, Object?>(
  small: 1,
  medium: 2,
  large: 3,
  builder: (context, columns, {data, responsiveValue}) {
    return GridView.count(crossAxisCount: columns);
  },
)
```

The responsive branch resolves a value. The callback still returns the widget to
render.

## Use screen orientation variants

`ScreenWidgetBuilderOrientation`

Use orientation variants when portrait and landscape need different payloads for
the same screen breakpoint family.

```dart
ScreenWidgetBuilderOrientation(
  small: (context, data) => const PortraitCompactPage(),
  smallLandscape: (context, data) => const LandscapeCompactPage(),
  large: (context, data) => const WidePage(),
)
```

Use `ScreenValueBuilderOrientation` when the widget structure stays the same and
only values differ by orientation.

Do not add orientation branching when normal width breakpoints already describe
the behavior.

## Use screen granular variants

`ScreenWidgetBuilderGranular`

Use screen granular variants when five `LayoutSize` buckets are too broad for
screen-owned behavior.

```dart
ScreenSize<LayoutSizeGranular>(
  breakpoints: BreakpointsGranular.defaultBreakpoints,
  child: ScreenWidgetBuilderGranular(
    compactSmall: (context, data) => const CompactShell(),
    standardNormal: (context, data) => const StandardShell(),
    jumboSmall: (context, data) => const JumboShell(),
  ),
)
```

Use `ScreenValueBuilderGranular` for granular value-only decisions.

Prefer standard screen APIs when five breakpoints are enough.

## Source anchors

`lib/src/screen_size/screen_size_data.dart`

Check these source files when behavior matters:
- `lib/src/screen_size/screen_size_data.dart`
- `lib/src/screen/standard/screen_widget_builder.dart`
- `lib/src/screen/standard/screen_value_builder.dart`
- `lib/src/screen/standard/screen_widget_builder_orientation.dart`
- `lib/src/screen/standard/screen_value_builder_orientation.dart`
- `lib/src/screen/granular/screen_widget_builder_granular.dart`
- `lib/src/screen/granular/screen_value_builder_granular.dart`
- `example/lib/pages/screen_size_builder_example.dart`
- `example/lib/pages/value_size_builder_example.dart`
