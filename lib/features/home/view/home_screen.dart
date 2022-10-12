import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/extensions_shelf.dart';
import '../../../core/helpers/selector_helper.dart';
import '../../../core/managers/navigation/navigation_shelf.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/task_status.dart';
import '../../../product/extensions/task_extensions.dart';
import '../../../product/models/task/task.dart';
import '../../settings/view-model/settings_view_model.dart';
import '../constants/home_texts.dart';
import '../view-model/home_view_model.dart';
import 'ui-models/tasks_section_title.dart';

part 'components/tasks/tasks_section.dart';

/// Home Screen of the app.
class HomeScreen extends StatelessWidget with HomeTexts {
  /// Default constructor for home screen.
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<HomeViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: DefaultAppBar(
          titleIcon: Icons.checklist_outlined,
          titleText: HomeTexts.homeScreenTitle,
          actionsList: _appBarActions(context),
          showBack: false,
        ),
      );

  List<Widget> _appBarActions(BuildContext context) => <Widget>[
        _appBarIcon(Icons.add_outlined, ScreenConfig.task()),
        context.sizedW(1),
        _appBarIcon(Icons.list_outlined, ScreenConfig.groups()),
        context.sizedW(1),
        _appBarIcon(Icons.settings_outlined, ScreenConfig.settings()),
      ];

  Widget _appBarIcon(IconData icon, ScreenConfig screen) => BaseIconButton(
        onPressed: () => NavigationManager.instance.setNewRoutePath(screen),
        icon: icon,
      );

  Widget _bodyBuilder(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.medWidth,
          vertical: context.extremeLowHeight,
        ),
        child: _listView,
      );

  Widget get _listView =>
      SelectorHelper<List<TasksSection>, SettingsViewModel>().builder(
        (_, SettingsViewModel model) => HomeViewModel.tasksSections
            .where((TasksSection s) => model.visibleStatuses.contains(s.status))
            .toList(),
        (_, List<TasksSection> sections, __) => ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (_, int index) =>
              _TasksSection(tasksSection: sections[index]),
          separatorBuilder: (_, __) => const CustomDivider(),
          itemCount: sections.length,
        ),
      );
}
