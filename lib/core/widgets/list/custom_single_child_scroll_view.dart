import 'package:flutter/material.dart';

/// Customized single child scroll view.
class CustomSingleChildScrollView extends SingleChildScrollView {
  /// Default constructor.
  const CustomSingleChildScrollView({
    Widget? child,
    ScrollPhysics? physics,
    ScrollViewKeyboardDismissBehavior? dismissBehavior,
    Key? key,
  }) : super(
          physics: physics ?? const BouncingScrollPhysics(),
          keyboardDismissBehavior:
              dismissBehavior ?? ScrollViewKeyboardDismissBehavior.onDrag,
          child: child,
          key: key,
        );
}
