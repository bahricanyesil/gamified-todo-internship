import 'package:flutter/material.dart';

import '../../constants/border/border_radii.dart';
import '../../constants/enums/view-enums/sizes.dart';
import '../../decoration/input_decoration.dart';
import '../../decoration/text_styles.dart';
import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../../theme/color/l_colors.dart';

/// Customized text field.
class CustomTextField extends StatelessWidget {
  /// Default constructor for [CustomTextField].
  const CustomTextField({
    this.controller,
    this.hintText,
    this.padding,
    this.maxLength,
    this.onChanged,
    this.contentPadding,
    this.borderRadius = BorderRadii.medHighCircular,
    this.inputDeco,
    Key? key,
  }) : super(key: key);

  /// Text editing controller of the text field.
  final TextEditingController? controller;

  /// Hint text.
  final String? hintText;

  /// Padding around the text field.
  final EdgeInsets? padding;

  /// Maximum length of the input text.
  final int? maxLength;

  /// On changed method to call when the text is changed.
  final Function(String? val)? onChanged;

  /// Padding around the text of the text field.
  final EdgeInsets? contentPadding;

  /// Border radius of the text field.
  final BorderRadius borderRadius;

  /// Custom input deco.
  final InputDecoration? inputDeco;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? context.horizontalPadding(Sizes.medHigh),
        child: Material(
          borderRadius: borderRadius,
          child: TextField(
            controller: controller,
            decoration: inputDeco ??
                InputDeco(context).normalDeco(
                  fillColor: context.primaryLightColor.lighten(.15),
                  hintText: hintText,
                  contentPadding: contentPadding,
                  borderRadius: borderRadius,
                ),
            onChanged: onChanged,
            autocorrect: false,
            style: TextStyles(context).bodyStyle(color: AppColors.black),
            maxLength: maxLength,
            maxLines: null,
          ),
        ),
      );
}
