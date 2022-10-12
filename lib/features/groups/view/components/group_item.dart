part of '../groups_screen.dart';

class _GroupItem extends StatelessWidget {
  const _GroupItem(this.group, {Key? key}) : super(key: key);
  final Group group;

  @override
  Widget build(BuildContext context) {
    final GroupsViewModel model = context.read<GroupsViewModel>();
    final Color color = model.color(group.id);
    return CustomExpansionTile(
      key: Key(group.id + model.isExpanded(group.id).toString()),
      mainListTile: _mainListTile(context, color, model),
      backgroundColor: color,
      collapsedBackgroundColor: Colors.transparent,
      initiallyExpanded: model.isExpanded(group.id),
      customChildrenWidget: _ExpansionChildren(groupId: group.id),
      onExpansionChanged: (bool val) => context
          .read<GroupsViewModel>()
          .setExpansion(group.id, isExpanded: val),
    );
  }

  Widget _mainListTile(
          BuildContext context, Color color, GroupsViewModel model) =>

      /// You can adjust the size of the group item here.
      Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * .1),
        child: Row(
          children: <Widget>[
            _circledText(color),
            Expanded(child: _colorSelector(_titleBuilder)),
            _deleteButton(context),
          ],
        ),
      );

  Widget _deleteButton(BuildContext context) => BaseIconButton(
      onPressed: () async =>
          context.read<GroupsViewModel>().deleteDialog(context, group.id),
      icon: Icons.delete,
      color: AppColors.error.darken(.1));

  Widget _circledText(Color color) =>
      SelectorHelper<String, GroupsViewModel>().builder(
          _circledTextSelector,
          (BuildContext context, String val, _) =>
              _buildCircledText(context, val, color));

  String _circledTextSelector(_, GroupsViewModel model) {
    final String? title = model.titleController(group.id)?.text;
    if (title == null || title.isEmpty) return ' ';
    return title[0];
  }

  Widget _buildCircledText(BuildContext context, String val, Color color) =>
      CircledText(
        text: val,
        color: color.darken(.4),
        paddingFactor: 1.2,
        margin: context.horizontalPadding(Sizes.extremeLow),
      );

  Widget _colorSelector(SelectorBuilder<Color> builder) =>
      SelectorHelper<Color, GroupsViewModel>().builder(
        (_, GroupsViewModel model) =>
            model.isExpanded(group.id) ? Colors.black : AppColors.white,
        builder,
      );

  Widget _titleBuilder(BuildContext context, Color color, Widget? child) {
    final GroupsViewModel model = context.read<GroupsViewModel>();
    return Padding(
      padding: context
          .horizontalPadding(Sizes.low)
          .copyWith(bottom: context.height * .8),
      child: TextField(
        controller: model.titleController(group.id),
        style: TextStyles(context).textFormStyle(color: color),
        decoration: InputDeco(context).underlinedDeco(color: color),
        onChanged: (String? val) => model.onTitleChanged(group.id, val),
      ),
    );
  }
}

class _ExpansionChildren extends StatelessWidget {
  const _ExpansionChildren({required this.groupId, Key? key}) : super(key: key);
  final String groupId;
  @override
  Widget build(BuildContext context) => DefaultListViewBuilder(
        itemCount: TaskStatus.values.length,
        itemBuilder: _listItemBuilder,
        physics: const NeverScrollableScrollPhysics(),
      );

  Widget _listItemBuilder(BuildContext context, int i) {
    final TaskStatus status = TaskStatus.values[i];
    return SelectorHelper<bool, HomeViewModel>().builder(
      (_, HomeViewModel model) =>
          model.getByGroupIdAndStatus(groupId, status).isNotEmpty,
      (BuildContext context, bool isNotEmpty, _) =>
          _listItem(context, isNotEmpty, i),
    );
  }

  Widget _listItem(BuildContext context, bool isNotEmpty, int i) {
    final TaskStatus status = TaskStatus.values[i];
    return isNotEmpty
        ? Padding(
            padding: _expansionChildPadding(i, context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BaseText(
                  status.value,
                  color: AppColors.black,
                  underline: true,
                  fontSizeFactor: 5.4,
                ),
                context.sizedH(.6),
                SelectorHelper<List<Task>, HomeViewModel>().builder(
                  (_, HomeViewModel model) =>
                      model.getByGroupIdAndStatus(groupId, status),
                  _statusTasksBuilder,
                )
              ],
            ),
          )
        : Container();
  }

  Widget _statusTasksBuilder(_, List<Task> tasks, __) => DefaultListViewBuilder(
        itemCount: tasks.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int i) => BulletText(
          tasks[i].content,
          color: AppColors.black,
          textAlign: TextAlign.start,
          fontSizeFactor: 4.8,
        ),
      );

  EdgeInsets _expansionChildPadding(int i, BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.width * 4,
      ).copyWith(
        top: context.height * (i == 0 ? 1.2 : .8),
        bottom: context.height *
            ((i == 1 || i == TaskStatus.values.length - 1) ? 1.2 : .8),
      );
}
