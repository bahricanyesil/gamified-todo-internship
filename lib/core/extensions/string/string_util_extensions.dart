/// Utility extensions for [String] class.
extension StringUtilExtensions on String {
  /// To use correct ellipsis behavior on text overflows.
  String get useCorrectEllipsis => replaceAll('', '\u200B');

  /// Returns the icon asset path for the given name.
  String get iconPng => 'assets/images/icons/$this.png';

  /// Returns hypenatied text.
  String get hyphenate => split('').join('\u00ad');
}
