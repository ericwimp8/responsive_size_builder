# Responsive Size Builder Code Conventions and Standards

## Table of Contents
1. [Introduction and Purpose](#1-introduction-and-purpose)
2. [General Principles](#2-general-principles)
3. [Naming Conventions](#3-naming-conventions)
4. [Code Formatting Rules](#4-code-formatting-rules)
5. [Comment Standards](#5-comment-standards)
6. [Architectural Patterns](#6-architectural-patterns)
7. [Best Practices](#7-best-practices)
8. [Anti-Patterns](#8-anti-patterns)
9. [Code Review Checklist](#9-code-review-checklist)
10. [Tools and Automation](#10-tools-and-automation)
11. [Appendix: Examples and Templates](#appendix-examples-and-templates)

---

## 1. Introduction and Purpose

This document serves as the definitive reference for all developers working on the `responsive_size_builder` Flutter package. The package provides comprehensive responsive layout tools for Flutter applications, enabling developers to create adaptive UIs that work seamlessly across different screen sizes and device types.

### Package Overview

The `responsive_size_builder` package offers:
- Flexible breakpoint systems (standard 5-tier and granular 13-tier)
- Multiple builder widgets for different responsive design scenarios
- Layout constraint access and utilities
- Value-based responsive design capabilities
- Overlay positioning utilities for responsive contexts

### Document Scope

This document covers coding standards for:
- **Primary Language**: Dart (Flutter framework)
- **Target Audience**: Package contributors, maintainers, and external contributors
- **Code Base**: Library source code, example applications, and test suites
- **Level of Detail**: Comprehensive standards with specific examples

---

## 2. General Principles

### Core Development Philosophy

1. **Consistency First**: All code should follow consistent patterns to maintain readability and predictability
2. **Developer Experience**: APIs should be intuitive and self-documenting
3. **Performance Aware**: Responsive widgets should minimize rebuilds and optimize rendering
4. **Type Safety**: Leverage Dart's type system to prevent runtime errors
5. **Maintainability**: Code should be easy to understand, modify, and extend
6. **Flutter Standards**: Adhere to Flutter framework conventions and best practices

### Code Quality Principles

- Write self-documenting code with clear intent
- Favor composition over inheritance
- Design for testability from the start
- Use immutable data structures where possible
- Follow the principle of least privilege for widget rebuilds
- Optimize for both development and runtime performance

---

## 3. Naming Conventions

### General Naming Principles

- Names should be descriptive and reveal intent, not implementation
- Use consistent terminology throughout the codebase
- Avoid abbreviations except for widely understood terms (e.g., `dto`, `id`, `url`)
- Names should be pronounceable and searchable
- Use domain-specific vocabulary consistently

### Variables

#### Local Variables and Parameters
```dart
// Correct: camelCase, descriptive names
final screenWidth = MediaQuery.of(context).size.width;
final isPortraitOrientation = orientation == Orientation.portrait;
final breakpointThresholds = widget.breakpoints.values;

// Incorrect: abbreviated or unclear names
final sw = MediaQuery.of(context).size.width;
final p = orientation == Orientation.portrait;
final bp = widget.breakpoints.values;
```

#### Constants
```dart
// Correct: UPPER_SNAKE_CASE for constants
const double DEFAULT_ANIMATION_DURATION_MS = 300.0;
const int MAX_BREAKPOINT_COUNT = 13;
static const String BREAKPOINT_KEY_PREFIX = 'responsive_';

// Incorrect: other naming patterns for constants
const double defaultAnimationDurationMs = 300.0;
const int MaxBreakpointCount = 13;
```

#### Private Fields and Methods
```dart
// Correct: Leading underscore + camelCase
late BreakpointsHandler<ScreenSizeWidgetBuilder> _handler;
final List<LayoutSize> _availableSizes = [];

void _validateBreakpoints() {
  // Implementation
}

bool _isScreenSizeSupported(LayoutSize size) {
  // Implementation
}
```

### Functions and Methods

#### Public Methods
```dart
// Correct: camelCase, verb phrases describing action
Widget buildResponsiveLayout(BuildContext context) { }
LayoutSize calculateCurrentSize(double width) { }
void updateBreakpoints(Breakpoints newBreakpoints) { }

// Incorrect: unclear or non-verb names
Widget layout(BuildContext context) { }
LayoutSize size(double width) { }
void breakpoints(Breakpoints newBreakpoints) { }
```

#### Event Handlers and Callbacks
```dart
// Correct: on + EventName pattern
void onScreenSizeChanged(LayoutSize newSize) { }
void onBreakpointReached(double threshold) { }
VoidCallback? onLayoutComplete;

// Widget builders follow builder pattern
final ScreenSizeWidgetBuilder? extraLarge;
final ValueBuilder<T>? mediumBuilder;
```

### Classes and Types

#### Widget Classes
```dart
// Correct: PascalCase, descriptive widget names
class ScreenSizeBuilder extends StatefulWidget { }
class ResponsiveLayoutWrapper extends StatelessWidget { }
class BreakpointAwareContainer extends StatelessWidget { }

// Incorrect: unclear or abbreviated names
class SSB extends StatefulWidget { }
class Layout extends StatelessWidget { }
class Container extends StatelessWidget { }
```

#### Data Classes and Models
```dart
// Correct: suffix with appropriate descriptor
class ScreenSizeModelData { }
class BreakpointConfiguration { }
class ResponsiveValueSpec<T> { }

// Handler classes for business logic
class BreakpointsHandler<T> { }
class LayoutConstraintsHandler { }
```

#### Abstract Classes and Interfaces
```dart
// Correct: descriptive base names, Base prefix for abstract classes
abstract class BaseBreakpoints<T extends Enum> { }
abstract class LayoutConstraintsProviderBase { }

// Mixins use descriptive names
mixin ResponsiveHelperMixin { }
mixin BreakpointValidationMixin { }
```

### Files and Directories

#### Source Files
```dart
// Correct: snake_case matching primary class/component
screen_size_builder.dart          // Contains ScreenSizeBuilder
breakpoints_handler.dart          // Contains BreakpointsHandler
layout_constraints_provider.dart  // Contains LayoutConstraintsProvider
```

#### Test Files
```dart
// Correct: _test suffix for test files
screen_size_builder_test.dart
breakpoints_handler_test.dart
responsive_value_test.dart

// Integration test files
responsive_layout_integration_test.dart
```

#### Directory Structure
```
// Correct: descriptive, logical grouping
lib/
  src/
    core/              # Core utilities and base classes
      breakpoints/     # Breakpoint-related classes
      utilities.dart   # Helper functions
    screen_size/       # Screen size builders and data
    layout_size/       # Layout size builders
    responsive_value/  # Value-based responsive components
    layout_constraints/ # Layout constraint utilities
    value_size/        # Value size builders
```

### Domain-Specific Naming

#### Responsive Design Terms
```dart
// Breakpoint-related naming
class Breakpoints { }              // Standard breakpoint configuration
class BreakpointsGranular { }      // Granular breakpoint configuration
enum LayoutSize { }                // Standard layout size categories
enum LayoutSizeGranular { }        // Granular layout size categories

// Builder-related naming
typedef ScreenSizeWidgetBuilder = Widget Function(BuildContext, ScreenSizeModelData);
typedef ValueBuilder<T> = T Function(LayoutSize);
typedef ResponsiveBuilder<T> = Widget Function(BuildContext, T);
```

#### Size Category Naming
```dart
// Standard categories: consistent across the package
enum LayoutSize {
  extraSmall,    // < 200px
  small,         // 200-600px
  medium,        // 600-950px  
  large,         // 950-1200px
  extraLarge,    // > 1200px
}

// Granular categories: organized by logical groups
enum LayoutSizeGranular {
  // Jumbo group (ultra-wide displays)
  jumboExtraLarge, jumboLarge, jumboNormal, jumboSmall,
  // Standard group (desktop/laptop)
  standardExtraLarge, standardLarge, standardNormal, standardSmall,
  // Compact group (mobile/tablet)
  compactExtraLarge, compactLarge, compactNormal, compactSmall,
  // Tiny group (minimal displays)
  tiny,
}
```

---

## 4. Code Formatting Rules

### Indentation and Spacing

#### Basic Indentation
```dart
// Use 2 spaces for indentation (never tabs)
class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
    this.extraLarge,
    this.large,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return BreakpointAwareBuilder(
      builder: (context, size) {
        return _buildForSize(size);
      },
    );
  }
}
```

#### Multi-line Expressions
```dart
// Correct: continuation lines indented one extra level
final widget = ResponsiveContainer(
    width: screenSize == LayoutSize.small
        ? 100.0
        : 200.0,
    child: Text('Responsive content'),
);

// Method chaining alignment
final processedBreakpoints = breakpoints.values
    .where((threshold) => threshold > 0)
    .toList()
    ..sort((a, b) => b.compareTo(a));
```

### Line Length and Breaking

#### Maximum Line Length
- **Target**: 80 characters for optimal readability
- **Hard limit**: 120 characters (matches analysis_options.yaml)
- **Break points**: After operators, before method names, at logical boundaries

```dart
// Correct: Break long lines at logical points
final isResponsiveBreakpoint = screenWidth >= breakpoints.medium &&
    screenWidth < breakpoints.large &&
    orientation == Orientation.landscape;

// Method calls with many parameters
final builder = ScreenSizeBuilder(
  extraLarge: (context, data) => DesktopLayout(),
  large: (context, data) => DesktopLayout(compact: true),
  medium: (context, data) => TabletLayout(),
  small: (context, data) => MobileLayout(),
  animateChange: true,
);
```

### Braces and Block Structure

#### Brace Style
```dart
// Correct: Opening braces on same line
if (screenSize == LayoutSize.small) {
  return MobileLayout();
} else if (screenSize == LayoutSize.medium) {
  return TabletLayout();
} else {
  return DesktopLayout();
}

// Always use braces, even for single statements
if (shouldAnimate) {
  return AnimatedSwitcher(child: layout);
}

// Empty blocks can be concise
void dispose() {}
```

#### Switch Statements
```dart
// Correct: Consistent formatting for switch expressions
Widget buildLayout(LayoutSize size) {
  return switch (size) {
    LayoutSize.extraSmall || LayoutSize.small => MobileLayout(),
    LayoutSize.medium => TabletLayout(),
    LayoutSize.large || LayoutSize.extraLarge => DesktopLayout(),
  };
}
```

### Whitespace Rules

#### Spacing Around Operators and Keywords
```dart
// Correct: Space around operators
final totalWidth = screenWidth + padding * 2;
final isLargeScreen = width >= breakpoints.large;

// Space after control flow keywords
if (condition) { }
for (final item in items) { }
while (isProcessing) { }

// Space after commas in parameter lists
final data = ScreenSizeModelData(
  screenSize: size,
  logicalScreenWidth: width,
  orientation: orientation,
);
```

#### Blank Lines
```dart
class BreakpointsHandler<T> {
  // Single blank line between class members
  final Map<LayoutSize, T> _builders = {};

  T getScreenSizeValue({required LayoutSize screenSize}) {
    // Implementation
  }

  void updateBuilder(LayoutSize size, T builder) {
    // Implementation  
  }
}
```

### Import Organization

#### Import Grouping and Ordering
```dart
// 1. Dart/Flutter framework imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 2. Third-party package imports (none currently used)

// 3. Internal package imports (always use package: syntax)
import 'package:responsive_size_builder/responsive_size_builder.dart';

// 4. Relative imports for internal files (within same module)
import '../core/breakpoints/breakpoints.dart';
import '../screen_size/screen_size_data.dart';

// Each group separated by blank line, alphabetically sorted within groups
```

---

## 5. Comment Standards

### Documentation Comments

#### Class-Level Documentation
```dart
/// A responsive widget builder that creates layouts based on screen size breakpoints.
///
/// [ScreenSizeBuilder] provides a simple and flexible way to build responsive
/// user interfaces that adapt to different screen sizes. It uses the standard
/// five-category breakpoint system and provides comprehensive screen size data
/// to each builder function.
///
/// ## Usage Example
///
/// ```dart
/// ScreenSizeBuilder(
///   small: (context, data) => MobileLayout(),
///   medium: (context, data) => TabletLayout(),
///   large: (context, data) => DesktopLayout(),
/// )
/// ```
///
/// See also:
///
/// * [ScreenSizeOrientationBuilder], for orientation-aware responsive building
/// * [ScreenSizeBuilderGranular], for fine-grained responsive control
class ScreenSizeBuilder extends StatefulWidget {
```

#### Method Documentation
```dart
/// Calculates the appropriate layout size category for the given screen width.
///
/// Uses the configured breakpoints to determine which size category applies.
/// The algorithm checks thresholds in descending order to find the first
/// match where the screen width meets or exceeds the breakpoint value.
///
/// ## Parameters
///
/// * [screenWidth]: The current screen width in logical pixels
/// * [breakpoints]: The breakpoint configuration to use for categorization
///
/// ## Returns
///
/// The [LayoutSize] category that corresponds to the given screen width.
/// Returns [LayoutSize.extraSmall] if the width is below all defined thresholds.
///
/// ## Example
///
/// ```dart
/// final size = calculateLayoutSize(800.0, Breakpoints.defaultBreakpoints);
/// // Returns LayoutSize.medium for 800px width with default breakpoints
/// ```
LayoutSize calculateLayoutSize(double screenWidth, Breakpoints breakpoints) {
  // Implementation
}
```

#### Property Documentation
```dart
/// Screen size breakpoints configuration.
///
/// Defines the thresholds used to categorize screen sizes. Each threshold
/// represents the minimum width required for that size category.
/// Defaults to [Breakpoints.defaultBreakpoints].
final Breakpoints breakpoints;
```

### Inline Comments

#### When to Use Inline Comments
```dart
// Correct: Explain "why" not "what"
// Using recursion here due to tree structure depth variability
Widget buildNestedLayout(LayoutNode node) {
  return node.hasChildren 
    ? buildNestedLayout(node.children.first)
    : Text(node.content);
}

// Correct: Complex algorithm explanation
// Apply breakpoint logic with fallback chain:
// large -> medium -> small -> extraSmall
final builder = _getBuilderWithFallback(currentSize);

// Incorrect: Obvious from code
// Increment counter by 1
counter++;

// Incorrect: Restating what the code does
// Create a new ScreenSizeBuilder widget
final widget = ScreenSizeBuilder(/*...*/);
```

#### Comment Placement
```dart
// Place comments on separate lines above the code
// This ensures better readability and maintainability
if (shouldUseCustomBreakpoints) {
  applyCustomConfiguration();
}

// For complex expressions, explain the logic
final shouldShowSidebar = screenSize == LayoutSize.large ||
    screenSize == LayoutSize.extraLarge ||
    // Always show sidebar on desktop platforms
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows;
```

### Special Comments

#### TODO Comments
```dart
// TODO(username): Add support for custom animation curves [Issue #123]
AnimatedSwitcher buildAnimatedTransition(Widget child) {
  return AnimatedSwitcher(
    duration: Duration(milliseconds: 300),
    child: child,
  );
}
```

#### FIXME Comments
```dart
// FIXME(username): Memory leak in large screen transitions [Issue #456]
// Temporary workaround until proper disposal is implemented
void dispose() {
  // Current implementation
}
```

#### HACK Comments
```dart
// HACK(username): Workaround for Flutter web layout issue
// Remove after Flutter 3.x.x fixes MediaQuery on web
final screenWidth = kIsWeb 
  ? window.innerWidth ?? MediaQuery.of(context).size.width
  : MediaQuery.of(context).size.width;
```

### Comment Maintenance

- **Update with Code**: Always update comments when changing code
- **Remove Obsolete Comments**: Delete comments that no longer apply
- **Code Reviews**: Verify comments are accurate and add value
- **Avoid Over-commenting**: Don't comment obvious operations

---

## 6. Architectural Patterns

### Package Architecture Overview

The `responsive_size_builder` package follows a layered architecture with clear separation of concerns:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Widgets, Builders, User APIs)    │
├─────────────────────────────────────┤
│          Business Layer             │
│   (Handlers, Models, Logic)        │
├─────────────────────────────────────┤
│         Infrastructure Layer        │
│  (Utilities, Base Classes)         │
└─────────────────────────────────────┘
```

### Required Design Patterns

#### Builder Pattern for Responsive Widgets

All responsive widgets use the builder pattern to provide maximum flexibility:

```dart
// Correct: Builder pattern implementation
class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    // ... other parameters
  });

  final ScreenSizeWidgetBuilder? extraLarge;
  final ScreenSizeWidgetBuilder? large;
  // ... other builders

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(context);
    final builder = _selectBuilderForSize(data.screenSize);
    return builder(context, data);
  }
}
```

#### Strategy Pattern for Breakpoint Handling

Use strategy pattern for different breakpoint configurations:

```dart
// Abstract strategy interface
abstract class BaseBreakpoints<T extends Enum> {
  Map<T, double> get values;
}

// Concrete strategies
class Breakpoints implements BaseBreakpoints<LayoutSize> {
  @override
  Map<LayoutSize, double> get values => {
    LayoutSize.extraLarge: extraLarge,
    LayoutSize.large: large,
    // ...
  };
}

class BreakpointsGranular implements BaseBreakpoints<LayoutSizeGranular> {
  @override
  Map<LayoutSizeGranular, double> get values => {
    LayoutSizeGranular.jumboExtraLarge: jumboExtraLarge,
    // ...
  };
}
```

#### Template Method Pattern for Handler Classes

Handler classes use template method pattern for consistent processing:

```dart
abstract class BaseBreakpointsHandler<T, TEnum extends Enum> {
  // Template method defining the algorithm
  T getScreenSizeValue({required TEnum screenSize}) {
    final builder = findBuilderForSize(screenSize);
    if (builder != null) {
      return builder;
    }
    return findFallbackBuilder(screenSize);
  }
  
  // Abstract methods implemented by concrete classes
  T? findBuilderForSize(TEnum size);
  T findFallbackBuilder(TEnum size);
}
```

### Module Organization

#### Feature-Based Structure
Each major feature area has its own module with consistent internal structure:

```
lib/src/
├── core/                    # Core utilities and base classes
│   ├── breakpoints/         # Breakpoint definitions and handlers
│   │   ├── base_breakpoints_handler.dart
│   │   ├── breakpoints.dart
│   │   ├── breakpoints_handler.dart
│   │   └── breakpoints_handler_granular.dart
│   ├── overlay_position_utils.dart
│   └── utilities.dart
├── screen_size/             # Screen size responsive widgets
│   ├── screen_size_builder.dart
│   ├── screen_size_data.dart
│   └── screen_size_orientation_builder.dart
├── layout_size/             # Layout size responsive widgets
├── responsive_value/        # Value-based responsive components
├── layout_constraints/      # Layout constraint utilities
└── value_size/             # Value size builders
```

#### Module Exports
Each module exports its public API through the main library file:

```dart
// lib/responsive_size_builder.dart
library responsive_size_builder;

// Export only public APIs, hide internal implementation
export 'src/core/breakpoints/breakpoints.dart';
export 'src/core/breakpoints/breakpoints_handler.dart';
export 'src/screen_size/screen_size_builder.dart';
export 'src/screen_size/screen_size_data.dart';
// ... other exports

// Internal files are not exported
// export 'src/core/breakpoints/base_breakpoints_handler.dart'; // Private
```

### Inheritance and Composition Guidelines

#### Favor Composition Over Inheritance

```dart
// Correct: Composition with handlers
class ScreenSizeBuilder extends StatefulWidget {
  // Compose functionality using handler
  late final BreakpointsHandler<ScreenSizeWidgetBuilder> _handler = 
    BreakpointsHandler<ScreenSizeWidgetBuilder>(
      breakpoints: widget.breakpoints,
      extraLarge: widget.extraLarge,
      large: widget.large,
      // ...
    );
}

// Incorrect: Deep inheritance hierarchies
class ScreenSizeBuilder extends ResponsiveWidget extends StatefulWidget {
  // Deep inheritance makes testing and modification difficult
}
```

#### Use Mixins for Cross-Cutting Concerns

```dart
// Mixin for common responsive functionality
mixin ResponsiveHelperMixin {
  bool isSmallScreen(double width) => width < 600;
  bool isMobileDevice() => defaultTargetPlatform.isMobile;
}

// Apply to classes that need the functionality
class CustomResponsiveWidget extends StatelessWidget with ResponsiveHelperMixin {
  @override
  Widget build(BuildContext context) {
    if (isSmallScreen(MediaQuery.of(context).size.width)) {
      return MobileLayout();
    }
    return DesktopLayout();
  }
}
```

### State Management Patterns

#### Widget-Level State Management

```dart
// Correct: Keep state management close to usage
class ScreenSizeBuilder extends StatefulWidget {
  @override
  State<ScreenSizeBuilder> createState() => _ScreenSizeBuilderState();
}

class _ScreenSizeBuilderState extends State<ScreenSizeBuilder> {
  // Handler is recreated when widget configuration changes
  late BreakpointsHandler<ScreenSizeWidgetBuilder> handler;
  
  @override
  void didUpdateWidget(ScreenSizeBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breakpoints != oldWidget.breakpoints) {
      handler = BreakpointsHandler<ScreenSizeWidgetBuilder>(
        breakpoints: widget.breakpoints,
        // ... other parameters
      );
    }
  }
}
```

#### Immutable Data Structures

```dart
// Correct: Immutable configuration classes
@immutable
class Breakpoints implements BaseBreakpoints<LayoutSize> {
  const Breakpoints({
    this.extraLarge = 1200.0,
    this.large = 950.0,
    this.medium = 600.0,
    this.small = 200.0,
  });

  final double extraLarge;
  final double large;
  final double medium;
  final double small;

  // Provide copyWith for immutable updates
  Breakpoints copyWith({
    double? extraLarge,
    double? large,
    double? medium,
    double? small,
  }) => Breakpoints(
    extraLarge: extraLarge ?? this.extraLarge,
    large: large ?? this.large,
    medium: medium ?? this.medium,
    small: small ?? this.small,
  );
}
```

---

## 7. Best Practices

### Widget Development Best Practices

#### Optimize Widget Rebuilds

```dart
// Correct: Extract expensive operations to avoid rebuilds
class ScreenSizeBuilder extends StatefulWidget {
  @override
  State<ScreenSizeBuilder> createState() => _ScreenSizeBuilderState();
}

class _ScreenSizeBuilderState extends State<ScreenSizeBuilder> {
  // Cache handler to avoid recreation on every build
  late final BreakpointsHandler<ScreenSizeWidgetBuilder> _handler;

  @override
  void initState() {
    super.initState();
    _handler = BreakpointsHandler<ScreenSizeWidgetBuilder>(
      breakpoints: widget.breakpoints,
      // ... configuration
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use cached handler, only rebuild when screen size changes
    final data = ScreenSizeModel.of<LayoutSize>(context);
    return _handler.getScreenSizeValue(screenSize: data.screenSize)(
      context,
      data,
    );
  }
}
```

#### Use const Constructors When Possible

```dart
// Correct: const constructor for immutable widgets
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    this.padding,
    super.key,
  });

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: child,
    );
  }
}

// Usage with const
const ResponsiveContainer(
  padding: EdgeInsets.all(16.0),
  child: Text('Content'),
)
```

#### Implement Proper Widget Keys

```dart
// Use keys for widgets in lists or when order might change
Widget buildResponsiveList(List<ResponsiveItem> items) {
  return Column(
    children: items.map((item) => ResponsiveListItem(
      key: ValueKey(item.id),  // Use stable, unique keys
      item: item,
    )).toList(),
  );
}
```

### Performance Best Practices

#### Minimize MediaQuery Lookups

```dart
// Correct: Pass screen data down instead of multiple MediaQuery calls
class ResponsiveLayoutBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Single MediaQuery lookup
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final orientation = mediaQuery.orientation;
    
    return _buildLayout(size, orientation);
  }

  Widget _buildLayout(Size size, Orientation orientation) {
    // Use passed parameters instead of additional MediaQuery lookups
    if (size.width > 1200) {
      return DesktopLayout();
    }
    return MobileLayout();
  }
}
```

#### Cache Expensive Calculations

```dart
class BreakpointsHandler<T> {
  BreakpointsHandler({required this.breakpoints});

  final BaseBreakpoints breakpoints;
  
  // Cache sorted breakpoints to avoid recomputation
  late final List<MapEntry<Enum, double>> _sortedBreakpoints = 
    breakpoints.values.entries
      .where((entry) => entry.value >= 0)  // Filter valid breakpoints
      .toList()
      ..sort((a, b) => b.value.compareTo(a.value));  // Sort descending

  T getScreenSizeValue({required Enum screenSize}) {
    // Use cached sorted list for efficient lookup
    for (final entry in _sortedBreakpoints) {
      if (screenSize == entry.key) {
        return _builders[screenSize]!;
      }
    }
    return _getDefaultBuilder();
  }
}
```

### API Design Best Practices

#### Design for Extensibility

```dart
// Correct: Use generic types to allow future extensions
abstract class BaseBreakpoints<T extends Enum> {
  Map<T, double> get values;
}

// This allows both LayoutSize and LayoutSizeGranular implementations
class Breakpoints implements BaseBreakpoints<LayoutSize> { }
class BreakpointsGranular implements BaseBreakpoints<LayoutSizeGranular> { }
```

#### Provide Sensible Defaults

```dart
// Correct: Provide default values for optional parameters
class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,  // Sensible default
    this.animateChange = false,                         // Safe default
    super.key,
  });
}
```

#### Use Named Parameters for Clarity

```dart
// Correct: Named parameters for complex constructors
final builder = ScreenSizeBuilder(
  extraLarge: (context, data) => DesktopLayout(),
  medium: (context, data) => TabletLayout(),
  small: (context, data) => MobileLayout(),
  breakpoints: customBreakpoints,
  animateChange: true,
);

// Incorrect: Positional parameters for complex APIs
final builder = ScreenSizeBuilder(
  desktopBuilder,
  null,        // What does this null represent?
  tabletBuilder,
  mobileBuilder,
  null,
  customBreakpoints,
  true,        // What does this boolean control?
);
```

### Error Handling Best Practices

#### Use Assertions for Development-Time Validation

```dart
class Breakpoints implements BaseBreakpoints<LayoutSize> {
  const Breakpoints({
    this.extraLarge = 1200.0,
    this.large = 950.0,
    this.medium = 600.0,
    this.small = 200.0,
  }) : assert(
         extraLarge > large && large > medium && medium > small && small >= 0,
         'Breakpoints must be in descending order and larger than or equal to 0.',
       );
}
```

#### Provide Meaningful Error Messages

```dart
// Correct: Descriptive assertion messages
const ScreenSizeBuilder({
  // ... parameters
}) : assert(
       extraLarge != null ||
       large != null ||
       medium != null ||
       small != null ||
       extraSmall != null,
       'At least one builder must be provided. ScreenSizeBuilder requires '
       'at least one size-specific builder to function properly.',
     );
```

#### Handle Edge Cases Gracefully

```dart
class BreakpointsHandler<T> {
  T getScreenSizeValue({required Enum screenSize}) {
    final builder = _builders[screenSize];
    if (builder != null) {
      return builder;
    }
    
    // Graceful fallback with clear logic
    return _findFallbackBuilder(screenSize) ?? 
           _getDefaultBuilder() ??
           throw StateError(
             'No suitable builder found for $screenSize and no default builder available. '
             'Ensure at least one builder is provided to ScreenSizeBuilder.',
           );
  }
}
```

### Testing Best Practices

#### Write Widget Tests for All Builders

```dart
// Test all responsive breakpoints
testWidgets('ScreenSizeBuilder builds correct widget for each screen size', (tester) async {
  for (final size in LayoutSize.values) {
    await tester.pumpWidget(
      MaterialApp(
        home: ScreenSize<LayoutSize>(
          screenWidth: _getWidthForSize(size),
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ScreenSizeBuilder(
            extraLarge: (_, __) => const Text('Desktop'),
            large: (_, __) => const Text('Desktop'),
            medium: (_, __) => const Text('Tablet'),
            small: (_, __) => const Text('Mobile'),
            extraSmall: (_, __) => const Text('Mobile'),
          ),
        ),
      ),
    );
    
    final expectedText = _getExpectedTextForSize(size);
    expect(find.text(expectedText), findsOneWidget);
  }
});
```

#### Test Edge Cases and Error Conditions

```dart
testWidgets('ScreenSizeBuilder throws when no builders provided', (tester) async {
  expect(
    () => ScreenSizeBuilder(), // No builders provided
    throwsAssertionError,
  );
});

testWidgets('ScreenSizeBuilder handles missing builder gracefully', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ScreenSize<LayoutSize>(
        screenWidth: 800,  // Medium size
        breakpoints: Breakpoints.defaultBreakpoints,
        child: ScreenSizeBuilder(
          // Only provide large builder, test fallback behavior
          large: (_, __) => const Text('Large'),
        ),
      ),
    ),
  );
  
  // Should fall back to large builder
  expect(find.text('Large'), findsOneWidget);
});
```

---

## 8. Anti-Patterns

### Common Anti-Patterns to Avoid

#### God Widget Anti-Pattern

```dart
// ❌ Bad: Widget doing too many responsibilities
class ResponsiveLayoutManager extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildNavigation(), 
        _buildContent(),
        _buildSidebar(),
        _buildFooter(),
        _buildModal(),
        _buildNotifications(),
        // ... 50+ methods
      ],
    );
  }
  
  Widget _buildHeader() { /* Complex header logic */ }
  Widget _buildNavigation() { /* Complex navigation logic */ }
  // ... many more methods
}

// ✅ Better: Separated responsibilities
class ResponsiveLayoutScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHeader(),
      drawer: ResponsiveNavigation(),
      body: ResponsiveContent(),
      endDrawer: ResponsiveSidebar(),
    );
  }
}

class ResponsiveHeader extends StatelessWidget { }
class ResponsiveNavigation extends StatelessWidget { }
class ResponsiveContent extends StatelessWidget { }
class ResponsiveSidebar extends StatelessWidget { }
```

#### Hardcoded Breakpoints Anti-Pattern

```dart
// ❌ Bad: Hardcoded breakpoints scattered throughout code
class MobileFirstLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {          // Magic number
      return MobileLayout();
    } else if (width < 1024) {  // Another magic number
      return TabletLayout();
    } else if (width < 1440) {  // Yet another magic number
      return DesktopLayout();
    }
    return DesktopLayout();
  }
}

// ✅ Better: Centralized breakpoint configuration
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      small: (_, __) => MobileLayout(),
      medium: (_, __) => TabletLayout(),
      large: (_, __) => DesktopLayout(),
      breakpoints: Breakpoints.defaultBreakpoints,  // Centralized config
    );
  }
}
```

#### Multiple MediaQuery Lookups Anti-Pattern

```dart
// ❌ Bad: Multiple unnecessary MediaQuery lookups
class InefficientResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width > 1200 ? 200 : 100,
          child: Text('Header'),
        ),
        Container(
          height: MediaQuery.of(context).size.height > 800 ? 300 : 200,
          child: Text('Content'),
        ),
        if (MediaQuery.of(context).size.width > 768)
          Container(child: Text('Sidebar')),
      ],
    );
  }
}

// ✅ Better: Single MediaQuery lookup with data passing
class EfficientResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      small: (context, data) => _buildLayout(data, isSmall: true),
      medium: (context, data) => _buildLayout(data, isSmall: false),
      large: (context, data) => _buildLayout(data, isSmall: false),
    );
  }
  
  Widget _buildLayout(ScreenSizeModelData data, {required bool isSmall}) {
    return Column(
      children: [
        Container(
          width: isSmall ? 100 : 200,
          child: Text('Header'),
        ),
        Container(
          height: data.logicalScreenHeight > 800 ? 300 : 200,
          child: Text('Content'),
        ),
        if (!isSmall)
          Container(child: Text('Sidebar')),
      ],
    );
  }
}
```

#### Deep Widget Tree Anti-Pattern

```dart
// ❌ Bad: Deep nesting makes widgets hard to understand and test
class DeepNestedResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      large: (context, data) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Container(
                            child: Text('Deep nested content'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Better: Extract widgets and compose
class CleanResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      large: (context, data) => DesktopLayoutContainer(
        child: MainContentArea(),
      ),
    );
  }
}

class DesktopLayoutContainer extends StatelessWidget {
  const DesktopLayoutContainer({required this.child, super.key});
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: child,
    );
  }
}

class MainContentArea extends StatelessWidget { }
```

#### Mutable State in Builders Anti-Pattern

```dart
// ❌ Bad: Modifying external state in builder functions
class StatefulResponsiveWidget extends StatefulWidget {
  @override
  State<StatefulResponsiveWidget> createState() => _StatefulResponsiveWidgetState();
}

class _StatefulResponsiveWidgetState extends State<StatefulResponsiveWidget> {
  int counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      large: (context, data) {
        counter++;  // ❌ Bad: Side effect in builder
        return Text('Built $counter times');
      },
      small: (context, data) {
        counter++;  // ❌ Bad: Side effect in builder
        return Text('Mobile: $counter');
      },
    );
  }
}

// ✅ Better: Keep builders pure, manage state properly
class CleanStatefulResponsiveWidget extends StatefulWidget {
  @override
  State<CleanStatefulResponsiveWidget> createState() => _CleanStatefulResponsiveWidgetState();
}

class _CleanStatefulResponsiveWidgetState extends State<CleanStatefulResponsiveWidget> {
  int counter = 0;
  
  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      large: (context, data) => DesktopCounterView(
        counter: counter,
        onIncrement: _incrementCounter,
      ),
      small: (context, data) => MobileCounterView(
        counter: counter,
        onIncrement: _incrementCounter,
      ),
    );
  }
}
```

#### Over-Engineering Anti-Pattern

```dart
// ❌ Bad: Over-complex solution for simple responsive needs
abstract class ResponsiveStrategy {
  Widget build(BuildContext context, ScreenSizeModelData data);
}

class MobileStrategy implements ResponsiveStrategy { }
class TabletStrategy implements ResponsiveStrategy { }
class DesktopStrategy implements ResponsiveStrategy { }

class ResponsiveStrategyFactory {
  static ResponsiveStrategy create(LayoutSize size) {
    switch (size) {
      case LayoutSize.small: return MobileStrategy();
      case LayoutSize.medium: return TabletStrategy();
      default: return DesktopStrategy();
    }
  }
}

class OverEngineeredResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      small: (context, data) => ResponsiveStrategyFactory
          .create(LayoutSize.small)
          .build(context, data),
      // ... more complex strategy usage
    );
  }
}

// ✅ Better: Simple, direct approach
class SimpleResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      small: (context, data) => MobileLayout(),
      medium: (context, data) => TabletLayout(),
      large: (context, data) => DesktopLayout(),
    );
  }
}
```

### Performance Anti-Patterns

#### Expensive Operations in Build Methods

```dart
// ❌ Bad: Expensive operations in build method
class SlowResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ Bad: Expensive computation on every build
    final sortedBreakpoints = Breakpoints.defaultBreakpoints.values.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));
    
    return ScreenSizeBuilder(
      large: (context, data) {
        // ❌ Bad: Another expensive operation
        final processedData = _processLargeAmountOfData(data);
        return Text(processedData);
      },
    );
  }
  
  String _processLargeAmountOfData(ScreenSizeModelData data) {
    // Expensive computation
    return 'processed';
  }
}

// ✅ Better: Cache expensive operations
class OptimizedResponsiveWidget extends StatefulWidget {
  @override
  State<OptimizedResponsiveWidget> createState() => _OptimizedResponsiveWidgetState();
}

class _OptimizedResponsiveWidgetState extends State<OptimizedResponsiveWidget> {
  // Cache expensive computations
  static final _sortedBreakpoints = Breakpoints.defaultBreakpoints.values.entries
      .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  
  String? _cachedProcessedData;
  
  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      large: (context, data) => Text(_getCachedProcessedData(data)),
    );
  }
  
  String _getCachedProcessedData(ScreenSizeModelData data) {
    return _cachedProcessedData ??= _processData(data);
  }
}
```

---

## 9. Code Review Checklist

### Pre-Review Checklist (Author)

#### Before Submitting PR

- [ ] **Code compiles without warnings or errors**
  - Run `dart analyze` and resolve all issues
  - Ensure no Flutter-specific warnings

- [ ] **All tests pass locally**
  - Run `flutter test` for all test suites
  - Verify example app builds and runs correctly

- [ ] **New code has appropriate test coverage**
  - Widget tests for all new responsive builders
  - Unit tests for business logic and utilities
  - Integration tests for complex responsive scenarios

- [ ] **Documentation updated for API changes**
  - Update doc comments for new public APIs
  - Add usage examples to doc comments
  - Update README if public interface changes

- [ ] **Code follows package conventions**
  - Naming conventions consistent with existing code
  - File organization follows established patterns
  - Import organization matches package standards

- [ ] **No debugging artifacts left in code**
  - No `print()` or `debugPrint()` statements
  - No commented-out code blocks
  - No TODO comments without associated issues

- [ ] **Proper error handling implemented**
  - Assertions for development-time validation
  - Graceful fallbacks for runtime conditions
  - Meaningful error messages

- [ ] **Performance considerations addressed**
  - Minimize MediaQuery lookups
  - Cache expensive computations
  - Avoid rebuilds in hot code paths

### Review Checklist (Reviewer)

#### Code Quality Review

- [ ] **Business requirements satisfied**
  - Feature works as specified
  - Edge cases properly handled
  - Responsive behavior correct across screen sizes

- [ ] **Architecture consistency**
  - Follows established patterns (Builder, Strategy, Template Method)
  - Maintains separation of concerns
  - Uses composition over inheritance appropriately

- [ ] **API Design Quality**
  - Public APIs are intuitive and well-documented
  - Named parameters used for complex constructors
  - Sensible defaults provided
  - Generic types used appropriately

- [ ] **Code Readability**
  - Code is self-documenting with clear names
  - Complex logic has explanatory comments
  - No overly complex methods or classes

- [ ] **Error Handling**
  - Proper assertions with meaningful messages
  - Graceful degradation for missing builders
  - Clear error messages for common mistakes

- [ ] **Performance Impact**
  - No obvious performance regressions
  - Efficient use of Flutter widget lifecycle
  - Minimal unnecessary widget rebuilds

#### Testing Review

- [ ] **Test Coverage Adequate**
  - Critical paths covered by tests
  - Edge cases have corresponding tests
  - Responsive behavior tested across breakpoints

- [ ] **Test Quality**
  - Tests are clear and maintainable
  - Test names describe the behavior being tested
  - Setup and teardown properly handled

- [ ] **Integration Testing**
  - Example app demonstrates new features
  - Complex responsive scenarios tested end-to-end

#### Documentation Review

- [ ] **API Documentation Complete**
  - All public classes and methods documented
  - Doc comments include usage examples
  - See-also references help navigation

- [ ] **Code Examples Accurate**
  - Examples compile and run correctly
  - Examples demonstrate best practices
  - Complex features have comprehensive examples

### Security and Compatibility Review

- [ ] **No Security Issues**
  - No sensitive information exposed
  - Input validation where appropriate
  - Safe defaults for all configurations

- [ ] **Flutter Compatibility**
  - Compatible with specified Flutter SDK version
  - Uses appropriate APIs for target platforms
  - Handles platform differences correctly

- [ ] **Breaking Changes Documented**
  - Any API changes clearly documented
  - Migration path provided for breaking changes
  - Deprecation warnings for removed features

### Review Process Guidelines

#### For Minor Changes
- Code style fixes
- Documentation updates
- Small bug fixes
- One senior developer review required

#### For Major Changes
- New responsive builders
- API changes or additions
- Architecture modifications
- Two senior developer reviews required
- Tech lead approval for breaking changes

#### Review Response Time
- **Urgent fixes**: 24 hours
- **Feature additions**: 48-72 hours
- **Major refactoring**: 1 week

#### Review Feedback Guidelines

```dart
// ✅ Good feedback: Specific, actionable, explains reasoning
// Consider using a const constructor here for better performance.
// The widget doesn't appear to use any mutable state.
class ResponsiveContainer extends StatelessWidget {

// ✅ Good feedback: Suggests alternative approach
// This could lead to unnecessary rebuilds. Consider extracting the
// MediaQuery lookup to the parent and passing size as a parameter.
final width = MediaQuery.of(context).size.width;

// ❌ Poor feedback: Vague, not actionable
// This doesn't look right.

// ❌ Poor feedback: Nitpicky without substance
// Extra space here.
```

---

## 10. Tools and Automation

### Linter Configuration

The package uses `very_good_analysis` as the base linting configuration with additional customizations:

#### analysis_options.yaml Configuration

```yaml
include: package:very_good_analysis/analysis_options.5.1.0.yaml

language:
  strict-casts: true
  strict-inference: true
  strict-raw-types: true

analyzer:
  plugins:
    - custom_lint
  exclude: [build/**, lib/**.freezed.dart, lib/**.g.dart, lib/l10n/**]
  errors:
    # Package-specific error overrides
    public_member_api_docs: false          # Handled by doc comments
    lines_longer_than_80_chars: false     # Allow up to 120 chars
    avoid_positional_boolean_parameters: false # Sometimes necessary for builders
    flutter_style_todos: false            # Custom TODO format used
    no_leading_underscores_for_local_identifiers: false # Allow for clarity

linter:
  rules:
    # Key rules for responsive size builder
    - always_declare_return_types
    - always_use_package_imports
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - require_trailing_commas
    - sort_child_properties_last
    - sort_constructors_first
    - use_key_in_widget_constructors
```

#### Running the Linter

```bash
# Analyze all Dart files
dart analyze

# Analyze specific directory
dart analyze lib/

# Apply automatic fixes
dart fix --apply

# Dry run to see what would be fixed
dart fix --dry-run
```

### Code Formatting

#### Dart Format Configuration

```bash
# Format all files with 80-character line length
dart format --line-length 80 .

# Format specific directory
dart format lib/

# Check formatting without applying changes
dart format --set-exit-if-changed .
```

#### IDE Settings

**VS Code (.vscode/settings.json)**:
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "editor.rulers": [80, 120],
  "dart.lineLength": 80,
  "dart.analysisExcludedFolders": [
    "build",
    ".dart_tool"
  ],
  "dart.enableSdkFormatter": true,
  "dart.formatOnSave": true
}
```

**IntelliJ IDEA / Android Studio**:
- Enable "Format code on save"
- Set line length to 80 characters
- Enable "Organize imports on save"
- Configure Dart analysis settings to match analysis_options.yaml

### Pre-commit Hooks

Install and configure pre-commit hooks to ensure code quality:

#### Installation

```bash
# Install pre-commit (requires Python)
pip install pre-commit

# Install hooks from configuration
pre-commit install
```

#### Configuration (.pre-commit-config.yaml)

```yaml
repos:
  - repo: local
    hooks:
      - id: dart-format
        name: Dart Format
        entry: dart format
        language: system
        files: \.dart$
        
      - id: dart-analyze
        name: Dart Analyze
        entry: dart analyze
        language: system
        files: \.dart$
        pass_filenames: false
        
      - id: dart-fix
        name: Dart Fix
        entry: dart fix --apply
        language: system
        files: \.dart$
        pass_filenames: false
        
      - id: flutter-test
        name: Flutter Test
        entry: flutter test
        language: system
        pass_filenames: false
        stages: [commit]
        
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
```

### Continuous Integration

#### GitHub Actions Workflow (.github/workflows/dart.yml)

```yaml
name: Dart CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.5.0'
        
    - name: Install dependencies
      run: flutter pub get
      
    - name: Verify formatting
      run: dart format --output=none --set-exit-if-changed .
      
    - name: Analyze project source
      run: dart analyze --fatal-infos
      
    - name: Run tests
      run: flutter test --coverage
      
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
        
    - name: Build example
      run: |
        cd example
        flutter build web --release
        flutter build apk --release
```

### Development Scripts

Create convenience scripts for common development tasks:

#### Makefile

```makefile
.PHONY: help analyze format test build clean example

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

analyze: ## Analyze Dart code
	dart analyze --fatal-infos

format: ## Format Dart code
	dart format --line-length 80 .

fix: ## Apply Dart fixes
	dart fix --apply

test: ## Run all tests
	flutter test --coverage

test-watch: ## Run tests in watch mode
	flutter test --watch

build-example: ## Build example app
	cd example && flutter build web --release

clean: ## Clean build artifacts
	flutter clean
	cd example && flutter clean

deps: ## Install dependencies
	flutter pub get
	cd example && flutter pub get

pub-check: ## Check package for publishing
	dart pub publish --dry-run

all: format analyze test build-example ## Run all quality checks
```

#### Development Scripts (scripts/dev.dart)

```dart
#!/usr/bin/env dart

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart scripts/dev.dart <command>');
    print('Commands: setup, test, build, publish-check');
    exit(1);
  }

  switch (args[0]) {
    case 'setup':
      setup();
      break;
    case 'test':
      runTests();
      break;
    case 'build':
      buildExample();
      break;
    case 'publish-check':
      publishCheck();
      break;
    default:
      print('Unknown command: ${args[0]}');
      exit(1);
  }
}

void setup() {
  print('Setting up development environment...');
  Process.runSync('flutter', ['pub', 'get']);
  Process.runSync('flutter', ['pub', 'get'], workingDirectory: 'example');
  print('Setup complete!');
}

void runTests() {
  print('Running tests...');
  final result = Process.runSync('flutter', ['test', '--coverage']);
  print(result.stdout);
  if (result.stderr.isNotEmpty) {
    print(result.stderr);
  }
  exit(result.exitCode);
}

void buildExample() {
  print('Building example app...');
  Process.runSync('flutter', ['build', 'web'], workingDirectory: 'example');
  Process.runSync('flutter', ['build', 'apk'], workingDirectory: 'example');
  print('Build complete!');
}

void publishCheck() {
  print('Checking package for publishing...');
  final result = Process.runSync('dart', ['pub', 'publish', '--dry-run']);
  print(result.stdout);
  if (result.stderr.isNotEmpty) {
    print(result.stderr);
  }
  exit(result.exitCode);
}
```

### IDE Extensions and Plugins

#### VS Code Extensions
- **Dart**: Official Dart language support
- **Flutter**: Official Flutter support
- **Dart Data Class Generator**: Generate data classes with copyWith methods
- **Flutter Widget Snippets**: Common Flutter widget snippets
- **Bracket Pair Colorizer**: Visual bracket matching
- **GitLens**: Git integration and history

#### IntelliJ IDEA / Android Studio Plugins
- **Dart**: Official Dart plugin
- **Flutter**: Official Flutter plugin  
- **Rainbow Brackets**: Visual bracket matching
- **Flutter Enhancement Suite**: Additional Flutter development tools

### Code Quality Metrics

#### Coverage Targets
- **Unit Test Coverage**: Minimum 80% line coverage
- **Widget Test Coverage**: All public widgets must have tests
- **Integration Test Coverage**: Critical user flows covered

#### Complexity Metrics
- **Cyclomatic Complexity**: Maximum 10 per method
- **Lines per Class**: Maximum 300 lines
- **Lines per Method**: Maximum 50 lines
- **Method Parameters**: Maximum 4 positional parameters

#### Automated Quality Checks

```bash
# Check test coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Check code complexity (using dart_code_metrics)
dart pub global activate dart_code_metrics
metrics lib --reporter=html

# Check for unused dependencies
dart pub deps --style=compact

# Check for dependency updates
dart pub outdated
```

---

## Appendix: Examples and Templates

### Widget Template

#### Basic Responsive Widget Template

```dart
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A responsive widget that adapts its layout based on screen size.
///
/// [ResponsiveWidgetTemplate] demonstrates the standard pattern for creating
/// responsive widgets using the responsive_size_builder package. It provides
/// different layouts for different screen size categories.
///
/// ## Usage Example
///
/// ```dart
/// ResponsiveWidgetTemplate(
///   title: 'My Content',
///   content: 'Responsive content that adapts to screen size',
///   customBreakpoints: myBreakpoints,
/// )
/// ```
///
/// See also:
///
/// * [ScreenSizeBuilder], the underlying responsive builder
/// * [Breakpoints], for configuring screen size thresholds
class ResponsiveWidgetTemplate extends StatelessWidget {
  /// Creates a [ResponsiveWidgetTemplate] with the given content.
  ///
  /// The [title] and [content] parameters are required and will be displayed
  /// using responsive layouts. The [breakpoints] parameter is optional and
  /// defaults to [Breakpoints.defaultBreakpoints].
  const ResponsiveWidgetTemplate({
    required this.title,
    required this.content,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    super.key,
  });

  /// The title text to display in the responsive layout.
  final String title;

  /// The main content text to display.
  final String content;

  /// Screen size breakpoints configuration.
  ///
  /// Defines the thresholds used to determine which layout to use.
  /// Defaults to [Breakpoints.defaultBreakpoints].
  final Breakpoints breakpoints;

  @override
  Widget build(BuildContext context) {
    return ScreenSizeBuilder(
      extraSmall: (context, data) => _buildMobileLayout(data),
      small: (context, data) => _buildMobileLayout(data),
      medium: (context, data) => _buildTabletLayout(data),
      large: (context, data) => _buildDesktopLayout(data),
      extraLarge: (context, data) => _buildDesktopLayout(data, expanded: true),
      breakpoints: breakpoints,
    );
  }

  /// Builds the mobile layout for small screens.
  ///
  /// Optimized for touch interaction with single-column layout
  /// and mobile-friendly spacing.
  Widget _buildMobileLayout(ScreenSizeModelData data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(data.context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(data.context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _buildMobileActions(data),
        ],
      ),
    );
  }

  /// Builds the tablet layout for medium screens.
  ///
  /// Provides more spacious layout with improved typography
  /// suitable for tablet-sized displays.
  Widget _buildTabletLayout(ScreenSizeModelData data) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(data.context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  content,
                  style: Theme.of(data.context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: _buildSideActions(data),
          ),
        ],
      ),
    );
  }

  /// Builds the desktop layout for large screens.
  ///
  /// Full-featured layout with sidebar, expanded content area,
  /// and desktop-optimized interactions.
  Widget _buildDesktopLayout(ScreenSizeModelData data, {bool expanded = false}) {
    return Padding(
      padding: EdgeInsets.all(expanded ? 32.0 : 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (expanded) ...[
            // Navigation sidebar for expanded desktop layout
            SizedBox(
              width: 250,
              child: _buildNavigationSidebar(data),
            ),
            const SizedBox(width: 32),
          ],
          Expanded(
            flex: expanded ? 3 : 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: expanded
                      ? Theme.of(data.context).textTheme.headlineLarge
                      : Theme.of(data.context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  content,
                  style: Theme.of(data.context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                _buildDesktopActions(data, expanded: expanded),
              ],
            ),
          ),
          const SizedBox(width: 32),
          SizedBox(
            width: expanded ? 300 : 250,
            child: _buildContentSidebar(data),
          ),
        ],
      ),
    );
  }

  /// Builds mobile-specific actions layout.
  Widget _buildMobileActions(ScreenSizeModelData data) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Primary Action'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Secondary Action'),
          ),
        ),
      ],
    );
  }

  /// Builds side actions for tablet layout.
  Widget _buildSideActions(ScreenSizeModelData data) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Primary Action'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Secondary Action'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text('Tertiary Action'),
        ),
      ],
    );
  }

  /// Builds desktop-specific actions layout.
  Widget _buildDesktopActions(ScreenSizeModelData data, {bool expanded = false}) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Primary Action'),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Secondary Action'),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
          child: const Text('Tertiary Action'),
        ),
        if (expanded) ...[
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            tooltip: 'Help',
          ),
        ],
      ],
    );
  }

  /// Builds navigation sidebar for expanded desktop layout.
  Widget _buildNavigationSidebar(ScreenSizeModelData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Navigation',
              style: Theme.of(data.context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildNavItem('Home', Icons.home),
            _buildNavItem('Settings', Icons.settings),
            _buildNavItem('Profile', Icons.person),
            _buildNavItem('Help', Icons.help),
          ],
        ),
      ),
    );
  }

  /// Builds content sidebar for desktop layouts.
  Widget _buildContentSidebar(ScreenSizeModelData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Related Content',
              style: Theme.of(data.context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildRelatedItem('Related Item 1'),
            _buildRelatedItem('Related Item 2'),
            _buildRelatedItem('Related Item 3'),
          ],
        ),
      ),
    );
  }

  /// Helper method to build navigation items.
  Widget _buildNavItem(String label, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
    );
  }

  /// Helper method to build related content items.
  Widget _buildRelatedItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {},
        child: Text(
          title,
          style: const TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
```

### Custom Breakpoints Template

#### Creating Custom Breakpoint Configuration

```dart
import 'package:flutter/foundation.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Custom breakpoint configuration for content-heavy applications.
///
/// This configuration is optimized for applications that display large amounts
/// of text content, such as documentation sites, blogs, or reading applications.
/// The breakpoints are adjusted to provide optimal reading line lengths and
/// comfortable content layouts.
///
/// ## Breakpoint Rationale
///
/// * **extraLarge (1400px)**: Wide content with sidebars for large monitors
/// * **large (1024px)**: Full content width with optional sidebar
/// * **medium (768px)**: Tablet-optimized reading width  
/// * **small (480px)**: Mobile reading width with larger text
///
/// ## Usage Example
///
/// ```dart
/// final contentBreakpoints = ContentOptimizedBreakpoints();
/// 
/// ScreenSizeBuilder(
///   breakpoints: contentBreakpoints,
///   large: (context, data) => WideContentLayout(),
///   medium: (context, data) => ReadingLayout(),
///   small: (context, data) => MobileReadingLayout(),
/// )
/// ```
@immutable
class ContentOptimizedBreakpoints implements BaseBreakpoints<LayoutSize> {
  /// Creates a content-optimized breakpoint configuration.
  ///
  /// The default values are optimized for reading applications where
  /// content readability and typography are primary concerns.
  const ContentOptimizedBreakpoints({
    this.extraLarge = 1400.0,
    this.large = 1024.0, 
    this.medium = 768.0,
    this.small = 480.0,
  }) : assert(
         extraLarge > large && large > medium && medium > small && small >= 0,
         'Breakpoints must be in descending order and non-negative.',
       );

  /// Breakpoint for extra large displays optimized for wide content layouts.
  ///
  /// At this width, content can be displayed with wide margins, multiple
  /// sidebars, and extensive white space for optimal reading experience
  /// on large monitors.
  final double extraLarge;

  /// Breakpoint for large displays optimized for full-width content.
  ///
  /// Content uses the full available width with comfortable margins
  /// and optional sidebar content. Suitable for laptop and desktop displays.
  final double large;

  /// Breakpoint for medium displays optimized for tablet reading.
  ///
  /// Content width is constrained for optimal reading line length
  /// on tablet devices. Typography and spacing are adjusted for
  /// touch interaction.
  final double medium;

  /// Breakpoint for small displays optimized for mobile reading.
  ///
  /// Content is presented in a single column with larger touch targets
  /// and mobile-optimized typography. Focus is on readability and
  /// easy navigation on small screens.
  final double small;

  /// Default content-optimized breakpoint configuration.
  static const defaultContentBreakpoints = ContentOptimizedBreakpoints();

  @override
  Map<LayoutSize, double> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: -1, // Catch-all for very small screens
      };

  @override
  String toString() {
    return 'ContentOptimizedBreakpoints(extraLarge: $extraLarge, large: $large, medium: $medium, small: $small)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContentOptimizedBreakpoints &&
        other.extraLarge == extraLarge &&
        other.large == large &&
        other.medium == medium &&
        other.small == small;
  }

  @override
  int get hashCode => Object.hash(extraLarge, large, medium, small);

  /// Creates a copy with the specified changes.
  ContentOptimizedBreakpoints copyWith({
    double? extraLarge,
    double? large,
    double? medium,
    double? small,
  }) {
    return ContentOptimizedBreakpoints(
      extraLarge: extraLarge ?? this.extraLarge,
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
    );
  }
}

/// E-commerce optimized breakpoint configuration.
///
/// Designed for online stores and shopping applications where product
/// displays, grids, and shopping cart layouts are primary concerns.
@immutable
class ECommerceBreakpoints implements BaseBreakpoints<LayoutSize> {
  const ECommerceBreakpoints({
    this.extraLarge = 1440.0,  // Large product grids
    this.large = 1200.0,       // Standard desktop shopping
    this.medium = 768.0,       // Tablet product browsing  
    this.small = 375.0,        // Mobile shopping optimized
  }) : assert(
         extraLarge > large && large > medium && medium > small && small >= 0,
         'Breakpoints must be in descending order and non-negative.',
       );

  final double extraLarge;
  final double large;
  final double medium;
  final double small;

  static const defaultECommerceBreakpoints = ECommerceBreakpoints();

  @override
  Map<LayoutSize, double> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: -1,
      };
}

/// Dashboard-optimized breakpoint configuration.
///
/// Designed for admin panels, analytics dashboards, and data-heavy
/// applications where multiple charts, tables, and widgets need to
/// be displayed simultaneously.
@immutable
class DashboardBreakpoints implements BaseBreakpoints<LayoutSize> {
  const DashboardBreakpoints({
    this.extraLarge = 1600.0,  // Multi-monitor dashboards
    this.large = 1200.0,       // Full dashboard layout
    this.medium = 900.0,       // Simplified dashboard
    this.small = 600.0,        // Mobile dashboard
  }) : assert(
         extraLarge > large && large > medium && medium > small && small >= 0,
         'Breakpoints must be in descending order and non-negative.',
       );

  final double extraLarge;
  final double large;
  final double medium;
  final double small;

  static const defaultDashboardBreakpoints = DashboardBreakpoints();

  @override
  Map<LayoutSize, double> get values => {
        LayoutSize.extraLarge: extraLarge,
        LayoutSize.large: large,
        LayoutSize.medium: medium,
        LayoutSize.small: small,
        LayoutSize.extraSmall: -1,
      };
}
```

### Test Templates

#### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Test suite template for responsive widgets.
///
/// This template demonstrates comprehensive testing patterns for responsive
/// widgets using the responsive_size_builder package. It covers all screen
/// sizes, edge cases, and common responsive scenarios.
void main() {
  group('ResponsiveWidget Tests', () {
    // Test helper to create widget with specific screen size
    Widget createTestWidget({
      required double screenWidth,
      required Widget child,
      Breakpoints? breakpoints,
    }) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(screenWidth, 800)),
          child: ScreenSize<LayoutSize>(
            breakpoints: breakpoints ?? Breakpoints.defaultBreakpoints,
            child: child,
          ),
        ),
      );
    }

    // Test data for different screen sizes
    final testSizes = {
      LayoutSize.extraSmall: 150.0,
      LayoutSize.small: 400.0,
      LayoutSize.medium: 800.0,
      LayoutSize.large: 1100.0,
      LayoutSize.extraLarge: 1300.0,
    };

    group('Layout Rendering Tests', () {
      testWidgets('renders correct layout for each screen size', (tester) async {
        for (final entry in testSizes.entries) {
          final size = entry.key;
          final width = entry.value;

          await tester.pumpWidget(
            createTestWidget(
              screenWidth: width,
              child: ScreenSizeBuilder(
                extraSmall: (_, __) => const Text('Extra Small Layout'),
                small: (_, __) => const Text('Small Layout'),
                medium: (_, __) => const Text('Medium Layout'),
                large: (_, __) => const Text('Large Layout'),
                extraLarge: (_, __) => const Text('Extra Large Layout'),
              ),
            ),
          );

          final expectedText = '${size.name.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim()} Layout'
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');

          expect(
            find.text(expectedText),
            findsOneWidget,
            reason: 'Expected $expectedText for screen size $size (width: $width)',
          );
        }
      });

      testWidgets('handles missing builders with fallback', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 800.0, // Medium size
            child: ScreenSizeBuilder(
              // Only provide large builder, should fall back
              large: (_, __) => const Text('Large Layout'),
              small: (_, __) => const Text('Small Layout'),
            ),
          ),
        );

        // Should fall back to small builder for medium size
        expect(find.text('Small Layout'), findsOneWidget);
      });

      testWidgets('respects custom breakpoints', (tester) async {
        final customBreakpoints = Breakpoints(
          extraLarge: 1000.0,
          large: 800.0,
          medium: 600.0,
          small: 400.0,
        );

        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 900.0,
            breakpoints: customBreakpoints,
            child: ScreenSizeBuilder(
              large: (_, __) => const Text('Large Layout'),
              medium: (_, __) => const Text('Medium Layout'),
              breakpoints: customBreakpoints,
            ),
          ),
        );

        // With custom breakpoints, 900px should be large (not extra large)
        expect(find.text('Large Layout'), findsOneWidget);
      });
    });

    group('Animation Tests', () {
      testWidgets('animates when screen size changes', (tester) async {
        Widget buildResponsiveWidget(double width) {
          return createTestWidget(
            screenWidth: width,
            child: ScreenSizeBuilder(
              small: (_, __) => const Text('Small'),
              large: (_, __) => const Text('Large'),
              animateChange: true,
            ),
          );
        }

        // Start with small screen
        await tester.pumpWidget(buildResponsiveWidget(400));
        expect(find.text('Small'), findsOneWidget);

        // Change to large screen
        await tester.pumpWidget(buildResponsiveWidget(1200));
        
        // Animation should be in progress
        await tester.pump(const Duration(milliseconds: 150));
        
        // Complete animation
        await tester.pumpAndSettle();
        expect(find.text('Large'), findsOneWidget);
      });

      testWidgets('does not animate when animateChange is false', (tester) async {
        Widget buildResponsiveWidget(double width) {
          return createTestWidget(
            screenWidth: width,
            child: ScreenSizeBuilder(
              small: (_, __) => const Text('Small'),
              large: (_, __) => const Text('Large'),
              animateChange: false, // No animation
            ),
          );
        }

        await tester.pumpWidget(buildResponsiveWidget(400));
        expect(find.text('Small'), findsOneWidget);

        await tester.pumpWidget(buildResponsiveWidget(1200));
        await tester.pump(); // Single pump should be enough
        expect(find.text('Large'), findsOneWidget);
      });
    });

    group('Data Access Tests', () {
      testWidgets('provides correct screen size data to builders', (tester) async {
        ScreenSizeModelData? capturedData;

        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 800.0,
            child: ScreenSizeBuilder(
              medium: (context, data) {
                capturedData = data;
                return const Text('Medium Layout');
              },
            ),
          ),
        );

        expect(capturedData, isNotNull);
        expect(capturedData!.screenSize, equals(LayoutSize.medium));
        expect(capturedData!.logicalScreenWidth, equals(800.0));
        expect(capturedData!.logicalScreenHeight, equals(800.0));
      });

      testWidgets('provides platform information in data', (tester) async {
        ScreenSizeModelData? capturedData;

        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 1200.0,
            child: ScreenSizeBuilder(
              large: (context, data) {
                capturedData = data;
                return const Text('Large Layout');
              },
            ),
          ),
        );

        expect(capturedData, isNotNull);
        expect(capturedData!.isDesktop, isA<bool>());
        expect(capturedData!.isTouch, isA<bool>());
        expect(capturedData!.isWeb, isA<bool>());
      });
    });

    group('Error Handling Tests', () {
      testWidgets('throws assertion error when no builders provided', (tester) async {
        expect(
          () => ScreenSizeBuilder(),
          throwsAssertionError,
        );
      });

      testWidgets('handles null breakpoints gracefully', (tester) async {
        // Should use default breakpoints when null is passed
        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 800.0,
            child: ScreenSizeBuilder(
              medium: (_, __) => const Text('Medium Layout'),
            ),
          ),
        );

        expect(find.text('Medium Layout'), findsOneWidget);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('handles exact breakpoint values', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 950.0, // Exactly at large breakpoint
            child: ScreenSizeBuilder(
              medium: (_, __) => const Text('Medium Layout'),
              large: (_, __) => const Text('Large Layout'),
            ),
          ),
        );

        // Should be large (>= breakpoint value)
        expect(find.text('Large Layout'), findsOneWidget);
      });

      testWidgets('handles very small screen sizes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 50.0, // Very small
            child: ScreenSizeBuilder(
              extraSmall: (_, __) => const Text('Extra Small Layout'),
              small: (_, __) => const Text('Small Layout'),
            ),
          ),
        );

        expect(find.text('Extra Small Layout'), findsOneWidget);
      });

      testWidgets('handles very large screen sizes', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            screenWidth: 5000.0, // Very large
            child: ScreenSizeBuilder(
              extraLarge: (_, __) => const Text('Extra Large Layout'),
              large: (_, __) => const Text('Large Layout'),
            ),
          ),
        );

        expect(find.text('Extra Large Layout'), findsOneWidget);
      });
    });
  });
}

/// Helper functions for testing
double getWidthForSize(LayoutSize size) {
  switch (size) {
    case LayoutSize.extraSmall:
      return 150.0;
    case LayoutSize.small:
      return 400.0;
    case LayoutSize.medium:
      return 800.0;
    case LayoutSize.large:
      return 1100.0;
    case LayoutSize.extraLarge:
      return 1300.0;
  }
}

String getExpectedTextForSize(LayoutSize size) {
  switch (size) {
    case LayoutSize.extraSmall:
    case LayoutSize.small:
      return 'Mobile';
    case LayoutSize.medium:
      return 'Tablet';
    case LayoutSize.large:
    case LayoutSize.extraLarge:
      return 'Desktop';
  }
}
```

### Integration Test Template

#### End-to-End Responsive Behavior Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Integration tests for responsive behavior across different scenarios.
///
/// These tests verify that responsive widgets work correctly in real-world
/// scenarios including device rotation, window resizing, and complex
/// responsive layouts.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Responsive Layout Integration Tests', () {
    testWidgets('responsive layout adapts to screen size changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenSizeBuilder(
              small: (context, data) => const MobileTestLayout(),
              medium: (context, data) => const TabletTestLayout(),
              large: (context, data) => const DesktopTestLayout(),
            ),
          ),
        ),
      );

      // Verify initial layout based on test device size
      await tester.pumpAndSettle();
      
      // Test navigation and interaction on current layout
      await _testLayoutInteractions(tester);
      
      // If running on a device that supports orientation changes
      if (await _supportsOrientationChange(tester)) {
        await _testOrientationChange(tester);
      }
    });

    testWidgets('complex responsive app navigation', (tester) async {
      await tester.pumpWidget(const ResponsiveTestApp());
      await tester.pumpAndSettle();

      // Test navigation between different pages
      await tester.tap(find.byType(NavigationDrawerIcon));
      await tester.pumpAndSettle();

      // Verify responsive navigation drawer
      expect(find.byType(DrawerHeader), findsOneWidget);
      
      // Navigate to different pages and verify responsive behavior
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      
      // Verify settings page adapts to current screen size
      await _verifyResponsiveSettings(tester);
    });

    testWidgets('responsive forms adapt to screen size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenSizeBuilder(
              small: (_, __) => const ResponsiveForm(layout: FormLayout.mobile),
              medium: (_, __) => const ResponsiveForm(layout: FormLayout.tablet),
              large: (_, __) => const ResponsiveForm(layout: FormLayout.desktop),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Test form interactions on current layout
      await _testFormInteractions(tester);
      
      // Verify form validation works across layouts
      await _testFormValidation(tester);
    });
  });

  group('Performance Integration Tests', () {
    testWidgets('responsive layouts do not cause excessive rebuilds', (tester) async {
      int buildCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScreenSizeBuilder(
              large: (context, data) {
                buildCount++;
                return Text('Build count: $buildCount');
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final initialBuildCount = buildCount;
      
      // Trigger some interactions that shouldn't cause rebuilds
      await tester.tap(find.text('Build count: $initialBuildCount'));
      await tester.pump();
      
      // Build count should not increase unnecessarily
      expect(buildCount, equals(initialBuildCount));
    });

    testWidgets('memory usage remains stable with responsive widgets', (tester) async {
      // This test would typically use more sophisticated memory monitoring
      // For example purposes, we verify that widgets are properly disposed
      
      for (int i = 0; i < 10; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: ScreenSizeBuilder(
              small: (_, __) => Text('Iteration $i'),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }
      
      // Verify final state
      expect(find.text('Iteration 9'), findsOneWidget);
    });
  });
}

/// Test helper functions

Future<void> _testLayoutInteractions(WidgetTester tester) async {
  // Test common interactions that should work on all layouts
  if (find.byType(FloatingActionButton).hitTestable().evaluate().isNotEmpty) {
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  }
  
  if (find.byType(IconButton).hitTestable().evaluate().isNotEmpty) {
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
  }
}

Future<bool> _supportsOrientationChange(WidgetTester tester) async {
  try {
    // Attempt to change orientation (this will fail on desktop)
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/system',
      null,
      (data) {},
    );
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> _testOrientationChange(WidgetTester tester) async {
  // Test orientation change if supported
  final originalSize = tester.binding.window.physicalSize;
  
  // Simulate orientation change by swapping width and height
  tester.binding.window.physicalSizeTestValue = Size(
    originalSize.height,
    originalSize.width,
  );
  
  await tester.pumpAndSettle();
  
  // Verify layout adapted to new orientation
  await _verifyOrientationAdaptation(tester);
  
  // Restore original size
  tester.binding.window.physicalSizeTestValue = originalSize;
  await tester.pumpAndSettle();
}

Future<void> _verifyOrientationAdaptation(WidgetTester tester) async {
  // Verify that the layout has adapted appropriately to orientation change
  // This would include checking for orientation-specific layouts
}

Future<void> _verifyResponsiveSettings(WidgetTester tester) async {
  // Verify that settings page adapts to screen size
  expect(find.byType(ListView), findsWidgets);
  
  // Test that settings are accessible regardless of screen size
  if (find.text('Theme').hitTestable().evaluate().isNotEmpty) {
    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();
  }
}

Future<void> _testFormInteractions(WidgetTester tester) async {
  // Test form field interactions
  final textFields = find.byType(TextFormField);
  if (textFields.evaluate().isNotEmpty) {
    await tester.enterText(textFields.first, 'Test input');
    await tester.pumpAndSettle();
  }
  
  // Test form submission
  final submitButton = find.text('Submit');
  if (submitButton.evaluate().isNotEmpty) {
    await tester.tap(submitButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _testFormValidation(WidgetTester tester) async {
  // Test form validation across different layouts
  final textFields = find.byType(TextFormField);
  if (textFields.evaluate().isNotEmpty) {
    await tester.enterText(textFields.first, ''); // Invalid input
    
    final submitButton = find.text('Submit');
    if (submitButton.evaluate().isNotEmpty) {
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      
      // Verify validation message appears
      expect(find.text('This field is required'), findsAtLeastNWidgets(1));
    }
  }
}

/// Test app components

class ResponsiveTestApp extends StatelessWidget {
  const ResponsiveTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScreenSizeBuilder(
        small: (_, __) => const MobileAppScaffold(),
        medium: (_, __) => const TabletAppScaffold(),
        large: (_, __) => const DesktopAppScaffold(),
      ),
    );
  }
}

class MobileTestLayout extends StatelessWidget {
  const MobileTestLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Mobile Layout'),
        Expanded(child: Center(child: Text('Mobile Content'))),
      ],
    );
  }
}

class TabletTestLayout extends StatelessWidget {
  const TabletTestLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 2, child: Text('Tablet Main')),
        Expanded(child: Text('Tablet Sidebar')),
      ],
    );
  }
}

class DesktopTestLayout extends StatelessWidget {
  const DesktopTestLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 250, child: Text('Desktop Nav')),
        Expanded(flex: 3, child: Text('Desktop Main')),
        SizedBox(width: 200, child: Text('Desktop Sidebar')),
      ],
    );
  }
}

enum FormLayout { mobile, tablet, desktop }

class ResponsiveForm extends StatelessWidget {
  const ResponsiveForm({required this.layout, super.key});
  
  final FormLayout layout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'This field is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'This field is required' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileAppScaffold extends StatelessWidget {
  const MobileAppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile App')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Mobile View')),
    );
  }
}

class TabletAppScaffold extends StatelessWidget {
  const TabletAppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tablet App')),
      drawer: const AppDrawer(),
      body: const Row(
        children: [
          Expanded(flex: 2, child: Center(child: Text('Tablet Main'))),
          Expanded(child: Center(child: Text('Tablet Panel'))),
        ],
      ),
    );
  }
}

class DesktopAppScaffold extends StatelessWidget {
  const DesktopAppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Row(
        children: [
          SizedBox(width: 250, child: AppNavigationRail()),
          Expanded(child: Center(child: Text('Desktop Content'))),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Menu')),
          ListTile(
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationRail(
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
      selectedIndex: 0,
    );
  }
}

class NavigationDrawerIcon extends StatelessWidget {
  const NavigationDrawerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }
}
```

---

This comprehensive Code Conventions and Standards document provides the foundation for consistent, maintainable, and high-quality code in the `responsive_size_builder` package. It should be reviewed and updated regularly as the package evolves and new patterns emerge.

The document serves as both a reference for current contributors and an onboarding guide for new developers joining the project. By following these standards, the codebase will remain clean, performant, and easy to maintain as it grows in complexity and features.