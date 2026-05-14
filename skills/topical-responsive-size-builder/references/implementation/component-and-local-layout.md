# Component And Local Layout

Use local constraint APIs when a widget's available width can differ from the
window width.

Good component-level responsibilities:

- switch toolbar labels to icons
- stack form fields when a pane is narrow
- choose card columns inside a constrained panel
- keep sections in a row only when each section can meet a minimum width
- size dialogs, sheets, popovers, and side panes
- adapt reusable widgets without coupling them to a global shell

## Local Builder Example

Use `LayoutWidgetBuilder` or `LayoutWidgetBuilderGranular` when structure changes
inside a component:

```dart
class ModeToggle extends StatelessWidget {
  const ModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutWidgetBuilderGranular(
      breakpoints: const BreakpointsGranular(
        standardLarge: 640,
        standardNormal: 639,
      ),
      tiny: (_) => const CompactModeToggle(),
      standardLarge: (_) => const FullModeToggle(),
    );
  }
}
```

This decision belongs to the toggle's local width. It should not force every
caller to install another screen-wide builder.

## Local Helpers

Use `ResponsiveGrid` when repeated children should flow into equal-width columns.

Use `ResponsiveSectionRow` when a few sections should be side-by-side only if
every section can meet its minimum width, otherwise stack vertically.

Use the `Base` variants inside an existing `LayoutConstraintsWrapper` when a
parent already captures constraints or when nested `LayoutBuilder` behavior would
conflict with intrinsic sizing.

```dart
LayoutConstraintsWrapper(
  builder: (context, child) => child,
  child: ResponsiveSectionRowBase(
    minSectionWidth: 320,
    sections: const [
      BillingSummarySection(),
      PaymentMethodSection(),
    ],
  ),
)
```

## Shared Responsive Values

Use a typed responsive value object only when many descendants need the same
resolved config:

```dart
class AppLayoutConfig {
  const AppLayoutConfig({
    required this.pagePadding,
    required this.useAutoScroll,
    required this.compactActions,
  });

  final double pagePadding;
  final bool useAutoScroll;
  final bool compactActions;
}
```

Good shared values:

- page padding
- section gap
- max content width
- compact action mode
- pane width policy
- whether expansion tiles should auto-scroll

Avoid storing route identity or business state in responsive config.

## Passing Decisions Down

Prefer constructor parameters when only one subtree needs the decision:

```dart
ActionsBar(compact: resolved.compactActions)
```

Prefer inherited responsive values when many unrelated descendants need the
same layout constants.

Prefer local constraints when the child should respond to the actual space its
parent gives it.

## Page-Level Then Local

A page may use a screen-wide builder to choose major structure, then local
helpers inside that branch:

```dart
ScreenWithValueWidgetBuilderGranular<AppLayoutConfig>(
  compactSmall: (_, data) => EditFormPage(config: data.responsiveValue),
  standardExtraLarge: (_, data) => EditFormSplitPage(config: data.responsiveValue),
)
```

Inside `EditFormPage`, use `ResponsiveSectionRow`, `ResponsiveGrid`, or local
constraints for form groups. Do not add more screen-wide builders for every
section.
