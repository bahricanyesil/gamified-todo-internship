import 'package:flutter/material.dart';

import '../constants/border/border_constants_shelf.dart';
import 'color/l_colors.dart';
import 'text/l_text_theme.dart';

/// Abstract class to define the properties of [ThemeData].
abstract class ITheme {
  /// Default constructor [ITheme], takes two arguments:
  /// [ITextTheme] textTheme - [IColors] colors
  const ITheme({required this.textTheme, required this.colors});

  /// Text theme.
  final ITextTheme textTheme;

  /// Colors of the theme.
  final IColors colors;

  /// Creates the corresponding [ThemeData].
  ThemeData get createTheme => ThemeData(
        fontFamily: textTheme.fontFamily,
        textTheme: textTheme.data,
        primaryTextTheme: textTheme.data,
        cardColor: AppColors.white,
        bottomAppBarColor: colors.scaffoldBackgroundColor,
        scaffoldBackgroundColor: colors.scaffoldBackgroundColor,
        colorScheme: colors.colorScheme,
        primaryColor: colors.colorScheme.primary,
        backgroundColor: colors.scaffoldBackgroundColor,
        primaryColorLight: colors.colorScheme.primary,
        primaryColorDark: colors.colorScheme.primary,
        canvasColor: colors.scaffoldBackgroundColor,
        dividerColor: AppColors.lightGrey,
        highlightColor: colors.highlightColor,
        splashColor: AppColors.lightGrey,
        disabledColor: colors.disabledColor,
        dialogBackgroundColor: colors.colorScheme.primary.withOpacity(.8),
        indicatorColor: colors.colorScheme.secondary,
        hintColor: textTheme.secondaryTextColor,
        errorColor: colors.colorScheme.error,
        toggleableActiveColor: colors.highlightColor,
        buttonTheme: _buttonTheme,
        inputDecorationTheme: _inputDecoTheme,
        iconTheme: _iconTheme,
        primaryIconTheme: _iconTheme,
        appBarTheme: _appBarTheme,
        dividerTheme: _dividerThemeData,
      );

  ButtonThemeData get _buttonTheme => ButtonThemeData(
        shape: ShapedBorders.roundedLow,
        disabledColor: colors.disabledColor,
        highlightColor: colors.highlightColor,
        splashColor: colors.dividerColor,
        hoverColor: colors.dividerColor,
        colorScheme: colors.colorScheme,
      );

  InputDecorationTheme get _inputDecoTheme => InputDecorationTheme(
        labelStyle: textTheme.labelStyle,
        helperStyle: textTheme.labelStyle,
        hintStyle: textTheme.hintStyle,
        errorStyle: textTheme.errorStyle,
        enabledBorder: _enabledBorder,
        focusedBorder: _focusedBorder,
        errorBorder: _errorBorder,
        focusedErrorBorder: _focusedBorder,
        disabledBorder: _enabledBorder,
      );

  InputBorder get _enabledBorder => OutlineInputBorder(
        borderSide: BorderSide(color: colors.primaryColorLight),
        borderRadius: BorderRadii.highCircular,
      );

  InputBorder get _focusedBorder => OutlineInputBorder(
        borderSide: BorderSide(color: colors.colorScheme.primary, width: 1.8),
        borderRadius: BorderRadii.extremeCircular,
      );

  InputBorder get _errorBorder => OutlineInputBorder(
        borderSide: BorderSide(color: colors.colorScheme.error, width: 1.8),
        borderRadius: BorderRadii.extremeCircular,
      );

  IconThemeData get _iconTheme => IconThemeData(
        color: textTheme.primaryTextColor,
      );

  AppBarTheme get _appBarTheme => AppBarTheme(
      titleTextStyle: textTheme.data.subtitle2, color: colors.primaryColorDark);

  DividerThemeData get _dividerThemeData =>
      const DividerThemeData(color: AppColors.primaryColor, thickness: 1);
}
