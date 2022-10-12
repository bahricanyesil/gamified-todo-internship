import 'package:flutter/material.dart';
import '../../../constants/enums/view-enums/text_color.dart';

import '../../../decoration/text_styles.dart';
import '../../../extensions/context/theme_extensions.dart';

/// Partially colored text widget.
class ColoredText extends StatelessWidget {
  /// Default constructor for [ColoredText].
  const ColoredText({
    required this.text,
    this.coloredTexts = const <String>[],
    Key? key,
  }) : super(key: key);

  /// Text itself to display.
  final String text;

  /// List of strings will be colored.
  final List<String> coloredTexts;

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: _textStyle(context),
          children: List<TextSpan>.generate(
              _markedTexts.length, (int i) => _textSpan(i, context)),
        ),
      );

  TextSpan _textSpan(int i, BuildContext context) {
    final _TextColors el = _markedTexts[i];
    return TextSpan(
      text: el.text,
      style: _textStyle(
        context,
        color: el.color == TextColor.black ? null : context.primaryColor,
        fontWeight: el.color == TextColor.black ? null : FontWeight.w600,
      ),
    );
  }

  List<_TextColors> get _markedTexts {
    final List<_TextColors> textsWithColors = <_TextColors>[];
    String tempText = text;
    int coloredIndex = _minColoredIndex(tempText);
    while (coloredIndex != -1) {
      final String coloredText = coloredTexts[coloredIndex];
      final int insertIndex =
          tempText.toLowerCase().indexOf(coloredText.toLowerCase());
      if (insertIndex != 0) {
        textsWithColors.add(
            _TextColors(tempText.substring(0, insertIndex), TextColor.black));
      }
      coloredIndex = tempText.toLowerCase().indexOf(coloredText.toLowerCase());
      final String text =
          tempText.substring(coloredIndex, coloredIndex + coloredText.length);
      textsWithColors.add(_TextColors(text, TextColor.primary));
      if (insertIndex + coloredText.length < tempText.length) {
        tempText = tempText.substring(insertIndex + coloredText.length);
      } else {
        return textsWithColors;
      }
      coloredIndex = _minColoredIndex(tempText);
    }
    if (tempText != '') {
      textsWithColors.add(_TextColors(tempText, TextColor.black));
    }
    return textsWithColors;
  }

  int _minColoredIndex(String tempText) {
    int min = -1;
    int minItemIndex = -1;
    for (int i = 0; i < coloredTexts.length; i++) {
      final int index =
          tempText.toLowerCase().indexOf(coloredTexts[i].toLowerCase());
      if (index == -1) continue;
      if (index < min || min == -1) {
        min = index;
        minItemIndex = i;
      }
    }
    return minItemIndex;
  }

  TextStyle _textStyle(BuildContext context,
          {Color? color, FontWeight? fontWeight}) =>
      TextStyles(context)
          .subtitleTextStyle(height: 1.9, color: color, fontWeight: fontWeight);
}

class _TextColors {
  const _TextColors(this.text, this.color);
  final String text;
  final TextColor color;
}
