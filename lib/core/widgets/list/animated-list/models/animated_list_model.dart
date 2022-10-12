import 'package:flutter/material.dart';
import '../custom_animated_list.dart';

/// Item callback to create a list item.
typedef ItemCallback<T> = Widget Function(T element, {bool isRemoved});

/// Item builder for removed item.
typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

/// Model to customize [CustomAnimatedList].
class AnimatedListModel<T> {
  /// Default constructor for [AnimatedListModel].
  AnimatedListModel({
    required this.items,
    required this.listKey,
    required this.itemCallback,
    this.visibleItemCount,
  });

  /// [GlobalKey] of the [CustomAnimatedList].
  final GlobalKey<AnimatedListState> listKey;

  /// Item callback to create a list item.
  final ItemCallback<T> itemCallback;

  /// Visible item count.
  int? visibleItemCount;

  /// List of items.
  List<T> items;

  AnimatedListState? get _animatedList => listKey.currentState;

  /// Inserts an item to the list.
  void insert(int index, T item) {
    items.insert(index, item);
    _animatedList?.insertItem(index);
  }

  /// Removes an item from the list.
  T removeAt(int index) {
    final T removedItem = items.removeAt(index);
    if (removedItem != null && _animatedList != null) {
      _animatedList!
          .removeItem(index, (_, __) => _removedItemBuilder(__, removedItem));
    }
    return removedItem;
  }

  Widget _removedItemBuilder(Animation<double> animation, T removedItem) =>
      AnimatedListItemWrapper(
        animation: animation,
        child: itemCallback(removedItem, isRemoved: true),
      );

  /// Returns the total length of the list.
  int get length => items.length;

  /// Implements [] operator for the list as a shortcut.
  T operator [](int index) => items[index];

  /// Returns the index of the given item.
  int indexOf(T item) => items.indexOf(item);

  /// Returns teh visible item count.
  int get itemCount => visibleItemCount ?? length;
}
