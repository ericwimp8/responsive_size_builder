# Responsive Size Builder

Responsive layout utilities for Flutter that choose widgets _and_ values based on screen size, orientation, or local layout constraints. Breakpoints are type-safe (`LayoutSize`, `LayoutSizeGranular`) and can be customized.

## Modules

- `ScreenSizeBuilder` / `ScreenSizeBuilderGranular`: MediaQuery-driven widget builders (5 or 13 breakpoints).
- `LayoutSizeBuilder` / `LayoutSizeBuilderGranular`: Constraint-driven widget builders using `LayoutBuilder`.
- `ValueSizeBuilder` / `ValueSizeBuilderGranular`: MediaQuery-driven value selectors.
- `LayoutValueSizeBuilder` / `LayoutValueSizeBuilderGranular`: **New** constraint-driven value selectors (no `ScreenSize` wrapper required).
- `ScreenSizeWithValue*`: Builders that pipe both breakpoint data and an injected value.

## Quick Start

```dart
// MediaQuery-based value selection
ScreenSize<LayoutSize>(
  child: ValueSizeBuilder<double>(
    small: 8,
    medium: 12,
    large: 20,
    builder: (context, spacing) => Padding(
      padding: EdgeInsets.all(spacing),
      child: const Text('Hello'),
    ),
  ),
);

// Constraint-based value selection (no ScreenSize wrapper needed)
LayoutValueSizeBuilder<int>(
  small: 1,
  medium: 2,
  large: 3,
  builder: (context, columns) => GridView.count(
    crossAxisCount: columns,
    children: const [/* ... */],
  ),
);
```

## Examples

Run the example app to see all builders in action, including the new layout-driven value builders:

```bash
flutter run example
```

Key routes in the demo:
- `/layout-value-size-builder` - constraint-based value selection
- `/layout-size-builder` - constraint-based widget selection
- `/value-size-builder` - screen-size value selection
- `/screen-size-builder` - screen-size widget selection

## Customizing Breakpoints

Pass your own `Breakpoints` or `BreakpointsGranular` to any builder:

```dart
const customBreakpoints = Breakpoints(
  small: 500,
  medium: 900,
  large: 1200,
  extraLarge: 1600,
);

LayoutValueSizeBuilder<double>(
  breakpoints: customBreakpoints,
  small: 8,
  medium: 12,
  large: 18,
  builder: (context, value) => Text('$value'),
);
```

## Notes

- All builders require at least one breakpoint value.
- `useShortestSide` is available on layout value builders when you want tablet/phone splits based on min dimension.
- For value builders, add `AnimatedSwitcher` yourself if you want animated transitions; widget builders have `animateChange` flags.
