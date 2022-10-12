import 'package:flutter/material.dart';

/// Collection of helpers for material state properties.
mixin MaterialStateHelpers {
  /// Returns the corresponding all material state property for given value.
  MaterialStateProperty<T> all<T>(T value) => MaterialStateProperty.all(value);
}
