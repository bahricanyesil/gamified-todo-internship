import 'package:flutter/material.dart';

import '../../../extensions/context/responsiveness_extensions.dart';
import '../../../helpers/material_state_helpers.dart';
import '../../text/base_text.dart';

/// Custom elevated button specific to text widgets.
class ElevatedTextButton extends StatelessWidget with MaterialStateHelpers {
  /// Default constructor for [ElevatedTextButton].
  const ElevatedTextButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  /// Callback that will be executed on a button press.
  final VoidCallback onPressed;

  /// Text that will be displayed on the button.
  final String text;

  /// Backgroundcolor of the button.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onPressed();
        },
        style: ButtonStyle(
          padding: all<EdgeInsets>(
            EdgeInsets.symmetric(
              horizontal: context.width * 4,
              vertical: context.responsiveSize * 5,
            ),
          ),
          backgroundColor: all<Color?>(backgroundColor),
        ),
        child: BaseText(text),
      );
}
