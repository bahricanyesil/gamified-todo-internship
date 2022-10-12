import 'package:flutter/material.dart';
import '../../../constants/constants_shelf.dart';

import '../../../extensions/context/responsiveness_extensions.dart';
import '../../text/base_text.dart';
import '../custom/custom_dropdown_button.dart';

/// Button with a text on top.
class TitledButton<T> extends StatelessWidget {
  /// Default constructor for [TitledButton].
  const TitledButton({
    required this.buttonTitle,
    this.title,
    this.values,
    this.initialValues,
    this.callback,
    this.customButton,
    this.autoSizeText = true,
    this.buttonWidth,
    this.icon,
    this.dialogType = ChooseDialogTypes.single,
    Key? key,
  })  : assert(
            customButton != null ||
                (title != null &&
                    values != null &&
                    initialValues != null &&
                    callback != null),
            """You should either provide a custom button or required parameters for default button."""),
        super(key: key);

  /// Title to show on top of the button.
  final String buttonTitle;

  /// Title of the dialog.
  final String? title;

  /// All possible values.
  final List<T>? values;

  /// Initial selected values.
  final List<T>? initialValues;

  /// Callback to call on value choose.
  final Function(List<T> val)? callback;

  /// Custom button.
  final Widget Function(BuildContext context)? customButton;

  /// Determines whether to autosize the text inside the button.
  final bool autoSizeText;

  /// Custom width for the button.
  final double? buttonWidth;

  /// Custom icon at the beginning of the button.
  final IconData? icon;

  /// Type of the choose dialog.
  final ChooseDialogTypes dialogType;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: context.leftPadding(Sizes.low),
            child: BaseText(buttonTitle),
          ),
          context.sizedH(.8),
          if (customButton != null)
            customButton!(context)
          else
            CustomDropdownButton<T>(
              title: title!,
              values: values!,
              initialValues: initialValues!,
              callback: callback!,
              autoSize: autoSizeText,
              buttonWidth: buttonWidth,
              type: dialogType,
              icon: icon,
            ),
        ],
      );
}
