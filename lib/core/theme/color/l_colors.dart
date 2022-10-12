import 'package:flutter/material.dart';

/// Abstract class to determine the colors across the app.
abstract class IColors {
  /// Default constructor for [IColors] class.
  const IColors({
    required this.scaffoldBackgroundColor,
    required this.appBarColor,
    required this.tabBarColor,
    required this.tabbarSelectedColor,
    required this.tabbarNormalColor,
    required this.disabledColor,
    required this.highlightColor,
    required this.dividerColor,
    required this.primaryColorLight,
    required this.primaryColorDark,
    required this.brightness,
    required this.colorScheme,
    this.secondaryColorDark,
    this.secondaryColorLight,
  });

  /// Background color of the scaffold.
  final Color scaffoldBackgroundColor;

  /// Color of the app bar.
  final Color appBarColor;

  /// Color of the tab bar.
  final Color tabBarColor;

  /// Color of the selected tab bar.
  final Color tabbarSelectedColor;

  /// Normal color of the tab bar.
  final Color tabbarNormalColor;

  /// Color to indicate disabled items.
  final Color disabledColor;

  /// Higlighted item color.
  final Color highlightColor;

  /// Divider color.
  final Color dividerColor;

  /// Light version of the primary color.
  final Color primaryColorLight;

  /// Dark version of the primary color.
  final Color primaryColorDark;

  /// Light version of the secondary color.
  final Color? secondaryColorLight;

  /// Dark version of the secondary color.
  final Color? secondaryColorDark;

  /// Brigtness of the theme.
  final Brightness brightness;

  /// Color scheme to be used across the app.
  final ColorScheme colorScheme;
}

/// Specific colors to use across the app.
@immutable
class AppColors {
  /// White color.
  static const Color primaryColor = Color(0xff668cff);

  /// White color.
  static const Color white = Color(0xfff5f5f5);

  /// White color.
  static const Color black = Color(0xff0d0d0d);

  /// Green color.
  static const Color green = Color(0xff00b33c);

  /// Medium grey color.
  static const Color mediumGrey = Color(0xffa6bcd0);

  /// Medium bold grey color.
  static const Color mediumGreyBold = Color(0xff748a9d);

  /// Light grey color.
  static const Color lightGrey = Color(0xffdbe2ed);

  /// Dark grey color.
  static const Color darkGrey = Color(0xff4e5d6a);

  /// Error color.
  static const Color error = Color(0xffff3333);

  /// Color for loading bubbles.
  static const Color loadingColor = Color(0xff708edf);

  /// High prioritized task color.
  static const Color highPriority = Color(0xfff47174);

  /// Medium prioritized task color.
  static const Color medPriority = Color(0xffe7e765);

  /// Low prioritized task color.
  static const Color lowPriority = Color(0xffacd1af);
}
