import 'package:intl/intl.dart';

/// Extensions on [DateTime] objects.
extension DateTimeExtension on DateTime {
  /// Gets the date-month-year format for the [DateTime].
  String get dmy => DateFormat('d MMMM yyyy').format(this);

  /// Gets the date-month format for the [DateTime].
  String get dm => DateFormat('d MMMM').format(this);
}
