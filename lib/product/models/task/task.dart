import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/extensions/string/type_conversion_extensions.dart';
import '../../../core/helpers/equality_checkers.dart';
import '../../../core/helpers/hasher.dart';
import '../../constants/enums/task/task_enums_shelf.dart';
import '../../managers/local-storage/hive_configs.dart';

part 'task.g.dart';

@HiveType(typeId: HiveConfigs.tasks)

/// [Task] model is to store the information about a task.
class Task with HiveObjectMixin, EqualityCheckers {
  /// Default constructor for [Task].
  /// Overrides [toString], [hashCode] methods and [==] operator.
  Task({
    required this.content,
    required this.groupId,
    Priorities? priority,
    DateTime? dueDate,
    TaskStatus? taskStatus,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? awardIds,
    List<String>? awardOfIds,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        dueDate = dueDate ?? DateTime.now(),
        _priority = (priority ?? Priorities.medium).name,
        _status = (taskStatus ?? TaskStatus.open).name,
        awardIds = awardIds ?? <String>[],
        awardOfIds = awardOfIds ?? <String>[];

  /// Mock object, dummy data for [Task].
  Task.mock({
    Priorities? newPriority,
    TaskStatus? taskStatus,
    String? groupId,
    String? content,
    List<String>? awardIds,
    List<String>? awardOfIds,
  })  : id = const Uuid().v4(),
        content = content ?? 'This is a great task.',
        groupId = groupId ?? '1',
        _priority = (newPriority ??
                Priorities.values[Random().nextInt(Priorities.values.length)])
            .name,
        _status = (taskStatus ??
                TaskStatus.values[Random().nextInt(TaskStatus.values.length)])
            .name,
        createdAt =
            DateTime.now().subtract(Duration(days: Random().nextInt(20))),
        updatedAt = DateTime.now(),
        dueDate = DateTime.now().add(Duration(days: Random().nextInt(20))),
        awardIds = awardIds ?? <String>[],
        awardOfIds = awardOfIds ?? <String>[];

  /// Copies the [Task].
  Task copyWith({
    Priorities? newPriority,
    String? content,
    TaskStatus? taskStatus,
    DateTime? dueDate,
    String? groupId,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? awardIds,
    List<String>? awardOfIds,
  }) =>
      Task(
        id: id ?? this.id,
        priority: newPriority ?? priority,
        content: content ?? this.content,
        groupId: groupId ?? this.groupId,
        dueDate: dueDate ?? this.dueDate,
        taskStatus: taskStatus ?? status,
        awardIds: awardIds ?? this.awardIds,
        awardOfIds: awardOfIds ?? this.awardOfIds,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: DateTime.now(),
      );

  /// Priority of the task.
  @HiveField(0)
  String _priority;

  /// Content of the task.
  @HiveField(1)
  String content;

  /// Unique id of the task.
  @HiveField(2)
  final String id;

  /// The date when the task is created.
  @HiveField(3)
  final DateTime createdAt;

  /// The date when the task is lastly updated.
  @HiveField(4)
  final DateTime updatedAt;

  /// Status of the task. Refer to [TaskStatus] enum.
  @HiveField(5)
  String _status;

  /// Planned due date of the task.
  @HiveField(6)
  DateTime dueDate;

  /// Group id of the task.
  @HiveField(7)
  String groupId;

  /// Refers to the tasks those this task is award of.
  @HiveField(8)
  final List<String> awardOfIds;

  /// Refers to the tasks that are award of this task.
  @HiveField(9)
  final List<String> awardIds;

  @override
  String toString() => content;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Task &&
        other.priority == priority &&
        other.content == content &&
        other.dueDate == dueDate &&
        other.status == status &&
        other.groupId == groupId &&
        other.id == id;
  }

  /// Compares two [Task] item.
  int operator >(Task other) {
    if (this == other) return 0;
    final List<Priorities> taskPriorities = Priorities.values.ordered;
    if (taskPriorities.indexOf(priority) <
        taskPriorities.indexOf(other.priority)) {
      return 1;
    }
    return -1;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[
        priority.name,
        content,
        createdAt.toIso8601String(),
        updatedAt.toIso8601String(),
        dueDate.toIso8601String(),
        status.name,
        groupId,
        awardIds.toString(),
        awardOfIds.toString(),
        id,
      ]);

  /// Returns the priority of the task.
  Priorities get priority =>
      _priority.toEnum(Priorities.values) ?? Priorities.medium;

  /// Returns the priority of the task.
  TaskStatus get status => _status.toEnum(TaskStatus.values) ?? TaskStatus.open;

  /// Gets the award status of the task to determine whether it is an award.
  TaskAwardStatus get awardStatus {
    final bool award = awardOfIds.isNotEmpty;
    final bool todo = awardIds.isNotEmpty;
    if (award && todo) return TaskAwardStatus.both;
    if (award && !todo) return TaskAwardStatus.award;
    return TaskAwardStatus.toDo;
  }

  /// Sets the status of the task.
  void setStatus(TaskStatus newStatus) {
    _status = newStatus.name;
  }

  /// Sets the priority of the task.
  void setPriority(Priorities newPriority) {
    _priority = newPriority.name;
  }
}
