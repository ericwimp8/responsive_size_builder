# Testing Strategy

## Executive Summary

This document outlines the comprehensive testing strategy for the responsive_size_builder Flutter package, a sophisticated responsive layout solution supporting both standard five-category and granular thirteen-category breakpoint systems. The package enables developers to build responsive Flutter applications that adapt seamlessly across desktop, tablet, and mobile devices.

Our testing approach emphasizes widget testing for UI components, unit testing for breakpoint logic, and integration testing for complete responsive workflows. The strategy ensures reliability across Flutter's diverse platform ecosystem while maintaining high performance and developer experience standards.

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Test Types and Pyramid](#test-types-and-pyramid)
3. [Coverage Requirements](#coverage-requirements)
4. [Testing Frameworks and Tools](#testing-frameworks-and-tools)
5. [What Should Be Tested](#what-should-be-tested)
6. [How to Write Effective Tests](#how-to-write-effective-tests)
7. [Test Organization](#test-organization)
8. [Continuous Integration](#continuous-integration)
9. [Performance Testing](#performance-testing)
10. [Maintenance and Updates](#maintenance-and-updates)
11. [Quick Reference](#quick-reference)
12. [Test Templates](#test-templates)

## Testing Philosophy

### Core Principles

- **Widget-Centric Testing**: Every responsive widget must have comprehensive widget tests covering all breakpoints
- **Breakpoint Logic Integrity**: All breakpoint calculations and fallback mechanisms must be thoroughly unit tested
- **Cross-Platform Validation**: Tests must validate behavior across Flutter's target platforms (iOS, Android, Web, Desktop)
- **Responsive Behavior Coverage**: Test behavior at boundary conditions between breakpoints
- **Performance Awareness**: Ensure responsive calculations don't impact frame rates or cause unnecessary rebuilds

### Testing Goals

- Verify responsive widgets render correctly across all supported breakpoints
- Ensure breakpoint calculation accuracy for both standard and granular systems
- Validate fallback logic when specific breakpoints aren't defined
- Catch responsive layout regressions before they reach production
- Document expected behavior for different screen sizes and orientations
- Enable confident refactoring of breakpoint logic and widget implementations

## Test Types and Pyramid

### Widget Tests (60% of tests)
**Purpose:** Test responsive widget behavior, breakpoint transitions, and UI rendering

**Characteristics:**
- Use Flutter's `testWidgets` framework
- Test responsive behavior across different screen sizes
- Verify widget tree structure and properties
- Mock MediaQuery data for different breakpoints
- Test orientation changes and their effects

**Example Structure:**
- Location: `test/widgets/` and alongside source files
- Naming: `*_test.dart`
- Execution time: < 500ms per test

**Key Test Scenarios:**
```dart
testWidgets('ScreenSizeBuilder renders correct widget for large screens', (tester) async {
  // Test widget rendering for specific breakpoint
});

testWidgets('BreakpointsHandler falls back correctly when no exact match', (tester) async {
  // Test fallback logic behavior
});
```

### Unit Tests (30% of tests)
**Purpose:** Test individual functions, breakpoint calculations, and utility methods

**Characteristics:**
- Fast execution (< 100ms)
- Test breakpoint calculation logic
- Test utility functions and platform detection
- Test data model equality and serialization
- Mock external dependencies

**Example Structure:**
- Location: `test/unit/` or alongside source files
- Naming: `*_test.dart`
- Execution time: < 100ms per test

**Key Test Scenarios:**
```dart
test('Breakpoints.getScreenSize returns correct LayoutSize for given width', () {
  // Test breakpoint calculation accuracy
});

test('BreakpointsHandler caches values correctly', () {
  // Test caching behavior
});
```

### Integration Tests (10% of tests)
**Purpose:** Test complete responsive workflows and multi-widget interactions

**Characteristics:**
- Test complete responsive scenarios
- Verify ScreenSize widget integration with builders
- Test MediaQuery integration and updates
- Validate responsive data flow through widget tree

**Example Structure:**
- Location: `test/integration/`
- Naming: `*.integration_test.dart`
- Execution time: < 2 seconds per test

**Key Test Scenarios:**
```dart
testWidgets('Complete responsive workflow with ScreenSize and ScreenSizeBuilder', (tester) async {
  // Test full responsive pipeline
});
```

## Coverage Requirements

### Minimum Coverage Thresholds
- Overall: 85%
- Widget tests: 80%
- Unit tests: 95%
- Critical breakpoint logic: 100%

### Coverage Metrics

| Metric | Target | Enforcement |
|--------|--------|-------------|
| Line Coverage | 85% | CI/CD pipeline |
| Branch Coverage | 80% | Pre-commit hook |
| Function Coverage | 90% | Pull request check |
| Statement Coverage | 85% | Build failure |

### Excluded from Coverage
- Example application code (`example/` directory)
- Generated documentation files
- Platform-specific constants (partial coverage acceptable)
- Debug-only utilities

### How to Check Coverage

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html

# Check specific file coverage
flutter test --coverage test/breakpoints_test.dart
```

## Testing Frameworks and Tools

### Core Testing Framework
**Framework:** Flutter Test Framework
**Version:** Latest stable with Flutter SDK
**Configuration:** `pubspec.yaml` and `test/` directory

**Key Features Used:**
- `testWidgets` for widget testing
- `test` for unit testing
- MediaQuery mocking for responsive testing
- Golden file testing for visual validation

### Additional Testing Libraries

#### Widget Testing
- **Test Utilities:** `flutter_test` package
- **Widget Simulation:** `WidgetTester` for interaction simulation
- **MediaQuery Mocking:** Custom utilities for breakpoint testing

#### Unit Testing
- **Mock Framework:** `mockito` for dependency mocking
- **Test Data:** Custom builders for ScreenSizeModelData
- **Matchers:** Custom matchers for breakpoint assertions

#### Integration Testing
- **Framework:** `integration_test` package
- **Real Device Testing:** For platform-specific validation

### Testing Utilities

```dart
// Location: test/utils/

// test_data_builders.dart - Generate test data
ScreenSizeModelData<LayoutSize> createMockScreenData({
  LayoutSize size = LayoutSize.large,
  double width = 1024.0,
  Orientation orientation = Orientation.portrait,
});

// breakpoint_test_utils.dart - Breakpoint testing utilities
void testAllBreakpoints<T extends Enum>(
  BaseBreakpoints<T> breakpoints,
  Map<T, double> testCases,
);

// widget_test_helpers.dart - Widget testing helpers
Future<void> pumpResponsiveWidget(
  WidgetTester tester,
  Widget widget, {
  Size? screenSize,
  Orientation? orientation,
});
```

## What Should Be Tested

### Must Test (Priority 1)
- **Breakpoint Calculations**: All breakpoint threshold calculations and edge cases
- **Widget Rendering**: Responsive widget rendering across all supported breakpoints
- **Fallback Logic**: Behavior when specific breakpoint values are null
- **Orientation Handling**: Portrait/landscape transitions and their effects
- **Data Model Accuracy**: ScreenSizeModelData properties and calculations
- **InheritedModel Behavior**: Efficient widget rebuilding and aspect dependencies
- **Platform Detection**: Desktop, touch, and web platform identification

### Should Test (Priority 2)
- **Animation Transitions**: Smooth transitions when breakpoints change
- **Custom Breakpoints**: User-defined breakpoint configurations
- **Performance Impact**: Memory usage and computation efficiency
- **Error Handling**: Graceful handling of invalid configurations
- **Granular Breakpoints**: All thirteen granular breakpoint categories

### Consider Testing (Priority 3)
- **Visual Regression**: Golden file tests for complex responsive layouts
- **Accessibility**: Screen reader compatibility across breakpoints
- **Edge Cases**: Extreme screen sizes and unusual aspect ratios

### Testing Checklist for New Features
- [ ] Widget tests for all supported breakpoints
- [ ] Unit tests for calculation logic
- [ ] Integration tests for complete workflows
- [ ] Error cases and edge conditions covered
- [ ] Performance impact assessed
- [ ] Cross-platform compatibility verified
- [ ] Documentation and examples updated

## How to Write Effective Tests

### Test Structure Pattern (AAA)

```dart
testWidgets('ScreenSizeBuilder should render large layout for desktop screens', (WidgetTester tester) async {
  // Arrange
  const testBreakpoints = Breakpoints(large: 1024);
  final mockData = ScreenSizeModelData<LayoutSize>(
    screenSize: LayoutSize.large,
    logicalScreenWidth: 1200.0,
    orientation: Orientation.portrait,
    // ... other required properties
  );

  // Act
  await tester.pumpWidget(
    ScreenSize<LayoutSize>(
      breakpoints: testBreakpoints,
      child: ScreenSizeBuilder(
        large: (context, data) => const Text('Large Layout'),
        small: (context, data) => const Text('Small Layout'),
      ),
    ),
  );

  // Assert
  expect(find.text('Large Layout'), findsOneWidget);
  expect(find.text('Small Layout'), findsNothing);
});
```

### Naming Conventions

```dart
// Good test names
testWidgets('should render mobile layout when screen width is below 600px')
test('should return LayoutSize.small for width 400px with default breakpoints')
testWidgets('should animate transition when breakpoint changes with animateChange enabled')

// Poor test names
testWidgets('test responsive behavior')
test('breakpoint calculation')
testWidgets('widget works')
```

### Common Testing Patterns

#### Testing Responsive Widgets
```dart
testWidgets('responsive widget adapts to different screen sizes', (tester) async {
  // Test small screen
  await pumpResponsiveWidget(
    tester,
    MyResponsiveWidget(),
    screenSize: const Size(400, 800),
  );
  expect(find.byType(MobileLayout), findsOneWidget);

  // Test large screen
  await pumpResponsiveWidget(
    tester,
    MyResponsiveWidget(),
    screenSize: const Size(1200, 800),
  );
  expect(find.byType(DesktopLayout), findsOneWidget);
});
```

#### Testing Breakpoint Logic
```dart
test('breakpoint handler returns correct values', () {
  final handler = BreakpointsHandler<String>(
    small: 'mobile',
    large: 'desktop',
  );

  expect(
    handler.getScreenSizeValue(screenSize: LayoutSize.small),
    equals('mobile'),
  );
  expect(
    handler.getScreenSizeValue(screenSize: LayoutSize.large),
    equals('desktop'),
  );
});
```

#### Testing MediaQuery Integration
```dart
testWidgets('ScreenSize provides correct data to descendants', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: ScreenSize<LayoutSize>(
        breakpoints: Breakpoints.defaultBreakpoints,
        child: Builder(
          builder: (context) {
            final data = ScreenSizeModel.of<LayoutSize>(context);
            return Text('${data.screenSize}');
          },
        ),
      ),
    ),
  );

  expect(find.text('LayoutSize.medium'), findsOneWidget);
});
```

## Test Organization

### Directory Structure

```
/responsive_size_builder
  /lib
    /src
      breakpoints.dart
      screen_size_builder.dart
  /test
    /unit                          # Unit tests
      breakpoints_test.dart
      breakpoints_handler_test.dart
      utilities_test.dart
    /widgets                       # Widget tests
      screen_size_builder_test.dart
      screen_size_orientation_builder_test.dart
      screen_size_data_test.dart
    /integration                   # Integration tests
      responsive_workflow_test.dart
    /utils                        # Test utilities
      test_data_builders.dart
      breakpoint_test_utils.dart
      widget_test_helpers.dart
    /fixtures                     # Test data
      sample_breakpoints.dart
      mock_screen_data.dart
```

### Test Data Management

```dart
// test/utils/test_data_builders.dart
class TestDataBuilders {
  static ScreenSizeModelData<LayoutSize> createScreenData({
    LayoutSize size = LayoutSize.medium,
    double width = 800.0,
    double height = 600.0,
    Orientation orientation = Orientation.portrait,
  }) {
    return ScreenSizeModelData<LayoutSize>(
      breakpoints: Breakpoints.defaultBreakpoints,
      currentBreakpoint: _getBreakpointForSize(size),
      screenSize: size,
      physicalWidth: width * 2,
      physicalHeight: height * 2,
      devicePixelRatio: 2.0,
      logicalScreenWidth: width,
      logicalScreenHeight: height,
      orientation: orientation,
    );
  }

  static Breakpoints createCustomBreakpoints({
    double? extraLarge,
    double? large,
    double? medium,
    double? small,
  }) {
    return Breakpoints(
      extraLarge: extraLarge ?? 1400,
      large: large ?? 1024,
      medium: medium ?? 768,
      small: small ?? 480,
    );
  }
}
```

### Shared Test Resources

```dart
// test/utils/widget_test_helpers.dart
extension ResponsiveWidgetTesting on WidgetTester {
  Future<void> pumpResponsiveWidget(
    Widget widget, {
    Size screenSize = const Size(800, 600),
    Orientation orientation = Orientation.portrait,
    Breakpoints? breakpoints,
  }) async {
    await pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: screenSize,
          orientation: orientation,
        ),
        child: ScreenSize<LayoutSize>(
          breakpoints: breakpoints ?? Breakpoints.defaultBreakpoints,
          child: MaterialApp(home: widget),
        ),
      ),
    );
  }

  Future<void> changeScreenSize(Size newSize) async {
    binding.window.physicalSizeTestValue = newSize * binding.window.devicePixelRatio;
    await pump();
  }
}
```

## Continuous Integration

### Test Execution Pipeline

```yaml
# .github/workflows/test.yml
name: Test Suite
on: [push, pull_request]

jobs:
  unit-widget-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test test/unit/
      - run: flutter test test/widgets/
      
  integration-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test test/integration/
      
  coverage-check:
    runs-on: ubuntu-latest
    needs: unit-widget-tests
    steps:
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-test
        name: Flutter tests
        entry: flutter test --no-pub --coverage
        language: system
        pass_filenames: false
        types: [dart]
      - id: flutter-analyze
        name: Flutter analyze
        entry: flutter analyze
        language: system
        pass_filenames: false
        types: [dart]
```

### Pull Request Requirements
- All tests must pass (unit, widget, integration)
- Code coverage must not decrease below thresholds
- New responsive features must include comprehensive tests
- Breakpoint logic changes require additional validation
- Performance benchmarks must remain stable

## Performance Testing

### Performance Test Categories
- **Responsive Calculation Speed**: Breakpoint calculations should complete in microseconds
- **Widget Rebuild Efficiency**: Minimize unnecessary rebuilds during responsive changes
- **Memory Usage**: Ensure efficient caching without memory leaks
- **Animation Performance**: Smooth transitions at 60fps during breakpoint changes

### Performance Benchmarks

```dart
test('breakpoint calculation performance', () {
  final stopwatch = Stopwatch()..start();
  final breakpoints = Breakpoints.defaultBreakpoints;
  
  // Perform 1000 breakpoint calculations
  for (int i = 0; i < 1000; i++) {
    breakpoints.getScreenSize(800.0);
  }
  
  stopwatch.stop();
  expect(stopwatch.elapsedMicroseconds, lessThan(1000));
});

testWidgets('responsive widget rebuild efficiency', (tester) async {
  int buildCount = 0;
  
  await tester.pumpWidget(
    ScreenSizeBuilder(
      large: (context, data) {
        buildCount++;
        return Container();
      },
    ),
  );
  
  // Change unrelated MediaQuery property
  await tester.binding.window.textScaleFactorTestValue = 1.5;
  await tester.pump();
  
  // Should not trigger unnecessary rebuilds
  expect(buildCount, equals(1));
});
```

### Tools for Performance Testing
- **Flutter DevTools**: For widget rebuild analysis
- **Benchmark Harness**: For micro-benchmarking breakpoint calculations
- **Memory Profiler**: For detecting memory leaks in responsive caching

## Maintenance and Updates

### Regular Maintenance Tasks
- **Weekly**: Review test execution times and flaky tests
- **Monthly**: Update test dependencies and Flutter SDK compatibility
- **Quarterly**: Audit test coverage and add tests for edge cases
- **Per Release**: Validate responsive behavior on new Flutter versions

### Dealing with Flaky Tests
1. **Identify** through CI logs and test reports
2. **Isolate** by running tests multiple times locally
3. **Fix** timing issues, async operations, or test setup
4. **Validate** fix with repeated test execution
5. **Monitor** for regression in subsequent runs

### Test Performance Optimization
- Use `setUp` and `tearDown` for expensive test initialization
- Mock MediaQuery data instead of creating full widget trees
- Group related tests to share expensive setup
- Use `testWidgets` efficiently with minimal widget pumping

### Responsive Testing Strategy Updates
When adding new features:
1. **Assess Impact**: Determine which existing tests need updates
2. **Add New Tests**: Ensure new responsive features have full coverage
3. **Update Utilities**: Enhance test helpers for new breakpoint categories
4. **Document Changes**: Update testing documentation with new patterns

## Quick Reference

### Common Test Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/breakpoints_test.dart

# Run tests with coverage
flutter test --coverage

# Run only unit tests
flutter test test/unit/

# Run only widget tests
flutter test test/widgets/

# Run tests in verbose mode
flutter test --reporter expanded

# Run integration tests
flutter test test/integration/

# Generate coverage report
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
```

### Debugging Tests

1. **Add Print Statements**: Use `debugPrint()` for widget test debugging
2. **Use Debugger**: Set breakpoints in IDE for step-through debugging
3. **Pump and Settle**: Use `await tester.pumpAndSettle()` for animation completion
4. **Widget Inspector**: Use `tester.binding.debugAssertAllWidgetVarsUnset` for widget leak detection
5. **Verbose Output**: Use `flutter test --reporter expanded` for detailed test output

### Common Responsive Test Patterns

```dart
// Test breakpoint boundary conditions
test('breakpoint boundary at exact threshold', () {
  final breakpoints = Breakpoints(medium: 600.0);
  expect(breakpoints.getScreenSize(600.0), equals(LayoutSize.medium));
  expect(breakpoints.getScreenSize(599.9), equals(LayoutSize.small));
});

// Test orientation changes
testWidgets('handles orientation changes correctly', (tester) async {
  await tester.pumpResponsiveWidget(widget, orientation: Orientation.portrait);
  expect(find.text('Portrait Layout'), findsOneWidget);
  
  await tester.pumpResponsiveWidget(widget, orientation: Orientation.landscape);
  expect(find.text('Landscape Layout'), findsOneWidget);
});

// Test fallback behavior
test('falls back to available breakpoint when exact match not found', () {
  final handler = BreakpointsHandler<String>(
    large: 'desktop',
    // medium is null - should fall back to next available
    small: 'mobile',
  );
  
  expect(handler.getScreenSizeValue(screenSize: LayoutSize.medium), equals('mobile'));
});
```

## Test Templates

### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('WidgetName', () {
    late BreakpointsHandler<Widget> handler;

    setUp(() {
      handler = BreakpointsHandler<Widget>(
        small: const Text('Small'),
        medium: const Text('Medium'),
        large: const Text('Large'),
      );
    });

    testWidgets('should render correct widget for small screens', (tester) async {
      // Arrange
      const screenSize = Size(400, 800);
      
      // Act
      await tester.pumpResponsiveWidget(
        ScreenSizeBuilder(
          small: (context, data) => const Text('Mobile Layout'),
          large: (context, data) => const Text('Desktop Layout'),
        ),
        screenSize: screenSize,
      );

      // Assert
      expect(find.text('Mobile Layout'), findsOneWidget);
      expect(find.text('Desktop Layout'), findsNothing);
    });

    testWidgets('should handle breakpoint transitions smoothly', (tester) async {
      // Test responsive transitions
      await tester.pumpResponsiveWidget(widget, screenSize: const Size(400, 800));
      expect(find.text('Mobile'), findsOneWidget);

      await tester.changeScreenSize(const Size(1200, 800));
      await tester.pumpAndSettle();
      expect(find.text('Desktop'), findsOneWidget);
    });
  });
}
```

### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('ClassName', () {
    late Breakpoints breakpoints;

    setUp(() {
      breakpoints = const Breakpoints(
        extraLarge: 1200,
        large: 950,
        medium: 600,
        small: 200,
      );
    });

    test('should calculate correct breakpoint for given width', () {
      // Arrange
      const testWidth = 800.0;

      // Act
      final result = breakpoints.getScreenSize(testWidth);

      // Assert
      expect(result, equals(LayoutSize.medium));
    });

    test('should handle edge cases correctly', () {
      expect(breakpoints.getScreenSize(600.0), equals(LayoutSize.medium));
      expect(breakpoints.getScreenSize(599.9), equals(LayoutSize.small));
    });
  });
}
```

### Integration Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('Responsive Integration Tests', () {
    testWidgets('complete responsive workflow works end-to-end', (tester) async {
      bool smallLayoutBuilt = false;
      bool largeLayoutBuilt = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenSizeBuilder(
              small: (context, data) {
                smallLayoutBuilt = true;
                return const Scaffold(body: Text('Mobile'));
              },
              large: (context, data) {
                largeLayoutBuilt = true;
                return const Scaffold(body: Text('Desktop'));
              },
            ),
          ),
        ),
      );

      // Start with small screen
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      await tester.pumpAndSettle();

      expect(find.text('Mobile'), findsOneWidget);
      expect(smallLayoutBuilt, isTrue);

      // Switch to large screen
      tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
      await tester.pumpAndSettle();

      expect(find.text('Desktop'), findsOneWidget);
      expect(largeLayoutBuilt, isTrue);
    });
  });
}
```

---

This testing strategy document provides comprehensive guidance for testing the responsive_size_builder package. Regular updates should be made as the package evolves and new responsive features are added. The strategy emphasizes thorough testing of breakpoint logic, responsive widget behavior, and cross-platform compatibility to ensure robust responsive layouts across all Flutter target platforms.