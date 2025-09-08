# Development Workflow Documentation

A comprehensive guide for developing, testing, and deploying the responsive_size_builder Flutter package.

## Introduction

This document provides a complete development workflow for the responsive_size_builder package, a Flutter library that enables responsive layouts based on screen size breakpoints. The package offers flexible breakpoint systems, multiple builder widgets, and comprehensive responsive design utilities for Flutter applications.

The responsive_size_builder package is designed to simplify responsive UI development across different screen sizes, from mobile devices to ultra-wide desktop monitors, with both simple and granular breakpoint systems.

## Step 1: Development Environment Setup

### 1.1 System Requirements

The following prerequisites are needed to work on the responsive_size_builder package:

**Operating System Requirements:**
- macOS 12+ / Ubuntu 20.04+ / Windows 10+

**Required Software and Minimum Versions:**
- Flutter SDK: v3.5.0 or higher
- Dart SDK: ^3.5.0 (included with Flutter)
- Git: v2.20.0 or higher
- IDE: VS Code, Android Studio, or IntelliJ IDEA

**Hardware Requirements:**
- RAM: Minimum 8GB, recommended 16GB
- Available disk space: 5GB minimum for Flutter SDK and project dependencies
- Internet connection for package downloads and updates

**Development Tools:**
- Flutter DevTools (included with Flutter)
- Browser for web development testing
- iOS Simulator (macOS) / Android Emulator for mobile testing

### 1.2 Installation Steps

Follow these sequential steps to set up your development environment:

#### 1. Install Flutter SDK
```bash
# Download Flutter from https://flutter.dev/docs/get-started/install
# Extract and add to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### 2. Clone the repository
```bash
git clone https://github.com/your-username/responsive_size_builder.git
cd responsive_size_builder
```

#### 3. Install dependencies
```bash
# Install package dependencies
flutter pub get

# Navigate to example directory and install its dependencies
cd example
flutter pub get
cd ..
```

#### 4. Configure IDE Extensions (VS Code)
Install the following recommended extensions:
- Flutter (Dart-Code.flutter)
- Dart (Dart-Code.dart-code)
- Flutter Widget Snippets
- Pubspec Assist

#### 5. Configure IDE Extensions (Android Studio/IntelliJ)
- Install Flutter plugin
- Install Dart plugin (usually bundled with Flutter plugin)

#### 6. Set up development devices
```bash
# For web development
flutter config --enable-web

# Check available devices
flutter devices

# Create Android emulator (if needed)
flutter emulators --create

# For iOS (macOS only)
open -a Simulator
```

### 1.3 Verification Steps

Verify your setup is correct by running these commands:

```bash
# Check Flutter installation and dependencies
flutter doctor -v

# Expected: All checkmarks with no critical issues

# Run example application
cd example
flutter run
# Expected: Example app launches successfully

# Run tests
cd ..
flutter test
# Expected: All tests pass

# Check analysis
flutter analyze
# Expected: No analysis issues

# Format code
dart format --set-exit-if-changed .
# Expected: No formatting issues
```

## Step 2: Running the Application Locally

### 2.1 Starting the Application

The responsive_size_builder package includes a comprehensive example application demonstrating all features:

#### Development Mode (Hot Reload)
```bash
cd example
flutter run
# Starts on available device with hot reload enabled
# Debug logging active
# Access via device/emulator

# For web specifically
flutter run -d chrome
# Starts on http://localhost:auto-assigned-port
# Enables responsive testing by resizing browser window
```

#### Production Mode (Optimized)
```bash
cd example
flutter build web
flutter run -d web-server --web-port 8080 --release
# Optimized build served at http://localhost:8080
# No debug output or hot reload
```

#### Specific Platform Builds
```bash
# Android APK
flutter build apk

# iOS (macOS only)
flutter build ios

# Web
flutter build web

# macOS (macOS only)
flutter build macos

# Windows (Windows only)
flutter build windows

# Linux (Linux only)  
flutter build linux
```

### 2.2 Common Local Development Tasks

#### Package Development Tasks
```bash
# Analyze package code
flutter analyze lib/

# Format package code
dart format lib/ test/

# Generate documentation
dart doc

# Publish dry-run (test package publication)
flutter pub publish --dry-run

# Update dependencies
flutter pub upgrade

# Clear build cache
flutter clean
flutter pub get
```

#### Example Application Tasks
```bash
cd example

# Hot restart (full restart with state reset)
# In running app: Press 'R' in terminal or Shift+R in IDE

# Hot reload (preserve state)
# In running app: Press 'r' in terminal or save file in IDE

# Toggle debug painting (widget boundaries)
# In running app: Press 'p' in terminal

# Open Flutter DevTools
# In running app: Press 'v' in terminal
# Or visit: http://localhost:9100
```

#### Responsive Testing Tasks
```bash
# Test different screen sizes with Flutter Inspector
# Available in Flutter DevTools -> Inspector tab

# Web responsive testing
flutter run -d chrome
# Use browser dev tools to simulate different screen sizes
# Test breakpoint transitions by resizing window

# Device-specific testing
flutter run -d "iPhone 14"
flutter run -d "Pixel 6"
```

## Step 3: Testing Procedures

### 3.1 Test Structure

The responsive_size_builder package follows Flutter testing best practices:

**Test Types and Locations:**
- **Unit Tests**: `test/` directory - Test individual functions and classes
- **Widget Tests**: `test/` directory - Test widget behavior and UI components  
- **Integration Tests**: `integration_test/` directory - Test complete user flows
- **Example Tests**: `example/test/` directory - Test example application

**Test File Naming Convention:**
- Unit tests: `*_test.dart` (e.g., `breakpoints_test.dart`)
- Widget tests: `*_widget_test.dart` (e.g., `screen_size_builder_widget_test.dart`)
- Integration tests: `*_integration_test.dart`

**Test Data Management:**
- Mock breakpoints for testing different screen sizes
- Custom FlutterView instances for controlled testing environments
- Test-specific screen size data fixtures

### 3.2 Running Tests

Execute different testing scenarios with these commands:

```bash
## All Tests
# Run complete test suite
flutter test

# Run with coverage reporting
flutter test --coverage
# Coverage report generated in coverage/lcov.info

## Specific Test Categories
# Run unit tests only
flutter test test/unit/

# Run widget tests only
flutter test test/widget/

# Run integration tests
flutter test integration_test/

# Run example app tests
cd example && flutter test

## Specific Test Files
# Run specific test file
flutter test test/breakpoints_test.dart

# Run tests matching pattern
flutter test --plain-name "ScreenSizeBuilder"

## Watch Mode (Re-run on changes)
flutter test --watch

## Debug Mode (Attach debugger)
flutter test --start-paused
# Then attach debugger from IDE

## Platform-specific tests
flutter test --platform chrome
flutter test -d "iPhone 14"
```

### 3.3 Writing New Tests

When adding new features or fixing bugs, follow these test patterns:

#### Unit Test Structure
```dart
// test/unit/breakpoints_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('Breakpoints', () {
    test('should create with default values', () {
      const breakpoints = Breakpoints();
      
      expect(breakpoints.extraLarge, equals(1200.0));
      expect(breakpoints.large, equals(950.0));
      expect(breakpoints.medium, equals(600.0));
      expect(breakpoints.small, equals(200.0));
    });
    
    test('should validate descending order', () {
      expect(
        () => Breakpoints(
          extraLarge: 500, // Invalid: smaller than large
          large: 1000,
        ),
        throwsAssertionError,
      );
    });
  });
}
```

#### Widget Test Structure
```dart
// test/widget/screen_size_builder_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('ScreenSizeBuilder Widget', () {
    testWidgets('should build correct widget for screen size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenSize<LayoutSize>(
            breakpoints: Breakpoints(),
            child: ScreenSizeBuilder(
              small: (context, data) => Text('Small'),
              large: (context, data) => Text('Large'),
            ),
          ),
        ),
      );
      
      // Set screen size to large
      await tester.binding.setSurfaceSize(Size(1000, 800));
      await tester.pumpAndSettle();
      
      expect(find.text('Large'), findsOneWidget);
      expect(find.text('Small'), findsNothing);
    });
  });
}
```

#### Test Best Practices
- Test edge cases and boundary conditions
- Use descriptive test names that explain the scenario
- Mock external dependencies and platform-specific code
- Test both positive and negative cases
- Verify error handling and assertion failures
- Use `pumpAndSettle()` for animated widgets
- Clean up resources in `tearDown()` when needed

## Step 4: Debugging Procedures

### 4.1 Debugging Tools

The following tools are available for debugging the responsive_size_builder package:

#### Built-in Flutter Debugging
```bash
# Run in debug mode with verbose logging
flutter run --debug --verbose

# Enable additional logging
flutter run --enable-asserts

# Profile mode (optimized but debuggable)
flutter run --profile
```

#### Flutter DevTools
```bash
# Launch DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Or via command in running app
# Press 'v' in terminal when flutter run is active
# Opens browser at http://localhost:9100
```

**DevTools Features for Responsive Development:**
- **Flutter Inspector**: Visual widget tree and properties
- **Timeline**: Performance profiling and frame analysis  
- **Memory**: Memory usage and leak detection
- **Network**: Network request monitoring
- **Logging**: Application and framework logs

#### IDE Debugging Configuration

**VS Code Launch Configuration (.vscode/launch.json):**
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "responsive_size_builder",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart"
    },
    {
      "name": "example",
      "type": "dart", 
      "request": "launch",
      "program": "example/lib/main.dart"
    }
  ]
}
```

#### Logging Configuration
The package uses Flutter's built-in logging:

```dart
// Enable in debug builds
import 'dart:developer' as developer;

developer.log('Current breakpoint: ${data.currentBreakpoint}', 
  name: 'responsive_size_builder');
```

### 4.2 Common Issues and Solutions

#### Issue: Breakpoint calculations incorrect
**Symptoms:** Wrong layout displayed for current screen size  
**Common Causes:**
1. Incorrect breakpoint configuration
2. Wrong screen dimension being used (width vs shortestSide)
3. MediaQuery not providing expected values

**Solutions:**
```bash
# Debug breakpoint calculation
flutter run --debug
# Add debug prints in _getScreenSize method
# Verify MediaQuery.of(context).size values
```

```dart
// Debug helper
developer.log('Screen: ${size.width}x${size.height}, Breakpoint: $screenSize');
```

#### Issue: ScreenSizeModel not found error
**Symptoms:** `ScreenSizeModel<LayoutSize> not found` runtime error  
**Common Causes:**
1. Missing ScreenSize wrapper widget
2. Wrong type parameter in ScreenSizeModel.of<T>()
3. Widget not in correct context tree

**Solutions:**
```dart
// Ensure proper wrapping
ScreenSize<LayoutSize>(
  breakpoints: Breakpoints(),
  child: YourApp(), // ScreenSizeBuilder should be descendant
)

// Verify correct type parameter
final data = ScreenSizeModel.of<LayoutSize>(context); // Not LayoutSizeGranular
```

#### Issue: Hot reload not working with responsive changes
**Symptoms:** Layout doesn't update when changing breakpoints  
**Solutions:**
```bash
# Use hot restart instead of hot reload
# Press 'R' in terminal or Shift+R in IDE

# Or restart Flutter completely
flutter run --hot
```

#### Issue: Tests failing with screen size dependencies  
**Symptoms:** Widget tests fail with MediaQuery or ScreenSize errors  
**Solutions:**
```dart
// Provide proper test environment
testWidgets('test name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ScreenSize<LayoutSize>(
        breakpoints: Breakpoints(),
        child: WidgetUnderTest(),
      ),
    ),
  );
  
  // Set specific screen size for testing
  await tester.binding.setSurfaceSize(Size(800, 600));
});
```

### 4.3 Debug Mode Configuration

#### Enable Verbose Breakpoint Logging
```dart
// In development builds, add to ScreenSize constructor:
const ScreenSize<LayoutSize>(
  breakpoints: Breakpoints(),
  child: MyApp(),
  // Add custom logging in _ScreenSizeState.updateMetrics
)
```

#### Performance Debugging
```bash
# Profile performance
flutter run --profile --trace-startup

# Analyze performance in DevTools Timeline tab
# Look for excessive rebuilds during screen size changes

# Memory profiling
flutter run --profile
# Monitor memory usage in DevTools Memory tab
```

#### Platform-Specific Debugging
```bash
# Web debugging (Chrome DevTools)
flutter run -d chrome --web-renderer html
# Access Chrome DevTools for additional web-specific debugging

# Android debugging
flutter run -d android
adb logcat -s flutter

# iOS debugging (macOS only)
flutter run -d ios
# Use Xcode Console for system logs
```

## Step 5: Branching Strategy

### 5.1 Branch Structure

The responsive_size_builder package follows Git Flow branching model:

#### Main Branches
- **main** - Production-ready code, tagged releases
- **develop** - Integration branch for new features and improvements

#### Supporting Branches
- **feature/** - New features and enhancements (from develop)
- **release/** - Release preparation and finalization (from develop)  
- **hotfix/** - Critical production fixes (from main)

#### Branch Naming Convention
```
feature/RSB-123-add-granular-orientation-support
feature/improve-breakpoint-performance
release/v1.2.0
hotfix/RSB-456-fix-web-breakpoint-calculation
```

**Naming Pattern:**
- `feature/[ISSUE-ID]-brief-description` or `feature/brief-description`
- `release/v[MAJOR].[MINOR].[PATCH]`
- `hotfix/[ISSUE-ID]-brief-description`

### 5.2 Branch Lifecycle

#### Feature Branch Workflow
```bash
# 1. Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/RSB-123-add-custom-breakpoint-validation

# 2. Develop feature with regular commits
git add .
git commit -m "feat: add validation for custom breakpoint thresholds"

# 3. Keep branch updated with develop
git fetch origin
git rebase origin/develop

# 4. Push feature branch
git push origin feature/RSB-123-add-custom-breakpoint-validation

# 5. Create Pull Request to develop
# Include: description, testing notes, breaking changes

# 6. After merge, delete feature branch
git checkout develop
git pull origin develop
git branch -d feature/RSB-123-add-custom-breakpoint-validation
git push origin --delete feature/RSB-123-add-custom-breakpoint-validation
```

#### Release Branch Workflow
```bash
# 1. Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/v1.2.0

# 2. Update version numbers and documentation
# - pubspec.yaml version
# - CHANGELOG.md entries
# - README.md if needed

# 3. Run final testing
flutter test
flutter analyze
flutter pub publish --dry-run

# 4. Fix any release-specific issues
git commit -m "chore: prepare v1.2.0 release"

# 5. Merge to main and tag
git checkout main
git merge --no-ff release/v1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"

# 6. Merge back to develop
git checkout develop  
git merge --no-ff release/v1.2.0

# 7. Push everything
git push origin main
git push origin develop
git push origin v1.2.0

# 8. Delete release branch
git branch -d release/v1.2.0
git push origin --delete release/v1.2.0
```

#### Hotfix Branch Workflow
```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/RSB-456-fix-breakpoint-assertion

# 2. Fix critical issue
git add .
git commit -m "fix: correct breakpoint assertion logic for edge case"

# 3. Test fix thoroughly
flutter test
flutter analyze

# 4. Merge to main and tag patch release
git checkout main
git merge --no-ff hotfix/RSB-456-fix-breakpoint-assertion
git tag -a v1.1.1 -m "Hotfix version 1.1.1"

# 5. Merge to develop
git checkout develop
git merge --no-ff hotfix/RSB-456-fix-breakpoint-assertion

# 6. Push and clean up
git push origin main
git push origin develop  
git push origin v1.1.1
git branch -d hotfix/RSB-456-fix-breakpoint-assertion
```

## Step 6: Code Review Process

### 6.1 Pull Request Guidelines

All code changes must go through the pull request review process:

#### PR Title Format
```
type(scope): brief description

Examples:
feat(breakpoints): add support for custom breakpoint validation
fix(builder): resolve widget rebuild performance issue  
docs(readme): update installation instructions
test(integration): add comprehensive breakpoint testing
refactor(core): simplify screen size calculation logic
```

#### PR Description Template
```markdown
## Description
Brief summary of changes and motivation.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Testing
- [ ] Unit tests pass
- [ ] Widget tests pass  
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] Example app tested

## Screenshots/Videos
Include screenshots for UI changes or videos for complex interactions.

## Breakpoint Testing
- [ ] Tested on mobile devices (small/extraSmall)
- [ ] Tested on tablets (medium)
- [ ] Tested on desktop (large/extraLarge) 
- [ ] Tested granular breakpoints (if applicable)
- [ ] Tested orientation changes
- [ ] Tested window resizing (web)

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Commented complex/unclear code
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Added/updated tests for changes
```

#### Required Reviewers
- **Core Team Member**: Must approve architectural changes
- **Package Maintainer**: Must approve breaking changes
- **Any Team Member**: Can approve bug fixes and documentation

#### Label Usage
- `bug`: Bug fixes
- `enhancement`: New features
- `documentation`: Documentation changes
- `breaking-change`: Breaking API changes
- `performance`: Performance improvements
- `ready-for-review`: PR ready for review
- `work-in-progress`: PR not ready for review

### 6.2 Review Standards

Reviewers should verify the following aspects:

#### Code Quality Checklist
```markdown
### Functionality
- [ ] Code fulfills the stated requirements
- [ ] Edge cases are properly handled
- [ ] No regression in existing features
- [ ] Responsive behavior works across all breakpoints

### Code Architecture  
- [ ] Follows established package architecture patterns
- [ ] Proper separation of concerns
- [ ] Appropriate use of Flutter widgets and patterns
- [ ] Efficient use of InheritedModel and BuildContext

### Code Style
- [ ] Follows Dart/Flutter style guidelines
- [ ] Consistent with existing codebase formatting
- [ ] No code duplication
- [ ] Clear and descriptive variable/function names
- [ ] Adequate documentation comments for public APIs

### Testing
- [ ] Unit tests added/updated for new functionality
- [ ] Widget tests cover UI behavior changes
- [ ] Integration tests added for new user flows
- [ ] All tests passing in CI
- [ ] Test coverage maintained or improved

### Performance
- [ ] No unnecessary widget rebuilds
- [ ] Efficient breakpoint calculations
- [ ] Proper use of const constructors
- [ ] Memory leaks prevented

### Documentation
- [ ] Public APIs documented with DartDoc comments
- [ ] README updated if needed
- [ ] CHANGELOG entries added
- [ ] Example code updated if applicable
```

#### Responsive Design Review
```markdown
### Breakpoint Behavior
- [ ] Correct breakpoint thresholds applied
- [ ] Smooth transitions between breakpoints
- [ ] Proper fallback handling for missing builders
- [ ] Orientation changes handled correctly

### Cross-Platform Testing
- [ ] Behavior consistent across platforms (iOS/Android/Web/Desktop)
- [ ] Platform-specific optimizations appropriate
- [ ] No platform-specific bugs introduced

### Accessibility
- [ ] Screen readers work properly across sizes
- [ ] Touch targets appropriate for mobile devices
- [ ] Keyboard navigation works on desktop
```

### 6.3 Review Workflow

#### Review Process Steps
1. **Author Self-Review**: Complete checklist before requesting review
2. **Automated Checks**: CI pipeline runs tests and analysis
3. **Peer Review**: At least one team member reviews code
4. **Address Feedback**: Author responds to comments and makes changes
5. **Final Approval**: Reviewer(s) approve after satisfactory changes
6. **Merge**: Use appropriate merge strategy

#### Handling Review Feedback
```bash
# Make requested changes
git add .
git commit -m "review: address feedback on breakpoint validation"

# Push updates
git push origin feature/branch-name

# Notify reviewers of updates in PR comments
```

#### Merge Strategies
- **Squash and Merge**: For feature branches (clean history)
- **Merge Commit**: For release/hotfix branches (preserve branch history)  
- **Rebase and Merge**: For simple bug fixes (linear history)

## Step 7: Deployment Pipeline

### 7.1 Environment Overview

The responsive_size_builder package deployment involves multiple environments:

#### Package Registry Environments

##### Development/Testing
- **Purpose**: Pre-release testing and validation
- **Registry**: Local pub cache and git branches  
- **Deployment**: Manual via `flutter pub publish --dry-run`
- **Usage**: Internal testing and development
- **Access**: Development team only

##### Staging (Pre-release)
- **Purpose**: Release candidate validation
- **Registry**: pub.dev with prerelease versions (e.g., 1.2.0-beta.1)
- **Deployment**: Manual trigger after release branch creation
- **Usage**: Community beta testing
- **Access**: Public with version constraints

##### Production
- **Registry**: pub.dev with stable versions (e.g., 1.2.0)
- **Purpose**: Public stable releases
- **Deployment**: Manual with approval process
- **Usage**: Production Flutter applications
- **Access**: Public

#### Example Application Environments

##### GitHub Pages
- **URL**: https://your-username.github.io/responsive_size_builder/
- **Purpose**: Live demonstration of package capabilities
- **Deployment**: Automatic on main branch updates
- **Content**: Built example Flutter web application

### 7.2 Deployment Process

#### Package Publishing Process

##### Pre-release Deployment (Staging)
```bash
# 1. Create release candidate
git checkout release/v1.2.0

# 2. Update version to pre-release
# pubspec.yaml: version: 1.2.0-beta.1

# 3. Run comprehensive validation
flutter test
flutter analyze  
flutter pub publish --dry-run

# 4. Publish pre-release
flutter pub publish
# Requires confirmation and pub.dev authentication

# 5. Test integration in sample project
flutter create test_integration
cd test_integration
# Add to pubspec.yaml: responsive_size_builder: ^1.2.0-beta.1
flutter pub get
# Test functionality
```

##### Production Deployment
```bash
# 1. Finalize release branch
git checkout release/v1.2.0

# 2. Update to stable version
# pubspec.yaml: version: 1.2.0

# 3. Final validation
flutter test --coverage
flutter analyze --fatal-warnings
flutter pub publish --dry-run

# 4. Merge to main and tag
git checkout main
git merge --no-ff release/v1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"

# 5. Publish to pub.dev
flutter pub publish
# Requires final confirmation

# 6. Update develop branch
git checkout develop
git merge --no-ff release/v1.2.0
git push origin main develop
git push origin v1.2.0
```

#### Example Application Deployment
```bash
# 1. Build web version
cd example
flutter build web --base-href "/responsive_size_builder/"

# 2. Deploy to GitHub Pages (automated via GitHub Actions)
# Triggered by push to main branch
# Or manual deployment:
git subtree push --prefix example/build/web origin gh-pages
```

#### Documentation Deployment
```bash
# 1. Generate package documentation
dart doc

# 2. Documentation available at:
# Local: doc/api/index.html
# Published: https://pub.dev/documentation/responsive_size_builder/latest/
```

### 7.3 Approval Workflows

#### Release Approval Process

##### Minor/Major Releases
1. **Development Complete**: All features merged to develop branch
2. **Release Branch Created**: Create release/vX.Y.0 from develop
3. **Testing Phase**: Comprehensive testing on release branch
4. **Pre-release Publishing**: Publish beta version for community testing
5. **Documentation Review**: Ensure all docs updated
6. **Maintainer Approval**: Package maintainer reviews and approves
7. **Production Release**: Merge to main, tag, and publish stable version

##### Patch Releases  
1. **Hotfix Branch Created**: Create hotfix/vX.Y.Z from main
2. **Fix Implementation**: Implement and test critical fix
3. **Expedited Review**: Fast-track code review process
4. **Emergency Approval**: Maintainer can approve without full process
5. **Immediate Release**: Publish patch version quickly

#### Approval Authority
- **Package Maintainer**: Can approve all releases
- **Core Contributors**: Can approve patch releases
- **Community PRs**: Require maintainer approval for release inclusion

#### Emergency Deployment Procedures
For critical security fixes or major bugs:

```bash
# 1. Create emergency hotfix
git checkout main
git checkout -b hotfix/emergency-security-fix

# 2. Implement fix with minimal changes
git commit -m "security: fix critical vulnerability in breakpoint handling"

# 3. Immediate testing
flutter test
flutter analyze

# 4. Emergency review (can be post-merge)
# Create PR but merge immediately if critical

# 5. Expedited release
git checkout main
git merge hotfix/emergency-security-fix
git tag -a v1.1.2 -m "Emergency security fix"
flutter pub publish
git push origin main v1.1.2
```

## Step 8: CI/CD Setup

### 8.1 CI Pipeline Configuration

The responsive_size_builder package uses GitHub Actions for continuous integration:

#### GitHub Actions Workflow (.github/workflows/ci.yml)
```yaml
name: CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        flutter-version: ['3.5.0', 'stable']
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: ${{ matrix.flutter-version }}
        cache: true
        
    - name: Get Dependencies
      run: flutter pub get
      
    - name: Run Tests
      run: flutter test --coverage
      
    - name: Upload Coverage
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
        
  analyze:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: 'stable'
        cache: true
        
    - name: Get Dependencies  
      run: flutter pub get
      
    - name: Analyze
      run: flutter analyze --fatal-warnings
      
    - name: Check Formatting
      run: dart format --set-exit-if-changed .
      
  example_test:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: 'stable'
        cache: true
        
    - name: Get Package Dependencies
      run: flutter pub get
      
    - name: Get Example Dependencies
      run: |
        cd example
        flutter pub get
        
    - name: Test Example
      run: |
        cd example
        flutter test
        
    - name: Build Example Web
      run: |
        cd example
        flutter build web
```

#### Multi-platform Testing (.github/workflows/platform_test.yml)
```yaml
name: Platform Testing

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test_platforms:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: 'stable'
        cache: true
        
    - name: Get Dependencies
      run: flutter pub get
      
    - name: Run Tests
      run: flutter test
      
    - name: Test Example Build
      run: |
        cd example
        flutter pub get
        flutter build apk --debug
      if: matrix.os == 'ubuntu-latest'
        
    - name: Test Example Build (macOS)
      run: |
        cd example  
        flutter pub get
        flutter build macos --debug
      if: matrix.os == 'macos-latest'
        
    - name: Test Example Build (Windows)
      run: |
        cd example
        flutter pub get  
        flutter build windows --debug
      if: matrix.os == 'windows-latest'
```

### 8.2 CD Configuration

#### Automated Example Deployment (.github/workflows/deploy.yml)
```yaml
name: Deploy Example

on:
  push:
    branches: [ main ]
  release:
    types: [ published ]

jobs:
  deploy_example:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: 'stable'
        cache: true
        
    - name: Get Dependencies
      run: |
        flutter pub get
        cd example
        flutter pub get
        
    - name: Build Web
      run: |
        cd example
        flutter build web --base-href "/responsive_size_builder/"
        
    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: example/build/web
```

#### Package Release Automation (.github/workflows/release.yml)
```yaml
name: Release Package

on:
  release:
    types: [ published ]

jobs:
  publish:
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/v')
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: 'stable'
        cache: true
        
    - name: Get Dependencies
      run: flutter pub get
      
    - name: Run Tests
      run: flutter test
      
    - name: Analyze
      run: flutter analyze --fatal-warnings
      
    - name: Check Publish Ready
      run: flutter pub publish --dry-run
      
    - name: Setup Pub Credentials
      run: |
        mkdir -p ~/.pub-cache
        echo '${{ secrets.PUB_CREDENTIALS }}' > ~/.pub-cache/credentials.json
        
    - name: Publish to Pub.dev
      run: flutter pub publish --force
```

### 8.3 Pipeline Maintenance

#### Managing Pipeline Configurations
```bash
# 1. Test workflows locally using act
# Install act: https://github.com/nektos/act
act -j test

# 2. Update Flutter versions in matrix
# Edit .github/workflows/ci.yml
# Update flutter-version matrix values

# 3. Add new platform support
# Update platform_test.yml matrix.os
# Add platform-specific build commands
```

#### Secret Management
Required secrets in GitHub repository settings:

```
GITHUB_TOKEN: Automatically provided by GitHub
PUB_CREDENTIALS: JSON credentials for pub.dev publishing
CODECOV_TOKEN: Token for code coverage reporting
```

#### Pipeline Status Monitoring
```bash
# 1. View workflow runs in GitHub Actions tab
# 2. Set up status badges in README.md
[![CI](https://github.com/username/responsive_size_builder/workflows/CI/badge.svg)](https://github.com/username/responsive_size_builder/actions)
[![Coverage](https://codecov.io/gh/username/responsive_size_builder/branch/main/graph/badge.svg)](https://codecov.io/gh/username/responsive_size_builder)

# 3. Configure notifications for failed builds
# GitHub Settings → Notifications → Actions
```

#### Troubleshooting Pipeline Issues
Common pipeline problems and solutions:

```yaml
# Issue: Flutter version conflicts
# Solution: Pin to specific version
flutter-version: '3.16.5'  # Instead of 'stable'

# Issue: Pub publish authentication failures  
# Solution: Verify credentials format
# credentials.json should contain:
{
  "accessToken": "...",
  "refreshToken": "...",
  "tokenEndpoint": "https://accounts.google.com/o/oauth2/token",
  "scopes": ["https://www.googleapis.com/auth/userinfo.email", "openid"],
  "expiration": 1234567890123
}

# Issue: Example build failures
# Solution: Add proper dependency caching
- name: Cache Flutter packages
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      example/.packages
    key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
```

## Step 9: Quick Reference Guides

### 9.1 Command Cheat Sheet

#### Daily Development Commands
```bash
# Project setup
flutter pub get                    # Install dependencies
cd example && flutter pub get     # Install example dependencies

# Development
flutter run                       # Start example app with hot reload
flutter run -d chrome            # Run in Chrome browser
flutter test --watch             # Run tests in watch mode
flutter analyze                  # Run static analysis
dart format .                    # Format all code

# Testing specific scenarios
flutter test test/breakpoints_test.dart        # Run specific test file
flutter test --name "ScreenSize"               # Run tests matching name
flutter test --coverage                        # Run with coverage
```

#### Package Management
```bash
# Version management
flutter pub deps                  # Show dependency tree
flutter pub outdated             # Check for outdated dependencies
flutter pub upgrade              # Update dependencies

# Publishing
flutter pub publish --dry-run    # Test package publication
flutter pub publish             # Publish to pub.dev
dart doc                        # Generate documentation
```

#### Build Commands
```bash
# Example app builds
cd example
flutter build web               # Build for web deployment
flutter build apk             # Build Android APK
flutter build ios             # Build iOS app (macOS only)
flutter build macos           # Build macOS app (macOS only)
flutter build windows         # Build Windows app (Windows only)
flutter build linux           # Build Linux app (Linux only)
```

#### Debugging Commands
```bash
flutter run --debug --verbose   # Verbose debug mode
flutter logs                    # Show device logs
flutter screenshot             # Take device screenshot
flutter symbolize --input=crash.txt  # Symbolize crash reports
```

### 9.2 Emergency Procedures

#### Critical Bug Hotfix Procedure
```bash
# 1. Create emergency branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-breakpoint-fix

# 2. Implement minimal fix
# Edit files, add tests
git add .
git commit -m "hotfix: resolve critical breakpoint calculation error"

# 3. Run essential tests
flutter test
flutter analyze

# 4. Create emergency PR
git push origin hotfix/critical-breakpoint-fix
# Create PR to main with "EMERGENCY" prefix

# 5. After approval, merge and release
git checkout main
git merge hotfix/critical-breakpoint-fix
git tag -a v1.2.1 -m "Emergency hotfix v1.2.1"

# 6. Publish immediately
flutter pub publish --force
git push origin main v1.2.1

# 7. Merge to develop
git checkout develop
git merge main
git push origin develop
```

#### Package Recall Procedure (if possible)
```bash
# Note: pub.dev packages cannot be unpublished
# Alternative: Publish fixed version immediately

# 1. Create fix version
# Update pubspec.yaml version (e.g., 1.2.1)

# 2. Publish corrected version
flutter pub publish

# 3. Contact pub.dev support if needed
# Email: pub-support@googlegroups.com
# Include: package name, version, issue description

# 4. Update documentation
# Add breaking change notices
# Update README with migration guide
```

#### CI/CD Pipeline Recovery
```bash
# If GitHub Actions are failing:

# 1. Check workflow status
# Visit: https://github.com/username/responsive_size_builder/actions

# 2. Re-run failed workflows
# Click "Re-run jobs" in GitHub Actions UI

# 3. Force update workflow files
git add .github/workflows/
git commit -m "fix: update CI configuration"  
git push origin main

# 4. Skip CI if needed (emergency only)
git commit -m "emergency fix [skip ci]"
```

#### Rollback Procedures
```bash
# Rollback last pub.dev release (not possible)
# Alternative: Publish fixed version

# Rollback git changes
git checkout main
git reset --hard v1.1.0  # Reset to last known good version
git push origin main --force-with-lease

# Rollback example deployment
git checkout gh-pages
git reset --hard previous-good-commit
git push origin gh-pages --force-with-lease
```

### 9.3 Troubleshooting Quick Fixes

#### Common Development Issues

**Issue: "ScreenSizeModel not found"**
```dart
// Quick fix: Ensure proper widget wrapping
MaterialApp(
  home: ScreenSize<LayoutSize>(
    breakpoints: Breakpoints(),
    child: Scaffold(
      body: ScreenSizeBuilder(...), // Must be descendant
    ),
  ),
)
```

**Issue: "Breakpoints assertion failed"**
```dart
// Quick fix: Verify descending order
const Breakpoints(
  extraLarge: 1200,  // Largest
  large: 950,        // Must be < extraLarge
  medium: 600,       // Must be < large
  small: 200,        // Must be < medium
)
```

**Issue: "Hot reload not working"**
```bash
# Quick fix: Use hot restart instead
# Press 'R' in terminal (not 'r')
# Or restart Flutter process completely
```

**Issue: "Tests failing with MediaQuery errors"**
```dart
// Quick fix: Wrap test widget properly
testWidgets('test name', (tester) async {
  await tester.pumpWidget(
    MaterialApp(  // Provides MediaQuery
      home: ScreenSize<LayoutSize>(
        breakpoints: Breakpoints(),
        child: WidgetUnderTest(),
      ),
    ),
  );
});
```

**Issue: "Package import errors"**
```bash
# Quick fix: Clean and reinstall
flutter clean
flutter pub get
cd example
flutter pub get
```

**Issue: "Web build failing"**
```bash
# Quick fix: Enable web support
flutter config --enable-web
cd example
flutter build web --no-tree-shake-icons
```

## Conclusion

This development workflow documentation provides a comprehensive guide for contributing to and maintaining the responsive_size_builder Flutter package. The workflow emphasizes:

1. **Consistent Development Environment**: Standardized setup across all contributors
2. **Comprehensive Testing**: Multiple test types ensuring quality and reliability  
3. **Systematic Branching**: Git Flow methodology for organized development
4. **Thorough Code Review**: Quality assurance through peer review processes
5. **Automated CI/CD**: Continuous integration and deployment for efficiency
6. **Emergency Procedures**: Quick response capabilities for critical issues

The responsive_size_builder package serves the Flutter community by providing robust, flexible responsive design capabilities. Following this workflow ensures continued quality, maintainability, and reliability for developers building responsive Flutter applications.

Regular updates to this documentation should reflect changes in development practices, tooling updates, and community feedback. Contributors should treat this as a living document that evolves with the project's needs and the broader Flutter ecosystem.

For questions or suggestions about this workflow, please create issues or discussions in the project repository. The development workflow should enable contributors to focus on creating excellent responsive design tools while maintaining high standards of quality and user experience.