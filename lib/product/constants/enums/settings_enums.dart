import 'package:flutter/material.dart';

/// Represents the settings options.
enum SettingsOptions {
  /// Indicates the key value for storing and retrieving visible task sections.
  visibleTaskSections,

  /// Interval of task delete.
  taskDeleteInterval,

  /// Indicates the section that will give information about the app.
  info,

  /// Indicates the section that will give information about the app.
  socialInfo,
}

/// Extensions on [SettingsOptions].
extension StringSettingsValues on SettingsOptions {
  /// Returns the title of the settings option.
  String get title {
    switch (this) {
      case SettingsOptions.visibleTaskSections:
        return 'Task Statuses';
      case SettingsOptions.info:
        return 'Info';
      case SettingsOptions.socialInfo:
        return 'Social Media Accounts';
      case SettingsOptions.taskDeleteInterval:
        return 'Task Delete Interval';
    }
  }

  /// Returns the subtitle of the settings option.
  String get subtitle {
    switch (this) {
      case SettingsOptions.visibleTaskSections:
        return 'They will be visible on home screen.';
      case SettingsOptions.info:
        return 'Confused about how to use app?';
      case SettingsOptions.socialInfo:
        return 'You can contact with me via these social media channels.';
      case SettingsOptions.taskDeleteInterval:
        return 'You can adjust the interval for task deletion.';
    }
  }

  /// Returns the corresponding icon for the settings option.
  IconData get icon {
    switch (this) {
      case SettingsOptions.visibleTaskSections:
        return Icons.grid_view_outlined;
      case SettingsOptions.info:
        return Icons.info_outline;
      case SettingsOptions.socialInfo:
        return Icons.contact_mail_outlined;
      case SettingsOptions.taskDeleteInterval:
        return Icons.lock_clock;
    }
  }
}
