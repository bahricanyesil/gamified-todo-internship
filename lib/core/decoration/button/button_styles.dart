import 'package:flutter/material.dart';
import '../../constants/border/border_radii.dart';

import '../../extensions/context/context_extensions_shelf.dart';

/// Collection of button styles.
class ButtonStyles {
  /// Default constructor that takes context as parameter.
  const ButtonStyles(this.context);

  /// Context to use theme and responsiveness extensions.
  final BuildContext context;

  /// Returns rounded button style.
  ButtonStyle roundedStyle({
    Color? backgroundColor,
    Color? borderColor,
    BorderRadius? borderRadius,
    double? borderWidth,
    EdgeInsetsGeometry? padding,
    Size? size,
  }) =>
      ButtonStyle(
        padding: _all(padding),
        fixedSize: _size(size),
        backgroundColor: _all(backgroundColor ?? context.canvasColor),
        shape: _all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadii.mediumCircular,
            side: BorderSide(
              color: borderColor ?? context.primaryColor,
              width: borderWidth ?? 2.0,
            ),
          ),
        ),
      );

  /// Returns low rounded button style.
  ButtonStyle lowRoundedStyle({
    Color? backgroundColor,
    Color? borderColor,
    double? width,
  }) =>
      ButtonStyle(
        backgroundColor: _all(backgroundColor ?? context.canvasColor),
        shape: _all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadii.mediumCircular,
            side: BorderSide(
              color: borderColor ?? context.primaryColor,
              width: width ?? 2.0,
            ),
          ),
        ),
      );

  MaterialStateProperty<Size> _size(Size? size) => size == null
      ? _all(Size.fromHeight(context.responsiveSize * 19))
      : _all(size);

  MaterialStateProperty<T> _all<T>(T value) => MaterialStateProperty.all(value);
}
