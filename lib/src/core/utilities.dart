import 'package:flutter/foundation.dart';

/// True when the current [defaultTargetPlatform] is a desktop platform
/// (Windows, macOS or Linux).
bool kIsDesktopDevice = [
  TargetPlatform.windows,
  TargetPlatform.macOS,
  TargetPlatform.linux,
].contains(defaultTargetPlatform);

/// True when the current [defaultTargetPlatform] is a mobile/touch platform
/// (Android or iOS).
bool kIsTouchDevice = [
  TargetPlatform.android,
  TargetPlatform.iOS,
].contains(defaultTargetPlatform);
