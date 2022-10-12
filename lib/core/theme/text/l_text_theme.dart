import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color/l_colors.dart';

/// Abstract class to determine the text theme across the app.
abstract class ITextTheme {
  /// Default constructor for [ITextTheme].
  const ITextTheme({
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  /// Primary text color.
  final Color primaryTextColor;

  /// Secondary text color.
  final Color secondaryTextColor;

  /// Font family of the text theme.
  String get fontFamily => GoogleFonts.poppins().fontFamily ?? 'Poppins';

  /// Complete [TextTheme] data.
  TextTheme get data => TextTheme(
        bodyText1: bodyText1.copyWith(color: primaryTextColor),
        bodyText2: bodyText2.copyWith(color: primaryTextColor),
        headline1: headline1.copyWith(color: primaryTextColor),
        headline2: headline2.copyWith(color: primaryTextColor),
        headline3: headline3.copyWith(color: primaryTextColor),
        headline4: headline4.copyWith(color: primaryTextColor),
        headline5: headline5.copyWith(color: primaryTextColor),
        headline6: headline6.copyWith(color: primaryTextColor),
        subtitle1: subtitle1.copyWith(color: primaryTextColor),
        subtitle2: subtitle2.copyWith(color: primaryTextColor),
      );

  /// Style of the label texts.
  TextStyle get labelStyle => headline5;

  /// Style of the hint texts.
  TextStyle get hintStyle => headline5.copyWith(color: secondaryTextColor);

  /// Style of the error texts.
  TextStyle get errorStyle => headline5.copyWith(color: AppColors.error);

  /// Style of the large body texts.
  TextStyle get bodyText1 => _textStyle(14);

  /// Style of the small body texts.
  TextStyle get bodyText2 => _textStyle(11);

  /// Style of the largest headline texts.
  TextStyle get headline1 =>
      _textStyle(26, fontWeight: FontWeight.w700, letterSpacing: 1.4);

  /// Style of the large headline texts.
  TextStyle get headline2 =>
      _textStyle(22, fontWeight: FontWeight.w600, letterSpacing: 1.3);

  /// Style of the medium-large headline texts.
  TextStyle get headline3 =>
      _textStyle(18, fontWeight: FontWeight.w500, letterSpacing: 1.2);

  /// Style of the medium-small headline texts.
  TextStyle get headline4 => _textStyle(15);

  /// Style of the small headline texts.
  TextStyle get headline5 => _textStyle(13);

  /// Style of the smallest headline texts.
  TextStyle get headline6 =>
      _textStyle(11, customTextColor: secondaryTextColor);

  /// Style of the large subtitles.
  TextStyle get subtitle1 =>
      _textStyle(10, customTextColor: secondaryTextColor);

  /// Style of the small subtitles.
  TextStyle get subtitle2 => _textStyle(8,
      fontWeight: FontWeight.w300,
      letterSpacing: .8,
      customTextColor: secondaryTextColor);

  TextStyle _textStyle(
    double fontSize, {
    double? letterSpacing,
    FontWeight? fontWeight,
    Color? customTextColor,
    String? customFontFamily,
  }) =>
      TextStyle(
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        color: customTextColor ?? primaryTextColor,
        fontFamily: customFontFamily ?? fontFamily,
      );
}
