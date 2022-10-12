import 'package:flutter/material.dart';

/// List view builder with default options.
class DefaultListViewBuilder extends StatelessWidget {
  /// Default constructor.
  const DefaultListViewBuilder({
    required this.itemBuilder,
    required this.itemCount,
    this.physics,
    this.controller,
    this.scrollDirection,
    this.itemExtent,
    this.padding,
    Key? key,
  }) : super(key: key);

  /// Item builder of the list.
  final IndexedWidgetBuilder itemBuilder;

  /// Count of the items in the list.
  final int itemCount;

  /// custom scroll physics.
  final ScrollPhysics? physics;

  /// Custom scroll direction, default is vertical.
  final Axis? scrollDirection;

  /// Custom scroll controller.
  final ScrollController? controller;

  /// Custom item extent value.
  final double? itemExtent;

  /// Custom padding value.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => ListView.builder(
        physics: physics ?? const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        itemCount: itemCount,
        padding: padding ?? EdgeInsets.zero,
        itemBuilder: itemBuilder,
        scrollDirection: scrollDirection ?? Axis.vertical,
        controller: controller,
        itemExtent: itemExtent,
      );
}
