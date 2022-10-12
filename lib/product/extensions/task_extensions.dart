import 'package:collection/collection.dart';
import '../constants/enums/task/task_enums_shelf.dart';

import '../models/task/task.dart';

/// Extensions on list of [Task].
extension TaskListExtensions on List<Task> {
  /// Finds and returns the [Task] item by id.
  Task? byId(String id) => firstWhereOrNull((Task task) => task.id == id);

  /// Finds and returns the index of [Task] item by id.
  int indexById(String id) => indexWhere((Task task) => task.id == id);

  /// Finds the appropriate index for the status.
  int findInsertIndex(Priorities priority) {
    int insertIndex = indexWhere((Task task) => task.priority == priority);
    int priorityIndex = Priorities.values.indexOf(priority);
    while (insertIndex == -1) {
      insertIndex = priorityIndex == 0 ? 0 : _lastBeforeIndex(priorityIndex);
      priorityIndex--;
    }
    return insertIndex;
  }

  int _lastBeforeIndex(int priorityIndex) =>
      lastIndexWhere((Task task) =>
          task.priority == Priorities.values[priorityIndex - 1]) +
      1;

  /// Gets the list of [Task] by filtering according to status.
  List<Task> byStatus(TaskStatus status) =>
      where((Task element) => element.status == status).toList()
        ..sort((Task a, Task b) => b > a);
}

/// Extensions on [Task].
extension TaskExtensions on Task {
  /// Returns whether the task is over due or not.
  bool get isOverDue =>
      status == TaskStatus.overDue ||
      dueDate.isBefore(DateTime.now().add(const Duration(seconds: 10)));

  /// Returns whether the task is finished.
  bool get isFinished => status == TaskStatus.finished;
}
