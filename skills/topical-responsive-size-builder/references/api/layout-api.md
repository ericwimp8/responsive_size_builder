# Layout API

Use layout APIs when parent constraints own the responsive decision.

## Branch by parent constraints

`LayoutWidgetBuilder`

Use `LayoutWidgetBuilder` when a reusable component needs different widget
structure at different available widths.

Good fits:
- cards used in narrow and wide regions
- split-pane content
- side panels
- dialogs and sheets
- reusable package widgets
- nested regions whose width differs from the full screen

```dart
LayoutWidgetBuilder(
  small: (context) => const CompactCard(),
  medium: (context) => const MediumCard(),
  large: (context) => const WideCard(),
)
```

This uses `LayoutBuilder` internally and classifies `constraints.maxWidth` by
default.

Do not use `ScreenWidgetBuilder` for this problem. A screen-wide breakpoint can
be wrong when the component is placed inside a narrow pane on a wide screen.

## Resolve local values

`LayoutValueBuilder`

Use `LayoutValueBuilder<T>` when parent constraints own the decision and only a
value changes.

Good fits:
- local grid columns
- local padding
- local spacing
- child aspect ratio
- compact/expanded text density

```dart
LayoutValueBuilder<int>(
  small: 1,
  medium: 2,
  large: 3,
  builder: (context, columns) {
    return GridView.count(crossAxisCount: columns);
  },
)
```

The generic type is the resolved value type. The callback still returns the
widget to render.

## Use layout orientation variants

`LayoutWidgetBuilderOrientation`

Use layout orientation variants when local parent constraints and orientation
together determine the component layout.

```dart
LayoutWidgetBuilderOrientation(
  small: (context) => const PortraitCompactCard(),
  smallLandscape: (context) => const LandscapeCompactCard(),
  large: (context) => const WideCard(),
)
```

Use `LayoutValueBuilderOrientation` when only a local value changes by
orientation.

Do not add orientation branching when local width breakpoints already describe
the behavior.

## Use layout granular variants

`LayoutWidgetBuilderGranular`

Use layout granular variants when a component needs more than the five standard
local width buckets.

```dart
LayoutValueBuilderGranular<double>(
  compactSmall: 8,
  standardNormal: 16,
  jumboSmall: 24,
  builder: (context, spacing) {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: const Content(),
    );
  },
)
```

Prefer standard layout APIs when five breakpoints are enough.

## Use shortest-side classification deliberately

`useShortestSide`

Use `useShortestSide` when the responsive class should be based on the shorter
dimension rather than width.

Good fits:
- square-ish constrained components
- orientation-sensitive layouts where height limits matter as much as width
- surfaces that should stay compact if either dimension is narrow

Avoid it for normal width-driven component behavior.

## Source anchors

`lib/src/layout/standard/layout_widget_builder.dart`

Check these source files when behavior matters:
- `lib/src/layout/standard/layout_widget_builder.dart`
- `lib/src/layout/standard/layout_value_builder.dart`
- `lib/src/layout/standard/layout_widget_builder_orientation.dart`
- `lib/src/layout/standard/layout_value_builder_orientation.dart`
- `lib/src/layout/granular/layout_widget_builder_granular.dart`
- `lib/src/layout/granular/layout_value_builder_granular.dart`
- `example/lib/pages/layout_size_builder_example.dart`
- `example/lib/pages/layout_value_size_builder_example.dart`
