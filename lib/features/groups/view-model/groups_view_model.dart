import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/helpers/color_helpers.dart';
import '../../../core/helpers/completer_helper.dart';
import '../../../core/widgets/dialogs/dialog_builder.dart';
import '../../../product/managers/local-storage/groups/groups_local_manager.dart';
import '../../../product/models/group/group.dart';
import '../../../product/models/task/task.dart';
import '../../home/view-model/home_view_model.dart';
import '../constants/groups_texts.dart';

/// View model to manage the data on create group screen.
class GroupsViewModel extends BaseViewModel {
  late final GroupsLocalManager _localManager;

  /// Returns the corresponding title controller for the given index.
  TextEditingController? titleController(String id) {
    final int index =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (index == -1) return null;
    return _groups[index].controller;
  }

  List<_GroupComplexModel> _groups = <_GroupComplexModel>[];

  /// Returns the corresponding group for given index.
  Group group(int i) => _groups[i].group;

  /// Returns all groups.
  List<Group> get groups {
    final List<Group> allGroups = <Group>[];
    for (final _GroupComplexModel model in _groups) {
      allGroups.add(model.group);
    }
    return allGroups;
  }

  @override
  Future<void> init() async {
    _localManager = GroupsLocalManager.instance;
    await _localManager.initStorage();
    final List<Group> storedGroups = _localManager.allValues();
    _groups = List<_GroupComplexModel>.generate(storedGroups.length, (int i) {
      final Group group = storedGroups[i];
      return _GroupComplexModel(group,
          controller: TextEditingController(text: group.title));
    });
  }

  @override
  Future<void> customDispose() async {
    for (int i = 0; i < _groups.length; i++) {
      _groups[i].isExpanded = false;
    }
  }

  /// Adds a new group with the given properties.
  void addGroup(String title) {
    final Group newGroup = Group(title: title);
    _groups.add(_GroupComplexModel(newGroup,
        controller: TextEditingController(text: 'New Group')));
    completer = CompleterHelper.wrapCompleter<void>(_addLocal(newGroup));
    notifyListeners();
  }

  /// Opens a delete dialog.
  Future<bool?> deleteDialog(BuildContext context, String id) async =>
      DialogBuilder(context).deleteDialog(
        deleteAction: () => _deleteGroup(id, context),
        contentText: GroupsTexts.deleteContent,
      );

  /// Deletes the group whose id is given.
  void _deleteGroup(String id, BuildContext context) {
    final int index =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (index != -1) {
      final HomeViewModel model = context.read<HomeViewModel>();
      final List<Task> groupTasks = model.getByGroupId(_groups[index].group.id);
      _groups.removeAt(index);
      for (final Task t in groupTasks) {
        model.deleteItem(t.id);
      }
      completer = CompleterHelper.wrapCompleter<void>(_removeLocal(id));
      notifyListeners();
    }
  }

  /// Notify listeners on title change.
  void onTitleChanged(String id, String? val) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return;
    _groups[i].group =
        _groups[i].group.copyWith(title: _groups[i].controller.text);
    completer = CompleterHelper.wrapCompleter<void>(_updateLocal(i));
    notifyListeners();
  }

  Future<void> _updateLocal(int i) async =>
      _localManager.update(_groups[i].group.id, _groups[i].group);

  Future<void> _removeLocal(String id) async => _localManager.removeItem(id);

  Future<void> _addLocal(Group newGroup) async =>
      _localManager.addOrUpdate(newGroup.id, newGroup);

  /// Returns whether the group item is expanded.
  bool isExpanded(String id) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return false;
    return _groups[i].isExpanded;
  }

  /// Sets the expansion status of the group item.
  void setExpansion(String id, {required bool isExpanded}) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return;
    _groups[i].isExpanded = isExpanded;
    notifyListeners();
  }

  /// Returns the corresponding color for the given group id.
  Color color(String id) {
    final int i =
        _groups.indexWhere((_GroupComplexModel g) => g.group.id == id);
    if (i == -1) return Colors.transparent;
    return _groups[i].backgroundColor;
  }
}

/// Complex group model with additional fields.
class _GroupComplexModel with ColorHelpers {
  /// Default constructor.
  _GroupComplexModel(
    this.group, {
    required this.controller,
    this.isExpanded = false,
    Color? bgColor,
  }) {
    backgroundColor = bgColor ?? lightRandomColor;
  }

  /// Text form controller.
  final TextEditingController controller;

  /// Background color.
  late final Color backgroundColor;

  /// Corresponding group for the item.
  Group group;

  /// Whether the item is expanded.
  bool isExpanded;
}
