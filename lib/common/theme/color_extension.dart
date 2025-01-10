import 'package:flutter/material.dart';

const _LUMINANCE_THRESHOLD = 0.5;

extension ColorExtension on Color {
  Color getForegroundColorDependingOnBackground({double luminanceThreshold = _LUMINANCE_THRESHOLD}) =>
      computeLuminance() > luminanceThreshold ? Colors.black87 : Colors.white;
}
