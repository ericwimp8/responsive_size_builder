# Responsive Size Builder Code Conventions and Standards

## Table of Contents

## 1. Introduction and Purpose
## 2. General Principles
## 3. Naming Conventions
## 4. Code Formatting Rules
## 5. Comment Standards
## 6. Architectural Patterns
## 7. Best Practices
## 8. Anti-Patterns
## 9. Code Review Checklist
## 10. Tools and Automation
## Appendix: Examples and Templates

---

## 1. Introduction and Purpose

This document establishes the code conventions and standards for the **Responsive Size Builder** Flutter package, a comprehensive responsive layout framework that provides flexible breakpoint systems and builder widgets for creating adaptive user interfaces.

### Project Overview

Responsive Size Builder is a Flutter package designed to simplify responsive design by offering:
- Flexible breakpoint systems (5-tier and 13-tier granular)
- Multiple responsive builder widgets
- Screen size detection and categorization
- Value-based responsive utilities
- Platform-specific device detection

### Target Audience

This document is intended for:
- Flutter developers working on the package
- Contributors to the open-source project
- Code reviewers and maintainers
- New team members joining the project

### Scope

These conventions apply to:
- All Dart code in the `lib/` directory
- Example applications in the `example/` directory
- Test files and supporting utilities
- Documentation and inline comments

---

## 2. General Principles

### Code Philosophy

Our codebase follows these fundamental principles:

1. **Clarity over Cleverness**: Code should be immediately understandable by any Flutter developer
2. **Consistency**: Similar problems should be solved in similar ways throughout the codebase
3. **Extensibility**: New breakpoints and responsive patterns should be easy to add
4. **Performance**: Responsive calculations should be efficient and cached when appropriate
5. **Type Safety**: Leverage Dart's type system to prevent runtime errors

### Design Values

- **Developer Experience**: APIs should be intuitive and well-documented
- **Flexibility**: Support both simple and complex responsive design scenarios
- **Reliability**: Edge cases should be handled gracefully with meaningful error messages
- **Maintainability**: Code should be organized logically and easy to modify

---

## 3. Naming Conventions

### General Naming Principles

- Names should be descriptive and self-documenting
- Avoid abbreviations except for widely understood terms (e.g., `mq` for MediaQuery)
- Use consistent terminology throughout the codebase
- Names should reveal intent, not implementation details

### Classes and Interfaces

**Classes**: PascalCase with descriptive noun phrases
```dart
// Correct
class ScreenSizeBuilder extends StatefulWidget { }
class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize> { }
class ScreenSizeModelData<K extends Enum> { }

// Incorrect
class SSBuilder { }
class Handler { }
class Data { }
```

**Abstract Classes**: Use descriptive names indicating their role
```dart
// Correct
abstract class BaseBreakpoints<T extends Enum> { }
abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> { }

// Incorrect
abstract class AbstractBreakpoints { }
abstract class IBreakpoints { }
```

**Mixins**: Use descriptive names indicating capability
```dart
// Correct (if we had mixins)
mixin ResponsiveCalculationMixin { }
mixin PlatformDetectionMixin { }
```

### Methods and Functions

**Public Methods**: camelCase with verb phrases describing the action
```dart
// Correct
T getScreenSizeValue({required K screenSize})
K getScreenSize(double size)
ScreenSizeModelData<T> updateMetrics(BuildContext context)

// Incorrect
T getValue(K k)  // Too generic
K calculate(double d)  // Unclear what is calculated
```

**Private Methods**: Leading underscore + camelCase
```dart
// Correct
T _getScreenSize(double size)
void _configureHandler()
Widget _buildResponsiveLayout()

// Incorrect
T getScreenSizePrivate(double size)  // Don't use "Private" in name
```

**Boolean Methods**: Use question-form naming
```dart
// Correct
bool get isDesktopDevice
bool get isTouchDevice
bool get isWeb

// Incorrect
bool get desktopDevice
bool get touchDevice
```

### Variables and Fields

**Local Variables**: camelCase with descriptive names
```dart
// Correct
final screenSize = getScreenSize(dimension);
final currentBreakpoint = widget.breakpoints.values[screenSize]!;
final mq = MediaQuery.of(context);

// Incorrect
final ss = getScreenSize(dimension);  // Too abbreviated
final bp = widget.breakpoints.values[screenSize]!;
final x = MediaQuery.of(context);  // Meaningless name
```

**Private Fields**: Leading underscore + camelCase
```dart
// Correct
late final FlutterView _view;
Orientation? _orientation;
BreakpointsHandler<WidgetBuilder> _handler;

// Incorrect
late final FlutterView view;  // Should be private
```

**Constants**: UPPER_SNAKE_CASE
```dart
// Correct
const Duration DEFAULT_ANIMATION_DURATION = Duration(milliseconds: 300);
const double DEFAULT_LARGE_BREAKPOINT = 950.0;

// From utilities.dart
bool kIsDesktopDevice = [/* ... */].contains(defaultTargetPlatform);
```

### Enums

**Enum Names**: PascalCase describing the category
```dart
// Correct
enum LayoutSize { extraSmall, small, medium, large, extraLarge }
enum LayoutSizeGranular { 
  jumboExtraLarge, jumboLarge, jumboNormal, jumboSmall,
  standardExtraLarge, standardLarge, standardNormal, standardSmall,
  compactExtraLarge, compactLarge, compactNormal, compactSmall,
  tiny
}
enum ScreenSizeAspect { screenSize, other }
```

**Enum Values**: camelCase with descriptive names
- Use size indicators: `small`, `medium`, `large`
- Use qualifiers: `extra`, `jumbo`, `standard`, `compact`
- Arrange from largest to smallest in granular enums

### Generic Type Parameters

**Single Letters**: Use conventional naming
```dart
// Correct
class ScreenSize<T extends Enum> extends StatefulWidget { }
class BaseBreakpointsHandler<T extends Object?, K extends Enum> { }
Map<K, T?> get values;

// Use T for primary type, K for secondary type (like keys)
```

### Files and Directories

**Dart Files**: snake_case matching the primary class name
```dart
// Correct
breakpoints.dart          // Contains Breakpoints class
screen_size_builder.dart  // Contains ScreenSizeBuilder class
breakpoints_handler.dart  // Contains BreakpointsHandler class

// Incorrect
Breakpoints.dart          // Wrong case
screenSizeBuilder.dart    // Wrong case
bpHandler.dart           // Too abbreviated
```

**Directories**: snake_case describing the content category
```dart
lib/src/          // Source files
example/lib/      // Example application
example/lib/pages/        // Example pages
example/lib/shared/widgets/  // Shared widgets
```

### Domain-Specific Naming

**Breakpoint-Related Classes**: Use "Breakpoint" or "Size" in names
```dart
// Correct
class Breakpoints implements BaseBreakpoints<LayoutSize>
class BreakpointsGranular implements BaseBreakpoints<LayoutSizeGranular>
class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize>
```

**Builder Widgets**: End with "Builder"
```dart
// Correct
class ScreenSizeBuilder extends StatefulWidget
class ScreenSizeOrientationBuilder extends StatefulWidget
class ScreenSizeBuilderGranular extends StatefulWidget
```

**Data Classes**: End with "Data"
```dart
// Correct
class ScreenSizeModelData<K extends Enum>
```

**Handler Classes**: End with "Handler"
```dart
// Correct
class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize>
class BreakpointsHandlerGranular<T> extends BaseBreakpointsHandler<T, LayoutSizeGranular>
```

---

## 4. Code Formatting Rules

### Indentation and Spacing

**Indentation**: Use 2 spaces (never tabs)
```dart
// Correct
class ScreenSize<T extends Enum> extends StatefulWidget {
  const ScreenSize({
    required this.breakpoints,
    required this.child,
    super.key,
  });
}

// Incorrect (uses 4 spaces)
class ScreenSize<T extends Enum> extends StatefulWidget {
    const ScreenSize({
        required this.breakpoints,
        required this.child,
        super.key,
    });
}
```

**Continuation Lines**: Align parameters or indent one additional level
```dart
// Correct - Aligned parameters
assert(
  extraLarge > large && 
  large > medium && 
  medium > small && 
  small >= 0,
  'Breakpoints must be in descending order and larger than or equal to 0.',
);

// Correct - Additional indentation
final model = InheritedModel.inheritFrom<ScreenSizeModel<K>>(
  context,
  aspect: ScreenSizeAspect.screenSize,
);
```

### Line Length

**Maximum**: 100 characters (configured in analysis_options.yaml with `lines_longer_than_80_chars: false`)
**Break Strategy**: At logical points (after operators, before method names)

```dart
// Correct
throw FlutterError('''
ScreenSizeModel<$K> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSize widget 
   (e.g., ScreenSize<LayoutSize>(...) or ScreenSize<LayoutSizeGranular>(...)).
2. You are requesting the correct type parameter <$K>.
''');

// Correct - Breaking at logical points
return other is BreakpointsGranular &&
    other.jumboExtraLarge == jumboExtraLarge &&
    other.jumboLarge == jumboLarge &&
    other.jumboNormal == jumboNormal;
```

### Braces and Blocks

**Opening Braces**: Same line (K&R style)
```dart
// Correct
if (condition) {
  doSomething();
}

class MyClass {
  void myMethod() {
    // Implementation
  }
}

// Incorrect
if (condition)
{
  doSomething();
}
```

**Single Statements**: Always use braces
```dart
// Correct
if (screenSizeCache == currentScreenSize && currentValue != null) {
  return currentValue!;
}

// Incorrect
if (screenSizeCache == currentScreenSize && currentValue != null)
  return currentValue!;
```

**Empty Blocks**: Can be written as `{}`
```dart
// Correct
void initState() {}

// Also correct for readability
void initState() {
  // No initialization needed
}
```

### Whitespace Rules

**Blank Lines**: 
- One blank line between method definitions
- One blank line between logical sections within long methods
- Two blank lines between top-level class definitions

**Trailing Whitespace**: Not allowed (enforced by linter)

**Spaces Around Operators**: Required
```dart
// Correct
final size = constraints.maxWidth;
if (size >= entry.value) {
  return entry.key;
}

// Incorrect
final size=constraints.maxWidth;
if (size>=entry.value) {
  return entry.key;
}
```

**Spaces After Keywords**: Required
```dart
// Correct
if (condition) { }
for (final item in items) { }
while (running) { }

// Incorrect
if(condition) { }
for(final item in items) { }
while(running) { }
```

### Import Organization

**Import Groups** (separated by blank lines):
1. Dart core libraries
2. Flutter libraries
3. Package dependencies
4. Local project imports (using relative paths)

```dart
// Correct
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../shared/widgets/screen_size_header.dart';
```

**Sorting**: Alphabetically within each group

**Path Style**: 
- Use `package:` imports for external dependencies
- Use relative imports for internal project files
- Always prefer `package:responsive_size_builder/` for internal library imports

---

## 5. Comment Standards

### Documentation Comments

**Public APIs**: Every public class, method, and significant field must have documentation comments

```dart
/// A responsive widget that provides screen size information to its child widgets.
///
/// [ScreenSize] monitors screen dimensions and breakpoints, making this data
/// available to descendant widgets through [ScreenSizeModel]. It automatically
/// updates when the screen size changes, allowing widgets to adapt their layout
/// responsively.
///
/// The type parameter [T] must extend [Enum] and represents the layout size
/// categories (e.g., [LayoutSize] or [LayoutSizeGranular]).
///
/// {@tool snippet}
/// This example shows how to wrap your app with [ScreenSize] to enable
/// responsive features:
///
/// ```dart
/// ScreenSize<LayoutSize>(
///   breakpoints: Breakpoints(),
///   child: MaterialApp(
///     home: MyHomePage(),
///   ),
/// )
/// ```
/// {@end-tool}
class ScreenSize<T extends Enum> extends StatefulWidget {
  // Implementation
}
```

**Documentation Structure**:
1. Brief description (one line)
2. Detailed explanation (if needed)
3. Type parameter documentation
4. Usage examples using `{@tool snippet}` blocks
5. See also references to related classes

**Parameter Documentation**:
```dart
/// Creates a [ScreenSize] widget.
///
/// The [breakpoints] parameter defines the screen size thresholds used to
/// determine the current layout category.
///
/// The [child] parameter is the widget subtree that will have access to
/// screen size data.
///
/// The [testView] parameter allows injection of a custom [FlutterView] for
/// testing purposes. When null, uses the platform's primary view.
const ScreenSize({
  required this.breakpoints,
  required this.child,
  this.testView,
  super.key,
});
```

### Inline Comments

**Use Sparingly**: Code should be self-documenting
**Explain "Why" Not "What"**: Focus on reasoning, not obvious operations

```dart
// Correct: Explains why
// Using recursion here due to tree structure depth variability
final entries = breakpoints.values.entries;

// Cache the last calculated screen size to avoid redundant calculations
K? screenSizeCache;

// Incorrect: Explains what (obvious from code)
// Get the entries from breakpoints values
final entries = breakpoints.values.entries;

// Set screenSizeCache to null
K? screenSizeCache;
```

**Complex Logic**: Add explanations for non-obvious algorithms
```dart
// Fallback resolution: search smaller breakpoints for available values
final index = breakpoints.values.keys.toList().indexOf(screenSizeCache!);
final validCallbacks = values.values.toList().sublist(index);
callback = validCallbacks.firstWhere(
  (element) => element != null,
  orElse: () => null,
);
```

### Special Comments

**TODO Comments**: For future enhancements
```dart
// TODO(username): Add support for custom aspect ratio calculations [FEATURE-123]
// TODO: Consider caching breakpoint calculations for performance
```

**FIXME Comments**: For known issues needing fixes
```dart
// FIXME(username): Handle edge case when all breakpoints are null [BUG-456]
```

**HACK Comments**: For temporary workarounds
```dart
// HACK(username): Temporary workaround for Flutter 3.0 compatibility - Remove after v2.0
```

**Implementation Notes**: For complex or non-obvious implementations
```dart
/// Implementation note: We use -1 as a special threshold value to indicate
/// catch-all categories that should match any remaining screen sizes.
final Map<LayoutSize, double> get values => {
  // ... other values
  LayoutSize.extraSmall: -1,  // Catch-all for smallest sizes
};
```

### Library Documentation

**Library Headers**: Document the purpose and main exports
```dart
/// A Flutter package for building responsive layouts based on screen size.
///
/// This library provides a comprehensive set of tools for creating responsive
/// user interfaces that adapt to different screen sizes and breakpoints.
///
/// ## Key Features
///
/// * **Flexible Breakpoint System**: Define custom breakpoints or use the
///   default ones to categorize screen sizes.
/// * **Multiple Builder Widgets**: Choose from various builder widgets depending
///   on your needs - simple screen size builders, orientation-aware builders,
///   and granular builders for fine-tuned control.
library responsive_size_builder;
```

---

## 6. Architectural Patterns

### Required Design Patterns

#### InheritedModel Pattern
All screen size data propagation must use Flutter's InheritedModel pattern for optimal performance:

```dart
/// Correct implementation using InheritedModel
class ScreenSizeModel<T extends Enum> extends InheritedModel<ScreenSizeAspect> {
  const ScreenSizeModel({
    required super.child,
    required this.data,
    super.key,
  });

  @override
  bool updateShouldNotifyDependent(
    ScreenSizeModel<T> oldWidget,
    Set<ScreenSizeAspect> dependencies,
  ) {
    // Selective notification based on aspects
    if (oldWidget.data.screenSize != data.screenSize &&
        dependencies.contains(ScreenSizeAspect.screenSize)) {
      return true;
    }
    return false;
  }
}
```

#### Generic Handler Pattern
All breakpoint-based value resolution must use the generic handler pattern:

```dart
// Base pattern
abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  Map<K, T?> get values;
  
  T getScreenSizeValue({required K screenSize}) {
    // Standard resolution logic with fallbacks
  }
}

// Concrete implementations
class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize> {
  // 5-category implementation
}

class BreakpointsHandlerGranular<T> extends BaseBreakpointsHandler<T, LayoutSizeGranular> {
  // 13-category implementation  
}
```

#### Builder Widget Pattern
All responsive widgets must follow Flutter's builder widget pattern:

```dart
// Required structure for responsive builders
class ScreenSizeBuilder extends StatefulWidget {
  // Builder function parameters for each breakpoint
  final ScreenSizeWidgetBuilder? small;
  final ScreenSizeWidgetBuilder? medium;
  // ... other sizes
  
  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(context);
    return handler.getScreenSizeValue(screenSize: data.screenSize)(context, data);
  }
}
```

#### Immutable Data Pattern
All data classes must be immutable with proper equality implementations:

```dart
@immutable
class ScreenSizeModelData<K extends Enum> {
  const ScreenSizeModelData({
    required this.breakpoints,
    required this.currentBreakpoint,
    required this.screenSize,
    // ... other required fields
  });

  final BaseBreakpoints<K> breakpoints;
  final double currentBreakpoint;
  final K screenSize;
  // ... other final fields

  // Implement equality and hashCode
  @override
  bool operator ==(Object other) { /* implementation */ }
  
  @override
  int get hashCode { /* implementation */ }
}
```

### Application Architecture

#### Layer Organization

**Presentation Layer** (`lib/src/` widgets):
- Responsive builder widgets (`ScreenSizeBuilder`, `ScreenSizeOrientationBuilder`)
- Data provider widgets (`ScreenSize`, `ScreenSizeModel`)
- Only UI logic and widget composition

**Business Logic Layer** (`lib/src/` handlers and utilities):
- Breakpoint calculation logic (`BaseBreakpointsHandler` implementations)
- Screen size categorization (`getScreenSize` methods)
- Platform detection utilities (`utilities.dart`)

**Data Layer** (`lib/src/` data classes):
- Breakpoint configurations (`Breakpoints`, `BreakpointsGranular`)
- Data models (`ScreenSizeModelData`)
- Enums defining categories (`LayoutSize`, `LayoutSizeGranular`)

#### Module Structure

Each responsive feature follows this structure:
```
/responsive-feature
  /breakpoint-config   # Breakpoints class defining thresholds
  /handler            # Logic for value resolution and caching
  /builder            # Widget implementing the responsive UI
  /data               # Immutable data classes
  /enums              # Size categories and aspects
```

Example with ScreenSizeBuilder:
```
/screen-size-builder
  breakpoints.dart         # Breakpoints configuration
  breakpoints_handler.dart # BreakpointsHandler logic  
  screen_size_builder.dart # ScreenSizeBuilder widget
  screen_size_data.dart    # ScreenSizeModel and data
  (shared enums in breakpoints.dart)
```

### Dependency Injection Pattern

Use constructor injection for all dependencies:

```dart
// Correct: Constructor injection
class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
    required this.breakpoints,  // Inject breakpoints configuration
    this.onChanged,             // Optional callback injection
    // ... other dependencies
  });
  
  final Breakpoints breakpoints;
  final void Function(LayoutSize)? onChanged;
}

// Incorrect: Global state or singletons
class ScreenSizeBuilder extends StatefulWidget {
  Widget build(BuildContext context) {
    final breakpoints = GlobalBreakpoints.instance;  // Avoid global state
    // ...
  }
}
```

---

## 7. Best Practices

### Generic Type Usage

**Always Use Bounded Generics**: Prevent type-related runtime errors
```dart
// Correct: Bounded generic ensures enum constraint
class BaseBreakpoints<T extends Enum> {
  Map<T, double> get values;
}

// Incorrect: Unbounded generic allows any type
class BaseBreakpoints<T> {
  Map<T, double> get values;  // T could be anything
}
```

**Meaningful Generic Names**: Use descriptive names for complex generics
```dart
// Correct: Clear meaning of each type parameter
class BaseBreakpointsHandler<TValue extends Object?, KCategory extends Enum> {
  Map<KCategory, TValue?> get values;
  TValue getScreenSizeValue({required KCategory screenSize});
}

// Acceptable for simple cases
class ScreenSize<T extends Enum> extends StatefulWidget { }
```

### Error Handling Standards

**Meaningful Error Messages**: Provide actionable information
```dart
// Correct: Detailed error with solution steps
throw FlutterError('''
ScreenSizeModel<$K> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSize widget 
   (e.g., ScreenSize<LayoutSize>(...) or ScreenSize<LayoutSizeGranular>(...)).
2. You are requesting the correct type parameter <$K>.

The context used to look up ScreenSizeModel was:
  $context
''');

// Incorrect: Vague error message
throw FlutterError('ScreenSizeModel not found');
```

**Assertions for Developer Errors**: Use assertions for configuration issues
```dart
// Correct: Assert configuration requirements
const Breakpoints({
  this.extraLarge = 1200.0,
  this.large = 950.0,
  this.medium = 600.0,
  this.small = 200.0,
}) : assert(
  extraLarge > large && large > medium && medium > small && small >= 0,
  'Breakpoints must be in descending order and larger than or equal to 0.',
);
```

**Graceful Fallbacks**: Handle edge cases without crashing
```dart
// Correct: Graceful fallback resolution
T getScreenSizeValue({required K screenSize}) {
  // Try direct match first
  var callback = values[screenSize];
  if (callback != null) {
    return callback;
  }
  
  // Fallback to smaller sizes
  final index = breakpoints.values.keys.toList().indexOf(screenSize);
  final validCallbacks = values.values.toList().sublist(index);
  callback = validCallbacks.firstWhere(
    (element) => element != null,
    orElse: () => null,
  );
  
  if (callback != null) {
    return callback;
  }
  
  // Last resort: return any available value
  return values.values.lastWhere((element) => element != null);
}
```

### Performance Optimization

**Caching Strategy**: Cache expensive calculations
```dart
// Correct: Cache screen size calculations
class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  T? currentValue;           // Cache resolved value
  K? screenSizeCache;        // Cache screen size category
  
  T getScreenSizeValue({required K screenSize}) {
    // Return cached value if screen size hasn't changed
    if (screenSizeCache == screenSize && currentValue != null) {
      return currentValue!;
    }
    
    // Recalculate and cache
    screenSizeCache = screenSize;
    currentValue = calculateValue(screenSize);
    return currentValue!;
  }
}
```

**Minimize Widget Rebuilds**: Use InheritedModel aspects effectively
```dart
// Correct: Selective dependency on specific data aspects
static K screenSizeOf<K extends Enum>(BuildContext context) {
  final model = InheritedModel.inheritFrom<ScreenSizeModel<K>>(
    context,
    aspect: ScreenSizeAspect.screenSize,  // Only rebuild on size changes
  );
  return model!.data.screenSize;
}
```

**Lazy Initialization**: Initialize expensive resources when needed
```dart
// Correct: Lazy initialization of platform dispatcher view
class _ScreenSizeState<T extends Enum> extends State<ScreenSize<T>> {
  late final view = widget.testView ?? 
      WidgetsBinding.instance.platformDispatcher.views.first;
}
```

### Type Safety Practices

**Prefer Non-Nullable Types**: Use nullable types only when necessary
```dart
// Correct: Non-null when value is always available
final BaseBreakpoints<T> breakpoints;
final T screenSize;

// Correct: Nullable when value might not exist
final T? extraLarge;  // Optional breakpoint value
```

**Use Proper Null Checking**: Handle nullable types safely
```dart
// Correct: Safe null checking with meaningful defaults
var callback = values[screenSize];
if (callback != null) {
  return callback;
}

// Correct: Use null-aware operators where appropriate
final view = widget.testView ?? 
    WidgetsBinding.instance.platformDispatcher.views.first;
```

### Widget Design Principles

**Required vs Optional Parameters**: Be explicit about requirements
```dart
// Correct: Clear distinction between required and optional
const ScreenSize({
  required this.breakpoints,    // Always required
  required this.child,          // Always required
  this.testView,                // Optional for testing
  this.useShortestSide = false, // Optional with sensible default
  super.key,
});
```

**Sensible Defaults**: Provide good default values
```dart
// Correct: Sensible defaults that work in most cases
const ScreenSizeBuilder({
  this.extraLarge,
  this.large,
  this.medium,
  this.small,
  this.extraSmall,
  this.breakpoints = Breakpoints.defaultBreakpoints,  // Good default
  this.animateChange = false,                         // Conservative default
  super.key,
});
```

**Validation**: Validate configuration at construction time
```dart
// Correct: Early validation with clear error messages
BreakpointsHandler({
  // ... parameters
}) : assert(
  extraLarge != null ||
      large != null ||
      medium != null ||
      small != null ||
      extraSmall != null,
  'BreakpointsHandler requires at least one size argument to be provided',
);
```

---

## 8. Anti-Patterns

### Anti-pattern Examples

#### ❌ God Classes
```dart
// Bad: Class handling too many responsibilities
class ResponsiveManager {
  // Screen size detection
  LayoutSize getCurrentSize() { }
  
  // Breakpoint configuration
  void setBreakpoints() { }
  
  // Widget building
  Widget buildResponsiveWidget() { }
  
  // Platform detection
  bool isDesktop() { }
  
  // Animation handling
  void animateTransition() { }
  
  // Theme management
  ThemeData getResponsiveTheme() { }
  // ... 20 more methods
}
```

#### ✅ Better: Separated Responsibilities
```dart
// Good: Each class has a single responsibility
class BreakpointsHandler<T> {
  T getScreenSizeValue({required LayoutSize screenSize});
}

class ScreenSizeBuilder extends StatefulWidget {
  Widget build(BuildContext context);
}

class PlatformUtils {
  static bool get isDesktop;
  static bool get isTouchDevice;
}
```

#### ❌ Magic Numbers and Strings
```dart
// Bad: Hardcoded values without explanation
if (width >= 1200) {
  return 'desktop';
} else if (width >= 768) {
  return 'tablet';
}

// Bad: Magic strings
final size = getScreenSize('large');
```

#### ✅ Better: Named Constants and Enums
```dart
// Good: Named constants with clear meaning
class Breakpoints {
  static const double extraLarge = 1200.0;
  static const double medium = 768.0;
}

// Good: Type-safe enums
enum LayoutSize { extraLarge, large, medium, small, extraSmall }
final size = getScreenSize(LayoutSize.large);
```

#### ❌ Weak Generic Constraints
```dart
// Bad: Unbounded generic allows any type
class BreakpointsHandler<T> {
  Map<T, double> get values;  // T could be String, int, anything
}

// Bad: Using Object instead of specific constraint
class ScreenSize<T extends Object> extends StatefulWidget { }
```

#### ✅ Better: Proper Generic Bounds
```dart
// Good: Bounded generic ensures type safety
class BreakpointsHandler<T extends Enum> {
  Map<T, double> get values;  // T must be an enum
}

class ScreenSize<T extends Enum> extends StatefulWidget { }
```

#### ❌ Global State and Singletons
```dart
// Bad: Global mutable state
class GlobalBreakpoints {
  static Breakpoints? _instance;
  static Breakpoints get instance => _instance ??= Breakpoints();
  
  static void updateBreakpoints(Breakpoints breakpoints) {
    _instance = breakpoints;
  }
}

// Bad: Using global state
Widget build(BuildContext context) {
  final breakpoints = GlobalBreakpoints.instance;
  // ...
}
```

#### ✅ Better: Dependency Injection
```dart
// Good: Constructor injection
class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
    required this.breakpoints,
    super.key,
  });
  
  final Breakpoints breakpoints;
}

// Good: Inherited widget for dependency propagation
ScreenSize<LayoutSize>(
  breakpoints: Breakpoints(),
  child: MyApp(),
)
```

#### ❌ Poor Error Handling
```dart
// Bad: Silent failures
T? getScreenSizeValue({required K screenSize}) {
  try {
    return values[screenSize];
  } catch (e) {
    return null;  // Hides the real problem
  }
}

// Bad: Vague error messages
if (breakpoints == null) {
  throw Exception('Error');
}
```

#### ✅ Better: Meaningful Error Handling
```dart
// Good: Clear error messages with context
if (model == null) {
  throw FlutterError('''
ScreenSizeModel<$K> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSize widget.
2. You are requesting the correct type parameter <$K>.
''');
}

// Good: Graceful fallbacks with logging
T getScreenSizeValue({required K screenSize}) {
  var value = values[screenSize];
  if (value != null) {
    return value;
  }
  
  // Log the fallback for debugging
  debugPrint('Falling back for screen size: $screenSize');
  
  // Implement fallback logic
  return findFallbackValue(screenSize);
}
```

#### ❌ Inefficient Widget Rebuilds
```dart
// Bad: Rebuilds entire widget tree on any change
class ResponsiveWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final screenData = ScreenSizeModel.of<LayoutSize>(context);
    // Widget rebuilds even when only orientation changes
    return buildComplexLayout(screenData);
  }
}
```

#### ✅ Better: Granular Rebuild Control
```dart
// Good: Only rebuild when screen size category changes
class ResponsiveWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeModel.screenSizeOf<LayoutSize>(context);
    // Only rebuilds when size category changes, not on orientation changes
    return buildLayoutForSize(screenSize);
  }
}
```

#### ❌ Inconsistent Naming and Organization
```dart
// Bad: Inconsistent naming conventions
class screenSizeBuilder { }         // Wrong case
class SSize { }                     // Too abbreviated
class ScreenSizeBuilderWidget { }   // Redundant suffix

// Bad: Inconsistent file organization
lib/
  screen_size.dart       // Contains multiple classes
  Breakpoints.dart       // Wrong case
  utils.dart             // Vague name
  responsive_builder.dart // Generic name
```

#### ✅ Better: Consistent Organization
```dart
// Good: Consistent naming
class ScreenSizeBuilder { }         // Clear, follows pattern
class BreakpointsHandler { }        // Descriptive purpose
class ScreenSizeModelData { }       // Indicates data class

// Good: Logical file organization
lib/src/
  breakpoints.dart               # Breakpoint configurations
  breakpoints_handler.dart       # Handler logic
  screen_size_builder.dart       # Builder widget
  screen_size_data.dart         # Data models
  utilities.dart                # Platform utilities
```

---

## 9. Code Review Checklist

### Before Submitting PR

#### Code Quality
- [ ] All new code follows the established naming conventions
- [ ] Generic types have appropriate bounds (e.g., `T extends Enum`)
- [ ] Public APIs have comprehensive documentation comments
- [ ] Error messages are clear and actionable
- [ ] No magic numbers or strings - use named constants

#### Architecture Compliance
- [ ] New responsive widgets follow the builder pattern
- [ ] Handler classes extend appropriate base classes
- [ ] Data classes are immutable with proper equality
- [ ] Dependencies are injected through constructors
- [ ] No global state or singleton patterns used

#### Performance Considerations
- [ ] Expensive operations are cached appropriately
- [ ] Widget rebuilds are minimized using InheritedModel aspects
- [ ] No unnecessary object allocations in hot paths
- [ ] Async operations handle errors gracefully

#### Testing Requirements
- [ ] Unit tests cover all public methods
- [ ] Widget tests verify responsive behavior
- [ ] Edge cases are tested (null values, extreme sizes)
- [ ] Performance tests for critical paths
- [ ] Example code demonstrates new features

#### Documentation
- [ ] All public APIs have dartdoc comments
- [ ] Complex algorithms have inline explanations  
- [ ] Breaking changes are noted in comments
- [ ] Example usage is provided for new features

### During Review

#### Design Review
- [ ] API design is consistent with existing patterns
- [ ] New breakpoint categories make logical sense
- [ ] Widget APIs are intuitive for developers
- [ ] Type safety is maintained throughout
- [ ] Error handling follows established patterns

#### Implementation Review
- [ ] Code is readable and self-documenting
- [ ] Logic is correct and handles edge cases
- [ ] Performance implications are acceptable
- [ ] Memory usage is reasonable
- [ ] No code duplication without good reason

#### Integration Review
- [ ] Changes integrate well with existing code
- [ ] No breaking changes to public APIs
- [ ] Backward compatibility is maintained
- [ ] New features work with both breakpoint systems
- [ ] Example applications demonstrate usage

#### Testing Review
- [ ] Test coverage is comprehensive
- [ ] Tests verify both success and failure cases
- [ ] Widget tests check responsive behavior
- [ ] Performance tests validate efficiency claims
- [ ] Tests are maintainable and not brittle

### Approval Criteria

A PR can be approved when:
1. All checklist items are satisfied
2. At least one senior developer has reviewed
3. All automated tests pass
4. Performance benchmarks meet requirements
5. Documentation is complete and accurate

---

## 10. Tools and Automation

### Linting Configuration

The project uses **very_good_analysis** with custom rules configured in `analysis_options.yaml`:

```yaml
include: package:very_good_analysis/analysis_options.5.1.0.yaml

language:
  strict-casts: true
  strict-inference: true
  strict-raw-types: true

analyzer:
  errors:
    public_member_api_docs: false      # We use dartdoc conventions
    lines_longer_than_80_chars: false  # Using 100-character limit
    avoid_positional_boolean_parameters: false
```

### Key Linting Rules

**Enforced Rules**:
- `always_declare_return_types` - All methods must declare return types
- `prefer_const_constructors` - Use const constructors where possible
- `require_trailing_commas` - Trailing commas for better diffs
- `sort_child_properties_last` - Widget child property comes last
- `avoid_dynamic_calls` - Prevent unsafe dynamic method calls
- `prefer_final_fields` - Immutability by default

**Disabled Rules**:
- `public_member_api_docs` - We use comprehensive dartdoc instead
- `lines_longer_than_80_chars` - Using 100-character limit for readability

### IDE Configuration

**VS Code Settings** (`.vscode/settings.json`):
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.dart": true,
    "source.organizeImports.dart": true
  },
  "editor.rulers": [100],
  "dart.lineLength": 100,
  "dart.insertArgumentPlaceholders": false,
  "dart.updateImportsOnRename": true
}
```

**Recommended Extensions**:
- Dart Code (Dart language support)
- Flutter (Flutter framework support)
- Error Lens (Inline error display)
- Better Comments (Enhanced comment highlighting)

### Automated Formatting

**dart format**: Automatic code formatting
```bash
# Format all Dart files
dart format .

# Check formatting without applying changes
dart format --set-exit-if-changed .
```

**Import Organization**: Automatic import sorting
```bash
# Organize imports in all files
dart fix --apply
```

### Build Scripts and Automation

**Package Scripts** (defined in project tooling):
```bash
# Run all linting checks
dart analyze

# Run all tests
flutter test

# Generate coverage report
flutter test --coverage
lcov --summary coverage/lcov.info

# Format code
dart format .

# Fix auto-fixable issues
dart fix --apply
```

### CI/CD Integration

**GitHub Actions** workflow includes:
1. **Linting**: `dart analyze` with zero warnings policy
2. **Formatting**: `dart format --set-exit-if-changed` 
3. **Testing**: `flutter test` with coverage requirements
4. **Documentation**: Dartdoc generation and validation
5. **Example Verification**: Build and test example applications

**Quality Gates**:
- All analysis issues must be resolved (warnings treated as errors)
- Test coverage must be above 90%
- All public APIs must have documentation
- Example applications must build successfully

### Pre-commit Hooks

**Recommended Git Hooks** (using `lefthook` or `husky`):
```yaml
# lefthook.yml
pre-commit:
  commands:
    dart-analyze:
      run: dart analyze --fatal-infos
    dart-format:
      run: dart format --set-exit-if-changed .
    flutter-test:
      run: flutter test
```

**Manual Installation**:
```bash
# Install pre-commit hooks
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
```

---

## Appendix: Examples and Templates

### Example: Complete Responsive Widget

```dart
/// A responsive card widget that adapts its layout based on screen size.
/// 
/// This example demonstrates proper usage of the responsive size builder
/// framework with comprehensive documentation and error handling.
class ResponsiveCard extends StatelessWidget {
  /// Creates a responsive card widget.
  /// 
  /// The [title] and [content] are required for the card content.
  /// The [breakpoints] parameter allows custom breakpoint configuration.
  const ResponsiveCard({
    required this.title,
    required this.content,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    super.key,
  });

  /// The title text displayed in the card header.
  final String title;

  /// The main content widget displayed in the card body.
  final Widget content;

  /// The breakpoint configuration used for responsive behavior.
  final Breakpoints breakpoints;

  @override
  Widget build(BuildContext context) {
    return ScreenSize<LayoutSize>(
      breakpoints: breakpoints,
      child: ScreenSizeBuilder(
        small: (context, data) => _buildMobileCard(context, data),
        medium: (context, data) => _buildTabletCard(context, data),
        large: (context, data) => _buildDesktopCard(context, data),
        extraLarge: (context, data) => _buildDesktopCard(context, data),
      ),
    );
  }

  /// Builds the mobile-optimized card layout.
  Widget _buildMobileCard(BuildContext context, ScreenSizeModelData data) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  /// Builds the tablet-optimized card layout.
  Widget _buildTabletCard(BuildContext context, ScreenSizeModelData data) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the desktop-optimized card layout.
  Widget _buildDesktopCard(BuildContext context, ScreenSizeModelData data) {
    return Card(
      margin: const EdgeInsets.all(24),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Divider(height: 32),
            content,
          ],
        ),
      ),
    );
  }
}
```

### Example: Custom Breakpoint Handler

```dart
/// A custom handler for managing responsive spacing values.
/// 
/// This example shows how to create domain-specific responsive handlers
/// that provide type-safe value resolution based on screen sizes.
class SpacingHandler extends BreakpointsHandler<EdgeInsets> {
  /// Creates a spacing handler with responsive padding values.
  /// 
  /// Different padding values are applied based on screen size to ensure
  /// optimal spacing across all device categories.
  SpacingHandler({
    super.breakpoints = Breakpoints.defaultBreakpoints,
    super.onChanged,
  }) : super(
          extraSmall: const EdgeInsets.all(4),
          small: const EdgeInsets.all(8),
          medium: const EdgeInsets.all(16),
          large: const EdgeInsets.all(24),
          extraLarge: const EdgeInsets.all(32),
        );

  /// Gets the appropriate padding for the current screen size.
  /// 
  /// This method uses Flutter's LayoutBuilder to determine the current
  /// constraints and returns the corresponding padding value.
  EdgeInsets getPadding(BoxConstraints constraints) {
    return getLayoutSizeValue(constraints: constraints);
  }
}

/// Example usage of the custom spacing handler
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacingHandler = SpacingHandler();

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = spacingHandler.getPadding(constraints);
        
        return Container(
          padding: padding,
          child: child,
        );
      },
    );
  }
}
```

### Template: New Breakpoint System

```dart
/// Template for creating a new breakpoint system
/// 
/// Follow this template when adding new breakpoint categories or
/// creating domain-specific responsive systems.

// Step 1: Define the size categories enum
enum CustomLayoutSize {
  /// Brief description of each size category
  tiny,
  small, 
  medium,
  large,
  huge,
}

// Step 2: Create the breakpoints configuration class
@immutable
class CustomBreakpoints implements BaseBreakpoints<CustomLayoutSize> {
  const CustomBreakpoints({
    this.huge = 2000.0,
    this.large = 1200.0,
    this.medium = 800.0,
    this.small = 400.0,
  }) : assert(
          huge > large && large > medium && medium > small && small >= 0,
          'Custom breakpoints must be in descending order and non-negative.',
        );

  final double huge;
  final double large;
  final double medium;
  final double small;

  static const defaultBreakpoints = CustomBreakpoints();

  @override
  Map<CustomLayoutSize, double> get values => {
        CustomLayoutSize.huge: huge,
        CustomLayoutSize.large: large,
        CustomLayoutSize.medium: medium,
        CustomLayoutSize.small: small,
        CustomLayoutSize.tiny: -1,  // Catch-all for smallest sizes
      };

  // Implement copyWith, toString, equality, etc.
  CustomBreakpoints copyWith({
    double? huge,
    double? large,
    double? medium,
    double? small,
  }) {
    return CustomBreakpoints(
      huge: huge ?? this.huge,
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
    );
  }
}

// Step 3: Create the handler class
class CustomBreakpointsHandler<T> 
    extends BaseBreakpointsHandler<T, CustomLayoutSize> {
  CustomBreakpointsHandler({
    super.breakpoints = CustomBreakpoints.defaultBreakpoints,
    super.onChanged,
    this.huge,
    this.large,
    this.medium,
    this.small,
    this.tiny,
  }) : assert(
          huge != null ||
              large != null ||
              medium != null ||
              small != null ||
              tiny != null,
          'At least one size value must be provided',
        );

  final T? huge;
  final T? large;
  final T? medium;
  final T? small;
  final T? tiny;

  @override
  Map<CustomLayoutSize, T?> get values => {
        CustomLayoutSize.huge: huge,
        CustomLayoutSize.large: large,
        CustomLayoutSize.medium: medium,
        CustomLayoutSize.small: small,
        CustomLayoutSize.tiny: tiny,
      };
}

// Step 4: Create the builder widget (if needed)
class CustomResponsiveBuilder extends StatefulWidget {
  const CustomResponsiveBuilder({
    this.huge,
    this.large,
    this.medium,
    this.small,
    this.tiny,
    this.breakpoints = CustomBreakpoints.defaultBreakpoints,
    super.key,
  });

  final WidgetBuilder? huge;
  final WidgetBuilder? large;
  final WidgetBuilder? medium;
  final WidgetBuilder? small;
  final WidgetBuilder? tiny;
  final CustomBreakpoints breakpoints;

  @override
  State<CustomResponsiveBuilder> createState() => 
      _CustomResponsiveBuilderState();
}

class _CustomResponsiveBuilderState extends State<CustomResponsiveBuilder> {
  late CustomBreakpointsHandler<WidgetBuilder> handler;

  @override
  void initState() {
    super.initState();
    handler = CustomBreakpointsHandler<WidgetBuilder>(
      breakpoints: widget.breakpoints,
      huge: widget.huge,
      large: widget.large,
      medium: widget.medium,
      small: widget.small,
      tiny: widget.tiny,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final builder = handler.getLayoutSizeValue(constraints: constraints);
        return builder(context);
      },
    );
  }
}
```

### Template: Documentation Comment

```dart
/// Brief one-line description of the class/method purpose.
///
/// More detailed explanation of what this class/method does, when to use it,
/// and how it fits into the overall architecture. Include important behavioral
/// details and any assumptions made.
///
/// ## Key Features (for classes)
///
/// * Feature 1: Brief description
/// * Feature 2: Brief description
/// * Feature 3: Brief description
///
/// ## Usage Example
///
/// {@tool snippet}
/// This example shows the basic usage pattern:
///
/// ```dart
/// final example = ExampleClass(
///   requiredParameter: 'value',
///   optionalParameter: true,
/// );
/// 
/// final result = example.performOperation();
/// ```
/// {@end-tool}
///
/// ## Performance Considerations (if relevant)
///
/// Explain any performance implications, caching behavior, or optimization
/// strategies used by this class/method.
///
/// ## Parameters (for methods/constructors)
///
/// * [requiredParam] - Description of what this parameter does
/// * [optionalParam] - Description with default behavior
///
/// Returns description of what is returned and under what conditions.
///
/// Throws [ExceptionType] if specific error conditions occur.
///
/// See also:
///
/// * [RelatedClass], for related functionality
/// * [AnotherClass], for alternative approaches
/// * [HelperMethod], for utility operations
class ExampleClass {
  // Implementation
}
```

This documentation serves as the definitive reference for all developers working with the Responsive Size Builder codebase. It should be updated as the project evolves and new patterns emerge.