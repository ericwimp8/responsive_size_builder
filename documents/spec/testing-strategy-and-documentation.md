# Testing Strategy

## Executive Summary

This document outlines the comprehensive testing strategy for the `responsive_size_builder` Flutter package. The package provides a responsive design system with breakpoint-based layout builders and value handlers for Flutter applications. Our testing approach emphasizes reliability, maintainability, and comprehensive coverage across all responsive components to ensure consistent behavior across different screen sizes and devices.

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
- Every responsive component must have corresponding tests that validate behavior across all breakpoints
- Tests should validate widget rendering, layout calculations, and breakpoint transitions
- Fast feedback loops are essential for UI component testing
- Test behavior and responsive outcomes, not implementation details
- Ensure consistent behavior across different screen sizes and orientations

### Testing Goals
- Catch responsive layout bugs before production
- Enable confident refactoring of breakpoint logic
- Document expected responsive behavior patterns
- Reduce manual testing overhead for different screen sizes
- Validate breakpoint calculations and widget selection accuracy

## Test Types and Pyramid

### Unit Tests (70% of tests)
**Purpose:** Test individual classes, methods, and responsive calculations in isolation

**Characteristics:**
- Fast execution (milliseconds)
- No external dependencies or widget rendering
- Mock all collaborators and dependencies
- Focus on single responsibility components

**Example Structure:**
- Location: `/test/unit/` or alongside source files
- Naming: `*_test.dart`
- Execution time: < 100ms per test

**Key Test Areas:**
- Breakpoint calculations and validations
- ResponsiveValue logic and fallback behavior
- Enum comparisons and sorting algorithms
- Data class equality and serialization

### Widget Tests (25% of tests)
**Purpose:** Test Flutter widget behavior and rendering with different constraints

**Characteristics:**
- Test widget building and layout behavior
- Validate responsive widget selection
- Test with different BoxConstraints
- Verify widget tree structure and properties

**Example Structure:**
- Location: `/test/widget/`
- Naming: `*_widget_test.dart`
- Execution time: < 500ms per test

**Key Test Areas:**
- LayoutSizeBuilder widget rendering at different breakpoints
- ScreenSizeBuilder responsive behavior
- ValueSizeBuilder constraint handling
- Widget tree composition and child selection

### Integration Tests (5% of tests)
**Purpose:** Test complete responsive workflows and cross-component interactions

**Characteristics:**
- Test multiple components working together
- Validate end-to-end responsive behavior
- Test real constraint changes and orientation switches
- Verify complex responsive scenarios

**Example Structure:**
- Location: `/test/integration/`
- Naming: `*_integration_test.dart`
- Execution time: < 2 seconds per test

## Coverage Requirements

### Minimum Coverage Thresholds
- Overall: 90%
- Unit tests: 95%
- Widget tests: 85%
- Critical responsive logic: 100%

### Coverage Metrics
| Metric | Target | Enforcement |
|--------|--------|-------------|
| Line Coverage | 90% | CI/CD pipeline |
| Branch Coverage | 85% | Pre-commit hook |
| Function Coverage | 95% | Pull request check |
| Statement Coverage | 90% | Build failure |

### Excluded from Coverage
- Generated files (*.g.dart, *.freezed.dart)
- Example code and documentation
- Debug utilities and development helpers
- Third-party package extensions

### How to Check Coverage
```bash
# Run coverage locally
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Check specific module coverage
flutter test --coverage test/unit/breakpoints/

# View coverage report
open coverage/html/index.html
```

## Testing Frameworks and Tools

### Core Testing Framework
**Framework:** Flutter Test Framework
**Version:** Latest stable with Flutter SDK
**Configuration:** `/test/` directory structure

**Key Features Used:**
- Widget testing with testWidgets
- Unit testing with test groups
- Mock generation and stubbing
- Coverage reporting and analysis

### Additional Testing Libraries

#### Widget Testing
- **Flutter Test:** Core widget testing framework
- **Mockito:** Mock generation for dependencies
- **Golden Toolkit:** Widget golden file testing

#### Unit Testing
- **Test:** Dart core testing framework
- **Matcher:** Custom assertion matchers
- **Fake Async:** Time-based testing utilities

#### Performance Testing
- **Flutter Driver:** Integration test performance
- **Benchmark Harness:** Performance benchmarking

### Testing Utilities
```dart
// Location: /test/utils/

- test_breakpoints.dart    // Predefined test breakpoints
- mock_factories.dart      // Mock object creation
- widget_test_helpers.dart // Widget testing utilities
- constraint_builders.dart // BoxConstraints helpers
```

## What Should Be Tested

### Must Test (Priority 1)
- Breakpoint calculation algorithms
- ResponsiveValue selection logic
- Widget builder selection based on constraints
- Breakpoint validation and assertions
- Layout size enum comparisons
- Fallback behavior for undefined breakpoints
- Error handling for invalid configurations
- State management in stateful widgets

### Should Test (Priority 2)
- Widget rendering at edge breakpoints
- Orientation change handling
- Complex nested responsive layouts
- Performance with rapid constraint changes
- Memory usage during widget rebuilds
- Accessibility features integration

### Consider Testing (Priority 3)
- Debug string representations
- Equality operators performance
- Documentation examples
- Development utility functions

### Testing Checklist for New Features
- [ ] Unit tests for core logic and calculations
- [ ] Widget tests for UI components
- [ ] Tests for all supported breakpoints
- [ ] Error cases and edge conditions covered
- [ ] Performance benchmarks (if applicable)
- [ ] Golden file tests for visual regression
- [ ] Documentation examples tested

## How to Write Effective Tests

### Test Structure Pattern (AAA)
```dart
group('BreakpointsHandler', () {
  group('getLayoutSizeValue', () => {
    testWidgets('should return extraLarge builder for wide constraints', (tester) async {
      // Arrange
      final handler = BreakpointsHandler<String>(
        extraLarge: 'XL',
        large: 'L',
        medium: 'M',
        small: 'S',
        extraSmall: 'XS',
      );
      const constraints = BoxConstraints(maxWidth: 1300);

      // Act
      final result = handler.getLayoutSizeValue(constraints: constraints);

      // Assert
      expect(result, equals('XL'));
    });
  });
});
```

### Naming Conventions
```dart
// Good test names
testWidgets('should render large layout when width is 1000px')
test('should throw AssertionError for invalid breakpoint order')
test('should fallback to smaller breakpoint when larger is null')

// Poor test names
testWidgets('test responsive behavior')
test('error case')
test('works correctly')
```

### Common Testing Patterns

#### Testing Widget Responsiveness
```dart
testWidgets('should build different widgets for different screen sizes', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LayoutSizeBuilder(
        small: (context) => const Text('Small'),
        large: (context) => const Text('Large'),
      ),
    ),
  );

  // Test small screen
  await tester.binding.setSurfaceSize(const Size(400, 800));
  await tester.pumpAndSettle();
  expect(find.text('Small'), findsOneWidget);

  // Test large screen
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpAndSettle();
  expect(find.text('Large'), findsOneWidget);
});
```

#### Testing Breakpoint Calculations
```dart
test('should correctly identify layout size for given constraints', () {
  const breakpoints = Breakpoints();
  const handler = BreakpointsHandler<String>(
    extraLarge: 'XL',
    large: 'L',
  );

  // Test exact breakpoint
  final result = handler.getLayoutSizeValue(
    constraints: BoxConstraints(maxWidth: breakpoints.large),
  );
  expect(result, equals('L'));
});
```

#### Testing Error Conditions
```dart
test('should throw AssertionError for descending breakpoint order', () {
  expect(
    () => Breakpoints(
      large: 1000,
      medium: 1200, // Invalid: larger than large
    ),
    throwsA(isA<AssertionError>()),
  );
});
```

## Test Organization

### Directory Structure
```
/responsive_size_builder
  /lib
    /src
      /core
        /breakpoints
          breakpoints.dart
          breakpoints_handler.dart
      /layout_size
        layout_size_builder.dart
  /test
    /unit                           # Unit tests
      /core
        /breakpoints
          breakpoints_test.dart
          breakpoints_handler_test.dart
    /widget                         # Widget tests
      /layout_size
        layout_size_builder_test.dart
    /integration                    # Integration tests
      responsive_workflow_test.dart
    /utils                         # Test utilities
      test_breakpoints.dart
      mock_factories.dart
    /fixtures                      # Test data
      sample_constraints.dart
```

### Test Data Management
- Use factory functions for consistent test breakpoints
- Maintain reusable BoxConstraints in `/test/fixtures`
- Create helper functions for common widget configurations
- Separate test scenarios by breakpoint categories

### Shared Test Resources
```dart
// /test/utils/test_helpers.dart
class TestBreakpoints {
  static const small = Breakpoints(
    extraLarge: 800,
    large: 600,
    medium: 400,
    small: 200,
  );
  
  static const standard = Breakpoints.defaultBreakpoints;
}

BoxConstraints createConstraints({required double width, double height = 600}) {
  return BoxConstraints(
    maxWidth: width,
    maxHeight: height,
  );
}

Widget createTestApp({required Widget child}) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}
```

## Continuous Integration

### Test Execution Pipeline
```yaml
# Example GitHub Actions workflow
name: Test Suite
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Analyze code
        run: flutter analyze
      
      - name: Run unit tests
        run: flutter test test/unit/
      
      - name: Run widget tests
        run: flutter test test/widget/
      
      - name: Run all tests with coverage
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

### Pre-commit Hooks
```yaml
# .github/workflows/pre-commit.yml
repos:
  - repo: local
    hooks:
      - id: flutter-test
        name: Flutter Test
        entry: flutter test
        language: system
        pass_filenames: false
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        pass_filenames: false
```

### Pull Request Requirements
- All tests must pass
- Coverage must not decrease below thresholds
- New responsive features must have comprehensive tests
- Widget golden files must be updated if UI changes
- Performance benchmarks must pass

## Performance Testing

### Performance Test Types
- **Layout Performance:** Widget building and constraint resolution speed
- **Memory Usage:** Widget tree efficiency and memory leaks
- **Breakpoint Calculation:** Algorithm performance for rapid changes
- **Rebuild Optimization:** Unnecessary widget rebuilds detection

### Performance Benchmarks
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('Performance Tests', () {
    test('should calculate breakpoints quickly for 1000 iterations', () {
      const handler = BreakpointsHandler<String>(
        extraLarge: 'XL',
        large: 'L',
        medium: 'M',
        small: 'S',
        extraSmall: 'XS',
      );
      
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 1000; i++) {
        handler.getLayoutSizeValue(
          constraints: BoxConstraints(maxWidth: i.toDouble()),
        );
      }
      
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
```

### Tools for Performance Testing
- **Flutter DevTools:** Widget rebuild analysis
- **Observatory:** Memory profiling
- **Benchmark Harness:** Custom performance metrics

## Security Testing

### Security Test Categories
- **Input Validation:** Breakpoint value validation and sanitization
- **State Protection:** Ensuring widget state cannot be corrupted
- **Memory Safety:** Preventing memory leaks in long-running apps

### Security Test Examples
```dart
group('Security Tests', () {
  test('should validate breakpoint values are positive', () {
    expect(
      () => Breakpoints(small: -1),
      throwsA(isA<AssertionError>()),
    );
  });

  test('should handle extreme constraint values safely', () {
    const handler = BreakpointsHandler<String>(extraSmall: 'XS');
    
    // Test with extreme values
    expect(
      () => handler.getLayoutSizeValue(
        constraints: BoxConstraints(maxWidth: double.infinity),
      ),
      returnsNormally,
    );
  });
});
```

## Test Maintenance

### Regular Maintenance Tasks
- **Weekly:** Review failing tests and flaky test reports
- **Monthly:** Update test dependencies and Flutter SDK
- **Quarterly:** Audit test coverage and identify gaps
- **Yearly:** Review and update testing strategy

### Dealing with Flaky Tests
1. Identify through CI logs and test history
2. Add `@Tags(['flaky'])` annotation
3. Investigate timing issues and async operations
4. Fix within 1 sprint or remove if not critical

### Test Performance Optimization
- Use `setUpAll` and `tearDownAll` for expensive setup
- Minimize widget pump operations in tests
- Use mocks instead of real widgets where possible
- Parallelize test execution with `--concurrency`

### Deprecation Strategy
When removing responsive features:
1. Mark tests as deprecated with clear comments
2. Keep tests for 1 minor version release
3. Remove tests when feature code is removed
4. Update documentation and migration guides

## Developer Testing Checklist

### Before Writing Code
- [ ] Review existing tests for similar responsive components
- [ ] Identify breakpoint scenarios (all sizes, edge cases, errors)
- [ ] Plan test data for different constraint combinations

### While Writing Code
- [ ] Write tests alongside responsive implementation
- [ ] Test with multiple breakpoint configurations
- [ ] Ensure widget tests cover constraint variations
- [ ] Validate fallback behavior for missing breakpoints

### Before Committing
- [ ] All tests passing locally
- [ ] Coverage meets 90% threshold
- [ ] No debugging statements in test code
- [ ] Widget golden files updated if necessary
- [ ] Performance tests pass for new features

### During Code Review
- [ ] Tests cover all responsive breakpoints
- [ ] Edge cases and error conditions tested
- [ ] Widget tests validate visual behavior
- [ ] Performance implications considered
- [ ] Test maintainability and readability verified

## Quick Reference

### Common Commands
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/breakpoints/breakpoints_test.dart

# Run tests with coverage
flutter test --coverage

# Run only unit tests
flutter test test/unit/

# Run widget tests
flutter test test/widget/

# Run tests in specific directory
flutter test test/integration/

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Update golden files
flutter test --update-goldens

# Run tests with verbose output
flutter test --verbose
```

### Debugging Tests
1. Use `debugPrint` for test debugging output
2. Set breakpoints in IDE test runner
3. Use `pumpAndSettle()` for widget stabilization
4. Increase test timeout for slow operations: `test('...', timeout: Timeout(Duration(seconds: 10)))`
5. Use `--verbose` flag for detailed test output

## Test Templates

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('ClassName', () {
    late ClassName instance;

    setUp(() {
      instance = ClassName();
    });

    group('methodName', () {
      test('should [expected behavior] when [condition]', () {
        // Arrange
        const input = /* test input */;
        const expected = /* expected output */;

        // Act
        final result = instance.methodName(input);

        // Assert
        expect(result, equals(expected));
      });
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('WidgetName Widget Tests', () {
    testWidgets('should [expected behavior] when [condition]', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: WidgetName(
            // widget configuration
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(WidgetName), findsOneWidget);
      // Additional assertions
    });
  });
}
```

### Responsive Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('Responsive Widget Tests', () {
    testWidgets('should adapt to different screen sizes', (tester) async {
      // Test multiple breakpoints
      final testCases = [
        (Size(400, 600), 'Small'),
        (Size(800, 600), 'Medium'),
        (Size(1200, 600), 'Large'),
      ];

      for (final testCase in testCases) {
        await tester.binding.setSurfaceSize(testCase.$1);
        
        await tester.pumpWidget(
          MaterialApp(
            home: LayoutSizeBuilder(
              small: (context) => Text('Small'),
              medium: (context) => Text('Medium'),
              large: (context) => Text('Large'),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        expect(find.text(testCase.$2), findsOneWidget);
      }
    });
  });
}
```

---

This testing strategy document should be reviewed quarterly and updated as the responsive_size_builder package evolves. All team members should familiarize themselves with these guidelines to ensure consistent, reliable testing practices across the project.