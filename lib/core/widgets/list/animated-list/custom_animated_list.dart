import 'package:flutter/material.dart';

import '../../../constants/enums/view-enums/sizes.dart';
import '../../../extensions/context/responsiveness_extensions.dart';
import 'models/animated_list_model.dart';

/// Customized [AnimatedList] widget.
class CustomAnimatedList<T> extends StatelessWidget {
  /// Default constructor for [CustomAnimatedList].
  const CustomAnimatedList({
    required this.animatedListModel,
    Key? key,
  }) : super(key: key);

  /// Contains the elements of the list.
  final AnimatedListModel<T> animatedListModel;

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    if (index > animatedListModel.length - 1) return Container();
    final T element = animatedListModel[index];
    return index < animatedListModel.itemCount
        ? SizeTransition(
            sizeFactor: animation,
            child: Padding(
              padding: EdgeInsets.only(bottom: context.height),
              child: animatedListModel.itemCallback(element),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) => animatedListModel.itemCount > 0
      ? AnimatedList(
          key: animatedListModel.listKey,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          initialItemCount: animatedListModel.length,
          itemBuilder: _buildItem,
        )
      : Container();
}

/// Wrapper widget for [CustomAnimatedList] elements.
class AnimatedListItemWrapper extends StatelessWidget {
  /// Default constructor for [AnimatedListItemWrapper].
  const AnimatedListItemWrapper(
      {required this.animation, required this.child, Key? key})
      : super(key: key);

  /// Animation of the [AnimatedList].
  final Animation<double> animation;

  /// Item itself.
  final Widget child;

  @override
  Widget build(BuildContext context) => SizeTransition(
        sizeFactor: animation,
        child: Padding(padding: context.bottomPadding(Sizes.low), child: child),
      );
}
