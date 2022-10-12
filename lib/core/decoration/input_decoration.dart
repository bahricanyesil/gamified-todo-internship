import 'package:flutter/material.dart';
import '../constants/border/border_constants_shelf.dart';

import '../constants/enums/view-enums/sizes.dart';
import '../extensions/extensions_shelf.dart';
import '../theme/color/l_colors.dart';
import '../widgets/icons/base_icon.dart';
import 'text_styles.dart';

/// [InputDeco] class collects all input decorations in one file.
class InputDeco {
  /// * Initializes theme fields after received the context.
  InputDeco(BuildContext context) {
    _context = context;
  }

  late final BuildContext _context;

  /// [InputDecoration] for the text form fields in the login screen.
  /// Both "CustomTextFormField" and "ObscuredTextFormField" uses this deco.
  InputDecoration normalDeco({
    String? hintText,
    String? labelText,
    double? paddingFactor,
    IconData? prefixIcon,
    Widget? prefixWidget,
    EdgeInsets? contentPadding,
    Color? fillColor,
    Color? hoverColor,
    bool showLabel = false,
    BorderRadius? borderRadius,
  }) =>
      InputDecoration(
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              vertical: _context.responsiveSize * 6,
              horizontal: _context.responsiveSize * 6,
            ),
        fillColor: fillColor ?? AppColors.white,
        hoverColor: hoverColor ?? _context.primaryLightColor.lighten(),
        hintText: hintText,
        hintStyle: TextStyles(_context).hintTextStyle(color: AppColors.black),
        labelText: showLabel ? hintText : null,
        labelStyle: showLabel ? TextStyles(_context).hintTextStyle() : null,
        errorMaxLines: 1,
        errorStyle: TextStyles(_context).errorTextStyle(),
        enabledBorder: _getOutlineBorder(borderRadius, widthFactor: .4),
        focusedBorder: _getOutlineBorder(
          borderRadius,
        ),
        focusedErrorBorder: _getOutlineBorder(
          borderRadius,
        ),
        errorBorder: _getOutlineBorder(borderRadius, widthFactor: .4),
        prefixIcon: prefixWidget ?? _getPrefixIcon(prefixIcon),
        filled: true,
      );

  /// Returns the prefix icon if there is any provided.
  Widget? _getPrefixIcon(IconData? prefixIcon) => prefixIcon == null
      ? null
      : Padding(
          padding: _context.horizontalPadding(Sizes.low),
          child: BaseIcon(prefixIcon),
        );

  /// Default function returns [OutlineInputBorder] with some common values.
  /// Takes [color] and [widthFactor] as parameters to specialize each border.
  OutlineInputBorder _getOutlineBorder(BorderRadius? borderRadius,
          {Color? color, double widthFactor = .62}) =>
      OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadii.medHighCircular,
        borderSide: BorderSide(
          width: _context.responsiveSize * widthFactor,
          color: color ?? _context.primaryLightColor,
        ),
      );

  /// Returns underlined input decoration.
  InputDecoration underlinedDeco(
          {String? hintText, double paddingFactor = 1, Color? color}) =>
      InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyles(_context)
            .textFormStyle(color: AppColors.black, fontSizeFactor: 5.4),
        border: _underlinedBorder(color),
        enabledBorder: _underlinedBorder(color),
        focusedBorder: _underlinedBorder(color),
        contentPadding: EdgeInsets.symmetric(
            vertical: _context.responsiveSize * paddingFactor),
      );

  UnderlineInputBorder _underlinedBorder(Color? color) => UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1.5, color: color ?? Colors.black),
      );
}
