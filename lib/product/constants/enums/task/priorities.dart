import 'package:flutter/material.dart';

import '../../../../../core/theme/color/l_colors.dart';
import '../../../../core/extensions/color/color_extensions.dart';
import '../../../../core/widgets/widgets_shelf.dart';

/// Determines the priorities of the tasks.
enum Priorities {
  /// Indicates a low prioritized task.
  low,

  /// Indicates a medium prioritized task.
  medium,

  /// Indicates a high prioritized task.
  high,
}

/// Extensions on [Priorities] enum.
extension PriorityExtensions on Priorities {
  /// Gets the corresponding color for the priority.
  Color get color {
    switch (this) {
      case Priorities.low:
        return AppColors.lowPriority;
      case Priorities.medium:
        return AppColors.medPriority.darken(.1);
      case Priorities.high:
        return AppColors.highPriority;
    }
  }

  /// Gets the corresponding text widget for the priority.
  BaseText get numberText {
    switch (this) {
      case Priorities.low:
        return const BaseText('3',
            fontSizeFactor: 6.2, fontWeight: FontWeight.w400);
      case Priorities.medium:
        return const BaseText('2',
            fontSizeFactor: 6.6, fontWeight: FontWeight.w500);
      case Priorities.high:
        return const BaseText('1',
            fontSizeFactor: 7, fontWeight: FontWeight.w600);
    }
  }
}

/// List of [Priorities] extensions.
extension OrderedPriorities on List<Priorities> {
  /// Ordered task status list.
  List<Priorities> get ordered => <Priorities>[
        Priorities.high,
        Priorities.medium,
        Priorities.low,
      ];
}
