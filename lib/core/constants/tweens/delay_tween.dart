import 'dart:math' as math show sin, pi;

import 'package:flutter/animation.dart';

/// Delay tween to use in animation.
class DelayTween extends Tween<double> {
  /// Default constructor for [DelayTween].
  DelayTween({
    required this.delay,
    double? begin,
    double? end,
  }) : super(begin: begin, end: end);

  /// Delay amount in double.
  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
