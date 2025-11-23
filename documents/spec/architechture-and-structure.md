# Responsive Size Builder Architecture Documentation

## Overview

The **Responsive Size Builder** is a Flutter package designed to simplify responsive design by providing a robust, type-safe breakpoint system for adapting UI layouts and values based on screen size and layout constraints. The package follows a modular, widget-based architecture that integrates seamlessly with Flutter's widget tree and build system.

## Architecture Style

- **Pattern**: Widget-based Responsive Framework with Abstract Type System
- **Key Technologies**: 
  - Dart 3.5.0+
  - Flutter 1.17.0+
  - Generic type constraints and enums
  - InheritedModel pattern for efficient rebuilds
  - LayoutBuilder integration for constraint-based responses

## Directory Structure

```
/lib
  /src
    /core
      /breakpoints        - Core breakpoint definitions and handling logic
      overlay_position_utils.dart - Utility for overlay positioning
      utilities.dart      - Platform detection utilities
    /layout_constraints   - Layout constraint providers and wrappers
    /layout_size         - Layout-based responsive builders
    /responsive_value    - Responsive value containers and builders
    /screen_size         - Screen size detection and builders
    /value_size          - Value-based size builders  
    /value_size_with_value_builder - Combined value and size builders
  responsive_size_builder.dart - Main library export file
```

## Component Overview

### Component 1: Core Breakpoints System
- **Location**: `/src/core/breakpoints/`
- **Responsibility**: Defines breakpoint configurations and handles breakpoint resolution logic
- **Key Functions**:
  - Abstract breakpoint definitions (`BaseBreakpoints<T>`)
  - Standard breakpoints (extraLarge, large, medium, small, extraSmall)
  - Granular breakpoints (13 size categories from tiny to jumboExtraLarge)
  - Breakpoint resolution algorithm with fallback mechanism
- **Dependencies**: Flutter foundation, enum types

### Component 2: Screen Size Detection
- **Location**: `/src/screen_size/`
- **Responsibility**: Provides screen size detection and data management through InheritedModel
- **Key Functions**:
  - Screen size calculation from MediaQuery
  - Physical and logical dimension tracking
  - Orientation detection
  - Platform-aware device type detection
  - Efficient widget tree updates via InheritedModel
- **Dependencies**: Core breakpoints, Flutter MediaQuery

### Component 3: Layout Constraint System
- **Location**: `/src/layout_constraints/`
- **Responsibility**: Manages layout constraints for widget-level responsive behavior
- **Key Functions**:
  - Constraint-based breakpoint resolution
  - Layout constraint inheritance
  - Wrapper widgets for constraint propagation
- **Dependencies**: Core breakpoints, Flutter LayoutBuilder

### Component 4: Responsive Value Containers
- **Location**: `/src/responsive_value/`
- **Responsibility**: Type-safe containers for responsive values with automatic breakpoint resolution
- **Key Functions**:
  - Generic value containers (`ResponsiveValue<V>`, `ResponsiveValueGranular<V>`)
  - Automatic value selection based on current breakpoint
  - Type-safe value retrieval with fallback mechanism
- **Dependencies**: Core breakpoints system

### Component 5: Builder Widgets
- **Locations**: `/src/layout_size/`, `/src/screen_size/`, `/src/value_size/`
- **Responsibility**: Flutter widgets that rebuild UI based on responsive conditions
- **Key Functions**:
  - Screen size-based builders
  - Layout constraint-based builders
  - Value-responsive builders with type safety
  - Optional animation support for size transitions
- **Dependencies**: All core systems, Flutter StatefulWidget

## Component Interactions

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  MediaQuery     │───▶│  ScreenSize     │───▶│  Builder        │
│  LayoutBuilder  │    │  Detection      │    │  Widgets        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                        │
                              ▼                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Breakpoints    │◀───│  Breakpoint     │───▶│  Responsive     │
│  Configuration  │    │  Handler        │    │  Values         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

**Communication Pattern**: 
- **Data Flow**: MediaQuery/LayoutBuilder → Size Detection → Breakpoint Resolution → Value Selection → Widget Building
- **Update Mechanism**: InheritedModel efficiently propagates only relevant changes to dependent widgets
- **Type Safety**: Generic type system ensures compile-time validation of breakpoint configurations

## Code Organization Conventions

### File Naming
- **Pattern**: snake_case for all files
- **Builder Files**: `*_builder.dart` for widget builders
- **Data Files**: `*_data.dart` for data models
- **Granular Variants**: `*_granular.dart` for 13-breakpoint implementations

### Code Location Guide

| Code Type | Location | Example |
|-----------|----------|---------|
| Breakpoint Definitions | `/src/core/breakpoints/` | `breakpoints.dart` |
| Size Detection Logic | `/src/screen_size/` | `screen_size_data.dart` |
| Builder Widgets | `/src/*/` | `screen_size_builder.dart` |
| Responsive Values | `/src/responsive_value/` | `responsive_value.dart` |
| Layout Constraints | `/src/layout_constraints/` | `layout_constraints_wrapper.dart` |
| Utility Functions | `/src/core/` | `utilities.dart` |
| Type Definitions | `*_builder.dart` files | `ScreenSizeWidgetBuilder` |
| Library Exports | Root `/lib/` | `responsive_size_builder.dart` |

### Architecture Patterns

#### Pattern 1: Abstract Type System
- **Implementation**: Uses generic enums (`LayoutSize`, `LayoutSizeGranular`) to provide type-safe breakpoint definitions
- **Benefits**: Compile-time validation, extensible breakpoint systems
- **Example**: `BaseBreakpoints<T extends Enum>` allows custom breakpoint enums

#### Pattern 2: Fallback Resolution Algorithm
- **Implementation**: Smart fallback mechanism in `BaseBreakpointsHandler.getScreenSizeValue()`
- **Logic**:
  1. Check exact breakpoint match
  2. Search larger breakpoints for defined values
  3. Fall back to any defined value
- **Benefits**: Graceful degradation, fewer required definitions

#### Pattern 3: InheritedModel Integration
- **Implementation**: `ScreenSizeModel<T>` extends `InheritedModel<ScreenSizeAspect>`
- **Benefits**: Efficient rebuilds only when relevant data changes
- **Aspects**: `screenSize` (for size changes) and `other` (for all data changes)

## Architectural Decisions

### ADR-001: Dual Breakpoint System
- **Date**: Package Creation
- **Status**: Accepted
- **Context**: Need to support both simple and granular responsive design requirements
- **Decision**: Implement two breakpoint systems - standard 5-point and granular 13-point
- **Consequences**: 
  - **Positive**: Flexibility for different use cases, progressive complexity
  - **Negative**: Code duplication, learning curve for granular system

### ADR-002: Generic Type System for Breakpoints
- **Date**: Package Creation  
- **Status**: Accepted
- **Context**: Ensure type safety and extensibility for breakpoint definitions
- **Decision**: Use generic enums with `BaseBreakpoints<T extends Enum>` pattern
- **Consequences**:
  - **Positive**: Type safety, custom breakpoint support, clear API contracts
  - **Negative**: More complex type signatures, generic constraints

### ADR-003: InheritedModel for State Management
- **Date**: Package Creation
- **Status**: Accepted
- **Context**: Efficiently propagate screen size changes without excessive rebuilds
- **Decision**: Use `InheritedModel` with aspect-based dependencies
- **Consequences**:
  - **Positive**: Optimal rebuild performance, Flutter best practices
  - **Negative**: Complexity in dependency management

### ADR-004: Widget-Based Builder Pattern
- **Date**: Package Creation
- **Status**: Accepted
- **Context**: Integrate responsive behavior naturally with Flutter's widget system
- **Decision**: Implement builders as StatefulWidgets with declarative breakpoint definitions
- **Consequences**:
  - **Positive**: Natural Flutter integration, declarative API, hot reload support
  - **Negative**: Widget tree depth, potential performance considerations

## Module Boundaries and Responsibilities

### Core Module (`/src/core/`)
- **Boundary**: Contains only fundamental abstractions and utilities
- **Restrictions**: No UI dependencies, no specific implementation details
- **Shared Code**: `BaseBreakpoints`, `BaseBreakpointsHandler`, platform detection

### Screen Size Module (`/src/screen_size/`)
- **Boundary**: Screen-level responsive behavior
- **Interface**: `ScreenSizeModel.of<T>()`, `ScreenSizeModel.screenSizeOf<T>()`
- **Responsibilities**: MediaQuery integration, device detection, InheritedModel management

### Layout Size Module (`/src/layout_size/`)
- **Boundary**: Widget constraint-level responsive behavior
- **Interface**: `LayoutSizeBuilder` widgets
- **Responsibilities**: LayoutBuilder integration, constraint-based breakpoint resolution

### Value Modules (`/src/responsive_value/`, `/src/value_size/`)
- **Boundary**: Value containers and value-based builders
- **Interface**: `ResponsiveValue<V>` containers, value builders (screen-size and layout-constraint based)
- **Responsibilities**: Type-safe value storage, value selection logic

## Getting Started

Quick guide for developers to understand the architecture:

1. **Breakpoint Definition**: Choose between `LayoutSize` (5 breakpoints) or `LayoutSizeGranular` (13 breakpoints)
2. **Screen Size Setup**: Wrap your app in `ScreenSize<LayoutSize>` or `ScreenSize<LayoutSizeGranular>`
3. **Builder Selection**: Use appropriate builders:
   - `ScreenSizeBuilder` for MediaQuery-based responses
   - `LayoutSizeBuilder` for constraint-based responses
   - `ValueSizeBuilder` for MediaQuery-driven value responses
   - `LayoutValueSizeBuilder` for constraint-driven value responses
4. **Type Safety**: Always specify the correct generic type parameter matching your breakpoint enum

## Key Conventions

- **Generic Type Consistency**: Always use the same enum type throughout a widget subtree
- **Null Safety**: At least one breakpoint value must be provided to any builder
- **Fallback Strategy**: Larger breakpoint values automatically fall back to smaller ones
- **Animation Support**: Use `animateChange: true` for smooth transitions between breakpoints

## Maintenance

- **Owner**: Package Developer
- **Last Updated**: 2024-01-XX (Package Creation)
- **Review Schedule**: Per release cycle
- **Update Triggers**: Breaking changes to Flutter, new responsive requirements, performance optimizations

---

This architecture prioritizes type safety, performance, and developer experience while maintaining flexibility for diverse responsive design needs. The modular structure allows developers to use only the components they need while providing a comprehensive solution for Flutter responsive design challenges.
