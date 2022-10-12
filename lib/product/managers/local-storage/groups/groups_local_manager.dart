import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/managers/storage/l_local_manager.dart';
import '../../../models/group/group.dart';
import '../hive_configs.dart';

/// Local storage manager for the groups.
class GroupsLocalManager extends ILocalManager<String, Group> {
  /// Factory constructor for singleton structure.
  factory GroupsLocalManager() => _instance;
  GroupsLocalManager._();

  static final GroupsLocalManager _instance = GroupsLocalManager._();

  /// Static instance getter of [GroupsLocalManager].
  static GroupsLocalManager get instance => _instance;

  /// Name of the box for groups.
  static const String _name = 'groups';

  @override
  String get boxName => _name;

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveConfigs.groups)) {
      Hive.registerAdapter(GroupAdapter());
    }
  }
}
