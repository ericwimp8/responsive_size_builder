import 'package:flutter/widgets.dart';

/// Provides the nearest [BoxConstraints] produced by a [LayoutBuilder] to
/// descendants in the tree.
class LayoutConstraintsProvider extends InheritedWidget {
  const LayoutConstraintsProvider({
    required this.constraints,
    required super.child,
    super.key,
  });

  final BoxConstraints constraints;

  /// Returns the [BoxConstraints] from the nearest [LayoutConstraintsProvider]
  /// above [context], or null when none is found.
  static BoxConstraints? of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<LayoutConstraintsProvider>();

    return result?.constraints;
  }

  @override
  bool updateShouldNotify(LayoutConstraintsProvider oldWidget) {
    return constraints != oldWidget.constraints;
  }
}
