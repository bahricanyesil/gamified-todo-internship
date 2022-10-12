import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../extensions/color/color_extensions.dart';
import '../../../extensions/context/responsiveness_extensions.dart';
import '../../../providers/theme/theme_provider.dart';
import '../../../theme/color/l_colors.dart';

/// Callback of the checkbox.
typedef CheckboxCallback = void Function(bool);

/// Customized checkbox.
class CustomCheckbox extends StatefulWidget {
  /// Default constructor of [CustomCheckbox].
  const CustomCheckbox({
    required this.onTap,
    this.initialValue = false,
    Key? key,
  }) : super(key: key);

  /// Initial value of the checkbox.
  final bool initialValue;

  /// Callback to call on checkbox click.
  final CheckboxCallback onTap;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool value = widget.initialValue;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints:
            BoxConstraints.loose(Size.fromHeight(context.height * 4.5)),
        child: Theme(
          data: context.read<ThemeProvider>().currentTheme.copyWith(
                unselectedWidgetColor: AppColors.white.darken(.1),
              ),
          child: Checkbox(
            value: value,
            onChanged: (bool? newValue) {
              if (newValue != null) _changeValue(newValue);
            },
          ),
        ),
      );

  void _changeValue(bool newValue) {
    widget.onTap(newValue);
    setState(() => value = newValue);
  }
}
