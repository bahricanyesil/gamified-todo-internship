part of '../../home_screen.dart';

class _TasksSection extends StatelessWidget {
  const _TasksSection({required this.tasksSection, Key? key}) : super(key: key);
  final TasksSection tasksSection;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _columnChildren(context),
      );

  List<Widget> _columnChildren(BuildContext context) => <Widget>[
        _TitleRow(section: tasksSection),
        context.sizedH(.5),
        _AnimatedTaskList(status: tasksSection.status),
      ];
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.section, Key? key}) : super(key: key);
  final TasksSection section;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.read<HomeViewModel>().setExpanded(section.status),
        child: Padding(
          padding: context.verticalPadding(Sizes.extremeLow),
          child: _row(context),
        ),
      );

  Widget _row(BuildContext context) => Row(
        children: <Widget>[
          section.status.icon,
          context.sizedW(1.8),
          BaseText(section.title, style: TextStyles(context).titleStyle()),
          context.sizedW(1.6),
          _lengthText(context),
          const Spacer(),
          _icon,
        ],
      );

  Widget _lengthText(BuildContext context) =>
      SelectorHelper<int, HomeViewModel>().builder(
        (_, HomeViewModel model) => model.tasks.byStatus(section.status).length,
        (BuildContext context, int tasksListLength, _) => BaseText(
          '($tasksListLength)',
          style: TextStyles(context)
              .subBodyStyle(color: context.primaryLightColor, height: 1.8),
        ),
      );

  Widget get _icon =>
      SelectorHelper<Tuple2<bool, bool>, HomeViewModel>().builder(
        (_, HomeViewModel model) => Tuple2<bool, bool>(
            model.expandedLists[TaskStatus.values.indexOf(section.status)],
            model.tasks.byStatus(section.status).length > 2),
        (BuildContext context, Tuple2<bool, bool> tuple, _) => tuple.item2
            ? BaseIcon(
                tuple.item1
                    ? Icons.arrow_drop_down_sharp
                    : Icons.arrow_right_sharp,
                color: tuple.item1
                    ? context.primaryLightColor
                    : context.primaryDarkColor,
              )
            : Container(),
      );
}

class _AnimatedTaskList extends StatefulWidget {
  const _AnimatedTaskList({required this.status, Key? key}) : super(key: key);
  final TaskStatus status;

  @override
  __AnimatedTaskListState createState() => __AnimatedTaskListState();
}

class __AnimatedTaskListState extends State<_AnimatedTaskList> {
  bool isExpanded = false;
  int itemCount = 2;
  Timer? _timer;
  List<Task> tasks = <Task>[];

  @override
  Widget build(BuildContext context) {
    tasks = SelectorHelper<List<Task>, HomeViewModel>().listenValue(
        (HomeViewModel model) => model.tasks.byStatus(widget.status), context);
    isExpanded = SelectorHelper<bool, HomeViewModel>().listenValue(
        (HomeViewModel model) =>
            model.expandedLists[TaskStatus.values.indexOf(widget.status)],
        context);
    _startTimer(isExpanded);
    return AnimatedContainer(
      duration: Duration(milliseconds: itemCount * (isExpanded ? 140 : 64)),
      child: CustomAnimatedList<Task>(animatedListModel: _animatedModel),
    );
  }

  AnimatedListModel<Task> get _animatedModel =>
      context.read<HomeViewModel>().animatedListModel(widget.status)
        ..visibleItemCount = itemCount
        ..items = tasks;

  void _startTimer(bool isExpanded) {
    final int diff = isExpanded ? tasks.length - itemCount : itemCount - 2;
    _restart(diff);
  }

  void _restart(int diff) {
    if (diff > 0 && _timer == null) {
      final int interval = itemCount * (isExpanded ? 70 : 32) ~/ diff;
      itemCount = isExpanded ? itemCount + 1 : itemCount - 1;
      _timer = Timer.periodic(Duration(milliseconds: interval), _timerCallback);
    }
  }

  void _timerCallback(Timer timer) {
    if (isExpanded && itemCount < tasks.length) {
      setState(() => itemCount++);
    } else if (!isExpanded && itemCount > 2) {
      setState(() => itemCount--);
    } else {
      timer.cancel();
      _timer = null;
    }
  }
}
