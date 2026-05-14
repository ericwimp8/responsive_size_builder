import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('LayoutConstraintsProvider', () {
    testWidgets('of returns null when no provider exists in the tree', (
      tester,
    ) async {
      BoxConstraints? resolvedConstraints;

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: Builder(
            builder: (context) {
              resolvedConstraints = LayoutConstraintsProvider.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(resolvedConstraints, isNull);
    });

    testWidgets('of resolves constraints from the nearest provider', (
      tester,
    ) async {
      const outerConstraints = BoxConstraints(
        minWidth: 10,
        maxWidth: 100,
        minHeight: 20,
        maxHeight: 200,
      );
      const innerConstraints = BoxConstraints(
        minWidth: 30,
        maxWidth: 300,
        minHeight: 40,
        maxHeight: 400,
      );
      BoxConstraints? resolvedConstraints;

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutConstraintsProvider(
            constraints: outerConstraints,
            child: LayoutConstraintsProvider(
              constraints: innerConstraints,
              child: Builder(
                builder: (context) {
                  resolvedConstraints = LayoutConstraintsProvider.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );

      expect(resolvedConstraints, innerConstraints);
    });

    test('updateShouldNotify returns false for equal constraints', () {
      const constraints = BoxConstraints(
        minWidth: 16,
        maxWidth: 48,
        minHeight: 24,
        maxHeight: 72,
      );
      const oldWidget = LayoutConstraintsProvider(
        constraints: constraints,
        child: SizedBox.shrink(),
      );
      const newWidget = LayoutConstraintsProvider(
        constraints: constraints,
        child: SizedBox.shrink(),
      );

      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });

    test('updateShouldNotify returns true for changed constraints', () {
      const oldWidget = LayoutConstraintsProvider(
        constraints: BoxConstraints(
          minWidth: 10,
          maxWidth: 100,
          minHeight: 20,
          maxHeight: 200,
        ),
        child: SizedBox.shrink(),
      );
      const newWidget = LayoutConstraintsProvider(
        constraints: BoxConstraints(
          minWidth: 10,
          maxWidth: 120,
          minHeight: 20,
          maxHeight: 220,
        ),
        child: SizedBox.shrink(),
      );

      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    testWidgets('notifies dependents only when constraints change', (
      tester,
    ) async {
      const initialConstraints = BoxConstraints(
        minWidth: 10,
        maxWidth: 100,
        minHeight: 20,
        maxHeight: 200,
      );
      const updatedConstraints = BoxConstraints(
        minWidth: 10,
        maxWidth: 140,
        minHeight: 20,
        maxHeight: 240,
      );
      final observedConstraints = <BoxConstraints?>[];
      final probe = _DependencyProbe(
        onBuild: observedConstraints.add,
      );

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutConstraintsProvider(
            constraints: initialConstraints,
            child: probe,
          ),
        ),
      );

      expect(observedConstraints, <BoxConstraints?>[initialConstraints]);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutConstraintsProvider(
            constraints: initialConstraints,
            child: probe,
          ),
        ),
      );

      expect(observedConstraints, <BoxConstraints?>[initialConstraints]);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: LayoutConstraintsProvider(
            constraints: updatedConstraints,
            child: probe,
          ),
        ),
      );

      expect(
        observedConstraints,
        <BoxConstraints?>[initialConstraints, updatedConstraints],
      );
    });
  });
}

class _DependencyProbe extends StatelessWidget {
  const _DependencyProbe({
    required this.onBuild,
  });

  final void Function(BoxConstraints?) onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild(LayoutConstraintsProvider.of(context));
    return const SizedBox.shrink();
  }
}
