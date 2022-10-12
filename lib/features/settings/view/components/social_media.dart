part of '../settings_screen.dart';

class _SocialMedia extends StatelessWidget {
  const _SocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: List<Widget>.generate(
          SettingsTexts.socialMediaAccounts.length,
          (int i) => _item(i, context),
        ),
      );

  Widget _item(int i, BuildContext context) {
    final SocialMediaModel account = SettingsTexts.socialMediaAccounts[i];
    return Expanded(
      child: IconButton(
        padding: context.allPadding(Sizes.lowMed),
        onPressed: () async => launch(account.link),
        icon: Image.asset(account.nameKey.iconPng,
            color: account.nameKey == 'github' ? AppColors.white : null),
        splashRadius: 25,
      ),
    );
  }
}
