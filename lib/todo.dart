/// Development task list and future enhancements for the responsive_size_builder package.
///
/// This file contains TODO items and planned improvements for the package architecture.
/// Items listed here represent potential breaking changes and new features that require
/// careful consideration and implementation planning.
///
/// The tasks primarily focus on:
/// - Simplifying the developer experience with pre-configured breakpoint wrappers
/// - Creating single-value responsive widgets for common use cases
/// - Refactoring the breakpoints system for better centralized configuration
/// - Implementing scoped rebuilds for breakpoint changes
library;

// TODO(ericwimp): Make a specific wrapper for each type of breakpoint to make it easy for
// devs to just add a widget aty the top of the tree and not have to worry about the generics being assigned
// This still enables the eager dev to build out their own breakpoints but caters to the dev who just wants things to work
//   eg. ScreenSize<LayoutSize> -> ScreenSize and ScreenSizeGranular -> ScreenSizeGranular
// TODO(ericwimp): create a single value changer wrapper that updates just a single value
// eg padding can be set for different breakpoints
// TODO(ericwimp): remove the argument for breakpoints in breakpoints handler
// and pass breakpoints into the functions inside breakpoints handler getScreenSize(double size, {Breakpoints? breakpoints})
// getScreenSizeValue(K screenSize, {Breakpoints? breakpoints}) this way it can be set app wide from the
// inherited model at the top of the tree ScreenSizeModelData
// so in the build funciton we would look up the tree for the breakpoints in ScreenSizeModelData and pass that into the
// handler function making it one source of truth
// Would also need to make a breakpointsOf function in ScreenSizeModel that scopes rebuilds
// to be only when the breakpoints change similar to  screenSizeOf in ScreenSizeModel
