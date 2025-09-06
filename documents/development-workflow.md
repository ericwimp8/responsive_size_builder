# Development Workflow Documentation

## Introduction

This document provides a comprehensive workflow guide for the **responsive_size_builder** Flutter package project. The responsive_size_builder is a sophisticated Flutter package that enables developers to create adaptive user interfaces across the full spectrum of device sizes, from smartwatches to ultra-wide monitors. It provides both simple and granular breakpoint systems with multiple builder widgets for different responsive design scenarios.

This workflow documentation ensures team consistency, reduces onboarding time, and maintains development standards for contributors working on this responsive design package.

## Step 1: Development Environment Setup

### 1.1 System Requirements

**Operating System:**
- macOS 12+ / Ubuntu 20.04+ / Windows 10+

**Required Software:**
- Flutter SDK: 3.5.0 or higher
- Dart SDK: Compatible with Flutter 3.5.0+
- Git: Latest stable version
- IDE: VS Code, Android Studio, or IntelliJ IDEA
- Chrome browser (for web development and testing)

**Hardware Requirements:**
- RAM: Minimum 8GB, recommended 16GB
- Available disk space: 5GB minimum for Flutter SDK and dependencies
- Screen resolution: 1280x720 minimum (for testing responsive layouts)

**Network Requirements:**
- Internet connection for downloading dependencies
- Access to pub.dev for package publishing

### 1.2 Installation Steps

1. **Install Flutter SDK:**
   ```bash
   # Download Flutter SDK from https://flutter.dev/docs/get-started/install
   # Add Flutter to your PATH
   export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/your-org/responsive_size_builder.git
   cd responsive_size_builder
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Configure IDE extensions (VS Code recommended):**
   - Flutter extension by Dart Code
   - Dart extension by Dart Code
   - Flutter Widget Snippets
   - Very Good Analysis (for code quality)

5. **Verify Flutter installation:**
   ```bash
   flutter doctor
   ```

### 1.3 Verification Steps

**Health check commands:**
```bash
# Verify Flutter installation
flutter doctor -v

# Verify project dependencies
flutter pub deps

# Run static analysis
flutter analyze

# Verify tests can run
flutter test
```

**Expected outputs:**
- ✅ Flutter doctor shows no critical issues
- ✅ All dependencies resolve successfully
- ✅ No analysis issues reported
- ✅ All tests pass

## Step 2: Running the Application Locally

### 2.1 Starting the Example Application

The project includes a comprehensive example app demonstrating all responsive features:

**Development Mode:**
```bash
cd example
flutter run -d chrome
# Starts example app in Chrome for responsive testing
# Hot reload enabled for rapid development
```

**Different Device Targets:**
```bash
# Run on specific platforms
flutter run -d chrome          # Web browser (best for responsive testing)
flutter run -d macos           # macOS desktop
flutter run -d "iPhone Simulator"  # iOS simulator
flutter run -d emulator-5554   # Android emulator
```

**Web Development Server:**
```bash
cd example
flutter run -d chrome --web-port=3000
# Starts on http://localhost:3000
# Ideal for responsive testing across breakpoints
```

### 2.2 Example Application Features

The example app demonstrates:
- **ScreenSizeBuilder**: Basic responsive layouts
- **ScreenSizeOrientationBuilder**: Orientation-aware responsive design
- **ScreenSizeBuilderGranular**: Fine-grained responsive control
- **LayoutSizeBuilder**: Layout-focused responsive building
- **ValueSizeBuilder**: Value-based responsive design
- **Screen size data inspection**: Real-time breakpoint information

### 2.3 Common Local Development Tasks

**Generate code coverage:**
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Format code:**
```bash
dart format .
```

**Analyze code quality:**
```bash
flutter analyze
dart run very_good_analysis
```

**Update dependencies:**
```bash
flutter pub upgrade
flutter pub get
```

## Step 3: Testing Procedures

### 3.1 Test Structure

**Test Organization:**
```
test/
├── widget_test.dart              # Widget tests for builders
├── unit/
│   ├── breakpoints_test.dart     # Breakpoints configuration tests
│   ├── breakpoints_handler_test.dart  # Handler logic tests
│   └── screen_size_data_test.dart     # Data model tests
├── integration/
│   └── responsive_behavior_test.dart   # End-to-end responsive tests
└── helpers/
    └── test_helpers.dart         # Test utilities and mocks
```

**Test Categories:**
- **Unit Tests**: Individual component functionality
- **Widget Tests**: Flutter widget behavior and rendering
- **Integration Tests**: Complete responsive workflows
- **Golden Tests**: Visual regression testing for layouts

### 3.2 Running Tests

**Run all tests:**
```bash
flutter test
```

**Run specific test suites:**
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only  
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/
```

**Run tests with coverage:**
```bash
flutter test --coverage
```

**Run tests in watch mode:**
```bash
flutter test --reporter=expanded --coverage --watch
```

**Test on multiple platforms:**
```bash
# Web platform
flutter test --platform chrome

# Multiple platforms
flutter test --platform vm,chrome
```

### 3.3 Writing New Tests

**Test File Naming Convention:**
- Unit tests: `[component_name]_test.dart`
- Widget tests: `[widget_name]_widget_test.dart`
- Integration tests: `[feature_name]_integration_test.dart`

**Test Structure Pattern:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('ComponentName', () {
    test('should behave correctly when condition met', () {
      // Arrange
      final component = ComponentName();
      
      // Act
      final result = component.performAction();
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

**Responsive Testing Helpers:**
```dart
// Mock different screen sizes for testing
testWidgets('should adapt to different breakpoints', (tester) async {
  await tester.binding.setSurfaceSize(const Size(360, 640)); // Mobile
  await tester.pumpWidget(testWidget);
  // Assert mobile layout
  
  await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop  
  await tester.pumpWidget(testWidget);
  // Assert desktop layout
});
```

## Step 4: Debugging Procedures

### 4.1 Debugging Tools

**Flutter DevTools:**
```bash
flutter run --debug
# Open DevTools in browser for widget inspector, performance profiler
```

**Debug Configuration Options:**
```dart
// Enable debug logging for responsive behavior
debugPrint('Current breakpoint: ${screenData.screenSize}');
debugPrint('Screen dimensions: ${screenData.logicalScreenWidth}x${screenData.logicalScreenHeight}');
```

**IDE Debug Configurations:**
- Breakpoints in responsive builder logic
- Variable inspection for screen size calculations
- Widget tree inspection for layout debugging

### 4.2 Common Issues and Solutions

**Issue: Breakpoints not triggering correctly**
```
Symptoms: Layout doesn't change at expected screen sizes
Common causes:
1. Incorrect breakpoint configuration
2. Wrong dimension being used (width vs shortest side)
3. MediaQuery data not available

Solutions:
1. Verify breakpoint values are in descending order
2. Check useShortestSide parameter
3. Ensure ScreenSize widget wraps the app
```

**Issue: Widget rebuilds too frequently**
```
Symptoms: Performance issues, excessive rebuild logs
Common causes:
1. Using ScreenSizeModel.of instead of screenSizeOf
2. Listening to unnecessary data changes

Solutions:
1. Use ScreenSizeModel.screenSizeOf for size-only dependencies
2. Implement proper InheritedModel aspects
```

**Issue: Example app not showing responsive changes**
```
Symptoms: Layout appears static when resizing
Common causes:
1. Missing ScreenSize wrapper
2. Incorrect builder configuration
3. Cached layout constraints

Solutions:
1. Verify app is wrapped in ScreenSize<T> widget
2. Check that at least one builder is provided
3. Restart app to clear constraints cache
```

### 4.3 Debug Mode Configuration

**Enable verbose responsive logging:**
```dart
// In development builds
const bool kDebugResponsive = !kReleaseMode;

if (kDebugResponsive) {
  final handler = BreakpointsHandler(
    onChanged: (size) => debugPrint('Breakpoint changed to: $size'),
    // ... builder configuration
  );
}
```

**Performance debugging:**
```bash
# Profile widget rebuilds
flutter run --profile
# Access performance tab in DevTools
```

## Step 5: Branching Strategy

### 5.1 Branch Structure (GitFlow Model)

**Main Branches:**
- `main` - Production-ready code, published versions
- `develop` - Integration branch for features

**Supporting Branches:**
- `feature/*` - New features and enhancements
- `release/*` - Release preparation and version updates
- `hotfix/*` - Critical bug fixes for published versions

**Branch Naming Convention:**
```
feature/issue-123-granular-breakpoints
feature/responsive-value-builder
release/v0.2.0
hotfix/breakpoint-calculation-bug
```

### 5.2 Branch Lifecycle

**Feature Development:**
1. Create feature branch from `develop`
2. Implement changes with tests
3. Create pull request to `develop`
4. Code review and approval
5. Merge and delete feature branch

**Release Process:**
1. Create release branch from `develop`
2. Update version numbers and changelog
3. Final testing and bug fixes
4. Merge to `main` and `develop`
5. Tag release on `main`

**Hotfix Process:**
1. Create hotfix branch from `main`
2. Fix critical issue with tests
3. Merge to both `main` and `develop`
4. Tag new patch version

## Step 6: Code Review Process

### 6.1 Pull Request Guidelines

**PR Title Format:**
```
[type]: Brief description of changes

Examples:
feat: Add support for granular breakpoints
fix: Correct breakpoint calculation for edge cases
docs: Update API documentation for ScreenSizeBuilder
```

**PR Description Template:**
```markdown
## Changes
Brief description of what this PR accomplishes

## Breaking Changes
- List any breaking API changes
- Migration notes if applicable

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Example app updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Documentation updated
- [ ] Changelog updated (for releases)
- [ ] No decrease in test coverage
```

### 6.2 Review Standards

**Code Review Checklist:**

**Functionality:**
- [ ] Code fulfills the requirements
- [ ] Edge cases are handled (null values, extreme screen sizes)
- [ ] No regression in existing responsive behavior
- [ ] Backwards compatibility maintained

**Code Quality:**
- [ ] Follows Dart/Flutter best practices
- [ ] Consistent with existing codebase style
- [ ] Clear and descriptive naming
- [ ] Adequate documentation comments
- [ ] No code duplication

**Testing:**
- [ ] Appropriate unit tests added/updated
- [ ] Widget tests cover responsive behavior
- [ ] All tests passing
- [ ] Test coverage maintained above 90%

**Performance:**
- [ ] No unnecessary widget rebuilds
- [ ] Efficient breakpoint calculations
- [ ] Memory usage considerations

### 6.3 Review Workflow

**Approval Process:**
1. All CI checks must pass
2. At least one approval from code owner
3. No unresolved review comments
4. Documentation updated appropriately

**Merge Strategies:**
- **Squash and merge** for feature branches (clean history)
- **Create merge commit** for releases (preserve branch structure)
- **Rebase and merge** for small fixes (linear history)

## Step 7: Deployment Pipeline

### 7.1 Package Publishing Environments

**Development:**
- Purpose: Internal testing and validation
- Trigger: Manual from develop branch
- Distribution: Internal teams only

**Staging (pub.dev pre-release):**
- Purpose: Community beta testing
- Trigger: Release branch creation
- Version: `X.Y.Z-beta.N`
- Distribution: Opt-in beta users

**Production (pub.dev stable):**
- Purpose: Public stable release
- Trigger: Manual from main branch
- Version: `X.Y.Z`
- Distribution: Public package registry

### 7.2 Deployment Process

**Pre-release Preparation:**
```bash
# Update version in pubspec.yaml
# Update CHANGELOG.md
# Verify all tests pass
flutter test

# Validate package
flutter packages pub publish --dry-run

# Check package scoring
pana --no-warning
```

**Staging Deployment:**
```bash
# Publish pre-release version
flutter packages pub publish --force
```

**Production Deployment:**
```bash
# Final validation
flutter test
flutter analyze

# Publish stable version
flutter packages pub publish

# Create GitHub release with notes
git tag v0.2.0
git push origin v0.2.0
```

**Post-deployment Verification:**
```bash
# Verify package is available
flutter pub deps --json
# Check pub.dev package page
# Test package installation in new project
```

### 7.3 Rollback Procedures

**Version Rollback:**
- pub.dev doesn't support version deletion
- Publish hotfix version (X.Y.Z+1) if critical issues found
- Update package documentation with migration notes

**Emergency Response:**
1. Immediately publish hotfix if security issue
2. Update GitHub releases with warnings
3. Communicate to community via package page

## Step 8: CI/CD Setup

### 8.1 CI Pipeline Configuration (.github/workflows/ci.yml)

**Pipeline Stages:**

1. **Checkout and Setup**
   ```yaml
   - uses: actions/checkout@v3
   - uses: subosito/flutter-action@v2
     with:
       flutter-version: '3.5.0'
   ```

2. **Dependencies**
   ```yaml
   - name: Get dependencies
     run: flutter pub get
   - name: Verify dependencies
     run: flutter pub deps
   ```

3. **Code Quality**
   ```yaml
   - name: Analyze code
     run: flutter analyze
   - name: Format check
     run: dart format --set-exit-if-changed .
   ```

4. **Testing**
   ```yaml
   - name: Run tests
     run: flutter test --coverage
   - name: Upload coverage
     uses: codecov/codecov-action@v3
   ```

5. **Build Verification**
   ```yaml
   - name: Build example (web)
     run: |
       cd example
       flutter build web
   - name: Build example (Android)
     run: |
       cd example  
       flutter build apk --debug
   ```

### 8.2 CD Configuration

**Package Publishing Pipeline:**
```yaml
name: Publish Package
on:
  push:
    tags:
      - 'v*'
      
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter packages pub publish --force
        env:
          PUB_DEV_TOKEN: ${{ secrets.PUB_DEV_TOKEN }}
```

**Environment Variables:**
- `PUB_DEV_TOKEN`: Package publishing authentication
- `CODECOV_TOKEN`: Code coverage reporting

### 8.3 Pipeline Maintenance

**Adding New Pipeline Stages:**
1. Create feature branch
2. Update workflow files
3. Test pipeline changes
4. Document new requirements

**Debugging Failed Pipelines:**
- Check GitHub Actions logs
- Reproduce locally with same Flutter version
- Verify environment variables are set
- Check for dependency conflicts

## Step 9: Quick Reference Guides

### 9.1 Command Cheat Sheet

**Daily Development:**
```bash
flutter pub get              # Install dependencies
flutter run -d chrome        # Run example app
flutter test                 # Run all tests
flutter analyze             # Static analysis
dart format .               # Format code
```

**Package Development:**
```bash
flutter packages pub publish --dry-run    # Validate package
pana --no-warning                         # Package analysis
flutter test --coverage                   # Generate coverage
dart doc                                  # Generate documentation
```

**Responsive Testing:**
```bash
# Test different screen sizes in Chrome DevTools
flutter run -d chrome
# Then use DevTools responsive mode to test breakpoints
```

**Release Commands:**
```bash
git tag v1.0.0              # Tag release
git push origin v1.0.0      # Push tag
flutter packages pub publish # Publish to pub.dev
```

### 9.2 Responsive Development Patterns

**Basic Responsive Widget:**
```dart
ScreenSizeBuilder(
  small: (context, data) => MobileLayout(),
  medium: (context, data) => TabletLayout(),
  large: (context, data) => DesktopLayout(),
)
```

**Granular Responsive Control:**
```dart
ScreenSizeBuilderGranular(
  compactLarge: (context, data) => ModernPhoneLayout(),
  standardNormal: (context, data) => TabletLayout(),
  jumboSmall: (context, data) => UltraWideLayout(),
)
```

**Value-based Responsive Design:**
```dart
final spacing = ValueSizeBuilder<double>(
  small: 8.0,
  medium: 16.0,
  large: 24.0,
);
```

## Step 10: Documentation Maintenance

### 10.1 Documentation Standards

**Documentation Update Requirements:**
- API changes require updated doc comments
- New features need example updates
- Breaking changes require migration guides
- Version updates need changelog entries

**Documentation Types:**
- **API Documentation**: Dart doc comments in code
- **Usage Examples**: In `/example` directory
- **README**: Overview and quick start
- **CHANGELOG**: Version history and breaking changes

### 10.2 Feedback Loop

**Documentation Improvement Process:**
1. **Issue Reporting**: GitHub issues for documentation gaps
2. **Community Feedback**: pub.dev comments and GitHub discussions
3. **Regular Reviews**: Quarterly documentation audits
4. **Onboarding Testing**: New contributors test setup instructions

**Documentation Metrics:**
- API documentation coverage: >95%
- Example app completeness: All features demonstrated
- Setup success rate: Track onboarding feedback
- Community questions: Monitor common support requests

## Best Practices Summary

1. **Consistent Development Environment**: Use specified Flutter versions and tools
2. **Comprehensive Testing**: Maintain >90% test coverage with responsive behavior tests
3. **Responsive-First Design**: Test across multiple breakpoints during development
4. **Documentation-Driven Development**: Update docs alongside code changes
5. **Community-Focused**: Consider developer experience in all changes
6. **Performance-Conscious**: Profile responsive builders to avoid excessive rebuilds
7. **Backwards Compatible**: Maintain API stability for package consumers
8. **Version Semantic**: Follow semantic versioning for package releases

## Conclusion

This development workflow documentation serves as the foundation for maintaining high-quality, responsive Flutter applications using the responsive_size_builder package. The workflow emphasizes testing across multiple device sizes, maintaining comprehensive documentation, and ensuring smooth responsive behavior across the entire device ecosystem.

Regular updates and team feedback ensure this documentation remains valuable and accurate as the package evolves. The responsive design patterns and development practices outlined here help teams create adaptable, maintainable Flutter applications that work beautifully across all screen sizes.