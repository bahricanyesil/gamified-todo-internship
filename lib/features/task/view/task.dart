import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/helpers/selector_helper.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/list/custom_single_child_scroll_view.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/priorities.dart';
import '../../../product/constants/enums/task/task_enums_shelf.dart';
import '../../../product/extensions/task_extensions.dart';
import '../../../product/models/group/group.dart';
import '../../../product/models/task/task.dart';
import '../../home/view-model/home_view_model.dart';
import '../constants/create_task_texts.dart';
import '../view-model/task_view_model.dart';

/// Screen to create a task.
class TaskScreen extends StatelessWidget with TaskTexts {
  /// Default constructor for [TaskScreen].
  const TaskScreen({this.id, Key? key}) : super(key: key);

  /// Id of the task if the screen is edit.
  final String? id;

  @override
  Widget build(BuildContext context) => BaseView<TaskViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: DefaultAppBar(
          titleText: TaskTexts.title,
          actionsList: _appBarIcons(context),
        ),
        customInitState: _customInitState,
      );

  List<Widget> _appBarIcons(BuildContext context) => <Widget>[
        if (id != null)
          BaseIconButton(
            margin: context.rightPadding(Sizes.low),
            onPressed: () async =>
                context.read<TaskViewModel>().delete(context),
            icon: Icons.delete,
            color: AppColors.error.lighten(.05),
          ),
      ];

  void _customInitState(TaskViewModel model) {
    if (id != null) model.setScreenType(ScreenType.edit, id!);
  }

  Widget _bodyBuilder(BuildContext context) => CustomSingleChildScrollView(
        child: Padding(
          padding: context.verticalPadding(Sizes.lowMed),
          child: Column(children: _bodyChildren(context)),
        ),
      );

  List<Widget> _bodyChildren(BuildContext context) {
    final TaskViewModel model = context.read<TaskViewModel>();
    return <Widget>[
      CustomTextField(
        controller: model.content,
        hintText: TaskTexts.hintText,
        maxLength: 175,
      ),
      context.sizedH(1.6),
      _chooseRow,
      context.sizedH(2.5),
      _dueDateButton,
      context.sizedH(2.5),
      _awardButtonWrapper,
      context.sizedH(4),
      _createButton(context, model),
    ];
  }

  Widget _createButton(BuildContext context, TaskViewModel model) =>
      ElevatedIconTextButton(
        icon: model.screenType.icon,
        text: model.screenType.actionText,
        onPressed: () => model.action(context.read<HomeViewModel>()),
      );

  Widget get _dueDateButton =>
      SelectorHelper<DateTime, TaskViewModel>().builder(
        (_, TaskViewModel model) => model.dueDate,
        (_, DateTime date, __) => TitledButton<DateTime>(
          buttonTitle: TaskTexts.dueDate,
          customButton: (BuildContext context) =>
              _customButtonCallback(context, date),
        ),
      );

  Widget _customButtonCallback(BuildContext context, DateTime date) {
    final TaskViewModel model = context.read<TaskViewModel>();
    return CustomDatePicker(
      callback: model.onDueDateChoose,
      selectedDate: date,
      initialDate: model.dueDate,
    );
  }

  Widget get _chooseRow => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_priorityButton, _groupButton],
      );

  Widget get _priorityButton =>
      SelectorHelper<Priorities, TaskViewModel>().builder(
        (_, TaskViewModel model) => model.priority,
        (BuildContext context, Priorities priority, _) {
          final TaskViewModel model = context.read<TaskViewModel>();
          return TitledButton<Priorities>(
            buttonTitle: TaskTexts.priority,
            title: TaskTexts.priorityDialogTitle,
            values: model.priorities,
            initialValues: <Priorities>[priority],
            callback: model.onPriorityChoose,
            buttonWidth: context.width * 36,
          );
        },
      );

  Widget get _groupButton => SelectorHelper<Group, TaskViewModel>().builder(
        (_, TaskViewModel model) => model.group,
        (BuildContext context, Group group, __) {
          final TaskViewModel model = context.read<TaskViewModel>();
          return TitledButton<Group>(
            buttonTitle: TaskTexts.group,
            title: TaskTexts.groupDialogTitle,
            values: model.groups(context),
            initialValues: <Group>[group],
            callback: model.onGroupChoose,
            autoSizeText: false,
            buttonWidth: context.width * 36,
          );
        },
      );

  Widget get _awardButtonWrapper =>
      SelectorHelper<List<Task>, HomeViewModel>().builder(
        (_, HomeViewModel model) => model.tasks,
        (BuildContext context, List<Task> tasks, __) =>
            SelectorHelper<List<Task>, TaskViewModel>().builder(
          (_, TaskViewModel model) => model.awardsTasks,
          (BuildContext context, List<Task> list, _) =>
              _awardButtonBuilder(context, list, tasks),
        ),
      );

  Widget _awardButtonBuilder(
      BuildContext context, List<Task> awardsTasks, List<Task> tasks) {
    final TaskViewModel model = context.read<TaskViewModel>();
    final List<Task> possibleValues = <Task>[];
    for (final Task t in tasks) {
      final bool otherContains = model.awardsOfTasks.contains(t.id);
      if (t.id != id && !otherContains && !t.isOverDue && !t.isFinished) {
        possibleValues.add(t);
      }
    }
    return TitledButton<Task>(
      buttonTitle: TaskTexts.awardsTitle,
      title: TaskTexts.awardsDialogTitle,
      values: possibleValues,
      dialogType: ChooseDialogTypes.multiple,
      initialValues: awardsTasks,
      callback: (List<Task> tasks) =>
          model.onAwardsChoose(tasks, context.read<HomeViewModel>()),
      autoSizeText: false,
      icon: Icons.card_giftcard_outlined,
    );
  }
}
