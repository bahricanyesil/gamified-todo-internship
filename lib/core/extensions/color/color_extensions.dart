import 'package:flutter/material.dart';

/// Extensions for [Color] class
extension ColorExtensions on Color {
  /// Makes color more darker.
  Color darken([double amount = .2]) {
    assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');

    final HSLColor hsl = HSLColor.fromColor(this);
    final HSLColor hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Makes color more lighter.
  Color lighten([double amount = .2]) {
    assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');

    final HSLColor hsl = HSLColor.fromColor(this);
    final HSLColor hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}
