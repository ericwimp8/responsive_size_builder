import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSize<T extends Enum> extends StatefulWidget {
  const ScreenSize({
    required this.breakpoints,
    required this.child,
    this.testView,
    this.useShortestSide = true,
    super.key,
  });
  final Widget child;
  final BaseBreakpoints<T> breakpoints;
  final FlutterView? testView;
  final bool useShortestSide;
  @override
  State<ScreenSize<T>> createState() => _ScreenSizeState<T>();
}

class _ScreenSizeState<T extends Enum> extends State<ScreenSize<T>> {
  T _getScreenSize(double size) {
    final entries = widget.breakpoints.values.entries;
    for (final entry in entries) {
      if (size >= entry.value) {
        return entry.key;
      }
    }

    return entries.last.key;
  }

  ScreenSizeModelData<T> updateMetrics(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenSize = widget.useShortestSide
        ? _getScreenSize(size.shortestSide)
        : _getScreenSize(size.width);

    return ScreenSizeModelData(
      breakpoints: widget.breakpoints,
      currentBreakpoint: widget.breakpoints.values[screenSize]!,
      screenSize: screenSize,
      physicalWidth: view.physicalSize.width,
      physicalHeight: view.physicalSize.height,
      devicePixelRatio: view.devicePixelRatio,
      logicalScreenWidth: size.width,
      logicalScreenHeight: size.height,
    );
  }

  late final view =
      widget.testView ?? WidgetsBinding.instance.platformDispatcher.views.first;

  @override
  Widget build(BuildContext context) {
    return ScreenSizeModel<T>(
      data: updateMetrics(context),
      child: widget.child,
    );
  }
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

@immutable
class ScreenSizeModelData<K extends Enum> {
  const ScreenSizeModelData({
    required this.breakpoints,
    required this.currentBreakpoint,
    required this.screenSize,
    required this.physicalWidth,
    required this.physicalHeight,
    required this.devicePixelRatio,
    required this.logicalScreenWidth,
    required this.logicalScreenHeight,
  });
  final BaseBreakpoints<K> breakpoints;
  final double currentBreakpoint;
  final K screenSize;
  final double physicalWidth;
  final double physicalHeight;
  final double devicePixelRatio;
  final double logicalScreenWidth;
  final double logicalScreenHeight;

  @override
  String toString() {
    return 'ScreenSizeModelData(breakpoints: $breakpoints, currentBreakpoint: $currentBreakpoint, screenSize: $screenSize, physicalWidth: $physicalWidth, physicalHeight: $physicalHeight, devicePixelRatio: $devicePixelRatio, logicalScreenWidth: $logicalScreenWidth, logicalScreenHeight: $logicalScreenHeight)';
  }
}

enum ScreenSizeAspect {
  screenSize,
  other,
}
