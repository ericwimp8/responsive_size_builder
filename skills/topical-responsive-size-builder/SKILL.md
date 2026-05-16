---
name: topical-responsive-size-builder
description: Topical guide for Flutter responsive UI with responsive_size_builder, covering both package API mechanics and real-world implementation architecture. Use when choosing or applying ScreenSize, ScreenSizeWithValue, ScreenValueBuilder, LayoutWidgetBuilder, LayoutValueBuilder, ResponsiveGrid, ResponsiveSectionRow, MaterialResponsiveSize, granular breakpoints, app/page shells, nested routers, tabbed views, adaptive navigation, master-detail layouts, state preservation, component-local layouts, or responsive tests.
---

# Topical Responsive Size Builder

Use this skill before implementing responsive UI with
`responsive_size_builder`.

The first job is to decide whether the task is about API mechanics,
implementation architecture, or both. Read this file every time the skill is
used, then open only the reference files that match the task.

## Ground Rules

- Treat package source as the source of truth for behavior.
- Inspect the relevant package source or example before making non-trivial usage
  changes.
- Resolve responsive decisions at the smallest boundary that owns the width and
  state being changed.
- Keep breakpoint or responsive-value ownership close to the app, feature, page,
  or component boundary that owns the behavior.
- Do not choose a screen-wide API when a component should respond to local
  parent constraints.
- Do not choose a widget-branching API when only a scalar or config value
  changes.
- Keep nested screen-wide builders rare. Use them for nested route or feature
  shells, not ordinary child widgets.

## Decision Flow

### 1. Classify the task

Use API references when the task is about:

- exact package behavior
- constructor options and builder signatures
- breakpoint fallback rules
- `ScreenSize`, `ScreenSizeWithValue`, layout builders, local helpers, or
  Material APIs

Use implementation references when the task is about:

- app shells, page shells, nested routers, tabs, or navigation chrome
- master-detail, split views, sidebars, drawers, or bottom navigation
- preserving route, tab, scroll, form, provider, or page state
- deciding where responsive builders belong in a real widget tree
- responsive tests and viewport/state contracts
- reviewing excessive builder nesting or unclear ownership

Use both when architecture choices depend on exact package behavior. Read the
implementation reference first, then the matching API reference.

### 2. Choose the responsive owner

- Use no app-level provider when responsive choices are isolated to local
  components.
- Use screen-wide APIs when the app window owns the decision.
- Use local constraint APIs when the parent container owns the decision.
- Use a typed shared value only when multiple descendants need the same resolved
  config.
- Use Material window size classes when Material adaptive layout should own the
  model.
- Scope the owner to a feature subtree when the whole app does not share the
  decision.

### 3. Choose the API family

Use screen-wide APIs for route shells, page-level navigation, full-page
structure, and subtrees that should all respond to the same `MediaQuery` width.

`ScreenSize`, `ScreenWidgetBuilder`, `ScreenValueBuilder`,
`ScreenSizeWithValue`

Use local constraint APIs for reusable widgets, cards, panes, dialogs, sheets,
side panels, and sections whose available width can differ from the full window.

`LayoutWidgetBuilder`, `LayoutValueBuilder`, `ResponsiveGrid`,
`ResponsiveSectionRow`

Use widget branching when the rendered structure changes: list to grid, compact
page to wide page, stacked layout to split layout.

`ScreenWidgetBuilder`, `LayoutWidgetBuilder`

Use value branching when the structure stays the same and only a value changes:
padding, spacing, columns, icon size, max width, pane count.

`ScreenValueBuilder`, `LayoutValueBuilder`, `ResponsiveValue`

Use shared responsive config when multiple descendants need the same derived
layout decisions: page padding, side-menu visibility, layout mode, pane counts.

`ScreenSizeWithValue`, `ResponsiveValue`, `ScreenWithValueWidgetBuilder`

Use generic package APIs when the product owns its responsive model.

`LayoutSize`, `LayoutSizeGranular`, `Breakpoints`, `BreakpointsGranular`

Use Material APIs when Material 3 window size classes and adaptive layout values
should own the responsive model.

`MaterialResponsiveSize`, `MaterialWindowSizeClass`,
`MaterialResponsiveValues`

Use standard breakpoints by default.

`LayoutSize`

Use granular breakpoints only when five buckets are too coarse and the product
has real behavior differences across compact, standard, jumbo, or ultra-wide
tiers.

`LayoutSizeGranular`

Use orientation variants when portrait and landscape need different payloads for
the same breakpoint family. Do not add orientation branching when ordinary width
breakpoints already describe the behavior.

## Reference Index

### API References

- [Screen API](references/api/screen-api.md) - Use when the chosen API is
  `ScreenSize`, `ScreenSizeModel`, `ScreenWidgetBuilder`,
  `ScreenValueBuilder`, or one of their granular/orientation variants.
  - `ScreenSize` - when a route, page, or major subtree responds to
    `MediaQuery` width
  - `ScreenWidgetBuilder` - when screen width changes the widget structure
  - `ScreenValueBuilder` - when screen width changes one value used by a widget
  - Screen granular/orientation variants - when the chosen screen API name
    includes `Granular` or `Orientation`

- [Screen With Value API](references/api/screen-with-value-api.md) - Use when
  the chosen API is `ScreenSizeWithValue`, `ScreenSizeModelWithValue`,
  `ResponsiveValue`, `ScreenWithValueWidgetBuilder`, or one of their
  granular/orientation variants.
  - `ScreenSizeWithValue` - when a subtree needs shared responsive config
  - `ResponsiveValue` - when breakpoint values should be a reusable config
    object
  - `ScreenWithValueWidgetBuilder` - when widget branches also need the shared
    value
  - `ScreenWithValueValueBuilder` - when a value builder should read a
    `ScreenSizeWithValue` provider

- [Layout API](references/api/layout-api.md) - Use when the chosen API is
  `LayoutWidgetBuilder`, `LayoutValueBuilder`, or one of their
  granular/orientation variants.
  - `LayoutWidgetBuilder` - when parent constraints change widget structure
  - `LayoutValueBuilder` - when parent constraints change one value used by a
    widget
  - Layout granular/orientation variants - when the chosen layout API name
    includes `Granular` or `Orientation`

- [Local Layout Helpers API](references/api/local-layout-helpers-api.md) - Use
  when the chosen API is `ResponsiveGrid`, `ResponsiveGridBase`,
  `ResponsiveSectionRow`, `ResponsiveSectionRowBase`,
  `LayoutConstraintsWrapper`, or `LayoutConstraintsProvider`.
  - `ResponsiveGrid` - when children should flow into equal-width columns
  - `ResponsiveSectionRow` - when sections should row when they fit and stack
    when narrow
  - Base variants - when an existing `LayoutConstraintsWrapper` should provide
    constraints

- [Material API](references/api/material-api.md) - Use when the chosen API is
  `MaterialResponsiveSize`, `MaterialResponsiveWidgetBuilder`,
  `MaterialWindowSizeClass`, `MaterialBreakpoints`,
  `MaterialResponsiveValue`, or `MaterialResponsiveValues`.
  - `MaterialResponsiveSize` - when Material 3 owns responsive classification
  - `MaterialResponsiveWidgetBuilder` - when Material window classes change the
    widget branch
  - `MaterialResponsiveValues` - when implementing Material margins, panes,
    sheets, dialogs, or adaptive constants
  - `MaterialBreakpoints` and `MaterialResponsiveValue` - when customizing the
    Material responsive path

- [Breakpoints And Resolution](references/api/breakpoints-and-resolution.md) -
  Use when the chosen API is `Breakpoints`, `BreakpointsGranular`,
  `BreakpointsHandler`, `BreakpointsHandlerGranular`,
  `BaseBreakpointsHandler`, `LayoutSize`, or `LayoutSizeGranular`, or when
  fallback behavior matters.
  - `Breakpoints` - when defining standard width thresholds
  - `BreakpointsGranular` - when defining granular width thresholds
  - fallback behavior - when sparse breakpoint values should resolve correctly
  - `useShortestSide` - when classification should use the shorter dimension

### Implementation References

- [Shell, Navigation, And State](references/implementation/shell-navigation-state.md)
  - Use for app shells, page shells, nested routers, AutoRoute-style stacks,
    tabs, bottom navigation, drawers, sidebars, master-detail, split views, and
    preserving route state across responsive branches.

- [Component And Local Layout](references/implementation/component-and-local-layout.md)
  - Use for forms, cards, sections, panes, dialogs, reusable widgets, local
    constraints, `ResponsiveGrid`, `ResponsiveSectionRow`, and deciding when not
    to use another screen-wide builder.

- [Testing Responsive Implementation](references/implementation/testing-responsive-implementation.md)
  - Use when adding or reviewing widget/integration tests for responsive
    behavior, viewport changes, router scopes, tab state, provider lifetime,
    scroll state, or responsive value contracts.

- [Patterns To Avoid](references/implementation/patterns-to-avoid.md)
  - Use during reviews and refactors to identify excessive top-level builder
    nesting, router resets, duplicated route state, branch-local controllers,
    and unsupported breakpoint gaps.

## Usage

**Before writing:** Classify the task, choose the responsive owner, then open the
matching implementation and/or API reference. If the task crosses more than one
responsive concern, open every matching reference before editing.

**While writing:** Keep API choice and ownership consistent. If implementation
pressure pushes you toward another family or another owner, return to the
decision flow and reclassify the responsive problem.

**After writing:** Verify the result still matches the selected API family,
package fallback behavior, ownership boundary, and state lifetime. Test the
real breakpoint setup and the state contracts affected by the branch.
