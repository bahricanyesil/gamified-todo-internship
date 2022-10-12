import 'package:flutter/material.dart';
import 'border_radii.dart';

/// Various constant [ShapedBorders] values to use across the app.
class ShapedBorders {
  /// Low rounded rectangle shaped border. Radius: 10.
  static const RoundedRectangleBorder roundedLow =
      RoundedRectangleBorder(borderRadius: BorderRadii.lowCircular);

  /// Low-Medium rounded rectangle shaped border. Radius: 14.
  static const RoundedRectangleBorder roundedLowMed =
      RoundedRectangleBorder(borderRadius: BorderRadii.lowMedCircular);

  /// Medium rounded rectangle shaped border. Radius: 18.
  static const RoundedRectangleBorder roundedMedium =
      RoundedRectangleBorder(borderRadius: BorderRadii.mediumCircular);

  /// Medium-High rounded rectangle shaped border. Radius: 23.
  static const RoundedRectangleBorder roundedMedHigh =
      RoundedRectangleBorder(borderRadius: BorderRadii.medHighCircular);

  /// High rounded rectangle shaped border. Radius: 26.
  static const RoundedRectangleBorder roundedHigh =
      RoundedRectangleBorder(borderRadius: BorderRadii.highCircular);

  /// Extremely rounded rectangle shaped border. Radius: 30.
  static const RoundedRectangleBorder roundedExtreme =
      RoundedRectangleBorder(borderRadius: BorderRadii.extremeCircular);
}
