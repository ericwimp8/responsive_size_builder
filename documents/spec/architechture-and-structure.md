# Responsive Size Builder Architecture Documentation

## Overview
The `responsive_size_builder` is a Flutter package that provides comprehensive tools for creating responsive user interfaces that adapt to different screen sizes and breakpoints. The package offers both simple and granular breakpoint systems, along with various builder widgets to handle different responsive design scenarios.

## Architecture Style
- **Pattern**: Component-based architecture with layered design following Flutter's widget composition model
- **Key Technologies**: 
  - Dart 3.5.0+
  - Flutter 1.17.0+
  - InheritedModel for efficient state propagation
  - MediaQuery for screen dimension access
  - LayoutBuilder for constraint-based responsive design

## Directory Structure
```
/responsive_size_builder
  /lib
    /src
      /core                    - Core breakpoint logic and utilities
        /breakpoints          - Breakpoint definitions and handlers
        overlay_position_utils.dart - Overlay positioning utilities
        utilities.dart        - Platform detection constants
      /layout_constraints     - BoxConstraints management
      /layout_size           - Layout-focused responsive builders  
      /responsive_value      - Value-based responsive design
      /screen_size          - Screen size detection and builders
      /value_size           - Value-oriented size builders
    responsive_size_builder.dart - Main library export file
  /example                  - Demo application with usage examples
  /test                     - Unit and widget tests
  /documents               - Project documentation
```

## Component Overview

### Core Components

#### 1. Breakpoints System
- **Location**: `/lib/src/core/breakpoints/`
- **Responsibility**: Define screen size thresholds and categorization logic
- **Key Functions**:
  - BaseBreakpoints<T> - Abstract breakpoint interface
  - Breakpoints - Standard 5-tier system (extraSmall, small, medium, large, extraLarge)
  - BreakpointsGranular - Comprehensive 13-tier system with jumbo, standard, compact, tiny categories
  - LayoutSize/LayoutSizeGranular enums - Size category definitions
- **Dependencies**: None (foundational component)

#### 2. Breakpoint Handlers
- **Location**: `/lib/src/core/breakpoints/breakpoints_handler.dart`
- **Responsibility**: Execute breakpoint resolution logic with fallback mechanisms
- **Key Functions**:
  - BaseBreakpointsHandler<T, K> - Abstract handler interface
  - BreakpointsHandler<T> - Standard 5-tier handler
  - BreakpointsHandlerGranular<T> - Granular 13-tier handler
- **Dependencies**: Core breakpoints, utilities

#### 3. Screen Size Data Management
- **Location**: `/lib/src/screen_size/screen_size_data.dart`
- **Responsibility**: Collect, process, and distribute screen size information
- **Key Functions**:
  - ScreenSize<T> - Root widget that monitors screen dimensions
  - ScreenSizeModel<T> - InheritedModel for efficient data propagation
  - ScreenSizeModelData<K> - Immutable data container with comprehensive metrics
- **Dependencies**: Core breakpoints, Flutter's MediaQuery

### Builder Components

#### 4. Screen Size Builders
- **Location**: `/lib/src/screen_size/`
- **Responsibility**: Widget builders that adapt to screen size changes
- **Key Functions**:
  - ScreenSizeBuilder - Basic responsive builder
  - ScreenSizeOrientationBuilder - Orientation-aware builder
  - ScreenSizeBuilderGranular - Fine-grained breakpoint control
- **Dependencies**: Screen size data, breakpoint handlers

#### 5. Layout Size Builders
- **Location**: `/lib/src/layout_size/`
- **Responsibility**: Layout-focused responsive builders using BoxConstraints
- **Key Functions**:
  - LayoutSizeBuilder - Constraint-based responsive building
  - LayoutSizeBuilderGranular - Granular constraint-based building
- **Dependencies**: Layout constraints providers, breakpoint handlers

#### 6. Value Size Builders
- **Location**: `/lib/src/value_size/`
- **Responsibility**: Value-based responsive design for non-widget responses
- **Key Functions**:
  - ValueSizeBuilder<T> - Returns typed values based on screen size
  - ValueSizeBuilderGranular<T> - Granular value-based building
- **Dependencies**: Screen size data, breakpoint handlers

#### 7. Responsive Value System
- **Location**: `/lib/src/responsive_value/`
- **Responsibility**: Advanced value-based responsive design with screen size integration
- **Key Functions**:
  - ResponsiveValue<T> - Value container with breakpoint mapping
  - ScreenSizeWithValue<T> - Screen size data with value integration
  - Multiple specialized builders for different scenarios
- **Dependencies**: Screen size data, breakpoint system

### Utility Components

#### 8. Layout Constraints Providers
- **Location**: `/lib/src/layout_constraints/`
- **Responsibility**: BoxConstraints management and access in responsive context
- **Key Functions**:
  - LayoutConstraintsProviderBase<T> - Abstract constraint provider
  - LayoutConstraintsWrapper - Constraint wrapping utilities
- **Dependencies**: Flutter's LayoutBuilder, breakpoint handlers

#### 9. Platform Utilities
- **Location**: `/lib/src/core/utilities.dart`
- **Responsibility**: Platform detection and device type identification
- **Key Functions**:
  - kIsDesktopDevice - Desktop platform detection
  - kIsTouchDevice - Touch device detection
- **Dependencies**: Flutter foundation

#### 10. Overlay Positioning
- **Location**: `/lib/src/core/overlay_position_utils.dart`
- **Responsibility**: Utilities for responsive overlay positioning
- **Dependencies**: Core breakpoint system

## Component Interactions

### Primary Data Flow
```
ScreenSize<T> Widget
    ↓
MediaQuery/View Data → ScreenSizeModel<T> → ScreenSizeModelData<T>
    ↓                                           ↓
Breakpoint Resolution                    Builder Components
    ↓                                           ↓
BreakpointsHandler<T>                     Widget Tree
    ↓
Value/Widget Selection
```

### Interaction Matrix

| Component | Calls | Called By | Communication Method |
|-----------|-------|-----------|---------------------|
| ScreenSize<T> | MediaQuery, BreakpointHandlers | Application Root | Widget composition |
| ScreenSizeModel<T> | InheritedModel system | Builder widgets | InheritedModel |
| BreakpointsHandler | Breakpoints configuration | All builders | Direct method calls |
| Builder widgets | ScreenSizeModel.of() | Application widgets | InheritedModel access |
| Responsive values | Breakpoint resolution | Builder widgets | Configuration objects |

### Dependency Rules
- Core components have no dependencies on builders
- Builders depend on core components and data models
- Utilities are standalone and can be used independently
- All components follow Flutter's widget composition patterns
- No circular dependencies between layers

## Architectural Patterns

### 1. Layered Architecture
**Implementation Details:**
- **Core Layer**: Fundamental breakpoint logic and data structures
- **Model Layer**: Data management with InheritedModel pattern
- **Builder Layer**: Widget construction with responsive logic
- **Utility Layer**: Platform-specific helpers and positioning tools

**Benefits:**
- Clear separation of concerns
- Testable individual components
- Reusable core logic across different builder types

### 2. Strategy Pattern
**Implementation Details:**
- BaseBreakpointsHandler<T, K> defines the strategy interface
- BreakpointsHandler and BreakpointsHandlerGranular provide specific implementations
- Runtime strategy selection based on breakpoint system choice

**Benefits:**
- Swappable breakpoint systems
- Consistent API across different complexity levels
- Easy extension for custom breakpoint strategies

### 3. Observer Pattern (via InheritedModel)
**Implementation Details:**
- ScreenSizeModel<T> extends InheritedModel<ScreenSizeAspect>
- Widgets register dependencies on specific data aspects
- Automatic rebuilds only when relevant data changes

**Benefits:**
- Efficient widget rebuilds
- Granular dependency tracking
- Optimal performance for responsive UIs

### 4. Builder Pattern
**Implementation Details:**
- Multiple builder widgets with consistent API patterns
- Type-safe builder functions: `(BuildContext, ScreenSizeModelData<T>) -> Widget`
- Fallback resolution when specific builders aren't provided

**Benefits:**
- Flexible responsive UI construction
- Type safety for different responsive scenarios
- Consistent developer experience

### 5. Template Method Pattern
**Implementation Details:**
- BaseBreakpointsHandler defines the algorithm skeleton
- Concrete handlers implement specific value resolution
- Common fallback logic shared across implementations

**Benefits:**
- Code reuse for common breakpoint logic
- Consistent behavior across different breakpoint systems
- Easy maintenance of core algorithms

## Code Organization Conventions

### File Naming
- **Pattern**: snake_case for files, PascalCase for classes
- **Test files**: `*_test.dart` in `/test` directory
- **Example files**: descriptive names in `/example/lib/pages/`

### Code Location Guide
| Code Type | Location | Example |
|-----------|----------|---------|
| Core Logic | `/lib/src/core/` | `breakpoints.dart`, `utilities.dart` |
| Data Models | `/lib/src/*/` | `screen_size_data.dart` |
| Builder Widgets | `/lib/src/*/` | `screen_size_builder.dart` |
| Abstract Interfaces | `/lib/src/core/` | `base_breakpoints_handler.dart` |
| Platform Utilities | `/lib/src/core/` | `utilities.dart` |
| Examples | `/example/lib/pages/` | `screen_size_builder_example.dart` |

### Import Conventions
- Package imports use full package path: `package:responsive_size_builder/responsive_size_builder.dart`
- Internal imports use relative paths within the same module
- Flutter framework imports grouped separately
- Dart core imports listed first

### Documentation Standards
- Comprehensive dartdoc comments for all public APIs
- Usage examples in class-level documentation
- Parameter documentation with types and constraints
- Cross-references between related classes

## Module Boundaries and Responsibilities

### Strict Boundaries
- **Core → Builders**: Core provides interfaces, builders implement behavior
- **Data → UI**: Data models are immutable, UI components consume data
- **Platform → Logic**: Platform utilities are isolated from business logic

### Shared Responsibilities
- **Error Handling**: Assertion-based validation in constructors
- **Type Safety**: Generic type parameters for breakpoint system flexibility
- **Performance**: Caching and efficient InheritedModel usage

### Integration Points
- **ScreenSizeModel**: Central integration point for all builder components
- **BaseBreakpoints**: Interface contract for all breakpoint systems
- **BreakpointsHandler**: Resolution logic shared across builders

## Architectural Decisions

### ADR-001: InheritedModel for State Propagation
- **Date**: Project inception
- **Status**: Accepted
- **Context**: Need efficient way to propagate screen size data to multiple widgets
- **Decision**: Use InheritedModel with aspect-based dependency tracking
- **Consequences**: 
  - Optimal performance with granular rebuilds
  - Complex implementation but excellent Flutter integration
  - Standard Flutter pattern for state distribution

### ADR-002: Generic Type System for Breakpoints
- **Date**: Project inception  
- **Status**: Accepted
- **Context**: Support both simple and granular breakpoint systems
- **Decision**: Use generic type parameters constrained to Enum
- **Consequences**:
  - Type safety across different breakpoint systems
  - Compile-time verification of breakpoint usage
  - Some complexity in API but better developer experience

### ADR-003: Fallback Resolution Strategy
- **Date**: Early development
- **Status**: Accepted
- **Context**: Handle cases where not all breakpoints have assigned values
- **Decision**: Implement systematic fallback from larger to smaller breakpoints
- **Consequences**:
  - Robust behavior with partial configurations
  - Predictable fallback patterns
  - Reduced configuration burden for simple use cases

### ADR-004: Separation of Builder Types
- **Date**: Feature expansion
- **Status**: Accepted
- **Context**: Different responsive scenarios need different builder approaches
- **Decision**: Create specialized builder widgets for different use cases
- **Consequences**:
  - Clear API boundaries for different scenarios
  - Some code duplication but better usability
  - Easier to optimize each builder type independently

## Getting Started
Quick guide for developers to understand the architecture:

1. **Start with ScreenSize<T>**: Wrap your app to enable responsive features
2. **Choose breakpoint system**: Use LayoutSize for simple (5 categories) or LayoutSizeGranular for complex (13 categories)
3. **Select appropriate builder**: Pick builder widget based on your responsive needs (widgets vs values, orientation awareness, etc.)
4. **Configure breakpoints**: Use default breakpoints or customize for your design requirements
5. **Implement fallback strategy**: Ensure at least one breakpoint category has a value defined

### Key Conventions to Follow
- Always wrap apps with ScreenSize<T> before using builders
- Match type parameters between ScreenSize<T> and builder widgets
- Provide fallback values to prevent runtime errors
- Use aspect-based dependencies with ScreenSizeModel.screenSizeOf() for performance
- Follow the layered architecture - don't skip abstraction layers

## Maintenance
- **Owner**: Package maintainer team
- **Last Updated**: 2025-01-15
- **Review Schedule**: Quarterly architecture reviews, updates with major feature additions

---

This architecture documentation provides developers with a comprehensive understanding of the responsive_size_builder package structure, enabling effective development and maintenance of responsive Flutter applications. The modular design ensures scalability while maintaining simplicity for common use cases.