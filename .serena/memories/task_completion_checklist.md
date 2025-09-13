# Task Completion Checklist

When completing any development task in the responsive_size_builder project, follow this checklist:

## 1. Code Quality Checks
- [ ] Run `dart format .` or use `mcp__server__dart_format` to format code
- [ ] Run `dart analyze` or use `mcp__server__analyze_files` to check for issues
- [ ] Run `dart fix --apply` or use `mcp__server__dart_fix` to apply automated fixes
- [ ] Ensure no linting errors remain

## 2. Testing
- [ ] Run `flutter test` or use `mcp__server__run_tests` to ensure all tests pass
- [ ] Add/update tests for new functionality
- [ ] Check test coverage if significant changes made

## 3. Documentation
- [ ] Update inline documentation for public APIs
- [ ] Update README.md if adding new features
- [ ] Add examples if introducing new widgets/utilities

## 4. Verification
- [ ] Test example app with changes: `cd example && flutter run`
- [ ] Verify responsive behavior across different screen sizes
- [ ] Check both portrait and landscape orientations

## 5. Git Workflow
- [ ] Review changes with `git diff`
- [ ] Stage changes with `git add`
- [ ] Commit with descriptive message
- [ ] Ensure commit follows project conventions

## 6. Final Checks
- [ ] Verify imports use package format
- [ ] Check for any debug print statements
- [ ] Ensure const constructors used where possible
- [ ] Confirm trailing commas added for better formatting

## Common Issues to Watch For
- Unnecessary library directives (remove if flagged)
- Import ordering (should be alphabetical)
- Missing const keywords
- Public members without documentation (if required)

## MCP Tools Available
- `mcp__server__analyze_files` - Full project analysis
- `mcp__server__dart_format` - Format all Dart files
- `mcp__server__dart_fix` - Apply automated fixes
- `mcp__server__run_tests` - Run test suite
- `mcp__serena-responsive__find_symbol` - Find code symbols
- `mcp__serena-responsive__search_for_pattern` - Search codebase