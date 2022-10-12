import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/enums/view-enums/sizes.dart';
import '../../../core/decoration/input_decoration.dart';
import '../../../core/decoration/text_styles.dart';
import '../../../core/extensions/color/color_extensions.dart';
import '../../../core/extensions/context/responsiveness_extensions.dart';
import '../../../core/helpers/selector_helper.dart';
import '../../../core/theme/color/l_colors.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/task_status.dart';
import '../../../product/models/models_shelf.dart';
import '../../home/view-model/home_view_model.dart';
import '../constants/groups_texts.dart';
import '../view-model/groups_view_model.dart';

part 'components/group_item.dart';

/// Screen to view, edit, create groups.
class GroupsScreen extends StatelessWidget with GroupsTexts {
  /// Default constructor for the [GroupsScreen].
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<GroupsViewModel>(
        bodyBuilder: _bodyBuilder,
        appBar: const DefaultAppBar(titleText: GroupsTexts.title),
      );

  Widget _bodyBuilder(BuildContext context) => Padding(
        padding: context.verticalPadding(Sizes.low),
        child: Column(
          children: <Widget>[
            const Flexible(child: _GroupsList()),
            context.sizedH(2),
            ElevatedIconTextButton(
              text: 'Add a Group',
              icon: Icons.add_outlined,
              onPressed: () =>
                  context.read<GroupsViewModel>().addGroup('New Group'),
            ),
          ],
        ),
      );
}

class _GroupsList extends StatelessWidget with GroupsTexts {
  const _GroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      SelectorHelper<int, GroupsViewModel>().builder(
        (_, GroupsViewModel model) => model.groups.length,
        _selectorBuilder,
      );

  Widget _selectorBuilder(BuildContext context, int val, _) =>
      DefaultListViewBuilder(
        itemCount: val,
        padding: context.horizontalPadding(Sizes.med),
        itemBuilder: (_, int i) => _listenGroup(i),
      );

  Widget _listenGroup(int i) =>
      SelectorHelper<Group, GroupsViewModel>().builder(
        (_, GroupsViewModel model) => model.group(i),
        _selectorChildBuilder,
        shouldRebuild: (Group pre, Group next) => pre.id != next.id,
      );

  Widget _selectorChildBuilder(BuildContext context, Group group, _) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * .6),
        child: _GroupItem(group),
      );
}
