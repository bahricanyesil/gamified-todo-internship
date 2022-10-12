import '../../../../core/managers/storage/l_local_manager.dart';

/// Local storage manager for the settings.
class SettingsLocalManager extends ILocalManager<Enum, String> {
  /// Factory constructor for singleton structure.
  factory SettingsLocalManager() => _instance;
  SettingsLocalManager._();

  static final SettingsLocalManager _instance = SettingsLocalManager._();

  /// Static instance getter of [SettingsLocalManager].
  static SettingsLocalManager get instance => _instance;

  /// Name of the box for settings.
  static const String _name = 'settings';

  @override
  String get boxName => _name;

  @override
  void registerAdapters() {}
}
