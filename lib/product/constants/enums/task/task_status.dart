import 'package:flutter/material.dart';
import '../../../../core/extensions/color/color_extensions.dart';
import '../../../../core/theme/color/l_colors.dart';
import '../../../../core/widgets/icons/base_icon.dart';

/// Enum to indicate the status of a task.
/// * Open
/// * Active
/// * Over Due
/// * Finished
enum TaskStatus {
  /// Indicates that the task is craeted but not yet in progress.
  open,

  /// Indicates that the task is active and currently working on.
  active,

  /// Indicates that the task is over due and it's aimed date is passed.
  overDue,

  /// Indicates that the task is finished on time.
  finished,
}

/// Custom extensions for [TaskStatus].
extension TaskStatusValue on TaskStatus {
  /// Gets the string value of the task status.
  String get value {
    switch (this) {
      case TaskStatus.open:
        return 'Open';
      case TaskStatus.active:
        return 'Active';
      case TaskStatus.overDue:
        return 'Over Due';
      case TaskStatus.finished:
        return 'Finished';
    }
  }

  /// Corresponding icon for the task status.
  BaseIcon get icon {
    switch (this) {
      case TaskStatus.open:
        return SizedBaseIcon(Icons.access_time_outlined,
            color: AppColors.medPriority.darken());
      case TaskStatus.active:
        return const SizedBaseIcon(Icons.run_circle_outlined,
            color: AppColors.loadingColor);
      case TaskStatus.overDue:
        return const SizedBaseIcon(Icons.close_outlined,
            color: AppColors.highPriority);
      case TaskStatus.finished:
        return SizedBaseIcon(Icons.check,
            color: AppColors.lowPriority.darken());
    }
  }
}

/// List of [TaskStatus] extensions.
extension OrderedTasks on List<TaskStatus> {
  /// Ordered task status list.
  List<TaskStatus> get ordered => <TaskStatus>[
        TaskStatus.overDue,
        TaskStatus.active,
        TaskStatus.open,
        TaskStatus.finished
      ];
}

/// Nullable [TaskStatus] extensions.
extension NullableTaskStatusExtensions on TaskStatus? {
  /// Returns the dismiss direction for task status.
  DismissDirection get direction {
    switch (this) {
      case TaskStatus.open:
        return DismissDirection.startToEnd;
      case TaskStatus.active:
        return DismissDirection.endToStart;
      default:
        return DismissDirection.horizontal;
    }
  }
}
