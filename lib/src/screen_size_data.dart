import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSize<K extends Enum> extends StatelessWidget {
  const ScreenSize({
    required this.breakpoints,
    required this.child,
    super.key,
  });
  final Widget child;
  final BaseBreakpoints<K> breakpoints;
  @override
  Widget build(BuildContext context) {
    return ScreenSizeData<K>(
      notifier: ScreenSizeDataChangeNotifier<K>(
        breakpoints: breakpoints,
      ),
      child: ScreenSizeModelWidget<K>(
        child: child,
      ),
    );
  }
}

class ScreenSizeModelWidget<T extends Enum> extends StatelessWidget {
  const ScreenSizeModelWidget({required this.child, super.key});
  final Widget child;

  ScreenSizeModelData<K> _of<K extends Enum>(
    BuildContext context,
  ) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ScreenSizeData<K>>();

    assert(
      result != null,
      'ScreenSizeData was not found in the widget tree. Make sure to wrap your widget tree with a ScreenSizeData.',
    );

    return result!.notifier!.data;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSizeModel<T>(
      data: _of<T>(context),
      child: child,
    );
  }
}

class ScreenSizeDataChangeNotifier<K extends Enum> extends ChangeNotifier
    with WidgetsBindingObserver {
  ScreenSizeDataChangeNotifier({
    required this.breakpoints,
    bool useShortestSide = false,
    // testView is only used for testing
    this.testView,
  }) : _useShortestSide = useShortestSide {
    updateMetrics();
    init();
  }
  late ScreenSizeModelData<K>? _data;

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  final FlutterView? testView;

  final BaseBreakpoints<K> breakpoints;

  ScreenSizeModelData<K> get data => _data!;

  bool _useShortestSide;

  bool get useShortestSide => _useShortestSide;

  void setUseShortestSide({required bool value}) {
    _useShortestSide = value;
    updateMetrics();
    notifyListeners();
  }

  @override
  void didChangeMetrics() {
    updateMetrics();
  }

  void updateMetrics() {
    // Get the current view or the first platform view if testView is null
    final view =
        testView ?? WidgetsBinding.instance.platformDispatcher.views.first;

    final physicalWidth = view.physicalSize.width;
    final physicalHeight = view.physicalSize.height;
    final devicePixelRatio = view.devicePixelRatio;
    final screenWidth = physicalWidth / devicePixelRatio;
    final screenHeight = physicalHeight / devicePixelRatio;

    final shortestSideDimension =
        screenWidth < screenHeight ? screenWidth : screenHeight;

    final screenSize = _getScreenSize(screenWidth);
    final screenSizeShortestSide = _getScreenSize(shortestSideDimension);

    _data = ScreenSizeModelData(
      breakpoints: breakpoints,
      currentBreakpoint: breakpoints.values[screenSize]!,
      screenSize: screenSize,
      screenSizeShortestSide: screenSizeShortestSide,
      physicalWidth: physicalWidth,
      physicalHeight: physicalHeight,
      devicePixelRatio: devicePixelRatio,
      logicalScreenWidth: screenWidth,
      logicalScreenHeight: screenHeight,
    );

    notifyListeners();
  }

  /// Returns the screen size based on the given size.
  K _getScreenSize(double size) {
    final entries = breakpoints.values.entries;
    for (final entry in entries) {
      if (size >= entry.value) {
        return entry.key;
      }
    }

    return entries.last.key;
  }
}

@immutable
class ScreenSizeModelData<K extends Enum> {
  const ScreenSizeModelData({
    required this.breakpoints,
    required this.currentBreakpoint,
    required this.screenSize,
    required this.screenSizeShortestSide,
    required this.physicalWidth,
    required this.physicalHeight,
    required this.devicePixelRatio,
    required this.logicalScreenWidth,
    required this.logicalScreenHeight,
  });
  final BaseBreakpoints<K> breakpoints;
  final double currentBreakpoint;
  final K screenSize;
  final K screenSizeShortestSide;
  final double physicalWidth;
  final double physicalHeight;
  final double devicePixelRatio;
  final double logicalScreenWidth;
  final double logicalScreenHeight;
}

enum ScreenSizeAspect {
  screenSize,
  other,
}

class ScreenSizeModel<T extends Enum> extends InheritedModel<ScreenSizeAspect> {
  const ScreenSizeModel({
    required super.child,
    required this.data,
    super.key,
  });

  final ScreenSizeModelData<T> data;

  @override
  bool updateShouldNotify(ScreenSizeModel oldWidget) {
    return data != oldWidget.data;
  }

  static ScreenSizeModelData<K> screenSizeOf<K extends Enum>(
    BuildContext context,
  ) {
    return InheritedModel.inheritFrom<ScreenSizeModel<K>>(
      context,
      aspect: ScreenSizeAspect.screenSize,
    )!
        .data;
  }

  @override
  bool updateShouldNotifyDependent(
    ScreenSizeModel<T> oldWidget,
    Set<ScreenSizeAspect> dependencies,
  ) {
    if (oldWidget.data.screenSize != data.screenSize &&
        dependencies.contains(ScreenSizeAspect.screenSize)) {
      return true;
    } else if (oldWidget.data != data &&
        dependencies.contains(ScreenSizeAspect.other)) {
      return true;
    }

    return false;
  }
}

class ScreenSizeData<K extends Enum>
    extends InheritedNotifier<ScreenSizeDataChangeNotifier<K>> {
  const ScreenSizeData({
    required ScreenSizeDataChangeNotifier<K> super.notifier,
    required super.child,
    super.key,
  });

// Should probably make this a porivate method of ScreenSizeModelWidget so the value here
// isnt exposed to the tree
  static ScreenSizeModelData<K> of<K extends Enum>(
    BuildContext context,
  ) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ScreenSizeData<K>>();

    assert(
      result != null,
      'ScreenSizeData was not found in the widget tree. Make sure to wrap your widget tree with a ScreenSizeData.',
    );

    return result!.notifier!.data;
  }

  @override
  bool updateShouldNotify(
    covariant InheritedNotifier<ScreenSizeDataChangeNotifier> oldWidget,
  ) {
    return oldWidget.notifier?.data != notifier?.data;
  }
}
