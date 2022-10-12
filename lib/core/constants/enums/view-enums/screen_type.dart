import 'package:flutter/material.dart';

/// Type of the screen.
enum ScreenType {
  /// Screen type is create.
  create,

  /// Screen type is edit.
  edit,
}

/// Helper extensions on [ScreenType].
extension ScreenTypeHelpers on ScreenType {
  /// Returns the action text for the screen type.
  String get actionText {
    switch (this) {
      case ScreenType.create:
        return 'Create';
      case ScreenType.edit:
        return 'Update';
    }
  }

  /// Returns the icon for the screen type.
  IconData get icon {
    switch (this) {
      case ScreenType.create:
        return Icons.add_outlined;
      case ScreenType.edit:
        return Icons.edit_outlined;
    }
  }
}
