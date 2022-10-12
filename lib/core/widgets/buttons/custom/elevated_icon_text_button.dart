import 'package:flutter/material.dart';

import '../../../decoration/button/button_styles.dart';
import '../../../extensions/color/color_extensions.dart';
import '../../../extensions/context/responsiveness_extensions.dart';
import '../../../extensions/context/theme_extensions.dart';
import '../../widgets_shelf.dart';

/// Returns an elevated button with both text and icon.
class ElevatedIconTextButton extends StatelessWidget {
  /// Default constructor for [ElevatedIconTextButton].
  const ElevatedIconTextButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  /// Callback that will be executed on a button press.
  final VoidCallback onPressed;

  /// Text that will be displayed on the button.
  final String text;

  /// Icon that will be shown at the beginning of the button.
  final IconData icon;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onPressed();
        },
        style: ButtonStyles(context).roundedStyle(
          padding: _padding(context),
          backgroundColor: context.primaryColor,
          borderColor: context.primaryDarkColor.darken(.1),
        ),
        child: _rowChild(context),
      );

  Widget _rowChild(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BaseIcon(icon),
          context.sizedW(3),
          BaseText(text),
        ],
      );

  EdgeInsets _padding(BuildContext context) => EdgeInsets.symmetric(
        horizontal: context.width * 3.5,
        vertical: context.height * 1,
      );
}
