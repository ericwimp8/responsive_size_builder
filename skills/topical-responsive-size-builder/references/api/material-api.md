# Material API

Use Material APIs when Material 3 window size classes and adaptive layout values
should own the responsive model.

## Wrap the app or feature

`MaterialResponsiveSize`

Use `MaterialResponsiveSize` when the app wants Material 3 classifications
instead of the package's generic `LayoutSize` buckets.

```dart
MaterialApp(
  builder: (context, child) => MaterialResponsiveSize(
    child: child ?? const SizedBox.shrink(),
  ),
  home: const HomePage(),
)
```

This wraps the subtree in
`ScreenSizeWithValue<MaterialWindowSizeClass, MaterialResponsiveValues>`.

Use it at the app builder or feature-shell boundary when Material values should
be available throughout that subtree.

## Read the Material window class

`MaterialWindowSizeClass`

Read the current Material window size class when branch logic needs the named
Material tier.

```dart
final windowClass =
    ScreenSizeModelWithValue.breakpointOf<MaterialWindowSizeClass>(context);
```

Default classes:
- `compact`
- `medium`
- `expanded`
- `large`
- `extraLarge`

## Use Material responsive values

`MaterialResponsiveValues`

Read the resolved values when implementing Material-aligned spacing and adaptive
layout decisions.

```dart
final values = ScreenSizeModelWithValue.responsiveValueOf<
    MaterialWindowSizeClass, MaterialResponsiveValues>(context);

return ListView(
  padding: EdgeInsets.all(values.pageMargin),
  children: [
    ResponsiveSectionRow(
      minSectionWidth: values.fixedPaneWidth ?? 280,
      spacing: values.paneSpacing,
      sections: sections,
    ),
  ],
);
```

Use fields such as `pageMargin`, `paneSpacing`, `recommendedPaneCount`,
`maxPaneCount`, `fixedPaneWidth`, and `sideSheetMaxWidth`.

Use static constants for Material sizing rules such as touch targets, pointer
targets, bottom sheets, dialogs, search, snackbars, progress, toolbars, and
carousel constraints.

## Customize Material thresholds

`MaterialBreakpoints`

Use custom `MaterialBreakpoints` only when the product intentionally shifts
Material window-size thresholds.

```dart
MaterialResponsiveSize(
  breakpoints: const MaterialBreakpoints(
    medium: 640,
    expanded: 900,
    large: 1240,
    extraLarge: 1600,
  ),
  child: const AppShell(),
)
```

Keep custom breakpoints at the same owner boundary as `MaterialResponsiveSize`.

## Customize Material values

`MaterialResponsiveValue`

Use the default `MaterialResponsiveValue` unless the product has a clear reason
to customize the Material responsive path.

Do not mix generic `LayoutSize` decisions into a subtree that is supposed to be
Material-class driven unless the product explicitly has a separate responsive
model for that branch.

## Choose Material vs generic APIs

`MaterialResponsiveSize` vs `ScreenSizeWithValue`

Choose `MaterialResponsiveSize` when Material 3 adaptive guidance is the source
of truth.

Choose generic `ScreenSize` or `ScreenSizeWithValue` when the product owns its
own breakpoints, config object, or layout tiers.

Do not use Material classes just because the app uses Material widgets. Use them
when Material's responsive model is the design contract.

## Source anchors

`lib/src/material/material_responsive_size.dart`

Check these source files when behavior matters:
- `lib/src/material/material_responsive_size.dart`
- `lib/src/responsive_value/screen_size_with_value.dart`
- `lib/src/responsive_value/responsive_value.dart`
- `example/lib/main.dart`
- `example/lib/pages/material_responsive_size_example.dart`
