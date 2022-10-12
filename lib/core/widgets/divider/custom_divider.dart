import 'package:flutter/material.dart';
import '../../theme/color/l_colors.dart';

/// Customized divider to use across the app.
class CustomDivider extends Divider {
  /// Default constructor for [CustomDivider].
  const CustomDivider({Key? key})
      : super(
          key: key,
          indent: 5,
          endIndent: 5,
          color: AppColors.primaryColor,
          thickness: 1,
        );
}
