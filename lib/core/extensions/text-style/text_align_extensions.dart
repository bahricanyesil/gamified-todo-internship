import 'package:flutter/material.dart';

/// Text align extensions.
extension TextAlignExtensions on TextAlign {
  /// Returns corresponding [Alignment] for [TextAlign].
  Alignment get alignment {
    switch (this) {
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.end:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }
}
