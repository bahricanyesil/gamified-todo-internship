import 'package:flutter/material.dart';
import '../../constants/enums/view-enums/sizes.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import 'base_text.dart';

/// Text that is wrapped with a circle colored conatiner.
class CircledText extends StatelessWidget {
  /// Default constructor of [CircledText].
  const CircledText({
    this.text,
    this.textWidget,
    this.color,
    this.textStyle,
    this.paddingFactor = 1,
    this.margin,
    this.sizeFactor = 11,
    Key? key,
  })  : assert(text != null || textWidget != null,
            'You should either provide a text or a custom text widget.'),
        super(key: key);

  /// Text of the widget.
  final String? text;

  /// Complete custom text widget.
  final Widget? textWidget;

  /// Color of the wrapper.
  final Color? color;

  /// Customized text style.
  final TextStyle? textStyle;

  /// Padding factor.
  final double paddingFactor;

  /// Margin around the widget.
  final EdgeInsets? margin;

  /// Size factor.
  final double sizeFactor;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: context.height * paddingFactor,
          horizontal: context.width * paddingFactor,
        ),
        margin: margin ?? context.horizontalPadding(Sizes.lowMed),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        width: context.responsiveSize * sizeFactor,
        child: textWidget ??
            BaseText(
              text!,
              fontSizeFactor: 6.2,
              fontWeight: FontWeight.w400,
              style: textStyle,
            ),
      );
}
