import 'package:flutter/widgets.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart'
    show LayoutConstraintsWrapper;
import 'package:responsive_size_builder/src/layout_constraints/layout_constraints_wrapper.dart'
    show LayoutConstraintsWrapper;

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
