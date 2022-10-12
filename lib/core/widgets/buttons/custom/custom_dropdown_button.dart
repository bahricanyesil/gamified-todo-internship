import 'package:flutter/material.dart';

import '../../../constants/constants_shelf.dart';
import '../../../decoration/button/button_styles.dart';
import '../../../decoration/text_styles.dart';
import '../../../extensions/extensions_shelf.dart';
import '../../../theme/color/l_colors.dart';
import '../../widgets_shelf.dart';

/// Customized dropdown button to open a choose dialog.
class CustomDropdownButton<T> extends StatelessWidget {
  /// Default constructor for [DropdownButton].
  const CustomDropdownButton({
    required this.title,
    required this.values,
    required this.initialValues,
    required this.callback,
    this.type = ChooseDialogTypes.single,
    this.autoSize = true,
    this.buttonWidth,
    this.icon,
    Key? key,
  }) : super(key: key);

  /// Title to show in the dialog.
  final String title;

  /// All possible values for the dialog.
  final List<T> values;

  /// Initial selected value.
  final List<T> initialValues;

  /// Callback to call on value choose.
  final Function(List<T> val) callback;

  /// Type of the choose dialog.
  final ChooseDialogTypes type;

  /// Determines whether to autosize the text inside the button.
  final bool autoSize;

  /// Width of the button.
  final double? buttonWidth;

  /// Custom icon at the beginning of the button.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final String value = _findValue;
    return ElevatedButton(
      style: ButtonStyles(context).roundedStyle(
        padding: context.horizontalPadding(Sizes.med),
        size: Size(
          buttonWidth ?? context.width * 85,
          context.responsiveSize * 18,
        ),
      ),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        await _onPressed(context);
      },
      child: _child(context, value),
    );
  }

  Widget _child(BuildContext context, String value) {
    if (icon != null) {
      return Row(
        children: <Widget>[
          BaseIcon(icon!),
          context.sizedW(3),
          Expanded(child: _textWidget(context, value)),
        ],
      );
    }
    return _textWidget(context, value);
  }

  Widget _textWidget(BuildContext context, String value) => autoSize
      ? BaseText(value)
      : Text(
          value.hyphenate,
          overflow: TextOverflow.ellipsis,
          style: TextStyles(context).normalStyle(color: AppColors.white),
        );

  Future<void> _onPressed(BuildContext context) async {
    if (type == ChooseDialogTypes.single) {
      final T? initialValue =
          initialValues.isNotEmpty ? initialValues[0] : null;
      await DialogBuilder(context)
          .singleSelectDialog(title, values, initialValue)
          .then((T? val) => callback(<T>[if (val != null) val]));
    } else {
      await DialogBuilder(context)
          .multipleSelectDialog(title, values, initialValues)
          .then(callback);
    }
  }

  String get _findValue {
    if (initialValues.isNotEmpty) {
      if (type == ChooseDialogTypes.multiple) {
        final StringBuffer buffer = StringBuffer(initialValues[0].toString());
        for (int i = 1; i < initialValues.length; i++) {
          buffer.write(', ${initialValues[i]}');
        }
        return buffer.toString();
      }
      return _getInitialValue(initialValues[0]);
    }
    return title;
  }

  String _getInitialValue(T initialValue) {
    if (initialValue is Enum) {
      return initialValue.name.capitalize;
    } else if (initialValue is String) {
      return initialValue;
    } else {
      return initialValue.toString();
    }
  }
}
