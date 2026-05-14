# Local Layout Helpers API

Use local layout helpers when the layout only needs simple width-aware grid,
row, or stack behavior.

## Flow children into columns

`ResponsiveGrid`

Use `ResponsiveGrid` when children should flow into equal-width columns based on
available width and a minimum child width.

```dart
ResponsiveGrid(
  minChildWidth: 220,
  spacing: 12,
  runSpacing: 12,
  children: cards,
)
```

Use this when simple column calculation is enough and custom breakpoint branches
would add unnecessary logic.

## Row sections when they fit

`ResponsiveSectionRow`

Use `ResponsiveSectionRow` when sections should stay in a row if they fit and
stack when the available width is too narrow.

```dart
ResponsiveSectionRow(
  minSectionWidth: 280,
  spacing: 16,
  runSpacing: 16,
  sections: [
    SummaryPanel(),
    DetailsPanel(),
  ],
)
```

Use `useIntrinsicHeight` only when equal-height row sections are worth the
intrinsic layout cost.

## Provide constraints to Base variants

`LayoutConstraintsWrapper`

`ResponsiveGridBase` and `ResponsiveSectionRowBase` expect constraints from
`LayoutConstraintsWrapper`.

```dart
LayoutConstraintsWrapper(
  builder: (context, child) => child,
  child: ResponsiveGridBase(children: cards),
)
```

Use the base variants inside an existing constraint wrapper when adding another
nested `LayoutBuilder` would be awkward for the surrounding layout.

## Read provided constraints

`LayoutConstraintsProvider`

Use `LayoutConstraintsProvider.of(context)` only when implementing a helper that
needs the constraints supplied by `LayoutConstraintsWrapper`.

If the task is ordinary application UI, prefer `ResponsiveGrid`,
`ResponsiveSectionRow`, or the non-Base builder APIs instead of reading the
provider directly.

## Source anchors

`lib/src/local_layout/responsive_grid.dart`

Check these source files when behavior matters:
- `lib/src/local_layout/responsive_grid.dart`
- `lib/src/local_layout/responsive_section_row.dart`
- `lib/src/layout_constraints/layout_constraints_wrapper.dart`
- `lib/src/layout_constraints/layout_constraints_provider_base.dart`
- `example/lib/pages/material_responsive_size_example.dart`
