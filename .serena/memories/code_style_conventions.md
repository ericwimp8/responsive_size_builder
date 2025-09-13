# Code Style and Conventions

## Linting Configuration
- Uses `very_good_analysis` package (v5.1.0) as base
- Custom lint rules via `analysis_options.yaml`
- Strict type checking enabled (strict-casts, strict-inference, strict-raw-types)

## Key Style Rules

### Naming Conventions
- Classes: PascalCase (e.g., `ScreenSizeBuilder`)
- Files: snake_case (e.g., `screen_size_builder.dart`)
- Variables/methods: camelCase
- Constants: lowerCamelCase (prefer const declarations)
- Private members: Leading underscore allowed for locals

### Import Style
- ALWAYS use package imports (`package:responsive_size_builder/...`)
- Directives ordering enforced
- Relative imports avoided

### Code Organization
- Sort constructors first
- Sort child properties last
- Prefer single quotes for strings
- Require trailing commas for better formatting
- Maximum line length: 80 chars (rule disabled in config)

### Flutter-specific
- Use key in widget constructors
- Use const constructors where possible
- Prefer const literals for immutables
- Size box widgets for whitespace

### Documentation
- Public API docs not enforced (public_member_api_docs: false)
- Use /// for doc comments
- TODO comments allowed without Flutter style

### Type Safety
- Prefer final fields and locals
- Type annotate public APIs
- Avoid dynamic calls
- Omit local variable types (type inference)
- No leading underscores for library prefixes

### Best Practices
- Avoid print statements (use proper logging)
- Avoid empty else blocks
- Use async/await properly
- Handle exceptions properly (avoid catching errors)
- Prefer null-aware operators
- Use build context synchronously

## Excluded from Analysis
- build/** directory
- *.freezed.dart files
- *.g.dart files
- lib/l10n/** directory