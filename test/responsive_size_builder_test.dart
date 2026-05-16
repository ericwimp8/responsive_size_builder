import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import 'harness/harness.dart';

void main() {
  group('ResponsiveGrid', () {
    testWidgets('wraps children into equal-width rows from available width', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const _TestFrame(
          width: 400,
          child: ResponsiveGrid(
            children: [
              _TestBox(key: Key('tile-1')),
              _TestBox(key: Key('tile-2')),
              _TestBox(key: Key('tile-3')),
            ],
          ),
        ),
      );

      final firstTopLeft = tester.getTopLeft(find.byKey(const Key('tile-1')));
      final secondTopLeft = tester.getTopLeft(find.byKey(const Key('tile-2')));
      final thirdTopLeft = tester.getTopLeft(find.byKey(const Key('tile-3')));

      expect(secondTopLeft.dy, firstTopLeft.dy);
      expect(thirdTopLeft.dy, greaterThan(firstTopLeft.dy));
    });

    testWidgets('base variant reads constraints from provider', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: _TestFrame(
          width: 180,
          child: LayoutConstraintsWrapper(
            builder: (context, child) => child,
            child: const ResponsiveGridBase(
              minChildWidth: 120,
              children: [
                _TestBox(key: Key('tile-1')),
                _TestBox(key: Key('tile-2')),
              ],
            ),
          ),
        ),
      );

      final firstTopLeft = tester.getTopLeft(find.byKey(const Key('tile-1')));
      final secondTopLeft = tester.getTopLeft(find.byKey(const Key('tile-2')));

      expect(secondTopLeft.dy, greaterThan(firstTopLeft.dy));
    });
  });

  group('ResponsiveSectionRow', () {
    testWidgets('uses row layout when every section has minimum width', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const _TestFrame(
          width: 520,
          child: ResponsiveSectionRow(
            sections: [
              _TestBox(key: Key('section-1')),
              _TestBox(key: Key('section-2')),
            ],
          ),
        ),
      );

      final firstTopLeft = tester.getTopLeft(
        find.byKey(const Key('section-1')),
      );
      final secondTopLeft = tester.getTopLeft(
        find.byKey(const Key('section-2')),
      );

      expect(secondTopLeft.dx, greaterThan(firstTopLeft.dx));
      expect(secondTopLeft.dy, firstTopLeft.dy);
    });

    testWidgets('stacks sections when width is too narrow', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: const _TestFrame(
          width: 300,
          child: ResponsiveSectionRow(
            sections: [
              _TestBox(key: Key('section-1')),
              _TestBox(key: Key('section-2')),
            ],
          ),
        ),
      );

      final firstTopLeft = tester.getTopLeft(
        find.byKey(const Key('section-1')),
      );
      final secondTopLeft = tester.getTopLeft(
        find.byKey(const Key('section-2')),
      );

      expect(secondTopLeft.dx, firstTopLeft.dx);
      expect(secondTopLeft.dy, greaterThan(firstTopLeft.dy));
    });
  });

  group('MaterialResponsiveValue', () {
    test('resolves Material window classes and values', () {
      final provider = MaterialResponsiveValue();

      expect(
        provider.getScreenSize(599),
        MaterialWindowSizeClass.compact,
      );
      expect(
        provider.getScreenSize(600),
        MaterialWindowSizeClass.medium,
      );
      expect(
        provider.getScreenSize(840),
        MaterialWindowSizeClass.expanded,
      );
      expect(
        provider.getScreenSize(1200),
        MaterialWindowSizeClass.large,
      );
      expect(
        provider.getScreenSize(1600),
        MaterialWindowSizeClass.extraLarge,
      );

      final compact = provider.getScreenSizeValue(
        screenSize: MaterialWindowSizeClass.compact,
      );
      final expanded = provider.getScreenSizeValue(
        screenSize: MaterialWindowSizeClass.expanded,
      );
      final extraLarge = provider.getScreenSizeValue(
        screenSize: MaterialWindowSizeClass.extraLarge,
      );

      expect(compact.pageMargin, 16);
      expect(compact.maxPaneCount, 1);
      expect(compact.minimumPaneWidth, 280);
      expect(expanded.fixedPaneWidth, 360);
      expect(expanded.minimumPaneWidth, 360);
      expect(expanded.singlePaneMaxWidth, 720);
      expect(extraLarge.recommendedPaneCount, 3);
      expect(extraLarge.sideSheetMaxWidth, 400);
    });

    testWidgets('MaterialResponsiveSize exposes Material values', (
      tester,
    ) async {
      late MaterialWindowSizeClass breakpoint;
      late MaterialResponsiveValues values;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: MaterialResponsiveSize(
          child: Builder(
            builder: (context) {
              breakpoint = ScreenSizeModelWithValue.breakpointOf<
                  MaterialWindowSizeClass>(context);
              values = ScreenSizeModelWithValue.responsiveValueOf<
                  MaterialWindowSizeClass, MaterialResponsiveValues>(context);

              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(breakpoint, isA<MaterialWindowSizeClass>());
      expect(values.pageMargin, isPositive);
      expect(values.paneSpacing, 24);
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

class _TestBox extends StatelessWidget {
  const _TestBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      child: Placeholder(),
    );
  }
}
