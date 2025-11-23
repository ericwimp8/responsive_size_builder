/// Public entrypoint for the responsive_size_builder package.
///
/// This library re-exports all core breakpoint types plus the screen, layout
/// and value builder widgets used to build fully responsive UIs.
// ignore_for_file: directives_ordering

// Core
export 'src/core/breakpoints/base_breakpoints_handler.dart';
export 'src/core/breakpoints/breakpoints.dart';
export 'src/core/breakpoints/breakpoints_handler.dart';
export 'src/core/breakpoints/breakpoints_handler_granular.dart';
export 'src/core/overlay_position_utils.dart';
export 'src/core/typedefs.dart';
export 'src/core/utilities.dart';

// Providers
export 'src/screen_size/screen_size_data.dart';
export 'src/responsive_value/screen_size_with_value.dart';

// Screen (global MediaQuery)
export 'src/screen/standard/screen_widget_builder.dart';
export 'src/screen/standard/screen_widget_builder_orientation.dart';
export 'src/screen/standard/screen_value_builder.dart';
export 'src/screen/standard/screen_value_builder_orientation.dart';
export 'src/screen/granular/screen_widget_builder_granular.dart';
export 'src/screen/granular/screen_widget_builder_granular_orientation.dart';
export 'src/screen/granular/screen_value_builder_granular.dart';
export 'src/screen/granular/screen_value_builder_granular_orientation.dart';

// Screen with responsive value
export 'src/screen_with_value/standard/screen_with_value_widget_builder.dart';
export 'src/screen_with_value/standard/screen_with_value_widget_builder_orientation.dart';
export 'src/screen_with_value/standard/screen_with_value_value_builder.dart';
export 'src/screen_with_value/standard/screen_with_value_value_builder_orientation.dart';
export 'src/screen_with_value/granular/screen_with_value_widget_builder_granular.dart';
export 'src/screen_with_value/granular/screen_with_value_widget_builder_granular_orientation.dart';
export 'src/screen_with_value/granular/screen_with_value_value_builder_granular.dart';
export 'src/screen_with_value/granular/screen_with_value_value_builder_granular_orientation.dart';

// Layout (local constraints)
export 'src/layout/standard/layout_widget_builder.dart';
export 'src/layout/standard/layout_widget_builder_orientation.dart';
export 'src/layout/standard/layout_value_builder.dart';
export 'src/layout/standard/layout_value_builder_orientation.dart';
export 'src/layout/granular/layout_widget_builder_granular.dart';
export 'src/layout/granular/layout_widget_builder_granular_orientation.dart';
export 'src/layout/granular/layout_value_builder_granular.dart';
export 'src/layout/granular/layout_value_builder_granular_orientation.dart';

// Layout constraints helpers
export 'src/layout_constraints/layout_constraints_provider_base.dart';
export 'src/layout_constraints/layout_constraints_wrapper.dart';

// Responsive values (non-builder helpers)
export 'src/responsive_value/responsive_value.dart';
