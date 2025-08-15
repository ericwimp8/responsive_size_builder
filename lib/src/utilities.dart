/// Utility constants for platform detection in responsive layout building.
///
/// This library provides platform-specific boolean constants that help determine
/// the device type at compile time, enabling responsive layouts and
/// platform-specific behavior in Flutter applications.
library;

import 'package:flutter/foundation.dart';

/// Whether the current platform is a desktop device.
///
/// Returns `true` if the app is running on Windows, macOS, or Linux platforms.
/// This constant can be used to apply desktop-specific layouts, behaviors,
/// or UI elements in responsive design implementations.
///
/// Example:
/// ```dart
/// if (kIsDesktopDevice) {
///   // Apply desktop-specific layout
///   return DesktopLayout();
/// }
/// ```
bool kIsDesktopDevice = [
  TargetPlatform.windows,
  TargetPlatform.macOS,
  TargetPlatform.linux,
].contains(defaultTargetPlatform);

/// Whether the current platform is a touch-enabled mobile device.
///
/// Returns `true` if the app is running on Android or iOS platforms.
/// This constant can be used to apply touch-specific layouts, gestures,
/// or UI elements optimized for mobile interaction patterns.
///
/// Example:
/// ```dart
/// if (kIsTouchDevice) {
///   // Apply mobile-specific touch interactions
///   return MobileLayout();
/// }
/// ```
bool kIsTouchDevice = [
  TargetPlatform.android,
  TargetPlatform.iOS,
].contains(defaultTargetPlatform);
