import 'package:flutter/foundation.dart';

/// Whether the current [defaultTargetPlatform] is a desktop platform:
/// Windows, macOS, or Linux.
bool kIsDesktopDevice = [
  TargetPlatform.windows,
  TargetPlatform.macOS,
  TargetPlatform.linux,
].contains(defaultTargetPlatform);

/// Whether the current [defaultTargetPlatform] is a touch platform: Android
/// or iOS.
bool kIsTouchDevice = [
  TargetPlatform.android,
  TargetPlatform.iOS,
].contains(defaultTargetPlatform);
