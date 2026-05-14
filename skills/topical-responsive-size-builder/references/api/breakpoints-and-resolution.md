# Breakpoints And Resolution

Use this reference when defining breakpoints, reasoning about fallback behavior,
or deciding between standard and granular size models.

## Use standard size buckets

`LayoutSize`

Use `LayoutSize` by default.

Standard buckets:
- `extraLarge`
- `large`
- `medium`
- `small`
- `extraSmall`

These are the right default when five width tiers can describe the behavior.

## Define standard thresholds

`Breakpoints`

Use `Breakpoints` to configure standard width thresholds.

```dart
const breakpoints = Breakpoints(
  small: 600,
  medium: 950,
  large: 1200,
  extraLarge: 1400,
);
```

Breakpoint values are minimum logical widths. Keep custom breakpoints close to
the app, route, feature, or component that owns the responsive behavior.

## Use granular size buckets

`LayoutSizeGranular`

Use `LayoutSizeGranular` only when five buckets are too coarse.

Good fits:
- compact, standard, jumbo, and ultra-wide tiers have distinct behavior
- desktop widths need multiple meaningful layout bands
- the product has named tiers beyond extra-small/small/medium/large
- visual density changes gradually across many breakpoints

Prefer `LayoutSize` when it can express the behavior clearly.

## Define granular thresholds

`BreakpointsGranular`

Use `BreakpointsGranular` to configure granular width thresholds.

The default model spans compact, standard, and jumbo classes, ending with
`tiny` below the smallest configured threshold.

Customize granular thresholds only when the product has real behavior at those
tiers.

## Resolve sparse breakpoint values

`BaseBreakpointsHandler.getScreenSizeValue`

The package does not require a value for every breakpoint. It resolves the
current breakpoint and falls back through the configured value map when the exact
breakpoint has no value.

That makes sparse declarations valid when neighboring sizes share behavior.

```dart
ScreenWidgetBuilder(
  extraSmall: (context, data) => const CompactPage(),
  large: (context, data) => const WidePage(),
)
```

Do not duplicate identical values across every breakpoint just to fill all
slots. Provide explicit entries where behavior actually changes.

## Resolve standard values directly

`BreakpointsHandler`

Use `BreakpointsHandler<T>` when code needs to resolve a standard breakpoint
value outside the widget-builder wrappers.

Most app UI should use `ScreenValueBuilder`, `LayoutValueBuilder`, or
`ResponsiveValue` instead.

## Resolve granular values directly

`BreakpointsHandlerGranular`

Use `BreakpointsHandlerGranular<T>` when code needs to resolve a granular
breakpoint value outside the widget-builder wrappers.

Most app UI should use granular screen/layout/value APIs instead.

## Use shortest-side classification deliberately

`useShortestSide`

Use `useShortestSide` when the responsive class should be based on the shorter
dimension rather than width.

Good fits:
- square-ish constrained components
- orientation-sensitive layouts where height limits matter as much as width
- surfaces that should stay compact if either dimension is narrow

Avoid it for normal page-width responsive behavior.

## Source anchors

`lib/src/core/breakpoints/base_breakpoints_handler.dart`

Check these source files when behavior matters:
- `lib/src/core/breakpoints/breakpoints.dart`
- `lib/src/core/breakpoints/base_breakpoints_handler.dart`
- `lib/src/core/breakpoints/breakpoints_handler.dart`
- `lib/src/core/breakpoints/breakpoints_handler_granular.dart`
