library;

import 'package:flutter/foundation.dart';

bool kIsDesktopDevice = [
  TargetPlatform.windows,
  TargetPlatform.macOS,
  TargetPlatform.linux,
].contains(defaultTargetPlatform);

bool kIsTouchDevice = [
  TargetPlatform.android,
  TargetPlatform.iOS,
].contains(defaultTargetPlatform);
