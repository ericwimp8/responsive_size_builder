import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('ResponsiveSectionRow', () {
    test('asserts on invalid constructor arguments', () {
      expect(
        () => ResponsiveSectionRow(
          sections: const [],
          minSectionWidth: 0,
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveSectionRow(
          sections: const [],
          spacing: -1,
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveSectionRow(
          sections: const [],
          runSpacing: -1,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('uses row layout when sections fit available width', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(700, 400),
        withScaffold: false,
        child: ResponsiveSectionRow(
          sections: _sections(2),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    });

    testWidgets('uses column layout when sections do not fit width', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(420, 400),
        withScaffold: false,
        child: ResponsiveSectionRow(
          sections: _sections(2),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });

    testWidgets('wraps row layout in IntrinsicHeight when enabled', (
      tester,
    ) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(700, 400),
        withScaffold: false,
        child: ResponsiveSectionRow(
          sections: _sections(2),
          useIntrinsicHeight: true,
        ),
      );

      expect(find.byType(IntrinsicHeight), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
    });
  });

  group('ResponsiveSectionRowBase', () {
    test('asserts on invalid constructor arguments', () {
      expect(
        () => ResponsiveSectionRowBase(
          sections: const [],
          minSectionWidth: 0,
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveSectionRowBase(
          sections: const [],
          spacing: -1,
        ),
        throwsAssertionError,
      );
      expect(
        () => ResponsiveSectionRowBase(
          sections: const [],
          runSpacing: -1,
        ),
        throwsAssertionError,
      );
    });

    testWidgets(
      'throws when constraints provider is missing for multi-section layout',
      (tester) async {
        await tester.pumpWidget(
          buildHarnessApp(
            withScaffold: false,
            child: ResponsiveSectionRowBase(
              sections: _sections(2),
            ),
          ),
        );

        final error = tester.takeException();
        expect(error, isA<FlutterError>());
      },
    );

    testWidgets('uses spacing SizedBox divider in row layout by default', (
      tester,
    ) async {
      const spacing = 14.0;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(700, 400),
        withScaffold: false,
        child: _wrapWithConstraints(
          ResponsiveSectionRowBase(
            sections: _sections(2),
            spacing: spacing,
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      final divider = row.children[1] as SizedBox;

      expect(row.children[0], isA<Expanded>());
      expect(divider.width, spacing);
      expect(row.children[2], isA<Expanded>());
    });

    testWidgets('uses runSpacing SizedBox divider in column layout by default',
        (tester) async {
      const runSpacing = 18.0;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(420, 400),
        withScaffold: false,
        child: _wrapWithConstraints(
          ResponsiveSectionRowBase(
            sections: _sections(2),
            runSpacing: runSpacing,
          ),
        ),
      );

      final column = tester.widget<Column>(find.byType(Column));
      final divider = column.children[1] as SizedBox;

      expect(divider.height, runSpacing);
    });

    testWidgets('uses custom divider builders when provided', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(700, 400),
        withScaffold: false,
        child: _wrapWithConstraints(
          ResponsiveSectionRowBase(
            sections: _sections(2),
            dividerBuilder: (_) => const SizedBox(
              key: Key('row-divider'),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('row-divider')), findsOneWidget);

      await tester.pumpWidget(
        buildHarnessApp(
          withScaffold: false,
          child: _wrapWithConstraints(
            ResponsiveSectionRowBase(
              sections: _sections(2),
              minSectionWidth: 400,
              columnDividerBuilder: (_) => const SizedBox(
                key: Key('column-divider'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('column-divider')), findsOneWidget);
    });

    testWidgets('uses row layout when maxWidth is infinite', (tester) async {
      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        withScaffold: false,
        child: LayoutConstraintsProvider(
          constraints: const BoxConstraints(),
          child: ResponsiveSectionRowBase(
            sections: _sections(2),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    });
  });
}

List<Widget> _sections(int count) {
  return List<Widget>.generate(
    count,
    (index) => SizedBox(
      key: Key('section-$index'),
      height: 32,
      child: const Placeholder(),
    ),
  );
}

Widget _wrapWithConstraints(Widget child) {
  return LayoutConstraintsWrapper(
    builder: (_, child) => child,
    child: child,
  );
}
