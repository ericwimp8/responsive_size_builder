import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that provides [BoxConstraints] to descendant widgets.
///
/// This widget enables any descendant in the widget tree to access layout
/// constraints without requiring a direct [LayoutBuilder] wrapper. It's
/// particularly useful in responsive design scenarios where multiple widgets
/// need access to the same constraint information.
///
/// The constraints are typically obtained from a [LayoutBuilder] and then
/// propagated down the tree via this provider, allowing descendant widgets
/// to make layout decisions based on available space.
///
/// ## Usage Pattern
///
/// 1. Wrap your widget subtree with [LayoutConstraintsProvider]
/// 2. Pass the constraints obtained from a [LayoutBuilder]
/// 3. Access the constraints in any descendant using [LayoutConstraintsProvider.of]
///
/// ## Example
///
/// ```dart
/// LayoutBuilder(
///   builder: (context, constraints) {
///     return LayoutConstraintsProvider(
///       constraints: constraints,
///       child: MyResponsiveWidget(),
///     );
///   },
/// )
///
/// // In any descendant widget:
/// class MyResponsiveWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final constraints = LayoutConstraintsProvider.of(context);
///
///     if (constraints == null) {
///       return const SizedBox.shrink();
///     }
///
///     return Container(
///       width: constraints.maxWidth * 0.8,
///       height: constraints.maxHeight * 0.5,
///       child: const Text('Responsive content'),
///     );
///   }
/// }
/// ```
///
/// ## Performance Considerations
///
/// Widgets that depend on this provider will rebuild whenever the constraints
/// change. This behavior is controlled by the [updateShouldNotify] method.
///
/// See also:
///
/// * [LayoutConstraintsWrapper], which combines [LayoutBuilder] with this provider
/// * [BoxConstraints], the constraint data being provided
/// * [InheritedWidget], the base class that enables the propagation mechanism
class LayoutConstraintsProvider extends InheritedWidget {
  /// Creates a [LayoutConstraintsProvider] that provides [constraints] to its descendants.
  ///
  /// The [constraints] parameter contains the layout constraints that will be
  /// made available to descendant widgets through [LayoutConstraintsProvider.of].
  /// These constraints are typically obtained from a [LayoutBuilder].
  ///
  /// The [child] parameter is the widget subtree that will have access to
  /// the provided constraints.
  ///
  /// ## Parameters
  ///
  /// * [constraints]: The [BoxConstraints] to provide to descendants
  /// * [child]: The widget subtree that can access the constraints
  /// * [key]: An optional key for this widget
  const LayoutConstraintsProvider({
    required this.constraints,
    required super.child,
    super.key,
  });

  /// The layout constraints being provided to descendant widgets.
  ///
  /// These constraints represent the available space for layout and are
  /// typically obtained from a [LayoutBuilder]. Descendant widgets can
  /// access these constraints using [LayoutConstraintsProvider.of].
  final BoxConstraints constraints;

  /// Retrieves the [BoxConstraints] from the nearest [LayoutConstraintsProvider] ancestor.
  ///
  /// This method establishes a dependency relationship between the calling widget
  /// and the [LayoutConstraintsProvider]. When the constraints change, any widget
  /// that has called this method will be automatically rebuilt.
  ///
  /// Returns `null` if no [LayoutConstraintsProvider] ancestor is found in the
  /// widget tree above the given [context]. Callers should handle this case
  /// appropriately, typically by providing fallback behavior or constraints.
  ///
  /// ## Parameters
  ///
  /// * [context]: The [BuildContext] from which to search for the provider
  ///
  /// ## Returns
  ///
  /// The [BoxConstraints] from the nearest ancestor provider, or `null` if
  /// no provider is found.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final constraints = LayoutConstraintsProvider.of(context);
  ///
  ///   if (constraints == null) {
  ///     // Handle case where no provider is available
  ///     return const SizedBox.shrink();
  ///   }
  ///
  ///   // Use the constraints for responsive layout
  ///   return Container(
  ///     width: constraints.maxWidth * 0.8,
  ///     child: const Text('Responsive content'),
  ///   );
  /// }
  /// ```
  static BoxConstraints? of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<LayoutConstraintsProvider>();

    // if (result == null) {
    //   throw FlutterError(
    //     'ConstraintsProvider.of() called with a context that does not contain a ConstraintsProvider.\n'
    //     'No ConstraintsProvider ancestor could be found starting from the context that was passed '
    //     'to ConstraintsProvider.of(). This usually happens because you used a context that does not '
    //     'have a ConstraintsProvider widget ancestor.\n'
    //     'Make sure to wrap the relevant part of your widget tree with a LayoutBuilder '
    //     'providing constraints to a ConstraintsProvider.\n'
    //     'The context used was: $context',
    //   );
    // }
    return result?.constraints;
  }

  /// Whether dependent widgets should be rebuilt when this widget updates.
  ///
  /// Returns `true` if the [constraints] have changed compared to the previous
  /// version of this widget ([oldWidget]). This ensures that any widget depending
  /// on these constraints will be rebuilt when the available layout space changes.
  ///
  /// The comparison relies on [BoxConstraints.operator==], which compares all
  /// constraint properties (minWidth, maxWidth, minHeight, maxHeight) for equality.
  ///
  /// ## Parameters
  ///
  /// * [oldWidget]: The previous version of this [LayoutConstraintsProvider]
  ///
  /// ## Returns
  ///
  /// `true` if dependent widgets should rebuild, `false` otherwise.
  @override
  bool updateShouldNotify(LayoutConstraintsProvider oldWidget) {
    return constraints != oldWidget.constraints;
  }
}

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
