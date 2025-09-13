# Development Workflow Documentation

A comprehensive guide for developing, testing, and maintaining the responsive_size_builder Flutter package.

## Introduction

The responsive_size_builder is a Flutter package that provides powerful tools for building responsive user interfaces. It offers breakpoint-based layout systems, responsive values, and screen size utilities to create adaptive Flutter applications across different screen sizes and orientations.

This document establishes the development workflow standards, tools, and procedures for maintaining and extending the package.

## System Requirements

### Operating System Support
- macOS 12+ (recommended for iOS development)
- Ubuntu 20.04+ / Linux distributions with snap support
- Windows 10+ with WSL2 (recommended) or native Windows

### Required Software and Minimum Versions
- **Flutter SDK**: 3.5.0 or higher
- **Dart SDK**: 3.5.0 or higher (included with Flutter)
- **Git**: 2.30.0 or higher
- **IDE**: VS Code with Flutter extension, Android Studio, or IntelliJ IDEA

### Hardware Requirements
- **RAM**: Minimum 8GB, recommended 16GB for smooth development
- **Storage**: 10GB available disk space minimum
- **Network**: Stable internet connection for pub.dev package resolution

### Development Dependencies
- **very_good_analysis**: ^5.1.0 (code quality and linting)
- **flutter_lints**: ^4.0.0 (additional Flutter-specific linting)
- **custom_lint**: For enhanced static analysis

## Installation Guide

### 1. Clone the Repository
```bash
git clone [repository-url]
cd responsive_size_builder
```

### 2. Verify Flutter Installation
```bash
flutter doctor -v
# Ensure all checkmarks are green, resolve any issues
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Verify Installation
```bash
# Run static analysis
flutter analyze

# Check formatting
dart format --set-exit-if-changed .

# Verify package structure
flutter packages pub publish --dry-run
```

### 5. IDE Setup

#### VS Code Extensions (Recommended)
- Flutter (Dart-Code.flutter)
- Dart (Dart-Code.dart-code)
- Bracket Pair Colorizer
- Error Lens

#### Android Studio/IntelliJ Plugins
- Flutter plugin
- Dart plugin

### 6. Development Environment Verification
```bash
# Verify package can be imported
dart analyze lib/responsive_size_builder.dart

# Check example compilation (if exists)
cd example && flutter build apk --debug
```

## Running the Package Locally

### Development Mode

#### Package Development
```bash
# Run static analysis with very strict rules
flutter analyze

# Format code according to project standards
dart format .

# Run custom lint checks
dart run custom_lint
```

#### Testing with Example App
```bash
# Navigate to example directory (if exists)
cd example

# Run in development mode
flutter run
# Available platforms: Chrome (--web), iOS Simulator, Android Emulator

# Hot reload enabled automatically
# Press 'r' for hot reload, 'R' for hot restart
```

#### Package Testing in External Project
```bash
# In external Flutter project, add dependency
dependencies:
  responsive_size_builder:
    path: /path/to/local/responsive_size_builder

# Then run
flutter pub get
flutter run
```

### Documentation Generation
```bash
# Generate API documentation
dart doc

# Serve documentation locally
dart doc --serve
# Opens documentation at http://localhost:8080
```

### Common Development Tasks

#### Code Formatting and Linting
```bash
# Auto-format all Dart files
dart format .

# Fix auto-fixable lint issues
dart fix --apply

# Run comprehensive analysis
flutter analyze --fatal-infos
```

#### Dependency Management
```bash
# Check for outdated dependencies
flutter pub outdated

# Update dependencies (carefully review breaking changes)
flutter pub upgrade

# Add new dependency
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name
```

#### Version Management
```bash
# Update version in pubspec.yaml
# Follow semantic versioning: MAJOR.MINOR.PATCH

# Update CHANGELOG.md with changes
# Document breaking changes, new features, bug fixes
```

## Testing Procedures

### Test Structure

The package follows Flutter testing best practices:

#### Test Types and Locations
- **Unit Tests**: `test/unit/` - Test individual functions and classes
- **Widget Tests**: `test/widget/` - Test widget behavior and rendering
- **Integration Tests**: `test/integration/` - Test complete feature workflows
- **Golden Tests**: `test/golden/` - Visual regression testing for layouts

#### Test File Naming Convention
```
test/
├── unit/
│   ├── breakpoints/
│   │   ├── breakpoints_test.dart
│   │   └── breakpoints_handler_test.dart
│   └── responsive_value/
│       └── responsive_value_test.dart
├── widget/
│   ├── layout_size_builder_test.dart
│   └── screen_size_builder_test.dart
└── integration/
    └── responsive_layout_integration_test.dart
```

### Running Tests

#### Basic Test Commands
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run specific test file
flutter test test/unit/breakpoints/breakpoints_test.dart

# Run tests matching pattern
flutter test --name "Breakpoints"

# Run tests with verbose output
flutter test --reporter expanded
```

#### Test Environment Setup
```bash
# Generate test coverage report
flutter test --coverage
lcov --summary coverage/lcov.info

# Run tests in different environments
flutter test --platform chrome
flutter test --platform vm
```

### Writing New Tests

#### Test Structure Pattern
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  group('BreakpointsTest', () {
    late Breakpoints breakpoints;
    
    setUp(() {
      breakpoints = const Breakpoints();
    });
    
    test('should have correct default values', () {
      expect(breakpoints.extraLarge, 1200.0);
      expect(breakpoints.large, 950.0);
      expect(breakpoints.medium, 600.0);
      expect(breakpoints.small, 200.0);
    });
    
    test('should maintain descending order constraint', () {
      expect(
        () => Breakpoints(
          extraLarge: 800.0,
          large: 950.0,
        ),
        throwsAssertionError,
      );
    });
  });
}
```

#### Widget Test Guidelines
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

void main() {
  testWidgets('LayoutSizeBuilder should render correct widget for screen size', 
    (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LayoutSizeBuilder(
          small: (context) => const Text('Small'),
          medium: (context) => const Text('Medium'),
          large: (context) => const Text('Large'),
        ),
      ),
    );
    
    // Test different screen sizes
    await tester.binding.setSurfaceSize(const Size(400, 600));
    await tester.pumpAndSettle();
    expect(find.text('Small'), findsOneWidget);
  });
}
```

### Test Quality Standards
- **Minimum Coverage**: 90% line coverage for all production code
- **Test Isolation**: Each test should be independent and repeatable
- **Descriptive Names**: Test names should clearly describe the expected behavior
- **Edge Cases**: Test boundary conditions and error scenarios

## Debugging Procedures

### Debugging Tools

#### Built-in Flutter Debugging
```bash
# Run with debugging enabled
flutter run --debug

# Enable verbose logging
flutter logs --verbose

# Inspect widget tree
flutter inspector
```

#### IDE Debugging Configuration

**VS Code**: Create `.vscode/launch.json`
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "responsive_size_builder",
      "request": "launch",
      "type": "dart",
      "program": "example/lib/main.dart",
      "args": [
        "--dart-define=DEBUG_RESPONSIVE_SIZE_BUILDER=true"
      ]
    }
  ]
}
```

#### Logging and Debug Output
```dart
// Use debugPrint for development debugging
debugPrint('Current breakpoint: $currentBreakpoint');

// Conditional debug output
if (kDebugMode) {
  print('ScreenSize changed: ${data.screenSize}');
}
```

### Common Issues and Solutions

#### Issue: Package Import Errors
**Symptoms:** 
- `Target of URI doesn't exist` errors
- Import resolution failures

**Solutions:**
1. Run `flutter pub get` to refresh dependencies
2. Check pubspec.yaml for correct package versions
3. Verify export statements in library files
4. Clear pub cache: `flutter pub cache repair`

#### Issue: Breakpoint Calculation Incorrect
**Symptoms:**
- Wrong layout rendered for screen size
- Responsive values not switching at expected points

**Solutions:**
1. Verify breakpoint values are in descending order
2. Check MediaQuery.of(context).size.width values
3. Debug with print statements in breakpoint handlers
4. Test with Flutter Inspector's device simulation

#### Issue: Hot Reload Not Working
**Symptoms:**
- Changes not reflected after hot reload
- Need to do full restart frequently

**Solutions:**
1. Check for syntax errors preventing hot reload
2. Verify StatefulWidget state management
3. Use hot restart (Shift+R) for structural changes
4. Check console for hot reload failures

#### Issue: Analysis/Lint Errors
**Symptoms:**
- flutter analyze shows errors
- CI pipeline failing on code quality

**Solutions:**
1. Run `dart fix --apply` for auto-fixable issues
2. Review analysis_options.yaml configuration
3. Update to latest very_good_analysis version
4. Check for deprecated API usage

### Debug Mode Configuration

#### Enable Comprehensive Debugging
```bash
# Run with all debugging flags
flutter run \
  --debug \
  --verbose \
  --enable-software-rendering \
  --dart-define=DEBUG_RESPONSIVE_SIZE_BUILDER=true
```

#### Performance Profiling
```bash
# Profile performance
flutter run --profile --trace-startup

# Memory profiling
flutter run --debug --dump-skp-on-shader-compilation
```

## Branching Strategy

### Git Flow Branch Structure

#### Main Branches
- **main** - Production-ready, published package versions
- **develop** - Integration branch for new features and improvements

#### Supporting Branches
- **feature/** - New features and enhancements
- **bugfix/** - Bug fixes that don't require immediate release
- **hotfix/** - Critical fixes that need immediate release
- **release/** - Release preparation and version bumping

### Branch Naming Convention
```
feature/responsive-value-orientation-support
bugfix/breakpoint-calculation-edge-case
hotfix/critical-memory-leak-fix
release/v1.2.0-preparation
```

### Branch Lifecycle

#### 1. Feature Development
```bash
# Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/new-granular-breakpoints

# Development work...
git add .
git commit -m "feat: add support for more granular breakpoints"

# Push and create PR
git push -u origin feature/new-granular-breakpoints
```

#### 2. Release Process
```bash
# Create release branch from develop
git checkout develop
git checkout -b release/v1.2.0

# Update version in pubspec.yaml
# Update CHANGELOG.md
# Run final tests

git commit -m "chore: bump version to 1.2.0"
git push -u origin release/v1.2.0

# After approval, merge to main and develop
git checkout main
git merge release/v1.2.0
git tag v1.2.0
git push origin main --tags

git checkout develop
git merge release/v1.2.0
git push origin develop
```

#### 3. Hotfix Process
```bash
# Create hotfix from main
git checkout main
git checkout -b hotfix/critical-bug-fix

# Fix the issue
git commit -m "fix: resolve critical breakpoint calculation bug"

# Merge to both main and develop
git checkout main
git merge hotfix/critical-bug-fix
git tag v1.1.1
git push origin main --tags

git checkout develop
git merge hotfix/critical-bug-fix
git push origin develop
```

### Branch Protection Rules
- **main**: Requires PR review, all checks must pass, no force push
- **develop**: Requires PR review, allows admins to bypass
- All branches: Require up-to-date status before merge

## Code Review Process

### Pull Request Guidelines

#### PR Title Format
```
type(scope): description

Examples:
feat(breakpoints): add support for custom breakpoint names
fix(responsive-value): resolve null safety issue in value calculation  
docs(readme): update usage examples and API documentation
test(widget): add comprehensive tests for ScreenSizeBuilder
```

#### PR Description Template
```markdown
## Description
Brief description of the changes and their purpose.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that causes existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No breaking changes without proper migration guide
- [ ] Performance impact considered
```

### Review Standards

#### Code Quality Checklist

**Functionality**
- [ ] Code fulfills the requirements completely
- [ ] Edge cases and error conditions handled
- [ ] No regression in existing functionality
- [ ] Performance impact is acceptable

**Code Style**
- [ ] Follows Flutter/Dart style guide
- [ ] Consistent with existing codebase patterns
- [ ] No code duplication or copy-paste programming
- [ ] Clear, descriptive variable and function names
- [ ] Appropriate comments for complex logic

**Testing**
- [ ] Unit tests cover new functionality
- [ ] Widget tests verify UI behavior
- [ ] All tests pass locally and in CI
- [ ] Test coverage maintained or improved
- [ ] Tests are maintainable and clear

**Documentation**
- [ ] Public APIs documented with dartdoc comments
- [ ] README updated if public interface changed
- [ ] Examples updated for new features
- [ ] Breaking changes documented in CHANGELOG

### Review Workflow

#### Review Process
1. **Self Review**: Author reviews their own PR before requesting review
2. **Automated Checks**: CI pipeline runs analysis, tests, and formatting checks
3. **Peer Review**: At least one team member reviews the code
4. **Address Feedback**: Author addresses review comments and re-requests review
5. **Approval**: PR approved by required number of reviewers
6. **Merge**: Author or reviewer merges using appropriate strategy

#### Reviewer Responsibilities
- Review within 24 hours of request
- Provide constructive, specific feedback
- Test functionality when reviewing complex changes
- Approve only when confident in code quality
- Suggest improvements, not just identify problems

#### Handling Review Feedback
- Respond to all comments, even if no changes made
- Ask for clarification when feedback is unclear
- Make requested changes or provide reasoning for alternatives
- Mark conversations as resolved after addressing
- Thank reviewers for their time and insights

## Deployment Pipeline

### Package Publishing Environments

#### Development/Testing
- **Purpose**: Internal testing and validation
- **Trigger**: Manual testing with local path dependency
- **Validation**: All tests pass, documentation builds
- **Access**: Development team only

#### Staging (Pre-release)
- **Purpose**: Beta testing and final validation
- **URL**: pub.dev with prerelease version (e.g., 1.2.0-beta.1)  
- **Trigger**: Release branch creation
- **Validation**: Comprehensive testing, community feedback
- **Access**: Beta testers and community

#### Production
- **Purpose**: Public release on pub.dev
- **URL**: pub.dev with stable version
- **Trigger**: Manual approval after staging validation
- **Validation**: Full test suite, documentation review, breaking change analysis

### Publishing Process

#### Pre-Publication Checklist
```bash
# 1. Version validation
grep version pubspec.yaml
# Ensure version follows semantic versioning

# 2. Documentation check  
dart doc --validate-links

# 3. Package analysis
flutter packages pub publish --dry-run

# 4. Dependency check
flutter pub deps

# 5. Test everything
flutter test --coverage
```

#### Publishing Steps
```bash
# 1. Final validation
flutter packages pub publish --dry-run

# 2. Publish to pub.dev
flutter packages pub publish

# 3. Verify publication
flutter pub info responsive_size_builder

# 4. Tag release
git tag v1.2.0
git push origin --tags

# 5. Create GitHub release with changelog
```

### Post-Deployment Verification

#### Publication Verification
- Package appears correctly on pub.dev
- Documentation generates properly  
- Examples work with published version
- Dependent packages can resolve and use new version

#### Rollback Procedures
```bash
# If critical issue found post-publication:

# 1. Identify problematic version
flutter pub info responsive_size_builder

# 2. Mark version as retracted (pub.dev)
# Login to pub.dev and mark version as retracted

# 3. Publish hotfix version immediately
# Follow hotfix process to publish corrected version

# 4. Notify community
# Update GitHub releases and pub.dev changelog
```

## CI/CD Setup

### Continuous Integration Pipeline

#### GitHub Actions Configuration (.github/workflows/ci.yml)
```yaml
name: CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.5.0'
      - name: Install dependencies
        run: flutter pub get
      - name: Verify formatting
        run: dart format --set-exit-if-changed .
      - name: Analyze project source
        run: flutter analyze --fatal-infos
      - name: Run custom lint
        run: dart run custom_lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.5.0'
      - name: Install dependencies
        run: flutter pub get
      - name: Run tests
        run: flutter test --coverage
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

  package-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.5.0'
      - name: Install dependencies
        run: flutter pub get
      - name: Check package
        run: flutter packages pub publish --dry-run
```

### Quality Gates

#### Required Checks for PR Merge
1. **Static Analysis**: All analyzer warnings resolved
2. **Formatting**: Code formatted according to Dart style guide  
3. **Tests**: All tests pass with minimum 90% coverage
4. **Package Validation**: dry-run publish succeeds
5. **Documentation**: dartdoc generation succeeds without errors

#### Performance Benchmarks
```yaml
# .github/workflows/benchmarks.yml
name: Performance Benchmarks

on:
  pull_request:
    branches: [ main ]

jobs:
  benchmark:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - name: Run benchmarks
        run: |
          cd benchmarks
          flutter test --reporter json > results.json
      - name: Compare results
        run: dart run benchmark_comparison.dart
```

### Pipeline Maintenance

#### Updating Dependencies
```bash
# Update Flutter version in CI
# .github/workflows/*.yml
flutter-version: '3.7.0'  # Update to latest stable

# Update analysis rules
# pubspec.yaml
very_good_analysis: ^5.2.0  # Update to latest version
```

#### Adding New Pipeline Stages
```bash
# Security scanning
- name: Security audit
  run: dart pub audit

# Documentation deployment  
- name: Deploy docs
  if: github.ref == 'refs/heads/main'
  run: |
    dart doc
    # Deploy to GitHub Pages or documentation hosting
```

## Quick Reference Guides

### Daily Development Commands

#### Essential Commands
```bash
# Start development
flutter pub get              # Install/update dependencies
flutter analyze             # Static analysis
dart format .               # Format code
flutter test               # Run tests

# Package development
dart doc                   # Generate documentation
flutter packages pub publish --dry-run  # Validate package

# Quality checks
dart fix --apply           # Auto-fix issues
flutter test --coverage   # Test with coverage
```

#### Git Workflow
```bash
# Feature development
git checkout develop
git pull origin develop
git checkout -b feature/my-feature
# ... development work ...
git commit -m "feat: add new feature"
git push -u origin feature/my-feature

# Release preparation
git checkout -b release/v1.2.0
# Update version, changelog
git commit -m "chore: prepare v1.2.0 release"
```

### Troubleshooting Quick Fixes

#### Package Resolution Issues
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

#### Analysis Issues
```bash
dart fix --apply            # Auto-fix lint issues
dart format .              # Fix formatting
flutter analyze --fatal-infos  # Check remaining issues
```

#### Test Failures
```bash
flutter test --reporter expanded  # Verbose test output
flutter test test/specific_test.dart  # Run specific test
flutter test --name "test pattern"   # Run matching tests
```

### Emergency Procedures

#### Critical Bug in Published Version
1. **Immediate Response**
   ```bash
   # Create hotfix branch
   git checkout main
   git checkout -b hotfix/critical-fix
   
   # Fix the issue
   # Update tests
   # Bump patch version
   ```

2. **Expedited Release**
   ```bash
   # Skip normal review process for critical fixes
   git checkout main
   git merge hotfix/critical-fix
   flutter packages pub publish
   git tag v1.1.1
   ```

3. **Communication**
   - Update GitHub release with fix details
   - Post in relevant community channels
   - Consider retracting problematic version on pub.dev

#### Package Publishing Failures
```bash
# Check pub.dev status
curl -I https://pub.dev

# Verify credentials
flutter packages pub token

# Retry with verbose output
flutter packages pub publish --verbose

# Alternative: Publish from different environment
```

### Contact Information

#### Development Team
- **Lead Developer**: [Contact information]
- **Code Review Team**: [Contact information]  
- **Release Management**: [Contact information]

#### Community Channels
- **GitHub Issues**: Primary support channel
- **Flutter Community**: Discord/Slack channels
- **Package Documentation**: pub.dev package page

## Documentation Maintenance

### Documentation Standards

#### Update Requirements
- All public API changes must be documented
- Breaking changes require migration guide
- New features need usage examples
- Version changes require CHANGELOG.md update

#### Review Schedule
- **Monthly**: Review documentation accuracy
- **Pre-release**: Comprehensive documentation review
- **Post-release**: Community feedback incorporation
- **Quarterly**: Documentation structure and navigation review

### Feedback Loop

#### Documentation Improvement Process
1. **Issue Reporting**: GitHub issues for documentation problems
2. **Community Input**: Regular feedback collection from users
3. **Analytics Review**: Monitor documentation usage patterns  
4. **Continuous Updates**: Incorporate improvements into regular releases

#### Quality Metrics
- Documentation coverage for all public APIs
- User feedback sentiment analysis
- Support ticket volume related to documentation gaps
- Community contribution frequency

---

*This development workflow documentation should serve as the authoritative guide for all development activities on the responsive_size_builder package. Regular updates ensure it remains current and valuable to all contributors.*