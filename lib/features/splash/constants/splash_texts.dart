import 'package:flutter/material.dart';
import '../view/splash_screen.dart';

/// Collection of texts in the [SplashScreen].
mixin SplashTexts on State<SplashScreen> {
  /// Error text will be displayed on any error.
  static const String error =
      'Something unexpected happened.\nClick below button to retry.';

  /// Text of the reply button.
  static const String retry = 'Retry';
}
