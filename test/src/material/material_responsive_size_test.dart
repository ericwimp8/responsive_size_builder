import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

import '../../harness/harness.dart';

void main() {
  group('MaterialBreakpoints', () {
    test('uses expected defaults', () {
      const breakpoints = MaterialBreakpoints.defaultBreakpoints;

      expect(breakpoints.extraLarge, 1600);
      expect(breakpoints.large, 1200);
      expect(breakpoints.expanded, 840);
      expect(breakpoints.medium, 600);
    });

    test('exposes enum values map including compact fallback', () {
      const breakpoints = MaterialBreakpoints(
        extraLarge: 1700,
        large: 1300,
        expanded: 900,
        medium: 650,
      );

      expect(
        breakpoints.values,
        equals(<MaterialWindowSizeClass, double>{
          MaterialWindowSizeClass.extraLarge: 1700,
          MaterialWindowSizeClass.large: 1300,
          MaterialWindowSizeClass.expanded: 900,
          MaterialWindowSizeClass.medium: 650,
          MaterialWindowSizeClass.compact: -1,
        }),
      );
    });

    test('supports value equality and stable hashCode', () {
      const first = MaterialBreakpoints(
        extraLarge: 1800,
        large: 1400,
        expanded: 950,
        medium: 700,
      );
      const second = MaterialBreakpoints(
        extraLarge: 1800,
        large: 1400,
        expanded: 950,
        medium: 700,
      );
      const third = MaterialBreakpoints(
        extraLarge: 1800,
        large: 1450,
        expanded: 950,
        medium: 700,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('toString includes all thresholds', () {
      const breakpoints = MaterialBreakpoints(
        extraLarge: 1700,
        large: 1400,
        expanded: 1000,
        medium: 700,
      );

      expect(
        breakpoints.toString(),
        'MaterialBreakpoints(extraLarge: 1700.0, large: 1400.0, expanded: 1000.0, medium: 700.0)',
      );
    });

    test('asserts when thresholds are not in descending order', () {
      expect(
        () => MaterialBreakpoints(
          extraLarge: 1200,
          large: 1300,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('MaterialResponsiveValues', () {
    test('supports value equality and stable hashCode', () {
      const first = MaterialResponsiveValues(
        pageMargin: 24,
        paneSpacing: 16,
        recommendedPaneCount: 2,
        maxPaneCount: 3,
        minimumPaneWidth: 360,
        singlePaneMaxWidth: 720,
        fixedPaneWidth: 380,
        sideSheetMaxWidth: 420,
      );
      const second = MaterialResponsiveValues(
        pageMargin: 24,
        paneSpacing: 16,
        recommendedPaneCount: 2,
        maxPaneCount: 3,
        minimumPaneWidth: 360,
        singlePaneMaxWidth: 720,
        fixedPaneWidth: 380,
        sideSheetMaxWidth: 420,
      );
      const third = MaterialResponsiveValues(
        pageMargin: 16,
        paneSpacing: 16,
        recommendedPaneCount: 2,
        maxPaneCount: 3,
        minimumPaneWidth: 280,
        singlePaneMaxWidth: 720,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect(first, isNot(third));
    });

    test('toString includes all configured fields', () {
      const values = MaterialResponsiveValues(
        pageMargin: 24,
        paneSpacing: 24,
        recommendedPaneCount: 3,
        maxPaneCount: 3,
        minimumPaneWidth: 412,
        singlePaneMaxWidth: 720,
        fixedPaneWidth: 412,
        sideSheetMaxWidth: 400,
      );

      expect(
        values.toString(),
        'MaterialResponsiveValues(pageMargin: 24.0, paneSpacing: 24.0, recommendedPaneCount: 3, maxPaneCount: 3, minimumPaneWidth: 412.0, singlePaneMaxWidth: 720.0, fixedPaneWidth: 412.0, sideSheetMaxWidth: 400.0)',
      );
    });

    test('exposes expected Material constants', () {
      expect(MaterialResponsiveValues.paddingStep, 4.0);
      expect(MaterialResponsiveValues.minimumTouchTarget, 48.0);
      expect(MaterialResponsiveValues.minimumPointerTarget, 44.0);
      expect(MaterialResponsiveValues.bottomSheetMaxWidth, 640.0);
      expect(MaterialResponsiveValues.dialogMinWidth, 280.0);
      expect(MaterialResponsiveValues.dialogMaxWidth, 560.0);
      expect(MaterialResponsiveValues.searchBarHeight, 56.0);
      expect(MaterialResponsiveValues.snackbarCompactMinHeight, 48.0);
      expect(MaterialResponsiveValues.progressCircularMaxSize, 240.0);
      expect(MaterialResponsiveValues.carouselCompactMaxTextItems, 3);
      expect(MaterialResponsiveValues.navigationDrawerWidth, 360.0);
      expect(MaterialResponsiveValues.navigationDrawerIndicatorWidth, 336.0);
      expect(MaterialResponsiveValues.navigationDrawerIndicatorHeight, 56.0);
      expect(MaterialResponsiveValues.navigationDrawerIndicatorPadding, 12.0);
    });
  });

  group('MaterialResponsiveValue', () {
    test('resolves Material window class boundaries', () {
      final provider = MaterialResponsiveValue();

      expect(provider.getScreenSize(599), MaterialWindowSizeClass.compact);
      expect(provider.getScreenSize(600), MaterialWindowSizeClass.medium);
      expect(provider.getScreenSize(839), MaterialWindowSizeClass.medium);
      expect(provider.getScreenSize(840), MaterialWindowSizeClass.expanded);
      expect(provider.getScreenSize(1199), MaterialWindowSizeClass.expanded);
      expect(provider.getScreenSize(1200), MaterialWindowSizeClass.large);
      expect(provider.getScreenSize(1599), MaterialWindowSizeClass.large);
      expect(provider.getScreenSize(1600), MaterialWindowSizeClass.extraLarge);
    });

    test('provides expected values for each window class', () {
      final provider = MaterialResponsiveValue();

      expect(
        provider.getScreenSizeValue(
          screenSize: MaterialWindowSizeClass.compact,
        ),
        const MaterialResponsiveValues(
          pageMargin: 16,
          paneSpacing: 24,
          recommendedPaneCount: 1,
          maxPaneCount: 1,
          minimumPaneWidth: 280,
          singlePaneMaxWidth: 720,
        ),
      );
      expect(
        provider.getScreenSizeValue(screenSize: MaterialWindowSizeClass.medium),
        const MaterialResponsiveValues(
          pageMargin: 24,
          paneSpacing: 24,
          recommendedPaneCount: 1,
          maxPaneCount: 2,
          minimumPaneWidth: 280,
          singlePaneMaxWidth: 720,
        ),
      );
      expect(
        provider.getScreenSizeValue(
          screenSize: MaterialWindowSizeClass.expanded,
        ),
        const MaterialResponsiveValues(
          pageMargin: 24,
          paneSpacing: 24,
          recommendedPaneCount: 2,
          maxPaneCount: 2,
          minimumPaneWidth: 360,
          singlePaneMaxWidth: 720,
          fixedPaneWidth: 360,
        ),
      );
      expect(
        provider.getScreenSizeValue(screenSize: MaterialWindowSizeClass.large),
        const MaterialResponsiveValues(
          pageMargin: 24,
          paneSpacing: 24,
          recommendedPaneCount: 2,
          maxPaneCount: 2,
          minimumPaneWidth: 412,
          singlePaneMaxWidth: 720,
          fixedPaneWidth: 412,
          sideSheetMaxWidth: 400,
        ),
      );
      expect(
        provider.getScreenSizeValue(
          screenSize: MaterialWindowSizeClass.extraLarge,
        ),
        const MaterialResponsiveValues(
          pageMargin: 24,
          paneSpacing: 24,
          recommendedPaneCount: 3,
          maxPaneCount: 3,
          minimumPaneWidth: 412,
          singlePaneMaxWidth: 720,
          fixedPaneWidth: 412,
          sideSheetMaxWidth: 400,
        ),
      );
    });

    test('uses provided breakpoints for layout resolution', () {
      final provider = MaterialResponsiveValue(
        breakpoints: const MaterialBreakpoints(
          extraLarge: 1800,
          large: 1400,
          expanded: 1000,
          medium: 700,
        ),
      );

      final values = provider.getLayoutSizeValue(
        constraints: const BoxConstraints(maxWidth: 980, maxHeight: 1200),
      );

      expect(values.recommendedPaneCount, 1);
      expect(values.maxPaneCount, 2);
    });
  });

  group('MaterialResponsiveSize', () {
    testWidgets('exposes Material breakpoint and responsive values', (
      tester,
    ) async {
      late MaterialWindowSizeClass breakpoint;
      late MaterialResponsiveValues values;

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1600, 1000),
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

      expect(breakpoint, MaterialWindowSizeClass.extraLarge);
      expect(values.recommendedPaneCount, 3);
      expect(values.sideSheetMaxWidth, 400);
    });

    testWidgets('uses shortest side classification when requested', (
      tester,
    ) async {
      late MaterialWindowSizeClass breakpoint;

      const breakpoints = MaterialBreakpoints(
        extraLarge: 900,
        large: 700,
        expanded: 500,
        medium: 300,
      );

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(640, 280),
        withScaffold: false,
        child: MaterialResponsiveSize(
          breakpoints: breakpoints,
          useShortestSide: true,
          child: Builder(
            builder: (context) {
              breakpoint = ScreenSizeModelWithValue.breakpointOf<
                  MaterialWindowSizeClass>(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(breakpoint, MaterialWindowSizeClass.compact);
    });

    testWidgets('uses explicit valueProvider when provided', (tester) async {
      late MaterialResponsiveValues values;

      final valueProvider = _TestMaterialResponsiveValueProvider(
        breakpoints: MaterialBreakpoints.defaultBreakpoints,
      );

      await pumpHarnessApp(
        tester: tester,
        addTearDown: addTearDown,
        customSize: const Size(1600, 1000),
        withScaffold: false,
        child: MaterialResponsiveSize(
          valueProvider: valueProvider,
          child: Builder(
            builder: (context) {
              values = ScreenSizeModelWithValue.responsiveValueOf<
                  MaterialWindowSizeClass, MaterialResponsiveValues>(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(values.pageMargin, 101);
      expect(values.recommendedPaneCount, 9);
    });
  });

  group('MaterialResponsiveWidgetBuilder', () {
    testWidgets('uses sparse builders with smaller-size fallback', (
      tester,
    ) async {
      final cases = [
        (size: const Size(390, 800), expected: 'compact compact 16.0'),
        (size: const Size(700, 900), expected: 'medium medium 24.0'),
        (size: const Size(1000, 900), expected: 'medium expanded 24.0'),
        (size: const Size(1366, 900), expected: 'large large 24.0'),
        (size: const Size(1680, 900), expected: 'large extraLarge 24.0'),
      ];

      for (final item in cases) {
        await pumpHarnessApp(
          tester: tester,
          addTearDown: addTearDown,
          customSize: item.size,
          withScaffold: false,
          child: MaterialResponsiveSize(
            child: MaterialResponsiveWidgetBuilder(
              compact: (context, data) => Text(
                'compact ${data.screenSize.name} ${data.responsiveValue.pageMargin}',
              ),
              medium: (context, data) => Text(
                'medium ${data.screenSize.name} ${data.responsiveValue.pageMargin}',
              ),
              large: (context, data) => Text(
                'large ${data.screenSize.name} ${data.responsiveValue.pageMargin}',
              ),
            ),
          ),
        );

        expect(find.text(item.expected), findsOneWidget);
        await unmountHarnessApp(tester: tester, withScaffold: false);
      }
    });
  });
}

class _TestMaterialResponsiveValueProvider extends MaterialResponsiveValue {
  _TestMaterialResponsiveValueProvider({
    required super.breakpoints,
  })  : _values = const {
          MaterialWindowSizeClass.extraLarge: MaterialResponsiveValues(
            pageMargin: 101,
            paneSpacing: 21,
            recommendedPaneCount: 9,
            maxPaneCount: 9,
            minimumPaneWidth: 901,
            singlePaneMaxWidth: 701,
          ),
          MaterialWindowSizeClass.large: MaterialResponsiveValues(
            pageMargin: 102,
            paneSpacing: 22,
            recommendedPaneCount: 8,
            maxPaneCount: 8,
            minimumPaneWidth: 902,
            singlePaneMaxWidth: 702,
          ),
          MaterialWindowSizeClass.expanded: MaterialResponsiveValues(
            pageMargin: 103,
            paneSpacing: 23,
            recommendedPaneCount: 7,
            maxPaneCount: 7,
            minimumPaneWidth: 903,
            singlePaneMaxWidth: 703,
          ),
          MaterialWindowSizeClass.medium: MaterialResponsiveValues(
            pageMargin: 104,
            paneSpacing: 24,
            recommendedPaneCount: 6,
            maxPaneCount: 6,
            minimumPaneWidth: 904,
            singlePaneMaxWidth: 704,
          ),
          MaterialWindowSizeClass.compact: MaterialResponsiveValues(
            pageMargin: 105,
            paneSpacing: 25,
            recommendedPaneCount: 5,
            maxPaneCount: 5,
            minimumPaneWidth: 905,
            singlePaneMaxWidth: 705,
          ),
        },
        super();

  final Map<MaterialWindowSizeClass, MaterialResponsiveValues?> _values;

  @override
  Map<MaterialWindowSizeClass, MaterialResponsiveValues?> get values => _values;
}
