part of '../settings_screen.dart';

class _TaskDeleteInterval extends StatelessWidget {
  const _TaskDeleteInterval({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SelectorHelper<int, SettingsViewModel>()
      .builder((_, SettingsViewModel model) => model.deleteInterval, _item);

  Widget _item(BuildContext context, int days, _) => Center(
        child: NumberPicker(
          textMapper: (String mappedValue) =>
              '$mappedValue day${mappedValue == '1' ? '' : 's'}',
          minValue: 1,
          maxValue: 60,
          value: days,
          onChanged: context.read<SettingsViewModel>().setDeleteInterval,
        ),
      );
}
