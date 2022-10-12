/// Collections of constant durations.
mixin Durations {
  /// Too slow duration constant with 1800 miliseconds.
  static const Duration tooSlow = Duration(milliseconds: 1800);

  /// Slow duration constant with 1500 miliseconds.
  static const Duration slow = Duration(milliseconds: 1500);

  /// Slow-Medium duration constant with 1200 miliseconds.
  static const Duration slowMed = Duration(milliseconds: 1200);

  /// Medium duration constant with 1000 miliseconds.
  static const Duration med = Duration(milliseconds: 1000);

  /// Medium-Fast duration constant with 800 miliseconds.
  static const Duration medFast = Duration(milliseconds: 800);

  /// Fast duration constant with 250 miliseconds.
  static const Duration fast = Duration(milliseconds: 240);

  /// Too fast duration constant with 125 miliseconds.
  static const Duration tooFast = Duration(milliseconds: 120);
}
