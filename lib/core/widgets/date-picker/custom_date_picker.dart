import 'package:flutter/material.dart';

import '../../constants/enums/view-enums/sizes.dart';
import '../../decoration/button/button_styles.dart';
import '../../decoration/text_styles.dart';
import '../../extensions/extensions_shelf.dart';
import '../../theme/color/l_colors.dart';
import '../icons/base_icon.dart';
import '../text/base_text.dart';

/// Customized date picker widget.
class CustomDatePicker extends StatelessWidget {
  /// Default constructor for [CustomDatePicker].
  const CustomDatePicker({
    required this.callback,
    required this.selectedDate,
    this.initialDate,
    Key? key,
  }) : super(key: key);

  /// Callback to call after choosing a date.
  final Function(DateTime? date) callback;

  /// Selected date.
  final DateTime selectedDate;

  /// Initial selectable date.
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyles(context).roundedStyle(
          padding: context.horizontalPadding(Sizes.med),
          size: Size(context.width * 85, context.responsiveSize * 18),
        ),
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          await _show(context);
        },
        child: Row(
          children: <Widget>[
            const BaseIcon(Icons.calendar_today_outlined),
            context.sizedW(3),
            BaseText(selectedDate.dm),
          ],
        ),
      );

  /// Shows a date picker.
  Future<void> _show(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: _firstDate(now),
      lastDate: now.add(const Duration(days: 365 * 20)),
      builder: (BuildContext context, Widget? child) => Theme(
        data: _data(context),
        child: child ?? Container(),
      ),
    );
    await callback(picked);
  }

  DateTime _firstDate(DateTime now) {
    if (initialDate == null) return now;
    if (initialDate!.isBefore(now)) return initialDate!;
    return now;
  }

  ThemeData _data(BuildContext context) => context.theme.copyWith(
        dialogBackgroundColor: context.primaryLightColor.lighten(.14),
        colorScheme: _colorScheme(context),
        textTheme: _textTheme(context),
        highlightColor: context.primaryLightColor.lighten(.02),
      );

  ColorScheme _colorScheme(BuildContext context) =>
      context.theme.colorScheme.copyWith(
        primary: context.primaryColor,
        surface: context.errorColor,
        onPrimary: AppColors.white,
        onSurface: AppColors.black,
        onSecondary: AppColors.black,
        onBackground: AppColors.black,
      );

  TextTheme _textTheme(BuildContext context) =>
      context.theme.textTheme.copyWith(
        headline4: TextStyles(context).titleStyle(),
        subtitle1: TextStyles(context).bodyStyle(),
        subtitle2: TextStyles(context)
            .bodyStyle(fontSizeFactor: 6, fontWeight: FontWeight.w500),
        overline: TextStyles(context).subBodyStyle(),
        button: TextStyles(context).subBodyStyle(),
      );
}
