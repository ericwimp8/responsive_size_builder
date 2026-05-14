import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens MaterialResponsiveSize example', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Responsive Size Builder Examples'), findsOneWidget);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed('/material-responsive-size');
    await tester.pumpAndSettle();

    expect(find.text('Material 3 preset'), findsOneWidget);
    expect(find.text('Window class'), findsOneWidget);
    expect(find.text('Page margin'), findsOneWidget);
  });
}
