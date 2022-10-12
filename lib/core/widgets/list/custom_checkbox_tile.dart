import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/enums/view-enums/sizes.dart';
import '../../decoration/text_styles.dart';
import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../../helpers/material_state_helpers.dart';
import '../../providers/theme/theme_provider.dart';
import '../../theme/color/l_colors.dart';
import '../dialogs/choose/custom_checkbox.dart';
import '../widgets_shelf.dart';

/// Customized [Checkbox] with a leading text.
class CustomCheckboxTile extends StatefulWidget {
  /// Default constructor for [CheckboxListTile].
  const CustomCheckboxTile({
    required this.onTap,
    required this.text,
    this.initialValue = false,
    this.color,
    Key? key,
  }) : super(key: key);

  /// Initial value of the checkbox.
  final bool initialValue;

  /// Callback to call on checkbox click.
  final CheckboxCallback onTap;

  /// Text will be shown beside of the checkbox.
  final String text;

  /// Main color of the checkbox and text.
  final Color? color;

  @override
  State<CustomCheckboxTile> createState() => _CustomCheckboxTileState();
}

class _CustomCheckboxTileState extends State<CustomCheckboxTile>
    with MaterialStateHelpers {
  late bool value = widget.initialValue;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _changeValue(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_checkbox, Expanded(child: _text)],
        ),
      );

  Widget get _checkbox => Container(
        margin: context.rightPadding(Sizes.low),
        constraints:
            BoxConstraints.loose(Size.fromHeight(context.height * 4.4)),
        child: Theme(
          data: context.read<ThemeProvider>().currentTheme.copyWith(
                unselectedWidgetColor:
                    widget.color ?? AppColors.white.darken(.1),
              ),
          child: Material(
            color: Colors.transparent,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4),
              value: value,
              onChanged: (bool? newValue) {
                if (newValue != null) _changeValue(newValue);
              },
            ),
          ),
        ),
      );

  Widget get _text => NotFittedText(
        widget.text,
        textAlign: TextAlign.left,
        hyphenate: false,
        useCorrectEllipsis: false,
        style: TextStyles(context).subBodyStyle(
          color: value ? context.primaryColor : widget.color,
          fontSizeFactor: 4.8,
        ),
      );

  void _changeValue(bool newValue) {
    widget.onTap(newValue);
    setState(() => value = newValue);
  }
}
