import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/managers/storage/l_local_manager.dart';
import '../../../../product/models/task/task.dart';
import '../hive_configs.dart';

/// Local storage manager for the tasks.
class TasksLocalManager extends ILocalManager<String, Task> {
  /// Factory constructor for singleton structure.
  factory TasksLocalManager() => _instance;
  TasksLocalManager._();

  static final TasksLocalManager _instance = TasksLocalManager._();

  /// Static instance getter of [TasksLocalManager].
  static TasksLocalManager get instance => _instance;

  /// Name of the box for tasks.
  static const String _name = 'tasks';

  @override
  String get boxName => _name;

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveConfigs.tasks)) {
      Hive.registerAdapter(TaskAdapter());
    }
  }
}
