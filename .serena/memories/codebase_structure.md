# Codebase Structure

## Root Structure
```
responsive_size_builder/
├── lib/                    # Main package source code
├── test/                   # Unit tests
├── example/                # Example Flutter application
├── documents/              # Project documentation
├── .serena/               # Serena configuration and cache
├── .claude/               # Claude Code configuration
└── .vscode/               # VS Code settings

```

## Library Structure (lib/)
```
lib/
├── responsive_size_builder.dart    # Main export file
├── todo.dart                       # TODO items file
└── src/                           # Source implementation
    ├── core/                      # Core utilities
    │   ├── breakpoints/          # Breakpoint handling
    │   ├── overlay_position_utils.dart
    │   └── utilities.dart
    ├── screen_size/              # Screen size detection widgets
    │   ├── screen_size_builder.dart
    │   ├── screen_size_builder_granular.dart
    │   ├── screen_size_orientation_builder.dart
    │   └── screen_size_data.dart
    ├── value_size/               # Value-based size builders
    │   ├── value_size_builder.dart
    │   └── value_size_builder_granular.dart
    ├── value_size_with_value_builder/  # Combined value builders
    │   ├── value_size_with_value_builder.dart
    │   └── value_size_with_value_builder_granular.dart
    ├── responsive_value/         # Responsive value selection
    │   ├── responsive_value.dart
    │   ├── screen_size_with_value.dart
    │   ├── screen_size_with_value_builder.dart
    │   ├── screen_size_with_value_granular_builder.dart
    │   └── screen_size_with_value_orientation_builder.dart
    ├── layout_constraints/       # Layout constraint handling
    │   ├── layout_constraints_wrapper.dart
    │   └── layout_constraints_provider_base.dart
    └── layout_size/             # Layout size builders
        ├── layout_size_builder.dart
        └── layout_size_granular_builder.dart
```

## Main Components

### Breakpoints System
- `BaseBreakpointsHandler`: Abstract base for breakpoint handling
- `BreakpointsHandler`: Standard breakpoint implementation
- `BreakpointsHandlerGranular`: Granular breakpoint control
- `Breakpoints`: Breakpoint definitions

### Builder Widgets
- **ScreenSizeBuilder**: Builds UI based on screen size categories
- **ValueSizeBuilder**: Selects values based on size
- **LayoutSizeBuilder**: Responds to layout constraints
- **ResponsiveValue**: Provides responsive value selection
- **OrientationBuilder variants**: Handle portrait/landscape

### Utilities
- **OverlayPositionUtils**: Positioning overlays responsively
- **Utilities**: General helper functions
- **ScreenSizeData**: Screen size information container

## Export Strategy
All public APIs are exported through the main `responsive_size_builder.dart` file, providing a clean and organized public interface.