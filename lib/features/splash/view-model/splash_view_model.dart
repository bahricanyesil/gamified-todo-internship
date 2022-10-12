import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/constants/enums/settings-enums/login_status.dart';
import '../../../core/constants/enums/settings-enums/settings_storage_keys.dart';
import '../../../core/extensions/string/type_conversion_extensions.dart';
import '../../../product/constants/enums/task/task_enums_shelf.dart';
import '../../../product/managers/local-storage/local_managers_shelf.dart';
import '../../../product/models/group/group.dart';
import '../../../product/models/task/task.dart';
import '../../settings/view-model/settings_view_model.dart';

part '../constants/default_data.dart';

/// View model to manaage the data on splash screen.
class SplashViewModel extends BaseViewModel {
  late final GroupsLocalManager _groupsStorage;
  late final TasksLocalManager _tasksStorage;
  late final SettingsLocalManager _settingsStorage;

  static const SettingsStorageKeys _loginKey = SettingsStorageKeys.loginStatus;

  late final LoginStatus? _loginStatus;

  @override
  Future<void> init() async {
    _groupsStorage = GroupsLocalManager.instance;
    _tasksStorage = TasksLocalManager.instance;
    _settingsStorage = SettingsLocalManager.instance;
    await _groupsStorage.initStorage();
    await _tasksStorage.initStorage();
    await _settingsStorage.initStorage();
    _loginStatus =
        _settingsStorage.get(_loginKey).toEnum<LoginStatus>(LoginStatus.values);
  }

  /// Initialize the settings view model.
  Future<void> initSettings(SettingsViewModel settingsViewModel) async =>
      settingsViewModel.initCompleter.future;

  /// Initialize the storage with the default values.
  Future<void> initStorage() async {
    if ((_loginStatus ?? LoginStatus.first) == LoginStatus.first) {
      await _groupsStorage.putItems(
          _DefaultData._defaultGroups.map((Group g) => g.id).toList(),
          _DefaultData._defaultGroups);
      await _tasksStorage.putItems(
          _DefaultData._defaultTasks.map((Task t) => t.id).toList(),
          _DefaultData._defaultTasks);
      await _settingsStorage.addOrUpdate(_loginKey, LoginStatus.normal.name);
    }
  }
}
