import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helpers/material_state_helpers.dart';
import 'base_dialog.dart';

/// Basic dialog action widget displays buttons specific to the platforms.
class BaseDialogAction extends BaseDialog<TextButton, CupertinoDialogAction>
    with MaterialStateHelpers {
  /// Default constructor of [BaseDialogAction]
  const BaseDialogAction({
    this.onPressed,
    this.text,
    this.isDelete = false,
    this.isDefault = false,
    Key? key,
  }) : super(key: key);

  /// Will be called on press to the button.
  final VoidCallback? onPressed;

  /// Text of the dialog action.
  final Widget? text;

  /// Determines whether the button is a delete button.
  final bool isDelete;

  /// Determines whether the button is the default selected button.
  final bool isDefault;

  @override
  TextButton buildAndroidWidget(BuildContext context) => TextButton(
        onPressed: onPressed,
        child: text ?? Container(),
      );

  @override
  CupertinoDialogAction buildIOSWidget(BuildContext context) =>
      CupertinoDialogAction(
        onPressed: onPressed,
        isDestructiveAction: isDelete,
        isDefaultAction: isDefault,
        child: text ?? Container(),
      );
}
