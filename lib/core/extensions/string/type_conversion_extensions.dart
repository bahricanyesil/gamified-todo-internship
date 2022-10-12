import 'package:collection/collection.dart';

/// Type conversion extensions on [String] class.
extension TypeConversions on String? {
  /// Converts the string to an enum according to the given list of values.
  T? toEnum<T extends Enum>(List<T> values) => values
      .firstWhereOrNull((T e) => e.name.toLowerCase() == this?.toLowerCase());

  /// Capitalizes the string.
  String get capitalize =>
      '${this?[0].toUpperCase()}${this?.toLowerCase().substring(1)}';
}

/// Type conversion extensions on [String] class without nullable.
extension TypeConversion on String {
  /// Converts the string to a duration.
  Duration get toDuration {
    int hours = 0;
    int minutes = 0;
    int microseconds;
    final List<String> parts = split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    microseconds = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: microseconds);
  }
}
