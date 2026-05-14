import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('ResponsiveGrid', () {
    test('requires a positive minimum child width', () {
      expect(
        () => ResponsiveGrid(
          minChildWidth: 0,
          children: const [SizedBox.shrink()],
        ),
        throwsAssertionError,
      );
    });

    test('requires non-negative spacing values', () {
      expect(
        () => ResponsiveGrid(
          spacing: -1,
          children: const [SizedBox.shrink()],
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveGrid(
          runSpacing: -1,
          children: const [SizedBox.shrink()],
        ),
        throwsAssertionError,
      );
    });

    testWidgets('returns a shrink box when children are empty', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const ResponsiveGrid(children: []),
      );

      expect(find.byType(ResponsiveGridBase), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets(
        'computes rows from finite width and preserves column alignment',
        (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const _TestFrame(
          width: 260,
          child: ResponsiveGrid(
            minChildWidth: 120,
            spacing: 20,
            runSpacing: 24,
            children: [
              _TestTile(key: Key('tile-1')),
              _TestTile(key: Key('tile-2')),
              _TestTile(key: Key('tile-3')),
            ],
          ),
        ),
      );

      final firstTopLeft = tester.getTopLeft(find.byKey(const Key('tile-1')));
      final secondTopLeft = tester.getTopLeft(find.byKey(const Key('tile-2')));
      final thirdTopLeft = tester.getTopLeft(find.byKey(const Key('tile-3')));

      expect(secondTopLeft.dy, firstTopLeft.dy);
      expect(thirdTopLeft.dy, firstTopLeft.dy + 54);
      expect(secondTopLeft.dx, greaterThan(firstTopLeft.dx));
      expect(thirdTopLeft.dx, firstTopLeft.dx);
    });
  });

  group('ResponsiveGridBase', () {
    test('requires a positive minimum child width', () {
      expect(
        () => ResponsiveGridBase(
          minChildWidth: 0,
          children: const [SizedBox.shrink()],
        ),
        throwsAssertionError,
      );
    });

    test('requires non-negative spacing values', () {
      expect(
        () => ResponsiveGridBase(
          spacing: -1,
          children: const [SizedBox.shrink()],
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveGridBase(
          runSpacing: -1,
          children: const [SizedBox.shrink()],
        ),
        throwsAssertionError,
      );
    });

    testWidgets('throws when no layout constraints provider exists',
        (tester) async {
      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: const ResponsiveGridBase(
            children: [
              _TestTile(key: Key('tile-1')),
            ],
          ),
        ),
      );
      await tester.pump();

      final exception = tester.takeException();

      expect(exception, isA<FlutterError>());
      expect(
        (exception! as FlutterError).message,
        contains(
          'ResponsiveGridBase must be used within a '
          'LayoutConstraintsWrapper.',
        ),
      );
    });

    testWidgets('uses fallback width when provided width is infinite', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const LayoutConstraintsProvider(
          constraints: BoxConstraints(),
          child: ResponsiveGridBase(
            minChildWidth: 120,
            spacing: 16,
            children: [
              _TestTile(key: Key('tile-1')),
              _TestTile(key: Key('tile-2')),
              _TestTile(key: Key('tile-3')),
            ],
          ),
        ),
      );

      final firstTopLeft = tester.getTopLeft(find.byKey(const Key('tile-1')));
      final secondTopLeft = tester.getTopLeft(find.byKey(const Key('tile-2')));
      final thirdTopLeft = tester.getTopLeft(find.byKey(const Key('tile-3')));

      expect(secondTopLeft.dy, firstTopLeft.dy);
      expect(thirdTopLeft.dy, firstTopLeft.dy);
      expect(secondTopLeft.dx, greaterThan(firstTopLeft.dx));
      expect(thirdTopLeft.dx, greaterThan(secondTopLeft.dx));
    });
  });
}

class _TestFrame extends StatelessWidget {
  const _TestFrame({
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    );
  }
}

class _TestTile extends StatelessWidget {
  const _TestTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      child: Placeholder(),
    );
  }
}
