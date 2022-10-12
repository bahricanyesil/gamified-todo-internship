import 'package:flutter/material.dart';
import '../../../../product/constants/enums/task/task_enums_shelf.dart';

/// Class to store and transfer the title and logo of tasks sections.
class TasksSection {
  /// Default constructors for [TasksSection].
  const TasksSection({
    required this.title,
    required this.status,
    this.icon,
  });

  /// Title of the tasks section (e.g. Finished Tasks).
  final String title;

  /// Optional [IconData] that represents the tasks section.
  /// As default the icon of status is used.
  final IconData? icon;

  /// [TaskStatus] of the tasks section.
  final TaskStatus status;
}
