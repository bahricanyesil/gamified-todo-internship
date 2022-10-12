import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/border/border_radii.dart';
import '../../../../../core/constants/durations/durations.dart';
import '../../../../../core/constants/enums/view-enums/sizes.dart';
import '../../../../../core/decoration/text_styles.dart';
import '../../../../../core/extensions/color/color_extensions.dart';
import '../../../../../core/extensions/context/responsiveness_extensions.dart';
import '../../../../../core/extensions/date/date_time_extensions.dart';
import '../../../../../core/helpers/selector_helper.dart';
import '../../../../../core/theme/color/l_colors.dart';
import '../../../../../core/widgets/menu/focused-menu/focused_menu.dart';
import '../../../../../core/widgets/widgets_shelf.dart';
import '../../../../../product/constants/enums/task/priorities.dart';
import '../../../../../product/constants/enums/task/task_status.dart';
import '../../../../../product/extensions/task_extensions.dart';
import '../../../../../product/models/task/task.dart';
import '../../../constants/home_texts.dart';
import '../../../view-model/home_view_model.dart';

/// Task item widget for animated lists.
class TaskItem extends StatelessWidget with HomeTexts {
  /// Default constructor for [TaskItem].
  const TaskItem({
    required this.id,
    this.isRemoved = false,
    Key? key,
  }) : super(key: key);

  /// Id of the task.
  final String id;

  /// Indicates whether the item is removed.
  final bool isRemoved;

  @override
  Widget build(BuildContext context) =>
      SelectorHelper<Priorities, HomeViewModel>().builder(
        (_, HomeViewModel model) =>
            model.tasks.byId(id)?.priority ?? Priorities.medium,
        (BuildContext context, Priorities priority, _) => FocusedMenu(
          onPressed: () => context.read<HomeViewModel>().navigateToTask(id),
          scrollPhysics: const NeverScrollableScrollPhysics(),
          menuItems: _menuOptions(context),
          highlightColor: priority.color,
          child: _wrapperDeco(
              isRemoved ? _customListTile(context) : _dismissible(context),
              priority),
        ),
      );

  Widget _wrapperDeco(Widget child, Priorities priority) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: priority.color.darken(.3), width: 1.2),
          borderRadius: BorderRadii.lowCircular,
        ),
        child: child,
      );

  List<FocusedMenuItem> _menuOptions(BuildContext context) {
    final Task? task = context.read<HomeViewModel>().tasks.byId(id);
    if (task == null) return <FocusedMenuItem>[];
    const List<String> titles = HomeViewModel.menuItemTitles;
    const List<IconData> icons = HomeViewModel.menuItemIcons;
    final List<FocusedMenuItem> items = <FocusedMenuItem>[];
    for (int i = 0; i < titles.length; i++) {
      if ((i == 0 && task.status == TaskStatus.finished) ||
          (i == 1 && task.status == TaskStatus.active) ||
          (i == 2 && task.status == TaskStatus.open)) {
        continue;
      }
      final bool isDelete = i == titles.length - 1;
      items.add(
        FocusedMenuItem(
          onPressed: () async => _onMenuItemPressed(i, context),
          title: BaseText(titles[i], color: isDelete ? AppColors.error : null),
          leadingIcon:
              BaseIcon(icons[i], color: isDelete ? AppColors.error : null),
        ),
      );
    }
    return items;
  }

  Future<void> _onMenuItemPressed(int i, BuildContext context) async {
    final HomeViewModel model = context.read<HomeViewModel>();
    switch (i) {
      case 0:
        return model.updateTaskStatus(id, TaskStatus.finished);
      case 1:
        return model.updateTaskStatus(id, TaskStatus.active);
      case 2:
        return model.updateTaskStatus(id, TaskStatus.open);
      case 3:
        return model.navigateToTask(id);
      case 4:
        await model.deleteDialog(context, id);
        break;
      default:
    }
  }

  Widget _dismissible(BuildContext context) => Dismissible(
        key: UniqueKey(),
        confirmDismiss: (DismissDirection direction) =>
            context.read<HomeViewModel>().confirmDismiss(direction, id),
        direction: _direction(context),
        background: _background(context),
        secondaryBackground: _secondaryBackground(context),
        movementDuration: Durations.tooFast,
        child: _customListTile(context),
      );

  Widget _customListTile(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * .2),
        child: Row(
          children: <Widget>[
            Expanded(child: _taskPriorityNumber),
            Expanded(flex: 5, child: _textColumn(context)),
            Expanded(child: _taskIcon(context)),
          ],
        ),
      );

  Widget get _taskPriorityNumber =>
      SelectorHelper<Priorities, HomeViewModel>().builder(
        (_, HomeViewModel model) =>
            model.tasks.byId(id)?.priority ?? Priorities.medium,
        (BuildContext context, Priorities priority, Widget? child) =>
            CircledText(textWidget: priority.numberText, color: priority.color),
      );

  Widget _taskIcon(BuildContext context) =>
      SelectorHelper<TaskStatus, HomeViewModel>().builder(
          (_, HomeViewModel model) =>
              model.tasks.byId(id)?.status ?? TaskStatus.open,
          (_, TaskStatus status, __) => status.icon);

  Widget _textColumn(BuildContext context) => Padding(
        padding: context.verticalPadding(Sizes.extremeLow),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_Title(id: id), _Subtitle(id: id)],
        ),
      );

  Container _secondaryBackground(BuildContext context) => Container(
        decoration: _boxDeco(Priorities.high.color),
        padding: context.rightPadding(Sizes.medHigh),
        alignment: Alignment.centerRight,
        child: const BaseText(HomeTexts.openTask, textAlign: TextAlign.start),
      );

  Container _background(BuildContext context) => Container(
        decoration: _boxDeco(Priorities.low.color),
        padding: context.leftPadding(Sizes.medHigh),
        alignment: Alignment.centerLeft,
        child: const BaseText(HomeTexts.activeTask, textAlign: TextAlign.end),
      );

  BoxDecoration _boxDeco(Color color) => BoxDecoration(
        color: color.darken(.07),
        border: Border.all(color: color.darken(.1), width: 1.2),
        borderRadius: BorderRadii.lowCircular,
      );

  DismissDirection _direction(BuildContext context) =>
      context.read<HomeViewModel>().tasks.byId(id)?.status.direction ??
      DismissDirection.horizontal;
}

class _Title extends StatelessWidget {
  const _Title({required this.id, Key? key}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) =>
      NotFittedText(_title(context), textAlign: TextAlign.start);

  String _title(BuildContext context) =>
      SelectorHelper<String, HomeViewModel>().listenValue(
        (HomeViewModel value) => value.tasks.byId(id)?.content ?? '',
        context,
      );
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.id, Key? key}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) => NotFittedText(
        _dueDate(context).dm,
        textAlign: TextAlign.start,
        style: TextStyles(context).subtitleTextStyle(),
      );

  DateTime _dueDate(BuildContext context) =>
      SelectorHelper<DateTime, HomeViewModel>().listenValue(
        (HomeViewModel value) =>
            value.tasks.byId(id)?.dueDate ?? DateTime.now(),
        context,
      );
}
