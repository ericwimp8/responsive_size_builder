# Responsive Size Builder – High-Level Overview

## Purpose
Responsive Size Builder is a Flutter package that maps breakpoints to widgets or plain values. It offers symmetric APIs across three data sources (screen, screen with responsive value, layout constraints), two breakpoint granularities (5-level `LayoutSize`, 12-level `LayoutSizeGranular`), and four payload types (widget, widget+orientation, value, value+orientation).

## Core Concepts
- **Breakpoints**: Encapsulated by `Breakpoints` and `BreakpointsGranular`, consumed via `BaseBreakpointsHandler` for nearest-match selection.
- **Providers**: `ScreenSize` and `ScreenSizeWithValue` inject MediaQuery-driven breakpoint data (and optional responsive values) into the tree.
- **Builders**: 24 wrappers cover every source/granularity/payload combination with optional orientation handling and animated switching.
- **Layout Path**: Layout builders classify `LayoutBuilder` constraints, keeping logic local (no global screen dependency) with optional `useShortestSide`.

## Public Surface (by category)
- Screen (global): `ScreenWidgetBuilder`, `ScreenWidgetBuilderOrientation`, `ScreenValueBuilder`, `ScreenValueBuilderOrientation` (+ granular variants).
- Screen with value: `ScreenWithValueWidgetBuilder`, `ScreenWithValueWidgetBuilderOrientation`, `ScreenWithValueValueBuilder`, `ScreenWithValueValueBuilderOrientation` (+ granular variants).
- Layout (local): `LayoutWidgetBuilder`, `LayoutWidgetBuilderOrientation`, `LayoutValueBuilder`, `LayoutValueBuilderOrientation` (+ granular variants).
- Utilities: `ScreenSize` / `ScreenSizeWithValue` providers, `ResponsiveValue`/`ResponsiveValueGranular`, layout constraints helpers.

## Behavior Guarantees
- Breakpoint selection falls back to the nearest available slot when an exact builder/value is missing.
- Orientation wrappers reuse the available posture when one orientation is not provided.
- Optional `animateChange` wraps widget outputs in `AnimatedSwitcher` with a 300ms default.
- Layout builders remain local-only; screen-based builders rely on inherited screen models.

## Structure
- `lib/src/core`: breakpoints, handlers, typedefs, utilities.
- `lib/src/screen*`: MediaQuery-driven builders (standard & granular).
- `lib/src/screen_with_value*`: MediaQuery + responsive value builders.
- `lib/src/layout*`: LayoutBuilder-driven builders.
- `lib/src/layout_constraints`: local constraints provider/wrapper.
- `example/`: demo routes for every wrapper.

## Verification
- Static: `dart analyze`
- Formatting: `dart format .`
- Runtime: `flutter test`, `flutter run example` (demos all wrappers).
