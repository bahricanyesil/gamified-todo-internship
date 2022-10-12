import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/helpers/completer_helper.dart';
import '../../../core/managers/navigation/navigation_shelf.dart';
import '../../../core/widgets/widgets_shelf.dart';
import '../../../product/constants/enums/task/task_enums_shelf.dart';
import '../../../product/extensions/task_extensions.dart';
import '../../../product/managers/local-storage/settings/settings_local_manager.dart';
import '../../../product/managers/local-storage/tasks/tasks_local_manager.dart';
import '../../../product/models/task/task.dart';
import '../view/components/tasks/task_item.dart';
import '../view/ui-models/tasks_section_title.dart';

/// View model to manaage the data on home screen.
class HomeViewModel extends BaseViewModel {
  late final TasksLocalManager _localManager;
  late final SettingsLocalManager _settingsLocalManager;

  /// All created tasks.
  List<Task> _tasks = <Task>[];

  /// List of tasks section titles.
  static const List<TasksSection> tasksSections = <TasksSection>[
    TasksSection(title: 'Active Tasks', status: TaskStatus.active),
    TasksSection(title: 'Open Tasks', status: TaskStatus.open),
    TasksSection(title: 'Finished Tasks', status: TaskStatus.finished),
    TasksSection(title: 'Over Due Tasks', status: TaskStatus.overDue),
  ];

  /// Titles of the menu items.
  static const List<String> menuItemTitles = <String>[
    'Finish',
    'Activate',
    'Open',
    'Edit',
    'Delete'
  ];

  /// Icons of the menu items.
  static const List<IconData> menuItemIcons = <IconData>[
    Icons.check_outlined,
    Icons.run_circle_outlined,
    Icons.access_time_outlined,
    Icons.edit_outlined,
    Icons.delete_outline,
  ];

  /// Stores the expansion status of the animated lists.
  final List<bool> expandedLists =
      List<bool>.generate(TaskStatus.values.length, (_) => false);

  /// Stores the [AnimatedListModel] configurations of the animated lists.
  late final List<AnimatedListModel<Task>> listModels;

  /// Returns all tasks.
  List<Task> get tasks => _tasks;

  @override
  Future<void> init() async {
    _localManager = TasksLocalManager.instance;
    _settingsLocalManager = SettingsLocalManager.instance;
    await _localManager.initStorage();
    await _settingsLocalManager.initStorage();
    final String daysText =
        _settingsLocalManager.get(SettingsStorageKeys.deleteInterval) ?? '3';
    final int days = int.tryParse(daysText) ?? 3;
    _tasks = _localManager.allValues();
    _tasks = _tasks
        .where((Task t) =>
            t.dueDate.isAfter(DateTime.now().subtract(Duration(days: days))))
        .toList();
    _tasks.sort((Task a, Task b) => b > a);
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].dueDate.isBefore(DateTime.now())) {
        _tasks[i].setStatus(TaskStatus.overDue);
        completer =
            CompleterHelper.wrapCompleter<void>(_updateLocal(_tasks[i]));
      }
    }
    completer = CompleterHelper.wrapCompleter<void>(_deleteOldTasks(days));
    listModels = List<AnimatedListModel<Task>>.generate(
        TaskStatus.values.length, _animatedModelBuilder);
  }

  Future<void> _deleteOldTasks(int days) async {
    final List<Task> allValues = _localManager.allValues();
    for (final Task t in allValues) {
      final DateTime limitDate = DateTime.now().subtract(Duration(days: days));
      if (t.dueDate.isBefore(limitDate)) {
        await _localManager.removeItem(t.id);
      }
    }
  }

  AnimatedListModel<Task> _animatedModelBuilder(int index) {
    final List<Task> statusTasks = _tasks.byStatus(TaskStatus.values[index]);
    return AnimatedListModel<Task>(
      listKey: GlobalKey<AnimatedListState>(debugLabel: index.toString()),
      items: statusTasks,
      itemCallback: (Task task, {bool isRemoved = false}) =>
          TaskItem(id: task.id, isRemoved: isRemoved),
    );
  }

  /// Updates the status of a task in the list.
  void updateTaskStatus(String id, TaskStatus newStatus, {bool notify = true}) {
    final int index = _tasks.indexWhere((Task t) => t.id == id);
    if (index == -1) return;
    final Task task = _tasks[index];
    if (task.status != newStatus) {
      _removeItemFromList(task);
      task.setStatus(newStatus);
      _addItemToList(task);
      _tasks[index] = task.copyWith(taskStatus: newStatus);
      completer =
          CompleterHelper.wrapCompleter<void>(_updateLocal(_tasks[index]));
      if (newStatus == TaskStatus.finished) {
        final List<String> awardOfIds = task.awardIds;
        for (final String id in awardOfIds) {
          final Task? otherTask =
              _tasks.firstWhereOrNull((Task t) => t.id == id);
          if (otherTask != null && !otherTask.isFinished && !task.isOverDue) {
            updateTaskStatus(id, TaskStatus.active, notify: false);
          }
        }
      }
      if (notify) notifyListeners();
    }
  }

  /// Used as the callback of confirmation on dismiss on a taks.
  Future<bool> confirmDismiss(DismissDirection direction, String id) async {
    if (direction == DismissDirection.startToEnd) {
      updateTaskStatus(id, TaskStatus.active);
    } else if (direction == DismissDirection.endToStart) {
      updateTaskStatus(id, TaskStatus.open);
    }
    return false;
  }

  int _statusIndex(TaskStatus status) => TaskStatus.values.indexOf(status);

  /// Switches the expansion status of the tasks section.
  void setExpanded(TaskStatus status) {
    final int index = TaskStatus.values.indexOf(status);
    expandedLists[index] = !expandedLists[index];
    notifyListeners();
  }

  /// Returns the corresponding [AnimatedListModel] for the status.
  AnimatedListModel<Task> animatedListModel(TaskStatus status) =>
      listModels[TaskStatus.values.indexOf(status)];

  /// Returns all of the tasks with the given group id.
  List<Task> getByGroupId(String id) =>
      _tasks.where((Task t) => t.groupId == id).toList();

  /// Returns all of the tasks with the given group id and status.
  List<Task> getByGroupIdAndStatus(String id, TaskStatus status) =>
      _tasks.where((Task t) => t.groupId == id && t.status == status).toList();

  /// Returns all of the visible tasks with the given id.
  List<Task> getVisibleByGroupId(String id, List<TaskStatus> visibleStatuses) {
    final List<Task> visibleTasks = _tasks
        .where(
            (Task t) => visibleStatuses.contains(t.status) && t.groupId == id)
        .toList();
    return visibleTasks;
  }

  /// Adds a new task to the list.
  void addTask(Task task) {
    _tasks.add(task);
    _addItemToList(task);
    notifyListeners();
  }

  /// Updates a task.
  void updateTask(String id, Task newTask) {
    final int index = _tasks.indexWhere((Task t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = newTask;
    notifyListeners();
  }

  Future<void> _updateLocal(Task newTask) async =>
      _localManager.addOrUpdate(newTask.id, newTask);

  /// Navigates to the corresponding task screen.
  void navigateToTask(String id) =>
      NavigationManager.instance.setNewRoutePath(ScreenConfig.task(id: id));

  /// Asks for confirmation and deletes the task.
  Future<bool?> deleteDialog(BuildContext context, String id) async =>
      DialogBuilder(context).deleteDialog(deleteAction: () => deleteItem(id));

  /// Directly deletes a task.
  void deleteItem(String id) {
    final int index = _tasks.indexWhere((Task t) => t.id == id);
    if (index != -1) {
      _removeItemFromList(_tasks[index]);
      _tasks.removeAt(index);
      completer = CompleterHelper.wrapCompleter<void>(_removeLocal(id));
      notifyListeners();
    }
  }

  void _removeItemFromList(Task task) {
    final int removedIndex = _tasks.byStatus(task.status).indexById(task.id);
    animatedListModel(task.status).removeAt(removedIndex);
  }

  void _addItemToList(Task task) {
    final int insertedIndex =
        _tasks.byStatus(task.status).findInsertIndex(task.priority);
    animatedListModel(task.status).insert(insertedIndex, task);
    if (insertedIndex > 1) expandedLists[_statusIndex(task.status)] = true;
  }

  Future<void> _removeLocal(String id) async => _localManager.removeItem(id);
}
