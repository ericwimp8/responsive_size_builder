/// A Flutter package for building responsive layouts based on screen size.
///
/// This library provides a comprehensive set of tools for creating responsive
/// user interfaces that adapt to different screen sizes and breakpoints. It
/// offers both simple and granular breakpoint systems, along with various
/// builder widgets to handle different responsive design scenarios.
///
/// ## Key Features
///
/// * **Flexible Breakpoint System**: Define custom breakpoints or use the
///   default ones to categorize screen sizes.
/// * **Multiple Builder Widgets**: Choose from various builder widgets depending
///   on your needs - simple screen size builders, orientation-aware builders,
///   and granular builders for fine-tuned control.
/// * **Layout Constraints Access**: Easily access and work with Flutter's
///   BoxConstraints in a responsive context.
/// * **Value-based Responsive Design**: Build responsive designs based on
///   screen size values rather than just widget builders.
/// * **Overlay Positioning Utilities**: Utilities for positioning overlays
///   responsively across different screen sizes.
///
/// ## Basic Usage
///
/// Wrap your app with a ScreenSize widget and use builder widgets to create
/// responsive layouts:
///
/// ```dart
/// import 'package:responsive_size_builder/responsive_size_builder.dart';
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: ScreenSize<LayoutSize>(
///         breakpoints: Breakpoints.defaultBreakpoints,
///         child: Scaffold(
///           body: ScreenSizeBuilder(
///             small: (context, data) => MobileLayout(),
///             medium: (context, data) => TabletLayout(),
///             large: (context, data) => DesktopLayout(),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Available Breakpoint Systems
///
/// * **LayoutSize**: Simple 5-tier system (extraSmall, small, medium, large, extraLarge)
/// * **LayoutSizeGranular**: Comprehensive 13-tier system with jumbo, standard,
///   compact, and tiny categories for precise control
///
/// ## Builder Widgets
///
/// * **ScreenSizeBuilder**: Basic responsive builder with screen size data
/// * **ScreenSizeOrientationBuilder**: Orientation-aware builder with separate
///   builders for portrait and landscape modes
/// * **ScreenSizeBuilderGranular**: Fine-grained control with granular breakpoints
/// * **LayoutSizeBuilder**: Layout-focused responsive builder
/// * **ValueSizeBuilder**: Value-based responsive design for non-widget responses
///
/// ## Utilities and Providers
///
/// * **LayoutConstraintsProvider**: Access to BoxConstraints in responsive context
/// * **OverlayPositionUtils**: Utilities for responsive overlay positioning
/// * **BreakpointsHandler**: Core logic for handling breakpoint calculations
///
/// See the individual classes and functions for detailed usage examples and
/// configuration options.
library responsive_size_builder;

export 'responsive_size_builder.dart';
export 'src/breakpoints.dart';
export 'src/breakpoints_handler.dart';
export 'src/layout_constraints_provider.dart';
export 'src/layout_size_builder.dart';
export 'src/overlay_position_utils.dart';
export 'src/responsive_value.dart';
export 'src/screen_size_builder.dart';
export 'src/screen_size_data.dart';
export 'src/screen_size_with_value.dart';
export 'src/utilities.dart';
export 'src/value_size_builder.dart';
