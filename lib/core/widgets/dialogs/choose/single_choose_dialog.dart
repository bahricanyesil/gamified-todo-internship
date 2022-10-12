import 'package:flutter/material.dart';

import '../../../constants/border/shape_borders.dart';
import '../../../decoration/text_styles.dart';
import '../../../extensions/context/context_extensions_shelf.dart';
import '../../../extensions/string/type_conversion_extensions.dart';
import '../../widgets_shelf.dart';

/// A choose dialog with single option.
class SingleChooseDialog<T> extends StatelessWidget {
  /// Default constructor of [SingleChooseDialog].
  const SingleChooseDialog({
    required this.title,
    required this.elements,
    this.initialValue,
    Key? key,
  }) : super(key: key);

  /// Title of the dialog.
  final String title;

  /// All possible elements.
  final List<T> elements;

  /// Initial selected value.
  final T? initialValue;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        shape: ShapedBorders.roundedMedium,
        backgroundColor: context.canvasColor,
        title: NotFittedText(title,
            style: TextStyles(context)
                .bodyStyle(color: context.primaryLightColor)),
        children: _getDialogChildren(elements, context),
      );

  List<Column> _getDialogChildren(List<T> elements, BuildContext context) =>
      List<Column>.generate(
        elements.length,
        (int index) => Column(
          children: <Widget>[
            if (index == 0) const CustomDivider(),
            _getSimpleDialogOption(elements[index], context),
            const CustomDivider(),
          ],
        ),
      );

  Widget _getSimpleDialogOption(T element, BuildContext context) => Material(
        color: Colors.transparent,
        child: SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(element),
          child: _dialogChild(context, element),
        ),
      );

  Widget _dialogChild(BuildContext context, T element) => SizedBox(
        width: context.responsiveSize * 70,
        child: NotFittedText(
          _value(element),
          style:
              TextStyles(context).subBodyStyle(color: _color(element, context)),
        ),
      );

  Color? _color(T element, BuildContext context) =>
      element == initialValue ? context.primaryColor : null;

  String _value(T el) {
    if (el is Enum) {
      return el.name.capitalize;
    } else if (el is String) {
      return el;
    } else {
      return el.toString();
    }
  }
}
