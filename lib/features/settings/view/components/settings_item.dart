part of '../settings_screen.dart';

class _SettingsItem extends StatelessWidget with SettingsTexts {
  const _SettingsItem({required this.settings, Key? key}) : super(key: key);
  final SettingsOptions settings;

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          highlightColor: context.primaryLightColor.lighten(.15),
          hoverColor: context.primaryLightColor,
        ),
        child: ListTileTheme(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          dense: true,
          child: _expansionTile(context),
        ),
      );

  Widget _expansionTile(BuildContext context) => ExpansionTile(
        collapsedTextColor: context.primaryLightColor,
        collapsedIconColor: context.primaryLightColor,
        tilePadding: context.horizontalPadding(Sizes.low),
        childrenPadding: EdgeInsets.zero,
        leading: PrimaryBaseIcon(settings.icon),
        title: _title(context),
        subtitle: _subtitle(context),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        children: _children(context),
      );

  List<Widget> _children(BuildContext context) {
    switch (settings) {
      case SettingsOptions.visibleTaskSections:
        return List<Widget>.generate((TaskStatus.values.length / 2).ceil(),
            (int i) => _checkboxRow(i, context));
      case SettingsOptions.info:
        return _infoTexts(context);
      case SettingsOptions.socialInfo:
        return <Widget>[const _SocialMedia()];
      case SettingsOptions.taskDeleteInterval:
        return <Widget>[const _TaskDeleteInterval()];
      default:
        return <Widget>[];
    }
  }

  List<Widget> _infoTexts(BuildContext context) => List<Padding>.generate(
        SettingsTexts.infoSentences.keys.length,
        (int i) => Padding(
          padding: context.horizontalPadding(Sizes.lowMed),
          child: BulletColoredText(
            text: SettingsTexts.infoSentences.keys.elementAt(i),
            coloredTexts: SettingsTexts.infoSentences.values.elementAt(i),
          ),
        ),
      );

  Widget _checkboxRow(int i, BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Expanded(flex: 6, child: _checkbox(i, context)),
          const Spacer(),
          Expanded(flex: 6, child: _checkbox(i + 1, context)),
          const Spacer(),
        ],
      );

  Widget _checkbox(int i, BuildContext context) {
    final TaskStatus status = TaskStatus.values[i];
    final SettingsViewModel model = context.read<SettingsViewModel>();
    return SelectorHelper<bool, SettingsViewModel>().builder(
      (_, SettingsViewModel model) =>
          model.sectionVisibility(TaskStatus.values[i]),
      (BuildContext context, bool val, _) => CustomCheckboxTile(
        text: status.value,
        onTap: (bool newValue) => model.setSectionVisibility(status, newValue),
        initialValue: val,
      ),
    );
  }

  Widget _title(BuildContext context) => BaseText(
        settings.title,
        textAlign: TextAlign.start,
        style: TextStyles(context).bodyStyle(color: context.primaryColor),
      );

  Widget _subtitle(BuildContext context) => BaseText(
        settings.subtitle,
        textAlign: TextAlign.start,
        style: TextStyles(context).subtitleTextStyle(),
      );
}
