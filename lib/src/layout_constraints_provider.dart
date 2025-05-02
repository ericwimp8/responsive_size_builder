import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that provides [BoxConstraints] down the widget tree.
///
/// Widgets below this in the tree can access the constraints obtained from
/// an ancestor (typically a [LayoutBuilder]) using the static [of] method.
///
/// This is useful when a descendant widget needs to know the constraints
/// imposed on its ancestor without requiring a [LayoutBuilder] directly
/// around itself, potentially simplifying the widget tree structure.
///
/// Example Usage:
/// ```dart
/// LayoutBuilder(
///   builder: (context, constraints) {
///     // Provide the constraints down the tree
///     return ConstraintsProvider(
///       constraints: constraints,
///       child: MyWidgetThatNeedsConstraints(),
///     );
///   },
/// )
///
/// // ... later in MyWidgetThatNeedsConstraints or its children ...
/// class MyWidgetThatNeedsConstraints extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     // Access the constraints
///     final BoxConstraints constraints = ConstraintsProvider.of(context);
///
///     return Container(
///       // Use the constraints, e.g., determine width based on maxWidth
///       width: constraints.maxWidth * 0.8,
///       height: 100,
///       color: Colors.blue,
///       child: Center(
///         child: Text(
///           'Max Width: ${constraints.maxWidth.toStringAsFixed(1)}',
///           style: TextStyle(color: Colors.white),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class LayoutConstraintsProvider extends InheritedWidget {
  /// Creates a [LayoutConstraintsProvider] widget.
  ///
  /// The [constraints] argument must not be null and is typically obtained
  /// from a [LayoutBuilder]. The [child] widget and its descendants can
  /// then access these constraints via [LayoutConstraintsProvider.of].
  const LayoutConstraintsProvider({
    required this.constraints,
    required super.child,
    super.key,
  });

  /// The [BoxConstraints] being provided down the tree.
  final BoxConstraints constraints;

  /// Retrieves the nearest [BoxConstraints] provided by a [LayoutConstraintsProvider]
  /// ancestor of the given [context].
  ///
  /// This method registers the [context] as dependent on the [LayoutConstraintsProvider].
  /// If the constraints change, the dependent widget will be rebuilt.
  ///
  /// Throws a [FlutterError] if no [LayoutConstraintsProvider] ancestor is found.
  static BoxConstraints of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<LayoutConstraintsProvider>();

    if (result == null) {
      throw FlutterError(
        'ConstraintsProvider.of() called with a context that does not contain a ConstraintsProvider.\n'
        'No ConstraintsProvider ancestor could be found starting from the context that was passed '
        'to ConstraintsProvider.of(). This usually happens because you used a context that does not '
        'have a ConstraintsProvider widget ancestor.\n'
        'Make sure to wrap the relevant part of your widget tree with a LayoutBuilder '
        'providing constraints to a ConstraintsProvider.\n'
        'The context used was: $context',
      );
    }
    return result.constraints;
  }

  /// Determines whether widgets that depend on this inherited widget should
  /// be rebuilt.
  ///
  /// Returns `true` if the [constraints] have changed compared to the
  /// [oldWidget].
  @override
  bool updateShouldNotify(LayoutConstraintsProvider oldWidget) {
    // BoxConstraints implements equality comparison (==), so this works correctly.
    return constraints != oldWidget.constraints;
  }
}

/// A wrapper widget that captures the [BoxConstraints] available to it
/// using a [LayoutBuilder] and provides them down the widget tree
/// via a [LayoutConstraintsProvider] for its [child].
///
/// This simplifies the pattern of needing constraints within a child widget
/// without requiring the child itself (or intermediate widgets) to be wrapped
/// directly in a [LayoutBuilder].
///
/// Example:
/// ```dart
/// // Instead of:
/// // LayoutBuilder(
/// //   builder: (context, constraints) {
/// //     return MyWidgetThatNeedsConstraints(constraints: constraints);
/// //   }
/// // )
///
/// // You can do:
/// ConstraintsWrapper(
///   child: MyWidgetThatReadsConstraintsFromProvider(),
/// )
///
/// // Where MyWidgetThatReadsConstraintsFromProvider accesses constraints like this:
/// // final constraints = ConstraintsProvider.of(context);
/// ```
class LayoutConstraintsWrapper extends StatelessWidget {
  /// Creates a widget that provides layout constraints to its child.
  const LayoutConstraintsWrapper({
    required this.child,
    required this.builder,
    super.key,
  });

  /// The widget below this widget in the tree.
  ///
  /// This child and its descendants can access the constraints captured
  /// by this wrapper using `ConstraintsProvider.of(context)`.
  final Widget child;
  final Widget Function(BuildContext context, Widget child) builder;

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get the constraints for the space
    // this ConstraintsWrapper occupies.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Use ConstraintsProvider to make the obtained constraints
        // available to the child and its descendants.
        return LayoutConstraintsProvider(
          constraints: constraints,
          child: builder(context, child), // Render the actual child widget here
        );
      },
    );
  }
}
