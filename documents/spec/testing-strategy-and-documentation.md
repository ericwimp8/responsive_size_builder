# Testing Strategy and Documentation

## Executive Summary

The responsive_size_builder package requires a comprehensive testing strategy that ensures the reliability and functionality of its responsive layout components across all Flutter platforms. This document outlines a complete testing approach that covers unit testing of core logic, widget testing of UI components, integration testing of responsive behavior, and golden file testing for visual consistency.

As a Flutter package designed for responsive UI development, our testing strategy must validate breakpoint calculations, widget builder selection logic, responsive value resolution, and cross-platform compatibility while maintaining high code quality standards and enabling confident development workflows.

## Table of Contents

1. Testing Philosophy
2. Test Types and Pyramid
3. Coverage Requirements
4. Testing Frameworks and Tools
5. Testing Guidelines
6. Test Organization
7. Continuous Integration
8. Performance Testing
9. Security Testing
10. Maintenance and Updates

## Testing Philosophy

### Core Principles

- Every responsive feature must have corresponding tests covering all breakpoint scenarios
- Tests should validate behavior across different screen sizes and orientations
- Widget tests must verify responsive layout changes under various constraints
- Tests should be maintainable, readable, and execute quickly in CI/CD pipelines
- Test responsive behavior, not implementation details of breakpoint calculations

### Testing Goals

- Validate responsive behavior across all supported screen sizes and breakpoints
- Ensure consistent widget rendering across different Flutter platforms
- Catch responsive layout regressions before production
- Enable confident refactoring of breakpoint and builder logic
- Document expected responsive behavior through comprehensive test coverage
- Reduce manual testing overhead for responsive layout scenarios

### Responsive-Specific Testing Principles

- Test breakpoint edge cases and boundary values
- Validate fallback logic for missing builders
- Ensure orientation changes trigger appropriate layout updates
- Verify platform-specific responsive behavior (web, mobile, desktop)
- Test granular and standard breakpoint systems independently

## Test Types and Pyramid

### Unit Tests (70% of tests)
**Purpose:** Test individual functions, classes, and responsive logic in isolation

**Characteristics:**
- Fast execution (< 100ms per test)
- No Flutter widget dependencies
- Mock all external collaborators
- Focus on single responsibility

**Responsive Testing Focus:**
- Breakpoint calculation accuracy
- Value resolution logic validation
- Handler selection algorithms
- Enum mappings and edge cases

**Example Structure:**
- Location: `test/unit/`
- Naming: `*_test.dart`
- Execution time: < 100ms per test

**Key Areas to Test:**
- `Breakpoints` class validation and calculations
- `BreakpointsHandler` value resolution logic
- `LayoutSize` and `LayoutSizeGranular` enum utilities
- Responsive value fallback mechanisms
- Screen size categorization algorithms

### Widget Tests (25% of tests)
**Purpose:** Test responsive widget behavior and UI rendering

**Characteristics:**
- Test widget trees with responsive components
- Verify layout changes across different screen sizes
- Use `MediaQuery` to simulate different devices
- Test builder function invocation and fallback logic

**Responsive Testing Focus:**
- `ScreenSizeBuilder` widget behavior across breakpoints
- `ValueSizeBuilder` value resolution in widget context
- Layout constraint handling in responsive widgets
- Orientation-aware builder selection

**Example Structure:**
- Location: `test/widget/`
- Naming: `*_widget_test.dart`
- Execution time: < 500ms per test

**Key Areas to Test:**
- Responsive builder widgets (`ScreenSizeBuilder`, `ScreenSizeOrientationBuilder`)
- Value-based builders (`ValueSizeBuilder`, granular variants)
- Layout constraint providers and wrappers
- Screen size data propagation through widget tree

### Integration Tests (5% of tests)
**Purpose:** Test complete responsive workflows and cross-platform behavior

**Characteristics:**
- Test real device responsive behavior
- Verify platform-specific responsive adaptations
- Test responsive navigation and complex layouts
- Include performance testing of responsive rebuilds

**Responsive Testing Focus:**
- End-to-end responsive layout adaptation
- Cross-platform responsive behavior consistency
- Performance of responsive rebuilds during window resizing
- Complex responsive component interactions

**Example Structure:**
- Location: `test/integration/`
- Naming: `*_integration_test.dart`
- Execution time: < 5 seconds per test

## Coverage Requirements

### Minimum Coverage Thresholds
- Overall: 85%
- Unit tests: 95%
- Widget tests: 80%
- Critical responsive paths: 100%

### Coverage Metrics
| Metric | Target | Enforcement |
|--------|--------|-------------|
| Line Coverage | 85% | CI/CD pipeline |
| Branch Coverage | 80% | Pre-commit hook |
| Function Coverage | 90% | Pull request check |
| Statement Coverage | 85% | Build failure |

### Responsive-Specific Coverage Requirements
- All breakpoint edge cases: 100%
- Fallback logic scenarios: 100%
- Platform-specific responsive behavior: 90%
- Orientation change handling: 100%

### Excluded from Coverage
- Example application code (`example/` directory)
- Generated platform-specific code
- Third-party Flutter framework integrations
- Debug utilities and development tools

### How to Check Coverage

```bash
# Run coverage locally
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Check specific responsive module
flutter test --coverage test/unit/breakpoints_test.dart

# Exclude example directory from coverage
flutter test --coverage --test-randomize-ordering-seed random
```

## Testing Frameworks and Tools

### Core Testing Framework
**Framework:** Flutter Test Framework
**Version:** Latest stable with Flutter SDK
**Configuration:** `test/` directory with standard Flutter conventions

**Key Features Used:**
- `testWidgets` for widget testing
- `test` for unit testing
- `MediaQuery.of` mocking for responsive testing
- `Finder` for widget location in tests

### Additional Testing Libraries

#### Unit Testing
- **Mock Data:** Built-in Flutter test utilities
- **Assertions:** Flutter test matchers and custom responsive matchers
- **Test Data:** Custom breakpoint configurations for edge cases

#### Widget Testing
- **Widget Testing:** `flutter_test` package
- **Screen Size Simulation:** `MediaQuery` override utilities
- **Layout Testing:** `RenderBox` testing for responsive layouts
- **Golden File Testing:** Flutter golden image comparison

#### Integration Testing
- **Framework:** `integration_test` package
- **Platform Testing:** Multi-platform test execution
- **Performance:** Flutter Driver for responsive performance testing

### Testing Utilities

```dart
// Location: test/utils/

// responsive_test_utils.dart - Generate responsive test scenarios
class ResponsiveTestUtils {
  static MediaQueryData createMediaQuery(Size size) { /* ... */ }
  static List<ResponsiveTestCase> generateBreakpointTests() { /* ... */ }
  static Widget wrapWithScreenSize<T extends Enum>(Widget child, BaseBreakpoints<T> breakpoints) { /* ... */ }
}

// mock_responsive_data.dart - Create mock responsive objects
class MockResponsiveData {
  static ScreenSizeModelData createMockData(LayoutSize size) { /* ... */ }
  static Breakpoints createCustomBreakpoints() { /* ... */ }
}

// test_breakpoints.dart - Predefined breakpoint configurations
class TestBreakpoints {
  static const tiny = Breakpoints(extraLarge: 100, large: 80, medium: 60, small: 40);
  static const overlapping = Breakpoints(/* edge cases */);
}
```

## What Should Be Tested

### Must Test (Priority 1)
- Breakpoint calculation algorithms and edge cases
- Responsive builder selection logic
- Value resolution and fallback mechanisms
- Widget tree responsive behavior
- Screen size categorization accuracy
- Platform-specific responsive adaptations
- Error handling for invalid breakpoints
- State management in responsive widgets

### Should Test (Priority 2)
- Complex responsive layout interactions
- Performance of responsive rebuilds
- Responsive animation and transitions
- Accessibility in responsive layouts
- Memory management in responsive widgets
- Cross-platform responsive consistency
- Edge cases with extreme screen sizes

### Consider Testing (Priority 3)
- Visual regression testing with golden files
- Responsive behavior in different Flutter channels
- Integration with third-party responsive packages
- Development utilities and debugging tools

### Responsive Testing Checklist for New Features
- [ ] Unit tests for responsive logic components
- [ ] Widget tests for responsive UI behavior
- [ ] Breakpoint edge cases covered
- [ ] Fallback scenarios identified and tested
- [ ] Cross-platform responsive behavior verified
- [ ] Performance impact of responsive changes measured
- [ ] Golden file tests for visual consistency (if applicable)
- [ ] Documentation updated with responsive usage examples

## How to Write Effective Tests

### Test Structure Pattern (AAA)

```dart
void main() {
  group('ScreenSizeBuilder', () {
    group('responsive behavior', () {
      testWidgets('should select correct builder for medium screen size', (tester) async {
        // Arrange
        const testBreakpoints = Breakpoints(
          extraLarge: 1200,
          large: 950,
          medium: 600,
          small: 200,
        );
        
        Widget? selectedWidget;
        
        final widget = ScreenSize<LayoutSize>(
          breakpoints: testBreakpoints,
          child: ScreenSizeBuilder(
            medium: (context, data) {
              selectedWidget = Container(key: ValueKey('medium'));
              return selectedWidget!;
            },
            large: (context, data) => Container(key: ValueKey('large')),
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: Size(800, 600)), // Medium size
              child: widget,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(ValueKey('medium')), findsOneWidget);
        expect(find.byKey(ValueKey('large')), findsNothing);
      });
    });
  });
}
```

### Naming Conventions

```dart
// Good test names for responsive features
testWidgets('should select extraLarge builder when screen width exceeds 1200px')
testWidgets('should fall back to smaller builder when target builder is null')
testWidgets('should rebuild when screen size category changes')
test('should categorize 800px width as medium size with default breakpoints')
test('should throw AssertionError when all breakpoint values are negative')

// Poor test names
testWidgets('test responsive widget')
test('breakpoint calculation')
testWidgets('builder selection works')
```

### Common Responsive Testing Patterns

#### Testing Breakpoint Transitions
```dart
testWidgets('should transition between builders when crossing breakpoints', (tester) async {
  const breakpoints = Breakpoints();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(500, 600)), // Small
        child: ScreenSize<LayoutSize>(
          breakpoints: breakpoints,
          child: ScreenSizeBuilder(
            small: (context, data) => Text('Small'),
            medium: (context, data) => Text('Medium'),
          ),
        ),
      ),
    ),
  );
  
  expect(find.text('Small'), findsOneWidget);
  
  // Simulate screen size change to medium
  await tester.binding.setSurfaceSize(Size(700, 600));
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(700, 600)), // Medium
        child: ScreenSize<LayoutSize>(
          breakpoints: breakpoints,
          child: ScreenSizeBuilder(
            small: (context, data) => Text('Small'),
            medium: (context, data) => Text('Medium'),
          ),
        ),
      ),
    ),
  );
  
  expect(find.text('Medium'), findsOneWidget);
  expect(find.text('Small'), findsNothing);
});
```

#### Testing Fallback Logic
```dart
test('should use fallback value when exact size not configured', () {
  final handler = BreakpointsHandler<String>(
    large: 'Large Value',
    small: 'Small Value',
    // medium intentionally omitted
  );
  
  final result = handler.getScreenSizeValue(screenSize: LayoutSize.medium);
  
  // Should fall back to small value
  expect(result, equals('Small Value'));
});
```

#### Testing Responsive Values
```dart
testWidgets('should apply correct spacing based on screen size', (tester) async {
  double? appliedSpacing;
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(800, 600)),
        child: ScreenSize<LayoutSize>(
          breakpoints: Breakpoints.defaultBreakpoints,
          child: ValueSizeBuilder<double>(
            small: 8.0,
            medium: 16.0,
            large: 24.0,
            builder: (context, spacing) {
              appliedSpacing = spacing;
              return Container();
            },
          ),
        ),
      ),
    ),
  );
  
  expect(appliedSpacing, equals(16.0)); // Medium screen = 16.0 spacing
});
```

## Test Organization

### Directory Structure

```
/responsive_size_builder
  /test
    /unit                          # Unit tests for core logic
      /breakpoints                 # Breakpoint calculation tests
        breakpoints_test.dart
        breakpoints_granular_test.dart
        breakpoints_handler_test.dart
      /responsive_value           # Value resolution tests
        responsive_value_test.dart
        screen_size_with_value_test.dart
      /utilities                  # Utility function tests
        utilities_test.dart
        overlay_position_utils_test.dart
    /widget                       # Widget behavior tests
      /builders                   # Builder widget tests
        screen_size_builder_test.dart
        screen_size_orientation_builder_test.dart
        value_size_builder_test.dart
        layout_size_builder_test.dart
      /providers                 # Provider widget tests
        layout_constraints_provider_test.dart
    /integration                 # Integration and performance tests
      responsive_workflow_test.dart
      cross_platform_test.dart
      performance_test.dart
    /golden                      # Golden file tests (if applicable)
      /baseline
    /utils                       # Test utilities and helpers
      responsive_test_utils.dart
      mock_responsive_data.dart
      test_breakpoints.dart
    /fixtures                    # Test data files
      screen_size_data.json
```

### Test Data Management

- Use factory functions for creating consistent test breakpoints
- Maintain responsive test fixtures in `/test/fixtures`
- Create reusable test utilities for common responsive scenarios
- Clean up widget trees after each test to prevent memory leaks

### Shared Test Resources

```dart
// /test/utils/responsive_test_utils.dart

/// Utility class for creating responsive test scenarios
class ResponsiveTestUtils {
  /// Creates a MediaQueryData instance for testing specific screen sizes
  static MediaQueryData createMediaQuery({
    required Size size,
    double devicePixelRatio = 1.0,
    Orientation orientation = Orientation.portrait,
  }) {
    return MediaQueryData(
      size: size,
      devicePixelRatio: devicePixelRatio,
      orientation: orientation,
    );
  }

  /// Wraps a widget with ScreenSize provider for testing
  static Widget wrapWithScreenSize<T extends Enum>({
    required Widget child,
    required BaseBreakpoints<T> breakpoints,
    Size screenSize = const Size(800, 600),
  }) {
    return MaterialApp(
      home: MediaQuery(
        data: createMediaQuery(size: screenSize),
        child: ScreenSize<T>(
          breakpoints: breakpoints,
          child: child,
        ),
      ),
    );
  }

  /// Generates test cases for all breakpoint transitions
  static List<ResponsiveTestCase> generateBreakpointTestCases() {
    return [
      ResponsiveTestCase(
        name: 'extra small screen',
        size: Size(150, 400),
        expectedSize: LayoutSize.extraSmall,
      ),
      ResponsiveTestCase(
        name: 'small screen',
        size: Size(400, 600),
        expectedSize: LayoutSize.small,
      ),
      ResponsiveTestCase(
        name: 'medium screen boundary',
        size: Size(600, 800),
        expectedSize: LayoutSize.medium,
      ),
      ResponsiveTestCase(
        name: 'large screen',
        size: Size(1000, 800),
        expectedSize: LayoutSize.large,
      ),
      ResponsiveTestCase(
        name: 'extra large screen',
        size: Size(1400, 900),
        expectedSize: LayoutSize.extraLarge,
      ),
    ];
  }
}

/// Test case data structure for responsive scenarios
class ResponsiveTestCase {
  const ResponsiveTestCase({
    required this.name,
    required this.size,
    required this.expectedSize,
  });

  final String name;
  final Size size;
  final LayoutSize expectedSize;
}
```

## Continuous Integration

### Test Execution Pipeline

```yaml
# .github/workflows/test.yml
name: Test Suite
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        flutter-version: [stable, beta]
    
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ matrix.flutter-version }}
      
      - name: Install dependencies
        run: flutter pub get
        
      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .
        
      - name: Analyze project source
        run: flutter analyze
        
      - name: Run unit tests
        run: flutter test test/unit --coverage
        
      - name: Run widget tests
        run: flutter test test/widget --coverage
        
      - name: Run integration tests
        run: flutter test test/integration --coverage
        
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

  build-example:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: cd example && flutter build web --release
      - run: cd example && flutter build apk --release
```

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-format
        name: Flutter Format
        entry: dart format .
        language: system
        pass_filenames: false
        
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        pass_filenames: false
        
      - id: flutter-test
        name: Flutter Test
        entry: flutter test
        language: system
        pass_filenames: false
```

### Pull Request Requirements
- All tests must pass across Flutter stable and beta channels
- Coverage must not decrease below thresholds
- New responsive features must include comprehensive tests
- Golden file tests must pass (if applicable)
- Performance benchmarks must not regress

## Test Maintenance

### Regular Maintenance Tasks
- **Weekly:** Review flaky tests and responsive edge cases
- **Monthly:** Update Flutter test dependencies and golden files
- **Quarterly:** Audit responsive test coverage and add missing scenarios
- **Yearly:** Review testing strategy for new Flutter responsive features

### Dealing with Flaky Tests
1. Identify through CI logs and responsive-specific failures
2. Tag with `@Tags(['flaky'])` annotation
3. Fix within 1 sprint, focusing on timing and widget lifecycle issues
4. If not fixable, quarantine or remove with team approval

### Test Performance Optimization
- Use `pumpAndSettle()` judiciously to avoid unnecessary waits
- Mock expensive responsive calculations where appropriate
- Share widget setup between related responsive test cases
- Use `setUp()` and `tearDown()` for consistent test environments

### Deprecation Strategy
When removing responsive features:
1. Mark tests as deprecated with clear migration paths
2. Keep for 2 release cycles to support gradual migration
3. Remove with feature code and update documentation
4. Ensure remaining tests cover replacement functionality

## Performance Testing

### Performance Test Types
- **Responsive Rebuild Testing:** Measure widget rebuild performance during screen size changes
- **Memory Usage Testing:** Verify no memory leaks in responsive widget lifecycle
- **Breakpoint Calculation Performance:** Benchmark breakpoint resolution algorithms
- **Large Widget Tree Testing:** Test responsive behavior with complex widget hierarchies

### Performance Benchmarks

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('Performance Tests', () {
    testWidgets('should rebuild responsive widgets efficiently during size changes', (tester) async {
      const int iterationCount = 100;
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < iterationCount; i++) {
        await tester.pumpWidget(
          ResponsiveTestUtils.wrapWithScreenSize(
            screenSize: Size(400 + i * 10, 600),
            breakpoints: Breakpoints.defaultBreakpoints,
            child: ScreenSizeBuilder(
              small: (context, data) => Container(),
              medium: (context, data) => Container(),
              large: (context, data) => Container(),
            ),
          ),
        );
        await tester.pump();
      }
      
      stopwatch.stop();
      final averageTimePerRebuild = stopwatch.elapsedMicroseconds / iterationCount;
      
      // Should complete rebuilds in under 1000 microseconds on average
      expect(averageTimePerRebuild, lessThan(1000));
    });

    test('should resolve breakpoint values efficiently for large datasets', () {
      const handler = BreakpointsHandler<String>(
        extraLarge: 'XL',
        large: 'L',
        medium: 'M',
        small: 'S',
        extraSmall: 'XS',
      );
      
      final stopwatch = Stopwatch()..start();
      
      // Test breakpoint resolution performance
      for (int i = 0; i < 10000; i++) {
        final size = LayoutSize.values[i % LayoutSize.values.length];
        handler.getScreenSizeValue(screenSize: size);
      }
      
      stopwatch.stop();
      
      // Should resolve 10,000 values in under 100ms
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
```

### Tools for Performance Testing
- **Flutter Performance Profiling:** Built-in Flutter performance tools
- **Memory Profiling:** Flutter memory profiling for responsive widget lifecycle
- **Benchmark Testing:** Custom benchmarks for responsive calculations

## Security Testing

### Security Test Categories
- **Input Validation:** Test breakpoint value validation and sanitization
- **Resource Management:** Ensure responsive widgets don't leak resources
- **Platform Security:** Verify responsive behavior doesn't expose platform vulnerabilities

### Security Test Examples

```dart
void main() {
  group('Security Tests', () {
    test('should validate breakpoint values to prevent overflow', () {
      expect(
        () => Breakpoints(
          extraLarge: double.maxFinite,
          large: double.maxFinite - 1,
          medium: double.maxFinite - 2,
          small: double.maxFinite - 3,
        ),
        throwsAssertionError,
      );
    });

    test('should handle negative breakpoint values safely', () {
      expect(
        () => Breakpoints(
          extraLarge: -1,
          large: -2,
          medium: -3,
          small: -4,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('should not expose sensitive device information through responsive data', (tester) async {
      ScreenSizeModelData? capturedData;
      
      await tester.pumpWidget(
        ResponsiveTestUtils.wrapWithScreenSize(
          child: ScreenSizeBuilder(
            medium: (context, data) {
              capturedData = data;
              return Container();
            },
          ),
        ),
      );
      
      // Verify no sensitive device information is exposed
      expect(capturedData?.logicalScreenWidth, isPositive);
      expect(capturedData?.physicalScreenWidth, isPositive);
      // Ensure no device identifiers or sensitive platform info
    });
  });
}
```

## Developer Testing Checklist

### Before Writing Responsive Code
- [ ] Review existing responsive tests for similar breakpoint scenarios
- [ ] Identify test scenarios (all breakpoints, edge cases, fallback behaviors)
- [ ] Plan test data requirements for different screen sizes
- [ ] Consider cross-platform responsive behavior differences

### While Writing Responsive Code
- [ ] Write tests alongside responsive implementation
- [ ] Run responsive tests frequently during development
- [ ] Ensure tests cover breakpoint edge cases and transitions
- [ ] Test fallback logic when builders are missing

### Before Committing Responsive Features
- [ ] All responsive tests passing locally
- [ ] Coverage meets requirements for responsive logic
- [ ] No debug print statements in responsive code
- [ ] Tests follow responsive naming conventions
- [ ] Test descriptions clearly indicate responsive scenarios
- [ ] Golden file tests updated (if applicable)

### During Code Review of Responsive Features
- [ ] Tests cover all responsive breakpoints and edge cases
- [ ] Fallback scenarios are tested
- [ ] Tests are maintainable and use appropriate test utilities
- [ ] No flaky tests introduced due to timing issues
- [ ] Performance impact of responsive changes is acceptable

## Quick Reference

### Common Commands

```bash
# Run all tests
flutter test

# Run specific responsive test file
flutter test test/unit/breakpoints/breakpoints_test.dart

# Run tests in watch mode (using entr or similar)
find test -name "*.dart" | entr flutter test /_

# Run with coverage
flutter test --coverage

# Run only unit tests
flutter test test/unit

# Run only widget tests
flutter test test/widget

# Run integration tests
flutter test test/integration

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run tests with verbose output for debugging
flutter test --reporter=expanded

# Run specific test group
flutter test --name="ScreenSizeBuilder responsive behavior"
```

### Debugging Responsive Tests

1. Use `debugPrint` for responsive value debugging
2. Use `tester.binding.debugPrint` to inspect widget state
3. Use `--verbose` for detailed responsive test output
4. Add `await tester.pumpAndSettle()` to ensure all animations complete
5. Use `find.byType()` and `find.byKey()` for specific widget location
6. Verify MediaQuery data with `MediaQuery.of(context).size`

### Creating Responsive Test Cases

```dart
// Template for responsive widget test
testWidgets('should [expected responsive behavior] when [screen size condition]', (tester) async {
  // Arrange - Set up responsive test environment
  const testBreakpoints = Breakpoints(/* custom breakpoints */);
  final testScreenSize = Size(/* width */, /* height */);
  
  // Act - Pump responsive widget with test conditions
  await tester.pumpWidget(
    ResponsiveTestUtils.wrapWithScreenSize(
      breakpoints: testBreakpoints,
      screenSize: testScreenSize,
      child: YourResponsiveWidget(),
    ),
  );
  await tester.pumpAndSettle();
  
  // Assert - Verify responsive behavior
  expect(find.byType(ExpectedWidget), findsOneWidget);
});

// Template for responsive value test
test('should return [expected value] when [breakpoint condition]', () {
  // Arrange - Set up breakpoint handler
  final handler = BreakpointsHandler<YourType>(
    // ... breakpoint values
  );
  
  // Act - Resolve value for test conditions
  final result = handler.getScreenSizeValue(screenSize: LayoutSize.medium);
  
  // Assert - Verify correct value resolution
  expect(result, equals(expectedValue));
});
```

## Additional Resources

- [Flutter Test Documentation](https://docs.flutter.dev/testing)
- [Flutter Widget Testing](https://docs.flutter.dev/testing/widget-testing)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Responsive Design Best Practices](https://docs.flutter.dev/ui/adaptive-responsive)
- [Flutter Performance Testing](https://docs.flutter.dev/testing/performance)
- [MediaQuery Testing Patterns](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)