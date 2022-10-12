import 'package:collection/collection.dart';

/// Collection of equality checkers.
mixin EqualityCheckers {
  /// Controls whether the lists consist of completely equal elements.
  bool listsEqual(List<dynamic> list1, List<dynamic> list2) =>
      const DeepCollectionEquality.unordered().equals(list1, list2);
}
