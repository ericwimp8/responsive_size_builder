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

This document establishes the coding standards and conventions for the Responsive Size Builder Flutter package project. These standards ensure consistency, maintainability, and quality across the entire codebase.

### Target Audience
- Package contributors and maintainers
- External developers using the package as a reference
- Code reviewers and maintainers

### Scope
This document covers:
- Dart/Flutter code conventions
- File and directory structure standards
- API design patterns
- Testing conventions
- Documentation requirements

---

## 2. General Principles

### Core Development Philosophy
- **Immutability First**: Prefer immutable classes with const constructors
- **Type Safety**: Leverage Dart's strong type system with generics
- **Null Safety**: Follow sound null safety practices
- **Performance**: Design for efficient widget rebuilds and memory usage
- **Developer Experience**: Create intuitive, self-documenting APIs

### Design Values
- Predictable behavior across different screen sizes
- Minimal boilerplate for common responsive scenarios
- Extensible architecture for custom breakpoint systems
- Consistent API patterns across all builder widgets

---

## 3. Naming Conventions

### Naming Principles
- Names should be descriptive and self-documenting
- Use consistent terminology throughout the package
- Avoid abbreviations except for widely understood terms (e.g., `mq` for MediaQuery)
- Names should reveal intent, not implementation details

### Classes and Types

#### Widget Classes
```dart
// Format: [Purpose][Type]Builder
class ScreenSizeBuilder extends StatefulWidget { }
class ValueSizeWithValueBuilder extends StatefulWidget { }
class LayoutSizeGranularBuilder extends StatefulWidget { }
```

#### Model Classes
```dart
// Format: [Domain][Type]
class ScreenSizeModelData<K extends Enum> { }
class ResponsiveValue<V extends Object?> { }
class Breakpoints implements BaseBreakpoints<LayoutSize> { }
```

#### Handler Classes
```dart
// Format: [Purpose]Handler
class BreakpointsHandler<T> extends BaseBreakpointsHandler<T, LayoutSize> { }
class BreakpointsHandlerGranular<T> extends BaseBreakpointsHandler<T, LayoutSizeGranular> { }
```

#### Abstract Base Classes
```dart
// Format: Base[Purpose] or Abstract[Purpose]
abstract class BaseBreakpoints<T extends Enum> { }
abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> { }
```

### Enumerations
```dart
// PascalCase for enum names, camelCase for values
enum LayoutSize {
  extraLarge,
  large,
  medium,
  small,
  extraSmall,
}

enum LayoutSizeGranular {
  jumboExtraLarge,
  jumboLarge,
  jumboNormal,
  jumboSmall,
  standardExtraLarge,
  standardLarge,
  standardNormal,
  standardSmall,
  compactExtraLarge,
  compactLarge,
  compactNormal,
  compactSmall,
  tiny,
}
```

### Variables and Fields

#### Constructor Parameters
```dart
// Use descriptive parameter names with optional named parameters
const ScreenSizeBuilder({
  this.extraLarge,
  this.large,
  this.medium,
  this.small,
  this.extraSmall,
  this.breakpoints = Breakpoints.defaultBreakpoints,
  this.animateChange = false,
  super.key,
})
```

#### Private Fields
```dart
// Leading underscore for private fields
class _ScreenSizeBuilderState extends State<ScreenSizeBuilder> {
  late BreakpointsHandler<ScreenSizeWidgetBuilder> handler;
  final Map<T, V?> _values; // Private field with meaningful name
}
```

#### Constants
```dart
// Static const for default values
static const defaultBreakpoints = Breakpoints();
static const BreakpointsGranular.defaultBreakpoints = BreakpointsGranular();
```

### Files and Directories

#### File Names
```dart
// snake_case matching the primary class/component name
breakpoints.dart              // Contains Breakpoints and BreakpointsGranular
screen_size_builder.dart      // Contains ScreenSizeBuilder
base_breakpoints_handler.dart // Contains BaseBreakpointsHandler
```

#### Directory Structure
```
lib/
├── responsive_size_builder.dart          // Main library export
└── src/
    ├── core/                              // Core functionality
    │   ├── breakpoints/                   // Breakpoint system
    │   ├── overlay_position_utils.dart    // Utility functions
    │   └── utilities.dart                 // Platform detection utils
    ├── layout_constraints/                // Layout constraint providers
    ├── layout_size/                       // Layout size builders
    ├── responsive_value/                  // Responsive value classes
    ├── screen_size/                       // Screen size builders and data
    ├── value_size/                        // Value size builders
    └── value_size_with_value_builder/     // Combined value/size builders
```

---

## 4. Code Formatting Rules

### Indentation and Line Length
- Use 2 spaces for indentation (never tabs)
- Maximum line length: 80 characters (enforced by linter)
- Break long lines at logical points (after operators, before method names)
- Align parameters in multi-line method calls

### Braces and Blocks
```dart
// Opening braces on same line
if (condition) {
  doSomething();
}

// Always use braces for single-line blocks
if (condition) {
  singleStatement();
}

// Empty blocks can be written as {}
const MyWidget() : super();
```

### Whitespace Rules
```dart
// One blank line between method definitions
class Example {
  void methodOne() { }

  void methodTwo() { }
}

// Space after keywords and around operators
if (condition) { }
for (final item in items) { }
final result = a + b;

// No space before semicolons or commas in parameter lists
doSomething(param1, param2);
```

### Constructor Formatting
```dart
// Multi-line constructor with trailing commas
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

### Import Organization
```dart
// 1. Dart imports
import 'dart:ui';

// 2. Flutter imports  
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:responsive_size_builder/responsive_size_builder.dart';

// 4. Relative imports (avoid - use package imports instead)
// import '../core/utilities.dart'; // Don't do this
```

---

## 5. Comment Standards

### Documentation Comments
Every public API must have comprehensive documentation comments:

```dart
/// Calculates the appropriate screen size based on the current dimensions.
/// 
/// Uses the configured [breakpoints] to determine which [LayoutSize] category
/// the current screen width falls into. The determination is made by comparing
/// the screen width against breakpoint values in descending order.
/// 
/// Parameters:
/// - [size]: The screen dimension to evaluate (typically width)
/// 
/// Returns the appropriate [LayoutSize] enum value for the given dimension.
/// If the size is smaller than all defined breakpoints, returns the smallest
/// available size category.
/// 
/// Example:
/// ```dart
/// final screenSize = _getScreenSize(MediaQuery.of(context).size.width);
/// ```
K getScreenSize(double size) {
  final entries = breakpoints.values.entries;
  for (final entry in entries) {
    if (size >= entry.value) {
      return entry.key;
    }
  }
  return entries.last.key;
}
```

### Inline Comments
```dart
// Use inline comments sparingly - code should be self-documenting
class ScreenSizeModelData<K extends Enum> {
  const ScreenSizeModelData({
    required this.breakpoints,
    required this.currentBreakpoint,
    required this.screenSize,
    // Physical dimensions for advanced calculations
    required this.physicalWidth,
    required this.physicalHeight,
    required this.devicePixelRatio,
    // Logical dimensions for UI layout
    required this.logicalScreenWidth,
    required this.logicalScreenHeight,
    required this.orientation,
  });
  
  // Platform detection utilities - computed once for performance
  bool get isDesktopDevice => kIsDesktopDevice;
  bool get isTouchDevice => kIsTouchDevice;
}
```

### Special Comments
```dart
// TODO(maintainer): Add support for custom orientation breakpoints [ISSUE-123]
// FIXME(contributor): Memory leak in handler cache - review disposal [BUG-456]  
// HACK(developer): Temporary workaround for Flutter 3.5 constraint issue - remove in v2.0
```

---

## 6. Architectural Patterns

### Generic Type System
The package heavily utilizes Dart's generic type system for flexibility:

```dart
// Base classes use generics for extensibility
abstract class BaseBreakpoints<T extends Enum> {
  const BaseBreakpoints();
  Map<T, double> get values;
}

// Concrete implementations specify the enum type
class Breakpoints implements BaseBreakpoints<LayoutSize> {
  // Implementation
}

class BreakpointsGranular implements BaseBreakpoints<LayoutSizeGranular> {
  // Implementation  
}
```

### Inherited Model Pattern
State propagation uses InheritedModel for efficient updates:

```dart
class ScreenSizeModel<T extends Enum> extends InheritedModel<ScreenSizeAspect> {
  const ScreenSizeModel({
    required super.child,
    required this.data,
    super.key,
  });

  // Specific aspect-based updates for performance
  @override
  bool updateShouldNotifyDependent(
    ScreenSizeModel<T> oldWidget,
    Set<ScreenSizeAspect> dependencies,
  ) {
    if (oldWidget.data.screenSize != data.screenSize &&
        dependencies.contains(ScreenSizeAspect.screenSize)) {
      return true;
    }
    // Check other aspects...
    return false;
  }
}
```

### Handler Pattern
Business logic is separated into handler classes:

```dart
abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  BaseBreakpointsHandler({required this.breakpoints, this.onChanged});

  // Caching for performance
  T? currentValue;
  K? screenSizeCache;
  
  // Core business logic
  T getScreenSizeValue({required K screenSize}) {
    // Implementation with caching and fallback logic
  }
}
```

### Builder Widget Pattern
All widgets follow consistent builder patterns:

```dart
class ScreenSizeBuilder extends StatefulWidget {
  // Required assertion ensures at least one builder is provided
  const ScreenSizeBuilder({
    this.extraLarge,
    this.large,
    this.medium, 
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  }) : assert(
         extraLarge != null ||
             large != null ||
             medium != null ||
             small != null ||
             extraSmall != null,
         'At least one builder must be provided',
       );

  @override
  State<ScreenSizeBuilder> createState() => _ScreenSizeBuilderState();
}
```

### Immutable Data Models
All data classes are immutable with proper equality:

```dart
@immutable
class ScreenSizeModelData<K extends Enum> {
  const ScreenSizeModelData({
    required this.breakpoints,
    // ... other required parameters
  });

  // All fields are final
  final BaseBreakpoints<K> breakpoints;
  final K screenSize;
  
  // Proper equality implementation
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenSizeModelData<K> &&
        other.breakpoints == breakpoints &&
        other.screenSize == screenSize;
        // ... check other fields
  }

  @override
  int get hashCode => Object.hash(breakpoints, screenSize, /*...*/);
}
```

---

## 7. Best Practices

### Performance Optimization
```dart
// Cache expensive calculations
class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  T? currentValue;
  K? screenSizeCache;
  
  T getScreenSizeValue({required K screenSize}) {
    // Return cached value if screen size hasn't changed
    if (screenSizeCache == screenSize && currentValue != null) {
      return currentValue!;
    }
    // Recalculate only when necessary
  }
}
```

### Error Handling
```dart
// Provide clear error messages with context
static ScreenSizeModelData<K> of<K extends Enum>(BuildContext context) {
  final model = InheritedModel.inheritFrom<ScreenSizeModel<K>>(context);
  if (model == null) {
    throw FlutterError('''
ScreenSizeModel<$K> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSize widget 
   (e.g., ScreenSize<LayoutSize>(...) or ScreenSize<LayoutSizeGranular>(...)).
2. You are requesting the correct type parameter <$K>.

The context used to look up ScreenSizeModel was:
  $context
''');
  }
  return model.data;
}
```

### Type Safety
```dart
// Use bounded generics for type safety
abstract class BaseResponsiveValue<T extends Enum, V extends Object?>
    extends BaseBreakpointsHandler<V, T> {
  // T must be an Enum, V must be a non-nullable Object
}

// Enforce constraints with assertions
ResponsiveValue({
  // Constructor parameters...
}) : assert(
       extraLarge != null ||
           large != null ||
           medium != null ||
           small != null ||
           extraSmall != null,
       'ResponsiveValue requires at least one size argument to be filled out',
     );
```

### API Consistency
```dart
// Consistent naming patterns across related classes
class ResponsiveValue<V extends Object?>
class ResponsiveValueGranular<V extends Object?>

class ScreenSizeBuilder extends StatefulWidget
class ScreenSizeBuilderGranular extends StatefulWidget

class Breakpoints implements BaseBreakpoints<LayoutSize>
class BreakpointsGranular implements BaseBreakpoints<LayoutSizeGranular>
```

### Testing Support
```dart
// Provide test-friendly constructors
class ScreenSize<T extends Enum> extends StatefulWidget {
  const ScreenSize({
    required this.breakpoints,
    required this.child,
    this.testView,  // Allow injection of mock FlutterView for testing
    this.useShortestSide = false,
    super.key,
  });
}
```

---

## 8. Anti-Patterns

### ❌ Mutable State in Data Classes
```dart
// Bad: Mutable fields
class BadBreakpoints {
  double extraLarge = 1200.0;  // Mutable - avoid!
  double large = 950.0;
  
  void updateExtraLarge(double value) {  // State mutation - avoid!
    extraLarge = value;
  }
}
```

**✅ Better: Immutable with copyWith**
```dart
@immutable 
class Breakpoints implements BaseBreakpoints<LayoutSize> {
  const Breakpoints({
    this.extraLarge = 1200.0,
    this.large = 950.0,
    // ... other parameters
  });

  final double extraLarge;  // Immutable
  final double large;

  Breakpoints copyWith({
    double? extraLarge,
    double? large,
    // ... other parameters  
  }) {
    return Breakpoints(
      extraLarge: extraLarge ?? this.extraLarge,
      large: large ?? this.large,
      // ... other parameters
    );
  }
}
```

### ❌ Generic Type Erasure
```dart
// Bad: Missing generic constraints
class BadHandler {
  Object getValue(Object screenSize) {  // Too generic
    // Implementation
  }
}
```

**✅ Better: Proper Generic Constraints**
```dart
abstract class BaseBreakpointsHandler<T extends Object?, K extends Enum> {
  T getScreenSizeValue({required K screenSize}) {  // Properly typed
    // Implementation
  }
}
```

### ❌ Inconsistent API Patterns
```dart
// Bad: Inconsistent constructor patterns
class BadBuilder extends StatefulWidget {
  const BadBuilder(this.callback);  // Positional parameter
  final Widget Function() callback;
}

class AnotherBadBuilder extends StatefulWidget {  
  const AnotherBadBuilder({required this.builder});  // Different name
  final Widget Function() builder;
}
```

**✅ Better: Consistent Patterns**
```dart
class ScreenSizeBuilder extends StatefulWidget {
  const ScreenSizeBuilder({
    this.extraLarge,    // Optional named parameters
    this.large,         // Consistent naming: size + action
    this.medium,
    super.key,
  });
}

class ValueSizeBuilder extends StatefulWidget {
  const ValueSizeBuilder({
    this.extraLarge,    // Same pattern maintained
    this.large,
    this.medium,
    super.key,
  });
}
```

### ❌ Missing Equality Implementation
```dart
// Bad: No equality implementation
@immutable
class BadScreenSizeData {
  const BadScreenSizeData(this.screenSize);
  final LayoutSize screenSize;
  // Missing == and hashCode - will break comparisons!
}
```

**✅ Better: Complete Equality Implementation**
```dart
@immutable
class ScreenSizeModelData<K extends Enum> {
  const ScreenSizeModelData({required this.screenSize});
  final K screenSize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenSizeModelData<K> &&
        other.screenSize == screenSize;
  }

  @override
  int get hashCode => screenSize.hashCode;
}
```

---

## 9. Code Review Checklist

### Before Submitting PR
- [ ] Code compiles without warnings
- [ ] All tests pass (run `flutter test`)
- [ ] Code formatted with `dart format` 
- [ ] Linter issues resolved (`dart analyze`)
- [ ] Public APIs have documentation comments
- [ ] Breaking changes documented in CHANGELOG
- [ ] No TODO/FIXME comments without tracking issues
- [ ] Generic types properly constrained
- [ ] Immutable classes use `@immutable` annotation

### API Design Review
- [ ] Public methods have comprehensive documentation
- [ ] Constructor parameters use named optional pattern where appropriate
- [ ] Assertions validate constructor parameters
- [ ] Error messages provide actionable guidance
- [ ] Generic constraints are appropriate and necessary
- [ ] Methods return appropriate nullable/non-nullable types

### Performance Review
- [ ] No unnecessary widget rebuilds
- [ ] Expensive calculations are cached when appropriate
- [ ] InheritedModel aspects are correctly defined
- [ ] No memory leaks in stateful widgets
- [ ] Object creation minimized in build methods

### Testing Review
- [ ] New features have corresponding tests
- [ ] Edge cases are covered (null values, empty collections)
- [ ] Error conditions are tested
- [ ] Generic type behavior is verified
- [ ] Test coverage maintains >85% threshold

---

## 10. Tools and Automation

### Linter Configuration
The project uses `very_good_analysis` with additional custom rules:

```yaml
# analysis_options.yaml
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
    public_member_api_docs: false
    lines_longer_than_80_chars: false

linter:
  rules:
    # Key rules enforced
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - always_use_package_imports
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - require_trailing_commas
    - type_annotate_public_apis
```

### Development Scripts
```yaml
# pubspec.yaml dev_dependencies
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  very_good_analysis: ^5.1.0
```

### IDE Configuration

**VS Code (.vscode/settings.json)**:
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "editor.rulers": [80],
  "dart.lineLength": 80,
  "[dart]": {
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off"
  }
}
```

### Pre-commit Hooks
```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-format
        name: Flutter Format
        entry: dart format lib/ test/
        language: system
        pass_filenames: false
      - id: flutter-analyze
        name: Flutter Analyze
        entry: dart analyze
        language: system
        pass_filenames: false
      - id: flutter-test
        name: Flutter Test
        entry: flutter test
        language: system
        pass_filenames: false
```

---

## Appendix: Examples and Templates

### Complete Widget Template
```dart
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A responsive builder widget that adapts its child based on screen size.
/// 
/// This widget uses the configured [breakpoints] to determine which builder
/// function to execute based on the current screen dimensions.
/// 
/// At least one size-specific builder must be provided. If a specific size
/// builder is not provided, the widget will fall back to the next largest
/// available builder.
/// 
/// Example usage:
/// ```dart
/// ScreenSizeBuilder(
///   large: (context, data) => DesktopLayout(),
///   medium: (context, data) => TabletLayout(),  
///   small: (context, data) => MobileLayout(),
/// )
/// ```
class ExampleBuilder extends StatefulWidget {
  /// Creates a responsive builder widget.
  const ExampleBuilder({
    this.extraLarge,
    this.large,
    this.medium,
    this.small,
    this.extraSmall,
    this.breakpoints = Breakpoints.defaultBreakpoints,
    this.animateChange = false,
    super.key,
  }) : assert(
         extraLarge != null ||
             large != null ||
             medium != null ||
             small != null ||
             extraSmall != null,
         'At least one builder must be provided',
       );

  /// Builder function for extra large screens (≥1200px by default).
  final ScreenSizeWidgetBuilder? extraLarge;

  /// Builder function for large screens (≥950px by default).
  final ScreenSizeWidgetBuilder? large;

  /// Builder function for medium screens (≥600px by default).
  final ScreenSizeWidgetBuilder? medium;

  /// Builder function for small screens (≥200px by default).
  final ScreenSizeWidgetBuilder? small;

  /// Builder function for extra small screens (<200px by default).
  final ScreenSizeWidgetBuilder? extraSmall;

  /// The breakpoints used to determine screen size categories.
  /// 
  /// Defaults to [Breakpoints.defaultBreakpoints].
  final Breakpoints breakpoints;

  /// Whether to animate transitions between different size builders.
  /// 
  /// When true, uses [AnimatedSwitcher] with a 300ms duration.
  final bool animateChange;

  @override
  State<ExampleBuilder> createState() => _ExampleBuilderState();
}

class _ExampleBuilderState extends State<ExampleBuilder> {
  late BreakpointsHandler<ScreenSizeWidgetBuilder> handler =
      BreakpointsHandler<ScreenSizeWidgetBuilder>(
    breakpoints: widget.breakpoints,
    extraLarge: widget.extraLarge,
    large: widget.large,
    medium: widget.medium,
    small: widget.small,
    extraSmall: widget.extraSmall,
  );

  @override
  Widget build(BuildContext context) {
    final data = ScreenSizeModel.of<LayoutSize>(context);

    var child = handler.getScreenSizeValue(
      screenSize: data.screenSize,
    )(context, data);

    if (widget.animateChange) {
      child = AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      );
    }

    return child;
  }
}
```

### Data Model Template
```dart
import 'package:flutter/foundation.dart';

/// Represents the complete screen size and device information.
/// 
/// This immutable data class contains all information needed for responsive
/// layout decisions, including physical device dimensions, logical screen
/// dimensions, and the calculated screen size category.
/// 
/// Generic type [K] represents the enum type used for screen size categories
/// (typically [LayoutSize] or [LayoutSizeGranular]).
@immutable
class ExampleModelData<K extends Enum> {
  /// Creates a screen size data model.
  const ExampleModelData({
    required this.breakpoints,
    required this.currentBreakpoint,
    required this.screenSize,
    required this.physicalWidth,
    required this.physicalHeight,
    required this.devicePixelRatio,
    required this.logicalScreenWidth,
    required this.logicalScreenHeight,
    required this.orientation,
  });

  /// The breakpoint configuration used to determine screen size.
  final BaseBreakpoints<K> breakpoints;

  /// The numeric breakpoint value for the current screen size.
  final double currentBreakpoint;

  /// The screen size category enum value.
  final K screenSize;

  /// Physical screen width in pixels.
  final double physicalWidth;

  /// Physical screen height in pixels.
  final double physicalHeight;

  /// Device pixel ratio (physical pixels per logical pixel).
  final double devicePixelRatio;

  /// Logical screen width (CSS pixels).
  final double logicalScreenWidth;

  /// Logical screen height (CSS pixels).
  final double logicalScreenHeight;

  /// Current device orientation.
  final Orientation orientation;

  /// Whether the current platform is a desktop device.
  bool get isDesktopDevice => kIsDesktopDevice;

  /// Whether the current platform is a touch-enabled device.
  bool get isTouchDevice => kIsTouchDevice;

  /// Whether the current platform is web.
  bool get isWeb => kIsWeb;

  @override
  String toString() {
    return 'ExampleModelData(breakpoints: $breakpoints, currentBreakpoint: $currentBreakpoint, screenSize: $screenSize, physicalWidth: $physicalWidth, physicalHeight: $physicalHeight, devicePixelRatio: $devicePixelRatio, logicalScreenWidth: $logicalScreenWidth, logicalScreenHeight: $logicalScreenHeight, orientation: $orientation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExampleModelData<K> &&
        other.breakpoints == breakpoints &&
        other.currentBreakpoint == currentBreakpoint &&
        other.screenSize == screenSize &&
        other.physicalWidth == physicalWidth &&
        other.physicalHeight == physicalHeight &&
        other.devicePixelRatio == devicePixelRatio &&
        other.logicalScreenWidth == logicalScreenWidth &&
        other.logicalScreenHeight == logicalScreenHeight &&
        other.orientation == orientation;
  }

  @override
  int get hashCode {
    return Object.hash(
      breakpoints,
      currentBreakpoint,
      screenSize,
      physicalWidth,
      physicalHeight,
      devicePixelRatio,
      logicalScreenWidth,
      logicalScreenHeight,
      orientation,
    );
  }
}
```

---

## Document Maintenance

### Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-01-01 | Package Team | Initial documentation |

### Review Process
1. Annual review by the package maintainers
2. Updates proposed via pull request to the documentation
3. Major changes require maintainer consensus
4. Minor clarifications can be made by core contributors

### Providing Feedback
- Create an issue in the repository for documentation suggestions
- Discuss in package development discussions
- Contact maintainers directly for urgent clarifications

---

*This document serves as the definitive guide for code quality and consistency in the Responsive Size Builder package. All contributors are expected to follow these conventions to maintain the high standards of the codebase.*