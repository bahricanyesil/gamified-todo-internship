import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/groups/view-model/groups_view_model.dart';
import '../../features/home/view-model/home_view_model.dart';
import '../../features/settings/view-model/settings_view_model.dart';
import '../../features/splash/view-model/splash_view_model.dart';
import '../../features/task/view-model/task_view_model.dart';
import '../managers/navigation/navigation_manager.dart';
import 'theme/theme_provider.dart';

/// Provides the list of providers will be used across the app.
class ProviderList {
  /// Singleton instance of [ProviderList].
  factory ProviderList() => _instance;
  ProviderList._();
  static final ProviderList _instance = ProviderList._();

  /// List of providers will be used for main [MultiProvider] class.
  static final List<SingleChildWidget> providers = <SingleChildWidget>[
    ..._viewModels,
    ..._functionals,
  ];

  static final List<SingleChildWidget> _viewModels = <SingleChildWidget>[
    ChangeNotifierProvider<SplashViewModel>(
      create: (_) => SplashViewModel(),
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
    ),
    ChangeNotifierProvider<SettingsViewModel>(
      create: (_) => SettingsViewModel(),
    ),
    ChangeNotifierProvider<TaskViewModel>(
      create: (_) => TaskViewModel(),
    ),
    ChangeNotifierProvider<GroupsViewModel>(
      create: (_) => GroupsViewModel(),
    ),
  ];

  static final List<SingleChildWidget> _functionals = <SingleChildWidget>[
    ChangeNotifierProvider<NavigationManager>(
      create: (_) => NavigationManager(),
    ),
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
    ),
  ];
}
