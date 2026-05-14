import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../core/test_harness_defaults.dart';

void configureTestView({
  required WidgetTester tester,
  required TearDownRegistrar addTearDown,
  TestViewportPreset preset = TestViewportPreset.desktop,
  Size? customSize,
  double devicePixelRatio = TestHarnessDefaults.devicePixelRatio,
  bool configureSpellCheck = true,
}) {
  tester.view.devicePixelRatio = devicePixelRatio;
  tester.view.physicalSize = customSize ?? TestHarnessDefaults.sizeFor(preset);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  if (configureSpellCheck) {
    tester.binding.platformDispatcher.nativeSpellCheckServiceDefinedTestValue =
        true;
    addTearDown(
      tester.binding.platformDispatcher.clearNativeSpellCheckServiceDefined,
    );
  }
}

Widget buildHarnessApp({
  required Widget child,
  Locale locale = TestHarnessDefaults.locale,
  ThemeData? theme,
  bool withScaffold = true,
}) {
  final body = withScaffold ? Scaffold(body: child) : child;

  return MaterialApp(
    locale: locale,
    theme: theme ?? TestHarnessDefaults.theme(),
    home: body,
  );
}

Future<void> pumpHarnessApp({
  required WidgetTester tester,
  required Widget child,
  required TearDownRegistrar addTearDown,
  TestViewportPreset preset = TestViewportPreset.desktop,
  Size? customSize,
  bool withScaffold = true,
  bool settle = true,
  int settleTimeoutMs = 5000,
}) async {
  configureTestView(
    tester: tester,
    addTearDown: addTearDown,
    preset: preset,
    customSize: customSize,
  );

  await tester.pumpWidget(
    buildHarnessApp(
      child: child,
      withScaffold: withScaffold,
    ),
  );

  if (settle) {
    await _pumpUntilSettled(
      tester: tester,
      settleTimeoutMs: settleTimeoutMs,
    );
  } else {
    await tester.pump();
  }
}

Future<void> unmountHarnessApp({
  required WidgetTester tester,
  bool withScaffold = true,
  int pumpCount = 2,
}) async {
  await tester.pumpWidget(
    buildHarnessApp(
      withScaffold: withScaffold,
      child: const SizedBox.shrink(),
    ),
  );

  for (var i = 0; i < pumpCount; i++) {
    await tester.pump();
  }
}

Future<void> _pumpUntilSettled({
  required WidgetTester tester,
  required int settleTimeoutMs,
}) async {
  final timeoutAt = DateTime.now().add(Duration(milliseconds: settleTimeoutMs));

  while (true) {
    await tester.pump(const Duration(milliseconds: 16));

    if (!tester.binding.hasScheduledFrame) {
      return;
    }

    if (DateTime.now().isAfter(timeoutAt)) {
      throw StateError(
        'pumpHarnessApp settle timed out after ${settleTimeoutMs}ms',
      );
    }
  }
}
