import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_size_builder/responsive_size_builder.dart';

class ScreenSize<T extends Enum> extends StatefulWidget {
  const ScreenSize({
    required this.breakpoints,
    required this.child,
    this.testView,
    this.useShortestSide = false,
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
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final orientation = mq.orientation;
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
      orientation: orientation,
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
    final shouldUpdate = data != oldWidget.data;
    return shouldUpdate;
  }

  static ScreenSizeModelData<K> of<K extends Enum>(
    BuildContext context,
  ) {
    final model = InheritedModel.inheritFrom<ScreenSizeModel<K>>(context);
    if (model == null) {
      throw FlutterError('''
ScreenSizeModel<$K> not found. Please ensure that:
1. Your application or relevant subtree is wrapped in a ScreenSize widget 
   (e.g., ScreenSize<LayoutSize>(...) or ScreenSize<LayoutSizeGranular>(...)).
2. You are requesting the correct type parameter <$K>.

The context used to look up ScreenSizeModel was:
  $context
''');
    }
    return model.data;
  }

  static K screenSizeOf<K extends Enum>(
    BuildContext context,
  ) {
    final model = InheritedModel.inheritFrom<ScreenSizeModel<K>>(
      context,
      aspect: ScreenSizeAspect.screenSize,
    );
    if (model == null) {
      throw FlutterError('''
ScreenSizeModel<$K> not found, please ensure that the app is wrapped in ScreenSize and 
the appropriate builder widget is being used.
ScreenSize<LayoutSizeGranular> will require ScreenSizeBuilderGranularGranular
ScreenSize<LayoutSize> will require ScreenSizeBuilderGranular
''');
    }

    return model.data.screenSize;
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
    required this.orientation,
  });

  final BaseBreakpoints<K> breakpoints;

  final double currentBreakpoint;

  final K screenSize;

  final double physicalWidth;

  final double physicalHeight;

  final double devicePixelRatio;

  final double logicalScreenWidth;

  final double logicalScreenHeight;

  final Orientation orientation;

  bool get isDesktopDevcie => kIsDesktopDevice;

  bool get isTouchDevice => kIsTouchDevice;

  bool get isWeb => kIsWeb;

  @override
  String toString() {
    return 'ScreenSizeModelData(breakpoints: $breakpoints, currentBreakpoint: $currentBreakpoint, screenSize: $screenSize, physicalWidth: $physicalWidth, physicalHeight: $physicalHeight, devicePixelRatio: $devicePixelRatio, logicalScreenWidth: $logicalScreenWidth, logicalScreenHeight: $logicalScreenHeight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScreenSizeModelData<K> &&
        other.breakpoints == breakpoints &&
        other.currentBreakpoint == currentBreakpoint &&
        other.screenSize == screenSize &&
        other.physicalWidth == physicalWidth &&
        other.physicalHeight == physicalHeight &&
        other.devicePixelRatio == devicePixelRatio &&
        other.logicalScreenWidth == logicalScreenWidth &&
        other.logicalScreenHeight == logicalScreenHeight &&
        other.orientation == orientation;
  }

  @override
  int get hashCode {
    return Object.hash(
      breakpoints,
      currentBreakpoint,
      screenSize,
      physicalWidth,
      physicalHeight,
      devicePixelRatio,
      logicalScreenWidth,
      logicalScreenHeight,
      orientation,
    );
  }
}

enum ScreenSizeAspect {
  screenSize,

  other,
}
