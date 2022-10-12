import 'package:flutter/material.dart';

import '../../constants/durations/durations.dart';
import '../../constants/tweens/delay_tween.dart';
import '../../extensions/context/responsiveness_extensions.dart';
import '../../theme/color/l_colors.dart';

/// Custom loading indicator to use across the app.
class LoadingIndicator extends StatelessWidget {
  /// Default constructor for [LoadingIndicator].
  const LoadingIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SizedBox.fromSize(
            size: Size.square(_size(context)),
            child: _stack(context),
          ),
        ),
      );

  Widget _stack(BuildContext context) => Stack(
        children:
            List<Widget>.generate(12, (int i) => _listElement(context, i)),
      );

  Widget _listElement(BuildContext context, int i) {
    final double _position = _size(context) * .5;
    return Positioned.fill(
      left: _position,
      top: _position,
      child: Transform(
        transform: Matrix4.rotationZ(30.0 * i * 0.0174533),
        child: Align(child: _LoadingBubble(index: i, size: _size(context))),
      ),
    );
  }

  double _size(BuildContext context) => context.responsiveSize * 40;
}

class _LoadingBubble extends StatefulWidget {
  const _LoadingBubble({required this.index, required this.size, Key? key})
      : super(key: key);
  final int index;
  final double size;

  @override
  __LoadingBubbleState createState() => __LoadingBubbleState();
}

class __LoadingBubbleState extends State<_LoadingBubble>
    with SingleTickerProviderStateMixin {
  final List<double> delays =
      List<double>.generate(12, (int index) => -1.1 + (index * .1));
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Durations.slowMed)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: DelayTween(begin: 0, end: 1, delay: delays[widget.index])
            .animate(_controller),
        child: _buildItem(widget.index),
      );

  Widget _buildItem(int index) => SizedBox.fromSize(
        size: Size.square(widget.size * 0.12),
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.loadingColor,
            shape: BoxShape.circle,
          ),
        ),
      );
}
