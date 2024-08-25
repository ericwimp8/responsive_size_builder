import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSize<K extends Enum> extends StatelessWidget {
  const ScreenSize({
    required this.child,
    required this.breakpoints,
    required this.view,
    super.key,
  });
  final Widget child;
  final BaseBreakpoints<K> breakpoints;
  final FlutterView view;
  @override
  Widget build(BuildContext context) {
    return MediaQuery.fromView(
      view: view,
      child: ScreenSizeModelWidget<K>(
        breakpoints: breakpoints,
        view: view,
        child: child,
      ),
    );
  }
}

class ScreenSizeModelWidget<T extends Enum> extends StatelessWidget {
  const ScreenSizeModelWidget({
    required this.breakpoints,
    required this.child,
    required this.view,
    super.key,
  });
  final Widget child;
  final BaseBreakpoints<T> breakpoints;
  final FlutterView view;

  /// Returns the screen size based on the given size.
  T _getScreenSize(double size) {
    final entries = breakpoints.values.entries;
    for (final entry in entries) {
      if (size >= entry.value) {
        return entry.key;
      }
    }

    return entries.last.key;
  }

  ScreenSizeModelData<T> updateMetrics(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = _getScreenSize(size.width);
    final screenSizeShortestSide = _getScreenSize(size.shortestSide);

    return ScreenSizeModelData(
      breakpoints: breakpoints,
      currentBreakpoint: breakpoints.values[screenSize]!,
      screenSize: screenSize,
      screenSizeShortestSide: screenSizeShortestSide,
      physicalWidth: view.physicalSize.width,
      physicalHeight: view.physicalSize.height,
      devicePixelRatio: view.devicePixelRatio,
      logicalScreenWidth: size.width,
      logicalScreenHeight: size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSizeModel<T>(
      data: updateMetrics(context),
      child: child,
    );
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
