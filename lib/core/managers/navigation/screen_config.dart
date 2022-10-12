import 'package:flutter/material.dart';

import '../../../features/screens_shelf.dart';
import '../../constants/navigation/navigation_constants.dart';
import '../../helpers/hasher.dart';

@immutable

/// [ScreenConfig] class to determine the properties of pages to navigate.
class ScreenConfig {
  /// Constructor for [ScreenConfig] class.
  const ScreenConfig({
    required this.path,
    required this.builder,
  });

  /// Screen config for default screen, in this case it is [SplashScreen].
  ScreenConfig.defaultScreen()
      : path = NavigationConstants.root,
        builder = (() => const SplashScreen());

  /// Screen config for the [HomeScreen].
  ScreenConfig.home()
      : path = NavigationConstants.home,
        builder = (() => const HomeScreen());

  /// Screen config for the [SettingsScreen]
  ScreenConfig.settings()
      : path = NavigationConstants.settings,
        builder = (() => const SettingsScreen());

  /// Screen config for the [TaskScreen].
  ScreenConfig.task({String? id})
      : path = NavigationConstants.task,
        builder = (() => TaskScreen(id: id));

  /// Screen config for the [GroupsScreen]
  ScreenConfig.groups()
      : path = NavigationConstants.groups,
        builder = (() => const GroupsScreen());

  /// Path of the page, will be the url on web.
  final String path;

  /// Builder method to navivgate to the page.
  final Widget Function() builder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ScreenConfig && other.path == path;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[path]);
}
