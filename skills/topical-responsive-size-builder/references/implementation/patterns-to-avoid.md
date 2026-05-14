# Patterns To Avoid

Use this file during implementation reviews and refactors.

## Excessive Screen Builder Nesting

Avoid putting screen-wide builders throughout nested widgets.

Problem signs:

- every feature widget imports `responsive_size_builder`
- ordinary buttons, cards, and form fields read screen breakpoints directly
- route shell, page shell, and component all branch on the same screen width
- behavior is hard to predict because many builders rerun on resize

Prefer:

- one screen-wide decision at the shell/page boundary
- constructor args for branch decisions
- breakpoint-only context when descendants only need a breakpoint
- typed shared responsive values when descendants need common constants
- Material window classes when Material adaptive layout is the owner
- local layout builders for reusable widgets
- `ResponsiveGrid` and `ResponsiveSectionRow` for common component layouts

## Branch-Local State Owners

Avoid creating controllers or route owners inside a branch that disappears at
another breakpoint.

Risky owners include:

- nested router widgets with new keys
- tab controllers
- scroll controllers
- text editing controllers
- form keys
- provider/cache wrappers with route lifetime

Place them in the shell state, route state, page storage, or a provider above
the responsive branch.

## Router Inside Volatile Wrappers

Avoid placing a nested router inside a loading/error/animated wrapper that may
temporarily remove its child. Keep the router stable and put volatile content in
the master pane, detail pane, or routed page content instead.

## Duplicated Navigation Truth

Avoid storing selected tab or selected section only in local widget state when
the URL already owns it. Local state can bridge transition frames, but route
state should remain the durable source.

## Silent Unsupported Breakpoints

Avoid returning `SizedBox.shrink()` for a breakpoint unless the unsupported
state is intentional and tested. Tiny or unusual widths should either reuse the
nearest usable compact layout or fail in a deliberate, visible way during
development.

## Global Breakpoints For Local Problems

Avoid using screen width to decide a component layout when the parent pane,
dialog, drawer, or split view controls the actual available width. Use local
constraints instead.

## Widget Branching For Simple Values

Avoid rebuilding different widget trees when only one value changes. Use value
builders, a typed responsive value, or a simple resolved parameter for padding,
spacing, icon-only mode, max width, or column count.
