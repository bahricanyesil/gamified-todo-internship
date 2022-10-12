import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../extensions/color/color_extensions.dart';
import '../../extensions/context/theme_extensions.dart';
import '../../theme/color/l_colors.dart';
import '../widgets_shelf.dart';
import 'base-dialog/base_dialog_action.dart';
import 'base-dialog/base_dialog_alert.dart';
import 'choose/choose_dialogs_shelf.dart';

/// Builds various types of dialogs.
class DialogBuilder {
  /// Default constructor with context parameter.
  const DialogBuilder(this.context);

  /// Shows dialogs with the given context.
  final BuildContext context;

  /// Shows a dialog with single selection option.
  Future<T?> singleSelectDialog<T>(
          String title, List<T> elements, T? initialValue) async =>
      showDialog<T?>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => SingleChooseDialog<T>(
            title: title, elements: elements, initialValue: initialValue),
      );

  /// Shows a dialog with multiple selection options.
  Future<List<T>> multipleSelectDialog<T>(
    String title,
    List<T> elements,
    List<T> initialValues, {
    bool enableSearch = true,
    Widget? contentWidget,
  }) async {
    List<T> items = initialValues;
    final List<T>? result =
        await DialogBuilder(context).platformSpecific<List<T>>(
      title: title,
      contentWidget: MultipleChooseDialog<T>(
        elements: elements,
        enableSearch: enableSearch,
        initialSelecteds: initialValues,
        onValueChanged: (List<T> newItems) => items = newItems,
      ),
      actions: <BaseDialogAction>[
        BaseDialogAction(
          text: _dialogActionText('Cancel'),
          onPressed: () => Navigator.pop(context, initialValues),
        ),
        BaseDialogAction(
          text: _dialogActionText('OK'),
          onPressed: () => Navigator.pop(context, items),
        ),
      ],
    );
    return result ?? initialValues;
  }

  /// Shows a platform specific dialog.
  Future<T?> platformSpecific<T>({
    WidgetBuilder? builder,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    String? title,
    String? contentText,
    Widget? contentWidget,
    List<BaseDialogAction> actions = const <BaseDialogAction>[],
  }) {
    final TargetPlatform platform = Theme.of(context).platform;
    final WidgetBuilder widgetBuilder = builder ??
        (BuildContext context) => _defaultBuilder(
              context,
              title: title,
              contentText: contentText,
              actions: actions,
              contentWidget: contentWidget,
            );
    switch (platform) {
      case TargetPlatform.iOS:
        return showCupertinoDialog<T>(
          context: context,
          builder: widgetBuilder,
          barrierDismissible: barrierDismissible,
          useRootNavigator: useRootNavigator,
        );
      default:
        return _showAndroidDialog<T>(
            widgetBuilder, barrierDismissible, useRootNavigator);
    }
  }

  /// Delete confirmation dialog.
  Future<bool?> deleteDialog<T>({
    required VoidCallback deleteAction,
    String? contentText,
    bool waitAction = false,
  }) async =>
      DialogBuilder(context).platformSpecific<bool>(
        title: 'Are you sure to delete?',
        contentText: contentText ?? "This action cannot be undone.",
        actions: <BaseDialogAction>[
          BaseDialogAction(
            text: _dialogActionText('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          _deleteActionButton(deleteAction),
        ],
      );

  BaseDialogAction _deleteActionButton(VoidCallback deleteAction) =>
      BaseDialogAction(
        text: _dialogActionText('Delete', color: AppColors.error.darken(.1)),
        onPressed: () {
          deleteAction();
          Navigator.pop(context, true);
        },
      );

  Widget _dialogActionText(String text, {Color? color}) =>
      BaseText(text, color: color ?? AppColors.black);

  Widget _defaultBuilder(
    BuildContext context, {
    String? title,
    String? contentText,
    List<BaseDialogAction> actions = const <BaseDialogAction>[],
    Widget? contentWidget,
  }) =>
      BaseDialogAlert(
        title: title == null
            ? null
            : BaseText(title, color: context.primaryColor, fontSizeFactor: 6.5),
        content: contentWidget ??
            (contentText == null
                ? null
                : NotFittedText(contentText,
                    color: AppColors.black, maxLines: 30)),
        actions: actions,
      );

  Future<T?> _showAndroidDialog<T>(WidgetBuilder builder,
          bool androidDismissible, bool useRootNavigator) =>
      showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: androidDismissible,
        useRootNavigator: useRootNavigator,
      );
}
