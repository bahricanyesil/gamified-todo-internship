import 'package:flutter/material.dart';

import '../../extensions/context/responsiveness_extensions.dart';
import '../../theme/color/l_colors.dart';

/// [BaseIcon] with default size.
class SizedBaseIcon extends BaseIcon {
  /// Default constructor for [SizedBaseIcon]..
  const SizedBaseIcon(IconData icon, {Color? color, Key? key})
      : super(icon, color: color, sizeFactor: 6.8, key: key);
}

/// Base icon with custom parameters
/// Wraps [Icon] with [FittedBox], and gives some paddings.
class BaseIcon extends StatelessWidget {
  /// Default constructor for [BaseIcon].
  const BaseIcon(
    this.iconData, {
    this.sizeFactor,
    this.color,
    this.padding,
    Key? key,
  }) : super(key: key);

  /// Icon itself.
  final IconData iconData;

  /// Custom size factor for icon.
  final double? sizeFactor;

  /// Color of the icon.
  final Color? color;

  /// Padding for the icon widget.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(padding: _getPadding(context), child: _icon(context)),
      );

  Widget _icon(BuildContext context) => Icon(
        iconData,
        size: sizeFactor != null ? (context.width * sizeFactor!) : null,
        color: color ?? AppColors.white,
      );

  EdgeInsets _getPadding(BuildContext context) => padding ?? EdgeInsets.zero;
}

/// [BaseIcon] with primary color.
class PrimaryBaseIcon extends BaseIcon {
  /// Default constructor for [PrimaryBaseIcon].
  const PrimaryBaseIcon(
    IconData icon, {
    EdgeInsets? padding,
    double? sizeFactor,
    Key? key,
  }) : super(
          icon,
          color: AppColors.primaryColor,
          padding: padding,
          sizeFactor: sizeFactor,
          key: key,
        );
}
