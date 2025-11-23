import 'package:flutter/widgets.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

/// Wraps a subtree in a [LayoutBuilder] and exposes its constraints via
/// [LayoutConstraintsProvider] before invoking [builder].
class LayoutConstraintsWrapper extends StatelessWidget {
  const LayoutConstraintsWrapper({
    required this.child,
    required this.builder,
    super.key,
  });

  final Widget child;

  /// Called with the current [BuildContext] and [child] once constraints
  /// have been captured.
  final Widget Function(BuildContext context, Widget child) builder;

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
