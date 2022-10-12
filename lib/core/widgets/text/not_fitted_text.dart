import 'package:flutter/material.dart';
import '../../decoration/text_styles.dart';
import '../../extensions/string/string_util_extensions.dart';

/// Base text with custom parameters but not wrapped with [FittedBox].
class NotFittedText extends StatelessWidget {
  /// This is the difference from the "BaseText", it also allows multline texts.
  /// Implements some further customizations.
  const NotFittedText(
    this.text, {
    this.style,
    this.textAlign = TextAlign.center,
    this.maxLines = 2,
    this.useCorrectEllipsis,
    this.hyphenate,
    this.color,
    Key? key,
  }) : super(key: key);

  /// Text content.
  final String text;

  /// Custom style for the text.
  final TextStyle? style;

  /// Alignment of the task.
  final TextAlign textAlign;

  /// Maximum liens for the text.
  final int? maxLines;

  /// Whether to use correct ellipsis.
  final bool? useCorrectEllipsis;

  /// Whether to hypenate.
  final bool? hyphenate;

  /// Custom color for the text.
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        _text,
        style: TextStyles(context).subBodyStyle(color: color).merge(style),
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      );

  String get _text {
    final bool ellipsis = useCorrectEllipsis ?? (maxLines ?? 1) <= 1;
    final bool hyphenateLocal = hyphenate ?? (maxLines ?? 1) <= 1;
    String finalText = text;
    if (ellipsis) finalText = finalText.useCorrectEllipsis;
    if (hyphenateLocal) finalText = finalText.hyphenate;
    return finalText;
  }
}
