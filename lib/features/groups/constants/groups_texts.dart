import 'package:flutter/material.dart';

/// Collection of texts in the groups screen.
mixin GroupsTexts on StatelessWidget {
  /// Title of the screen.
  static const String title = 'Groups';

  /// Content of the delete dialog.
  static const String deleteContent =
      """If you delete this group, all of the tasks that belong to this group will also be deleted. Don't forget that this action cannot be undone.""";
}
