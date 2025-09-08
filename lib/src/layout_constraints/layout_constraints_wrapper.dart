import 'package:flutter/widgets.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// A convenience widget that automatically provides layout constraints to its children.
///
/// This widget combines [LayoutBuilder] and [LayoutConstraintsProvider] into a single
/// component that captures the available layout constraints and makes them accessible
/// to all descendant widgets through [LayoutConstraintsProvider.of].
///
/// The [builder] function receives both the [BuildContext] and the [child] widget,
/// allowing for additional processing or wrapper widgets around the child before
/// it's rendered within the constraints provider.
///
/// ## Use Cases
///
/// * Simplifying the pattern of needing constraints in deeply nested widgets
/// * Avoiding manual [LayoutBuilder] + [LayoutConstraintsProvider] boilerplate
/// * Creating reusable responsive components that automatically provide constraints
/// * Building responsive wrapper widgets that need to modify their children
///
/// ## Example
///
/// ```dart
/// // Simple usage - child widgets can access constraints
/// LayoutConstraintsWrapper(
///   builder: (context, child) => child,
///   child: MyResponsiveWidget(),
/// )
///
/// // Advanced usage - modify the child before providing constraints
/// LayoutConstraintsWrapper(
///   builder: (context, child) => Container(
///     decoration: BoxDecoration(border: Border.all()),
///     child: child,
///   ),
///   child: MyResponsiveWidget(),
/// )
///
/// // In MyResponsiveWidget or any descendant:
/// final constraints = LayoutConstraintsProvider.of(context);
/// ```
///
/// ## Comparison with Manual Approach
///
/// ```dart
/// // Manual approach:
/// LayoutBuilder(
///   builder: (context, constraints) {
///     return LayoutConstraintsProvider(
///       constraints: constraints,
///       child: MyWidget(),
///     );
///   },
/// )
///
/// // Using LayoutConstraintsWrapper:
/// LayoutConstraintsWrapper(
///   builder: (context, child) => child,
///   child: MyWidget(),
/// )
/// ```
///
/// See also:
///
/// * [LayoutConstraintsProvider], the underlying provider widget
/// * [LayoutBuilder], the widget used internally to capture constraints
/// * [BoxConstraints], the constraint data that's made available
class LayoutConstraintsWrapper extends StatelessWidget {
  /// Creates a [LayoutConstraintsWrapper] that provides constraints to its child.
  ///
  /// The [builder] function is called with the current [BuildContext] and the
  /// [child] widget, allowing for additional processing or wrapper widgets
  /// before the child is rendered within the constraints provider.
  ///
  /// ## Parameters
  ///
  /// * [builder]: Function that processes the child widget within the constraint context
  /// * [child]: The widget that will have access to layout constraints
  /// * [key]: An optional key for this widget
  ///
  /// ## Example
  ///
  /// ```dart
  /// LayoutConstraintsWrapper(
  ///   builder: (context, child) => Padding(
  ///     padding: const EdgeInsets.all(16.0),
  ///     child: child,
  ///   ),
  ///   child: MyResponsiveContent(),
  /// )
  /// ```
  const LayoutConstraintsWrapper({
    required this.child,
    required this.builder,
    super.key,
  });

  /// The widget that will have access to layout constraints.
  ///
  /// This child widget and all of its descendants can access the layout
  /// constraints captured by this wrapper using [LayoutConstraintsProvider.of].
  /// The child is passed to the [builder] function for potential modification
  /// before being rendered within the constraints provider.
  final Widget child;

  /// Function that processes the child widget within the constraint context.
  ///
  /// This function receives the current [BuildContext] and the [child] widget,
  /// allowing for additional wrapper widgets or modifications before the child
  /// is placed within the [LayoutConstraintsProvider].
  ///
  /// The function must return a [Widget] that will be used as the child of
  /// the [LayoutConstraintsProvider].
  ///
  /// ## Example Uses
  ///
  /// ```dart
  /// // Simple pass-through
  /// builder: (context, child) => child
  ///
  /// // Add padding
  /// builder: (context, child) => Padding(
  ///   padding: const EdgeInsets.all(16.0),
  ///   child: child,
  /// )
  ///
  /// // Add decoration based on constraints
  /// builder: (context, child) {
  ///   final constraints = LayoutConstraintsProvider.of(context);
  ///   return Container(
  ///     decoration: constraints?.maxWidth > 600
  ///         ? BoxDecoration(border: Border.all())
  ///         : null,
  ///     child: child,
  ///   );
  /// }
  /// ```
  final Widget Function(BuildContext context, Widget child) builder;

  /// Builds the widget tree with layout constraints provided to descendants.
  ///
  /// This method uses a [LayoutBuilder] to capture the available layout space,
  /// then wraps the processed child widget in a [LayoutConstraintsProvider] to
  /// make those constraints accessible to all descendant widgets.
  ///
  /// The build process follows these steps:
  /// 1. [LayoutBuilder] captures the available [BoxConstraints]
  /// 2. [builder] function processes the [child] widget
  /// 3. [LayoutConstraintsProvider] makes constraints available to descendants
  /// 4. The processed child is rendered within the provider
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return LayoutConstraintsProvider(
          constraints: constraints,
          child: builder(context, child),
        );
      },
    );
  }
}
