import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

import '../../../core/base/view-model/base_view_model.dart';
import '../../../core/constants/constants_shelf.dart';
import '../../../core/extensions/string/type_conversion_extensions.dart';
import '../../../core/helpers/completer_helper.dart';
import '../../../product/constants/enums/task/task_status.dart';
import '../../../product/managers/local-storage/settings/settings_local_manager.dart';

/// View model to manaage the data on settings screen.
class SettingsViewModel extends BaseViewModel {
  late final SettingsLocalManager _localManager;

  /// Stores the visiblity of the animated lists.
  late final List<Tuple2<TaskStatus, bool>> _visibleSections;

  int _deleteInterval = 3;

  @override
  Future<void> init() async {
    _localManager = SettingsLocalManager.instance;
    await _localManager.initStorage();
    final String? interval =
        _localManager.get(SettingsStorageKeys.deleteInterval);
    final int? storedInterval = int.tryParse(interval ?? '');
    if (storedInterval != null) {
      _deleteInterval = storedInterval;
    }
    final List<Tuple2<TaskStatus, bool>>? storedList =
        _localManager.get(SettingsStorageKeys.sectionStatus)?.fromJson;
    _visibleSections = storedList ??
        List<Tuple2<TaskStatus, bool>>.generate(TaskStatus.values.length,
            (int i) => Tuple2<TaskStatus, bool>(TaskStatus.values[i], true));
  }

  /// Sets the visibility of a section.
  // ignore: avoid_positional_boolean_parameters
  void setSectionVisibility(TaskStatus status, bool value) {
    final int index = _visibleSections
        .indexWhere((Tuple2<TaskStatus, bool> tuple) => tuple.item1 == status);
    if (index == -1) return;
    _visibleSections[index] = _visibleSections[index].withItem2(value);
    notifyListeners();
    completer = CompleterHelper.wrapCompleter(_storeLocal());
  }

  /// Returns the visibility of the given task status.
  bool sectionVisibility(TaskStatus status) =>
      _visibleSections
          .firstWhereOrNull(
              (Tuple2<TaskStatus, bool> tuple) => tuple.item1 == status)
          ?.item2 ??
      false;

  /// Returns the list of visible task statuses.
  List<TaskStatus> get visibleStatuses {
    final List<TaskStatus> visibleOnes = <TaskStatus>[];
    for (final Tuple2<TaskStatus, bool> tuple in _visibleSections) {
      if (tuple.item2) visibleOnes.add(tuple.item1);
    }
    return visibleOnes;
  }

  Future<void> _storeLocal() async => _localManager.addOrUpdate(
      SettingsStorageKeys.sectionStatus, _visibleSections.toJson);

  /// Returns the delete interval
  int get deleteInterval => _deleteInterval;

  /// Sets the delete interval
  void setDeleteInterval(int days) {
    _deleteInterval = days;
    completer = CompleterHelper.wrapCompleter<void>(_updateLocal(days));
    notifyListeners();
  }

  Future<void> _updateLocal(int days) async => _localManager.addOrUpdate(
      SettingsStorageKeys.deleteInterval, days.toString());
}

extension _VisibleSectionsLocalConverter on List<Tuple2<TaskStatus, bool>> {
  String get toJson {
    final Map<String, dynamic> map = <String, dynamic>{};
    for (final Tuple2<TaskStatus, bool> tuple in this) {
      map[tuple.item1.name] = tuple.item2;
    }
    return jsonEncode(map);
  }
}

extension _StringToSectionLocalConverter on String {
  List<Tuple2<TaskStatus, bool>> get fromJson {
    final List<Tuple2<TaskStatus, bool>> sections =
        <Tuple2<TaskStatus, bool>>[];
    final Map<String, dynamic> map = jsonDecode(this);
    for (final String key in map.keys) {
      final TaskStatus? status = key.toEnum(TaskStatus.values);
      if (status == null) continue;
      sections.add(Tuple2<TaskStatus, bool>(status, map[key]));
    }
    return sections;
  }
}
