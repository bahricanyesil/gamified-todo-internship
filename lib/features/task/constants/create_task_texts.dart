import 'package:flutter/material.dart';

/// Collection of texts in the Task Screen.
mixin TaskTexts on StatelessWidget {
  /// Title of the screen.
  static const String title = 'Create a Task';

  /// Hint text of the content field.
  static const String hintText = 'Write the task content';

  /// Due date title for the task.
  static const String dueDate = 'Due Date:';

  /// Priority title for the task.
  static const String priority = 'Priority:';

  /// Priority dialog title.
  static const String priorityDialogTitle = 'Choose a Priority';

  /// Group title for the task.
  static const String group = 'Group:';

  /// Group dialog title.
  static const String groupDialogTitle = 'Choose a Group';

  /// Awards to tasks.
  static const String awardsTitle = 'Awards of This Task:';

  /// Awards to dialog title.
  static const String awardsDialogTitle = 'Choose the tasks';
}
