import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../extensions/color/color_extensions.dart';

//// Collection of helper methods for [Color]s.
mixin ColorHelpers {
  /// Returns a random color
  Color get randomColor =>
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(.85);

  /// Returns a light random color.
  Color get lightRandomColor {
    final List<String> letters = 'ABCDEF'.split('');
    final StringBuffer buffer = StringBuffer('0xff');
    for (int i = 0; i < 6; i++) {
      buffer.write(letters[(math.Random().nextInt(letters.length)).floor()]);
    }
    return Color(int.parse(buffer.toString())).darken(.04);
  }
}
