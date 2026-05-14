import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('LayoutConstraintsWrapper', () {
    testWidgets('passes the provided child to the builder callback', (
      tester,
    ) async {
      const child = SizedBox(
        key: Key('wrapped-child'),
      );
      Widget? callbackChild;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: LayoutConstraintsWrapper(
          builder: (context, child) {
            callbackChild = child;
            return child;
          },
          child: child,
        ),
      );

      expect(find.byKey(const Key('wrapped-child')), findsOneWidget);
      expect(identical(callbackChild, child), isTrue);
    });

    testWidgets('exposes layout constraints to descendants via provider', (
      tester,
    ) async {
      BoxConstraints? capturedConstraints;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(420, 280),
        withScaffold: false,
        child: LayoutConstraintsWrapper(
          builder: (context, child) => child,
          child: Builder(
            builder: (context) {
              capturedConstraints = LayoutConstraintsProvider.of(context);

              return const SizedBox(
                key: Key('constraints-child'),
              );
            },
          ),
        ),
      );

      expect(find.byKey(const Key('constraints-child')), findsOneWidget);
      expect(capturedConstraints, isNotNull);
      expect(capturedConstraints!.maxWidth, 420);
      expect(capturedConstraints!.maxHeight, 280);
    });
  });
}
