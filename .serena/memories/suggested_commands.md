# Development Commands for responsive_size_builder

## Essential Flutter/Dart Commands

### Package Management
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter pub outdated` - Check for outdated packages

### Code Quality & Formatting
- `dart format .` or `mcp__server__dart_format` - Format all Dart code
- `dart fix --apply` or `mcp__server__dart_fix` - Apply automated fixes
- `dart analyze` or `mcp__server__analyze_files` - Run static analysis
- `flutter analyze` - Run Flutter-specific analysis

### Testing
- `flutter test` or `mcp__server__run_tests` - Run all tests
- `flutter test test/<specific_test>.dart` - Run specific test file
- `flutter test --coverage` - Run tests with coverage

### Running Examples
- `cd example && flutter run` - Run the example app
- `flutter run -d chrome` - Run in Chrome browser
- `flutter run -d macos` - Run on macOS desktop

## System Commands (macOS/Darwin)

### Git Operations
- `git status` - Check repository status
- `git add .` - Stage all changes
- `git commit -m "message"` - Commit changes
- `git push` - Push to remote
- `git diff` - View unstaged changes

### File System
- `ls -la` - List files with details
- `cd <dir>` - Change directory
- `pwd` - Print working directory
- `mkdir -p <dir>` - Create directory structure
- `rm -rf <dir>` - Remove directory recursively

### Search & Find
- `rg <pattern>` - Search with ripgrep (preferred over grep)
- `fd <pattern>` - Find files (preferred over find)
- `bat <file>` - Display file with syntax highlighting (preferred over cat)

## Build & Documentation
- `flutter pub publish --dry-run` - Test package publishing
- `flutter pub publish` - Publish package to pub.dev
- `dart doc` - Generate API documentation

## Serena-specific Commands
- Check onboarding: Use `mcp__serena-responsive__check_onboarding_performed`
- Find symbols: Use `mcp__serena-responsive__find_symbol`
- Search patterns: Use `mcp__serena-responsive__search_for_pattern`