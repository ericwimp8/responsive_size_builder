# Testing Responsive Implementation

Responsive tests should prove behavior contracts, not only widget existence.

## Mirror The Real Setup

Install the same responsive owner used by the app or feature under test. That
may be no global owner, `ScreenSize`, `ScreenSizeWithValue`,
`MaterialResponsiveSize`, or a feature-scoped wrapper.

If the app uses shared responsive values, mirror that setup:

```dart
Widget responsiveSubject(Widget child) {
  final breakpoints = BreakpointsGranular.defaultBreakpoints.copyWith(
    compactSmall: 200,
  );

  return ScreenSizeWithValue<LayoutSizeGranular, AppLayoutConfig>(
    breakpoints: breakpoints,
    valueProvider: ResponsiveValueGranular<AppLayoutConfig>(
      breakpoints: breakpoints,
      compactSmall: const AppLayoutConfig(
        pagePadding: 16,
        useAutoScroll: true,
        compactActions: true,
      ),
      standardLarge: const AppLayoutConfig(
        pagePadding: 32,
        useAutoScroll: false,
        compactActions: false,
      ),
    ),
    child: child,
  );
}
```

Do not test app behavior against package defaults if the app customizes
breakpoints, Material classes, or responsive values.

## Test Named Breakpoints

Use named cases that map to meaningful breakpoints:

- tiny
- compact small
- compact normal
- standard normal
- standard extra large
- any custom product threshold that changes behavior

Assert the resolved breakpoint and the visible branch:

```dart
expect(
  ScreenSizeModel.breakpointOf<LayoutSizeGranular>(context),
  LayoutSizeGranular.compactSmall,
);
expect(find.byType(BottomNavigationBar), findsOneWidget);
expect(find.byType(NavigationRail), findsNothing);
```

Use `ScreenSizeModelWithValue.breakpointOf` instead when the test subject is
wrapped by `ScreenSizeWithValue`.

## Test Responsive Values

When the implementation uses responsive values, assert fallback behavior too:

- exact breakpoint value
- fallback from a nearby breakpoint
- derived values exposed through app helpers

## Test Route And Tab Sync

For shell routes, test:

- selected navigation state matches the current route
- tab highlight updates after navigation
- title/subtitle updates with the selected route
- route path stays correct after resizing
- child route content survives shell branch changes

Widget tests that need router context should install the route scopes required by
the router package in use. Integration tests can cover full browser/device
resizing and real navigation.

## Test State Lifetime

Exercise at least one resize or branch change for state that users can modify:

- scroll offset
- selected tab
- active detail row
- expanded/collapsed section
- partially edited form field
- dismissed banner or local page flag

State that must survive branch changes should be owned above the branch, stored
in page storage, or held by a route/provider scope with the correct lifetime.

## Keep Tests Focused

Widget tests should prove the shell contract and state handoff. Use broader
integration tests for full route graphs, real browser resizing, platform chrome,
and end-to-end navigation.
