import 'package:flutter/widgets.dart';

class LayoutConstraintsProvider extends InheritedWidget {
  const LayoutConstraintsProvider({
    required this.constraints,
    required super.child,
    super.key,
  });

  final BoxConstraints constraints;

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
