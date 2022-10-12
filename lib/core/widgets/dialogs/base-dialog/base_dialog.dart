import 'package:flutter/material.dart';

/// Type definition of the dialog builder.
typedef BaseDialogBuilder<T> = T Function(BuildContext context);

/// Base dialog to define methods.
abstract class BaseDialog<A extends Widget, I extends Widget>
    extends StatelessWidget {
  /// Default constructor of the [BaseDialog].
  const BaseDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;

    switch (platform) {
      case TargetPlatform.android:
        return buildAndroidWidget(context);
      case TargetPlatform.iOS:
        return buildIOSWidget(context);
      default:
        return buildAndroidWidget(context);
    }
  }

  /// Builds android specific widget.
  A buildAndroidWidget(BuildContext context);

  /// Builds IOS specific widget.
  I buildIOSWidget(BuildContext context);
}
