import 'package:flutter/widgets.dart';

/// Collection of texts in the settings screen.
mixin SettingsTexts on StatelessWidget {
  /// Screen title for settings screen.
  static const String title = 'Settings';

  /// Information sentences wşth colored words in the settings screen.
  static const Map<String, List<String>> infoSentences = <String, List<String>>{
    'Numbers from 1 to 3 represents the priorities of the tasks.': <String>[],
    """There are three priorities:\n\t\t\t1- Urgent\n\t\t\t2- Normal\n\t\t\t3- Nonurgent""":
        <String>['Urgent', 'Normal', 'Nonurgent'],
    'Colors (red-yellow-green) represents the status of the tasks.': <String>[
      'red-yellow-green'
    ],
    """There are four task status:
    1- Active Tasks: Represented with blue color and a person who runs. These are the tasks that you've started but not yet finished.
    2- Open Tasks: Respresented with yellow color and a clock. These are the tasks that you've created but not yet started.
    3- Finished Tasks: Respresented with green color and a check sign. These are the tasks that you've finished.
    4- Over Due Tasks: Respresented with red color and a cross sign. These are the tasks that you couldn't finished before the deadline""":
        <String>[
      'Active Tasks',
      'Open Tasks',
      'Finished Tasks',
      'Over Due Tasks'
    ],
  };

  /// Social media accounts.
  static final List<SocialMediaModel> socialMediaAccounts = <SocialMediaModel>[
    SocialMediaModel(nameKey: 'email', link: _emailUri.toString()),
    const SocialMediaModel(
        nameKey: 'linkedin',
        link: 'https://tr.linkedin.com/in/bahrican-yesil-490151172'),
    const SocialMediaModel(
        nameKey: 'github', link: 'https://github.com/bahricanyesil'),
    const SocialMediaModel(
        nameKey: 'instagram', link: 'https://www.instagram.com/bahricanyesil/'),
    const SocialMediaModel(
        nameKey: 'twitter', link: 'https://twitter.com/bahricanyesil'),
  ];

  static Uri get _emailUri => Uri(
        scheme: 'mailto',
        path: 'bahricanyesil@gmail.com',
        query: _encodeQueryParameters(<String, String>{
          'subject': 'From Gamified-ToDo App',
        }),
      );
  static String? _encodeQueryParameters(Map<String, String> params) =>
      params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

  /// Made with 💙 by Bahrican Yesil.
  static const String madeBy = ' Made with 💙 by Bahrican Yesil';
}

/// Model for social media accounts.
class SocialMediaModel {
  /// Default constructor for [SocialMediaModel].
  const SocialMediaModel({required this.nameKey, required this.link});

  /// Key for the name of the social media type.
  final String nameKey;

  /// Link to the social media.
  final String link;
}
