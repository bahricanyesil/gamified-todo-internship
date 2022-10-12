import '../string/type_conversion_extensions.dart';

/// Extensions on abstract [Enum] class.
extension EnumValues on Enum {
  /// Gets the value of enum.
  String get value => toString().split('.').last.capitalize;
}
