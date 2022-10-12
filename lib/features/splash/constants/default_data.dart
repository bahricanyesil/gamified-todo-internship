part of '../view-model/splash_view_model.dart';

/// Default initial data of the app.
mixin _DefaultData {
  static final List<Group> _defaultGroups = <Group>[
    Group(title: 'Self-Care'),
    Group(title: 'Sport'),
    Group(title: 'Self-Development'),
    Group(title: 'Emotional'),
  ];

  static List<Task> get _defaultTasks {
    _reading.awardOfIds.add(_stretching.id);
    _watching.awardOfIds.add(_stretching.id);
    _stretching.awardOfIds.add(_walking.id);
    _stretching.awardIds.addAll(<String>[_reading.id, _watching.id]);
    _walking.awardIds.add(_stretching.id);
    _brushingTeeths.awardIds.add(_stretching.id);
    return <Task>[
      _reading,
      _stretching,
      _walking,
      _brushingTeeths,
      _beingHappy,
      _watching,
    ];
  }

  static final Task _reading = Task(
      priority: Priorities.medium,
      content: 'Read "When Nietzsche Wept"',
      groupId: _defaultGroups[2].id,
      dueDate: DateTime.now().add(const Duration(hours: 28)));

  static final Task _watching = Task(
      priority: Priorities.low,
      content: 'Watch "The Pianist"',
      groupId: _defaultGroups[2].id,
      dueDate: DateTime.now().add(const Duration(days: 4)));

  static final Task _walking = Task(
      priority: Priorities.high,
      content: 'Walk at least 40 mins',
      groupId: _defaultGroups[1].id,
      taskStatus: TaskStatus.finished,
      dueDate: DateTime.now().add(const Duration(hours: 1)));

  static final Task _stretching = Task(
      priority: Priorities.medium,
      content: 'Do stretching exercises',
      groupId: _defaultGroups[1].id,
      dueDate: DateTime.now().add(const Duration(hours: 20)));

  static final Task _brushingTeeths = Task(
      priority: Priorities.high,
      content: 'Brush your teeth at morning',
      groupId: _defaultGroups[0].id,
      taskStatus: TaskStatus.active,
      dueDate: DateTime.now().add(const Duration(days: 5)));

  static final Task _beingHappy = Task(
      priority: Priorities.high,
      content: 'Be happy',
      groupId: _defaultGroups[3].id,
      taskStatus: TaskStatus.overDue,
      dueDate: DateTime.now().add(const Duration(days: 1)));
}
