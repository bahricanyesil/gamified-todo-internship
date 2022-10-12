import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme/theme_provider.dart';
import 'responsiveness_extensions.dart';

/// Theme extension for easy use with context.
extension ThemeExtension on BuildContext {
  /// Current theme of the app.
  ThemeData get theme => watch<ThemeProvider>().currentTheme;

  /// Primary color of the theme.
  Color get primaryColor => theme.primaryColor;

  /// Accent/Secondary color of the theme.
  Color get secondaryColor => theme.colorScheme.secondary;

  /// Canvas color of the theme.
  Color get canvasColor => theme.canvasColor.withOpacity(.85);

  /// Error color of the theme.
  Color get errorColor => theme.errorColor;

  /// Primary Light color color of the theme.
  Color get primaryLightColor => theme.primaryColorLight;

  /// Primary Dark color of the theme.
  Color get primaryDarkColor => theme.primaryColorDark;

  /// Headline1 text style for very large texts.
  TextStyle get headline1 => _getStyle(theme.textTheme.headline1);

  /// Headline1 text style for large texts.
  TextStyle get headline2 => _getStyle(theme.textTheme.headline2);

  /// Headline1 text style for medium-large texts.
  TextStyle get headline3 => _getStyle(theme.textTheme.headline3);

  /// Headline1 text style for medium-small texts.
  TextStyle get headline4 => _getStyle(theme.textTheme.headline4);

  /// Headline1 text style for small texts.
  TextStyle get headline5 => _getStyle(theme.textTheme.headline5);

  /// Headline1 text style for very small texts.
  TextStyle get headline6 => _getStyle(theme.textTheme.headline6);

  /// Large subtitle style.
  TextStyle get subtitle1 => _getStyle(theme.textTheme.subtitle1);

  /// Small subtitle style.
  TextStyle get subtitle2 => _getStyle(theme.textTheme.subtitle2);

  /// Large body text style.
  TextStyle get bodyText1 => _getStyle(theme.textTheme.bodyText1);

  /// Small body text style.
  TextStyle get bodyText2 => _getStyle(theme.textTheme.bodyText2);

  TextStyle _getStyle(TextStyle? style) {
    final TextStyle _style =
        style ?? TextStyle(color: Colors.black87, fontSize: responsiveSize);
    return isLandscape
        ? _style.copyWith(fontSize: pow(_style.fontSize ?? 15, 1.18) * 1)
        : _style;
  }
}
