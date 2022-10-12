import 'dart:math';

import 'package:flutter/material.dart';
import '../../constants/enums/view-enums/sizes.dart';

/// Extensions for responsive ui designs with context.
extension ResponsivenessExtensions on BuildContext {
  MediaQueryData get _mediaQuery => MediaQuery.of(this);

  /// Top padding of the screen.
  double get screenTopPadding => _mediaQuery.viewPadding.top;

  /// One percent of the screen height, in terms of logical pixels.
  double get height => _mediaQuery.size.height * 0.01;

  /// One percent of the screen width, in terms of logical pixels.
  double get width => _mediaQuery.size.width * 0.01;

  /// Provides responsive base size value by using default 16/9 ratio.
  double get responsiveSize =>
      min(height * 16, width * 9) / (isLandscape ? 24 : 12);

  /// Customized extreme low height value.
  double get extremeLowHeight => height * .8;

  /// Customized extreme low width value.
  double get extremeLowWidth => width * 1;

  /// Customized low height value.
  double get lowHeight => height * 1.6;

  /// Customized low width value.
  double get lowWidth => width * 2;

  /// Customized low-medium height value.
  double get lowMedHeight => height * 2.5;

  /// Customized low-medium width value.
  double get lowMedWidth => width * 3.2;

  /// Customized medium height value.
  double get medHeight => height * 4;

  /// Customized medium width value.
  double get medWidth => width * 5;

  /// Customized medium-high height value.
  double get medHighHeight => height * 7;

  /// Customized medium-high width value.
  double get medHighWidth => width * 7;

  /// Customized high height value.
  double get highHeight => height * 10;

  /// Customized high width value.
  double get highWidth => width * 10;

  /// Returns padding from all edges acc. to the given [sizeType].
  EdgeInsets allPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.all(
        sizedValues[0] < sizedValues[1] ? sizedValues[0] : sizedValues[1]);
  }

  /// Returns padding from vertical edges acc. to the given [sizeType].
  EdgeInsets verticalPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.symmetric(vertical: sizedValues[1]);
  }

  /// Returns padding from horizontal edges acc. to the given [sizeType].
  EdgeInsets horizontalPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.symmetric(horizontal: sizedValues[0]);
  }

  /// Returns padding from the left edge acc. to the given [sizeType].
  EdgeInsets leftPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(left: sizedValues[0]);
  }

  /// Returns padding from the right edge acc. to the given [sizeType].
  EdgeInsets rightPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(right: sizedValues[0]);
  }

  /// Returns padding from the top edge acc. to the given [sizeType].
  EdgeInsets topPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(top: sizedValues[1]);
  }

  /// Returns padding from the bottom edge acc. to the given [sizeType].
  EdgeInsets bottomPadding(Sizes sizeType) {
    final List<double> sizedValues = _getSizedValue(sizeType);
    return EdgeInsets.only(bottom: sizedValues[1]);
  }

  /// Returns a responsive horizontal [SizedBox] to give space.
  SizedBox sizedW(double factor) => SizedBox(width: width * factor);

  /// Returns a responsive vertical [SizedBox] to give space.
  SizedBox sizedH(double factor) => SizedBox(height: height * factor);

  /// Returns a responsive horizontal [SizedBox] to give space.
  SizedBox sizedWR(double factor) => SizedBox(width: responsiveSize * factor);

  /// Returns a responsive vertical [SizedBox] to give space.
  SizedBox sizedHR(double factor) => SizedBox(height: responsiveSize * factor);

  List<double> _getSizedValue(Sizes sizeType) {
    late double horizontalValue;
    late double verticalValue;
    switch (sizeType) {
      case Sizes.extremeLow:
        horizontalValue = extremeLowWidth;
        verticalValue = extremeLowHeight;
        break;
      case Sizes.low:
        horizontalValue = lowWidth;
        verticalValue = lowHeight;
        break;
      case Sizes.lowMed:
        horizontalValue = lowMedWidth;
        verticalValue = lowMedHeight;
        break;
      case Sizes.med:
        horizontalValue = medWidth;
        verticalValue = medHeight;
        break;
      case Sizes.medHigh:
        horizontalValue = medHighWidth;
        verticalValue = medHighHeight;
        break;
      case Sizes.high:
        horizontalValue = highWidth;
        verticalValue = highHeight;
        break;
    }
    return <double>[horizontalValue, verticalValue];
  }

  /// Maximum possible height for the screen.
  double get maxPossibleHeight => _mediaQuery.size.height;

  /// Maximum possible width for the screen.
  double get maxPossibleWidth => _mediaQuery.size.width;

  /// Checks whether the screen is in landscape mode.
  bool get isLandscape => height / width < 1.05;
}
