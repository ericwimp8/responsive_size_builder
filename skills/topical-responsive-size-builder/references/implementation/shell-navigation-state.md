# Shell, Navigation, And State

Use screen-wide responsive builders at boundaries where the full window changes
the app structure.

Good shell-level responsibilities:

- Swap mobile scaffold, tablet header, desktop sidebar, and large split views.
- Choose bottom navigation, navigation rail, drawer, side menu, or tab bar.
- Choose list-only, detail-only, or master-detail route composition.
- Decide whether a child route should render content or a desktop placeholder.
- Install breakpoint or responsive-value context for a subtree when descendants
  need it.

Keep the routed child stable:

```dart
class OrdersShellPage extends StatefulWidget {
  const OrdersShellPage({super.key});

  @override
  State<OrdersShellPage> createState() => _OrdersShellPageState();
}

class _OrdersShellPageState extends State<OrdersShellPage> {
  final _routerKey = GlobalKey<AutoRouterState>(
    debugLabel: 'OrdersShellPage router',
  );

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter(key: _routerKey);

    return ScreenWithValueWidgetBuilderGranular<AppLayoutConfig>(
      compactSmall: (_, _) => Scaffold(
        body: router,
        bottomNavigationBar: const OrdersBottomNavigation(),
      ),
      standardNormal: (_, _) => OrdersTabletShell(body: router),
      standardExtraLarge: (_, _) => OrdersMasterDetailShell(detail: router),
    );
  }
}
```

The router is created once by the shell state and passed into every branch.
Branches replace chrome around the router; they do not create different routers.

## Route-Derived UI State

Prefer deriving selected shell state from the current route:

- active home section
- selected tab
- current detail item
- active stage or mode
- whether shell chrome should be visible

When a route replacement temporarily lags or route params disappear during
teardown, keep a short-lived local cache for the displayed shell state. Update
the cache immediately after navigation so the tab highlight, title, or subtitle
does not flicker.

```dart
void selectTab(SettingsTab tab) {
  context.router.replace(tab.route);
  setState(() {
    _cachedTab = tab;
  });
}
```

The cache should mirror route state, not replace it as the long-term source of
truth.

## Master-Detail Ownership

For list/detail apps, make one shell own the split:

- compact: child route renders list or detail as normal pages
- medium: child route may render page chrome around the same content
- expanded: parent shell owns the master pane and child router owns detail

On expanded layouts, a list child route can return a placeholder in the detail
pane when nothing is selected. The parent shell owns the real master list.

## State Lifetime

Keep these outside responsive branches that can unmount:

- nested routers
- tab controllers
- scroll controllers and page storage
- form controllers and form keys
- provider scopes or cache wrappers that must preserve page state
- state wrappers that can briefly show loading or error UI

Do not place a router inside a provider/loading wrapper that may remove it during
refresh. That can reset the nested route stack and trigger redirects.

## Advanced Escape Hatches

Keeping a hidden routed child alive with maintained state can be useful when a
large-screen summary renders outside the route body but route state still has to
survive. Treat this as an escape hatch. Prefer a visible stable router or a
clearer route ownership model first.

## Dialogs And Overlays

If dialog or overlay content reads responsive values, show it inside the
responsive provider tree. Use the nearest navigator or an equivalent scoped
overlay pattern so inherited responsive data is still available.
