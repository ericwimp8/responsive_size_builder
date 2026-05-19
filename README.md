# responsive_size_builder

Responsive Flutter layout builders for screen-wide breakpoints, local parent
constraints, shared responsive values, orientation variants, granular window
tiers, and Material 3 window size classes.

Use it when a Flutter UI needs explicit responsive decisions without scattering
`MediaQuery`, `LayoutBuilder`, and breakpoint conditionals through the widget
tree.

This package is also LLM-friendly by design. It is intentionally used in LLM
code-writing systems where generated Flutter code needs predictable responsive
ownership, clear API choices, and a small set of patterns that are easy to
inspect. The package includes an optional LLM usage skill at
[`skills/topical-responsive-size-builder`](skills/topical-responsive-size-builder/SKILL.md)
so coding agents can learn the intended API selection rules before writing UI.

## Contents

- [Features](#features)
- [LLM-Friendly Responsive UI](#llm-friendly-responsive-ui)
- [Installation](#installation)
- [Mental Model](#mental-model)
- [API Map](#api-map)
- [Breakpoints And Fallbacks](#breakpoints-and-fallbacks)
- [Screen-Owned Layout](#screen-owned-layout)
- [Screen-Owned Values](#screen-owned-values)
- [Local Parent Constraints](#local-parent-constraints)
- [Local Layout Helpers](#local-layout-helpers)
- [Shared Responsive Config](#shared-responsive-config)
- [Material 3 Window Classes](#material-3-window-classes)
- [Orientation And Shortest Side](#orientation-and-shortest-side)
- [Architecture And State](#architecture-and-state)
- [Testing Responsive UI](#testing-responsive-ui)
- [LLM Usage Skill](#llm-usage-skill)
- [Example App](#example-app)
- [License](#license)

## Features

- Screen-wide builders for route shells, page layouts, and app-level structure.
- Constraint-driven builders for reusable widgets, cards, dialogs, panes, and
  other local layout regions.
- Value builders for padding, spacing, column counts, maximum widths, icon
  sizes, density, and other scalar layout decisions.
- Shared responsive values through `ScreenSizeWithValue` and `ResponsiveValue`.
- Standard 5-tier breakpoints, granular breakpoint tiers, orientation variants,
  and shortest-side classification.
- Material 3 window size classes and adaptive layout constants through
  `MaterialResponsiveSize`.
- Local helpers for responsive grids and section rows.
- A checked-in LLM usage skill and focused reference docs.

## LLM-Friendly Responsive UI

`responsive_size_builder` is a normal Flutter package for human-written apps. It
is also shaped to work well in LLM-assisted coding workflows.

Responsive bugs in generated UI often come from unclear ownership: a component
branches on full screen width when its parent pane is narrow, a router is
created inside a breakpoint branch, or a widget tree is rebuilt when only a
padding value changed. This package keeps those choices visible:

- screen APIs mean the full app window owns the decision
- layout APIs mean the parent constraints own the decision
- value builders mean the widget structure stays the same
- shared responsive values mean a subtree needs one coherent layout contract
- Material APIs mean Material 3 window classes own the responsive model

The included skill is for coding assistants that support local skill files. If
your workflow uses an LLM to write Flutter, point it at
[`skills/topical-responsive-size-builder/SKILL.md`](skills/topical-responsive-size-builder/SKILL.md)
or paste the relevant README section into the coding context.

LLM support is optional. The public Dart APIs are the package contract, and the
README is written to be usable as the main human-facing guide.

## Installation

```yaml
dependencies:
  responsive_size_builder: ^0.1.3
```

Then import the package:

```dart
import 'package:responsive_size_builder/responsive_size_builder.dart';
```

## Mental Model

Choose the responsive owner first.

The owner is the smallest boundary that controls the width and state affected by
the responsive decision. Once the owner is clear, the API choice is usually
straightforward.

Use screen-wide APIs when the full app window owns the decision:

- route shells
- app navigation chrome
- page-level list vs grid structure
- master-detail shells
- subtrees that should all share one `MediaQuery` breakpoint

Use local constraint APIs when a parent container owns the decision:

- reusable widgets
- cards in narrow panes
- dialogs and sheets
- side panels
- form sections
- any component whose available width can differ from the screen width

Use value APIs when the widget tree stays the same and only a value changes:

- padding
- spacing
- column count
- icon size
- content max width
- density
- pane count

Use shared responsive values when several descendants need the same resolved
layout config:

- `LayoutConfig(columns, padding, showSideMenu)`
- pane count and pane spacing
- navigation mode
- density and sizing policy

Use Material APIs when Material 3 adaptive layout guidance is the design model.

## API Map

| Need | Use | Why |
| --- | --- | --- |
| Wrap a screen-owned route, page, or shell | `ScreenSize` | Provides a screen breakpoint from `MediaQuery` width. |
| Branch full-screen widget structure | `ScreenWidgetBuilder` | Swaps page or shell structure by screen breakpoint. |
| Resolve a full-screen scalar value | `ScreenValueBuilder` | Changes one value while keeping the widget structure stable. |
| Share one responsive config through a subtree | `ScreenSizeWithValue` | Provides both breakpoint data and a typed responsive value. |
| Branch with shared config available | `ScreenWithValueWidgetBuilder` | Lets branch builders read the shared responsive value. |
| Resolve a value inside a shared-config subtree | `ScreenWithValueValueBuilder` | Keeps value resolution tied to `ScreenSizeWithValue`. |
| Branch by parent constraints | `LayoutWidgetBuilder` | Uses local `LayoutBuilder` constraints instead of screen width. |
| Resolve a local scalar value | `LayoutValueBuilder` | Changes one value based on parent constraints. |
| Flow repeated children into columns | `ResponsiveGrid` | Calculates equal-width columns from available width. |
| Row sections when they fit, stack when narrow | `ResponsiveSectionRow` | Keeps sections side by side only when each section can fit. |
| Use Material 3 window classes | `MaterialResponsiveSize` | Provides `MaterialWindowSizeClass` and `MaterialResponsiveValues`. |
| Use custom product breakpoints | `Breakpoints` or `BreakpointsGranular` | Keeps thresholds at the boundary that owns the behavior. |

Standard APIs use `LayoutSize`:

- `extraLarge`
- `large`
- `medium`
- `small`
- `extraSmall`

Granular APIs use `LayoutSizeGranular` for compact, standard, jumbo, and
ultra-wide tiers, with `tiny` below the smallest configured threshold.

## Breakpoints And Fallbacks

The standard breakpoint defaults are:

```dart
const Breakpoints(
  small: 200,
  medium: 600,
  large: 950,
  extraLarge: 1200,
);
```

Breakpoint values are minimum logical widths. `extraSmall` is the fallback below
`small`.

Custom breakpoints should live at the same boundary that owns the responsive
behavior:

```dart
ScreenSize<LayoutSize>(
  breakpoints: const Breakpoints(
    small: 600,
    medium: 950,
    large: 1200,
    extraLarge: 1400,
  ),
  child: const OrdersShell(),
)
```

Builders and responsive values accept sparse breakpoint entries. If the current
breakpoint has no explicit value, the package resolves through the configured
value map until it finds a provided value.

```dart
ScreenWidgetBuilder(
  extraSmall: (context, data) => const CompactPage(),
  large: (context, data) => const WidePage(),
)
```

Provide entries where behavior changes. Repeating identical values at every
breakpoint usually makes the responsive contract harder to read.

Use granular APIs when five buckets are too coarse:

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

## Screen-Owned Layout

Use `ScreenSize` and `ScreenWidgetBuilder` when screen width changes the page or
shell structure.

Good fits:

- compact navigation vs rail or sidebar navigation
- single-column page vs master-detail page
- list layout vs dashboard layout
- route shell changes
- major content regions that all use the same screen breakpoint

```dart
ScreenSize<LayoutSize>(
  breakpoints: const Breakpoints(
    small: 600,
    medium: 950,
    large: 1200,
    extraLarge: 1400,
  ),
  child: ScreenWidgetBuilder(
    extraSmall: (context, data) => const CompactPage(),
    medium: (context, data) => const TwoColumnPage(),
    large: (context, data) => const WideDashboard(),
  ),
)
```

Descendants can read the screen data when they genuinely need it:

```dart
final data = ScreenSizeModel.of<LayoutSize>(context);
final breakpoint = ScreenSizeModel.breakpointOf<LayoutSize>(context);
```

Prefer `breakpointOf` when the widget only needs the resolved breakpoint.

## Screen-Owned Values

Use `ScreenValueBuilder` when the full screen owns the decision but only one
value changes.

Good fits:

- page padding
- grid columns
- content max width
- toolbar density
- icon size

```dart
ScreenValueBuilder<int, Object?>(
  extraSmall: 1,
  medium: 2,
  large: 4,
  builder: (context, columns, {data, responsiveValue}) {
    return GridView.count(crossAxisCount: columns);
  },
)
```

The branch resolves a value. The callback still returns the widget to render.

## Local Parent Constraints

Use `LayoutWidgetBuilder` or `LayoutValueBuilder` when a reusable component
should respond to its actual parent width.

Good fits:

- cards used inside narrow and wide regions
- split-pane content
- side panels
- dialogs and sheets
- reusable package widgets
- nested regions whose width differs from the full screen

```dart
LayoutWidgetBuilder(
  extraSmall: (context) => const CompactCard(),
  medium: (context) => const MediumCard(),
  large: (context) => const WideCard(),
)
```

For value-only local decisions:

```dart
LayoutValueBuilder<double>(
  extraSmall: 8,
  medium: 16,
  large: 24,
  builder: (context, spacing, constraints) {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: const CardContent(),
    );
  },
)
```

This matters in split views and panes. A wide desktop window can contain a narrow
panel, and the panel should usually respond to its own constraints.

## Local Layout Helpers

Use `ResponsiveGrid` when repeated children should flow into equal-width columns
based on available width and a minimum child width.

```dart
ResponsiveGrid(
  minChildWidth: 220,
  spacing: 12,
  runSpacing: 12,
  children: cards,
)
```

Use `ResponsiveSectionRow` when sections should remain side by side only when
each section can meet its minimum width.

```dart
ResponsiveSectionRow(
  minSectionWidth: 280,
  spacing: 16,
  runSpacing: 16,
  sections: const [
    SummaryPanel(),
    DetailsPanel(),
  ],
)
```

`ResponsiveGridBase` and `ResponsiveSectionRowBase` read constraints from an
existing `LayoutConstraintsWrapper`. Use the base variants when a parent already
captures constraints for the surrounding layout.

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

## Shared Responsive Config

Use `ScreenSizeWithValue` when multiple descendants need one resolved layout
configuration.

```dart
class LayoutConfig {
  const LayoutConfig({
    required this.columns,
    required this.padding,
    this.showSideMenu = false,
  });

  final int columns;
  final double padding;
  final bool showSideMenu;
}

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

Read the value from descendants:

```dart
final config =
    ScreenSizeModelWithValue.responsiveValueOf<LayoutSize, LayoutConfig>(
  context,
);
```

Use `ScreenWithValueWidgetBuilder` when each branch needs the shared config:

```dart
ScreenWithValueWidgetBuilder<LayoutConfig>(
  extraSmall: (context, data) {
    return CompactLayout(config: data.responsiveValue);
  },
  large: (context, data) {
    return WideLayout(config: data.responsiveValue);
  },
)
```

Good shared values are layout data: padding, section gap, max content width,
compact action mode, pane width policy, layout mode, and pane count.

Keep route identity, selected item, edited form data, and business state in the
route, page state, or app state layer that owns them.

## Material 3 Window Classes

Use `MaterialResponsiveSize` when Material 3 window size classes and adaptive
layout values should drive the subtree.

```dart
MaterialApp(
  builder: (context, child) {
    return MaterialResponsiveSize(
      child: child ?? const SizedBox.shrink(),
    );
  },
  home: const HomePage(),
)
```

`MaterialResponsiveSize` wraps the subtree in:

```dart
ScreenSizeWithValue<MaterialWindowSizeClass, MaterialResponsiveValues>
```

Read the current Material class:

```dart
final windowClass =
    ScreenSizeModelWithValue.breakpointOf<MaterialWindowSizeClass>(context);
```

Read the resolved Material values:

```dart
final values = ScreenSizeModelWithValue.responsiveValueOf<
    MaterialWindowSizeClass, MaterialResponsiveValues>(context);

return ListView(
  padding: EdgeInsets.all(values.pageMargin),
  children: [
    ResponsiveSectionRow(
      minSectionWidth: values.minimumPaneWidth,
      spacing: values.paneSpacing,
      sections: sections,
    ),
  ],
);
```

Branch by Material window class:

```dart
MaterialResponsiveWidgetBuilder(
  compact: (context, data) => const CompactShell(),
  medium: (context, data) => const RailShell(),
  large: (context, data) => const DrawerShell(),
)
```

Sparse branches fall back through the Material size classes, so the example
above uses the `medium` builder for expanded windows and the `large` builder for
extra-large windows.

`MaterialResponsiveValues` includes values such as `pageMargin`, `paneSpacing`,
`recommendedPaneCount`, `maxPaneCount`, `minimumPaneWidth`,
`singlePaneMaxWidth`, `fixedPaneWidth`, and `sideSheetMaxWidth`. Use these
values for Material-owned margins, pane gaps, pane reflow widths, and focused
single-pane width constraints instead of scattering fallback numbers through
screens. It also exposes constants for Material sizing rules such as touch
targets, pointer targets, dialogs, bottom sheets, search, snackbars, progress
indicators, toolbars, navigation drawers, and carousel constraints.

Use custom `MaterialBreakpoints` only when the product intentionally shifts the
Material thresholds:

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

## Orientation And Shortest Side

Use orientation variants when portrait and landscape need different payloads
within the same breakpoint family.

```dart
ScreenWidgetBuilderOrientation(
  small: (context, data) => const PortraitCompactPage(),
  smallLandscape: (context, data) => const LandscapeCompactPage(),
  large: (context, data) => const WidePage(),
)
```

The same pattern exists for screen values, local layout widgets, local layout
values, shared-value builders, and granular APIs.

Use `useShortestSide` when the responsive class should be based on the shorter
dimension instead of width.

Good fits:

- square-ish constrained components
- orientation-sensitive surfaces where height limits matter
- layouts that should stay compact if either dimension is narrow

## Architecture And State

Screen-wide builders are strongest at app, route, feature, and page boundaries.
Local builders are strongest inside reusable widgets and constrained layout
regions.

For shell-level layout, keep durable state owners above responsive branches that
can unmount:

- nested routers
- tab controllers
- scroll controllers and page storage
- form controllers and form keys
- provider scopes or cache wrappers that preserve page state
- state wrappers that can briefly show loading or error UI

Branches should replace responsive chrome around stable state. For example, a
compact shell and desktop shell can wrap the same child router with different
navigation UI.

For route-derived UI state, prefer deriving selected shell state from the current
route. A short-lived local cache can bridge transition frames when navigation
has just changed and the route tree has not finished rebuilding.

For component-level layout, pass a resolved value through constructor parameters
when only one subtree needs it. Use inherited responsive values when many
unrelated descendants need the same layout constants. Use local constraints when
the child should respond to the actual space its parent gives it.

## Testing Responsive UI

Tests should install the same responsive owner used by the app or feature:

- no global owner for local-only components
- `ScreenSize` for screen-owned branches
- `ScreenSizeWithValue` for shared responsive config
- `MaterialResponsiveSize` for Material window classes
- feature-scoped wrappers when a feature owns custom breakpoints

Test named breakpoints that matter to the product:

- `extraSmall`, `small`, `medium`, `large`, `extraLarge`
- granular tiers such as `compactSmall`, `standardNormal`, and
  `standardExtraLarge`
- any custom threshold that changes behavior

When testing shell routes, include at least one resize or branch change for state
that should survive:

- selected tab
- active detail row
- scroll offset
- expanded section
- partially edited form field
- dismissed local page flag

When responsive values matter, test exact values and fallback behavior.

## LLM Usage Skill

The package includes a skill for LLM coding agents:

[`skills/topical-responsive-size-builder/SKILL.md`](skills/topical-responsive-size-builder/SKILL.md)

The skill teaches agents to:

- classify whether a task is about API mechanics, implementation architecture,
  or both
- choose the responsive owner before choosing an API
- use screen APIs for app-window decisions
- use layout APIs for parent-constraint decisions
- use value builders for scalar decisions
- use shared responsive config when a subtree needs one layout contract
- preserve routers, controllers, provider scopes, and page state across
  responsive branches
- review common responsive mistakes

The skill also links to focused references:

- [Screen API](skills/topical-responsive-size-builder/references/api/screen-api.md)
- [Screen With Value API](skills/topical-responsive-size-builder/references/api/screen-with-value-api.md)
- [Layout API](skills/topical-responsive-size-builder/references/api/layout-api.md)
- [Local Layout Helpers API](skills/topical-responsive-size-builder/references/api/local-layout-helpers-api.md)
- [Material API](skills/topical-responsive-size-builder/references/api/material-api.md)
- [Breakpoints And Resolution](skills/topical-responsive-size-builder/references/api/breakpoints-and-resolution.md)
- [Shell, Navigation, And State](skills/topical-responsive-size-builder/references/implementation/shell-navigation-state.md)
- [Component And Local Layout](skills/topical-responsive-size-builder/references/implementation/component-and-local-layout.md)
- [Testing Responsive Implementation](skills/topical-responsive-size-builder/references/implementation/testing-responsive-implementation.md)
- [Patterns To Avoid](skills/topical-responsive-size-builder/references/implementation/patterns-to-avoid.md)

For LLM workflows, this README is the broad human guide and the skill is the
agent-facing operational guide.

## Example App

The `example/` app demonstrates the main API families:

- screen builders
- screen value builders
- local layout builders
- local layout value builders
- shared responsive values
- granular breakpoints
- orientation variants
- Material 3 responsive values

Run it with:

```sh
cd example
flutter run
```

## License

MIT
