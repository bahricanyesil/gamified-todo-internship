import 'package:hive_flutter/hive_flutter.dart';

/// Abstract local manager interface, implemented for Hive.
/// * T: Value to store
/// * R: Key to search
abstract class ILocalManager<R, T> {
  /// Default constructor for [ILocalManager], takes key as argument.
  ILocalManager();

  /// Local storage should have a box name.
  String get boxName;

  late Box<T>? _box;

  /// Initialize the required settings for box.
  Future<void> initStorage() async {
    registerAdapters();
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<T>(boxName);
    }
    _box = Hive.box<T>(boxName);
  }

  /// Clears all of the things in the box.
  Future<void> clearAll() async => await _box?.clear();

  /// Adapt the registers for custom models.
  void registerAdapters();

  /// Gets the element from the box with the corresponding key.
  T? get(R key) => _box?.get(_key(key));

  /// Gets the all elements for the given key set.
  List<T> getMultiple(List<R> keys) {
    final List<T> items = <T>[];
    for (final R key in keys) {
      final T? item = _box?.get(_key(key));
      if (item == null) continue;
      items.add(item);
    }
    return items;
  }

  /// Adds an element to the box with the corresponding key.
  Future<void> addOrUpdate(R key, T item) async =>
      await _box?.put(_key(key), item);

  /// Updates the element in the box with the corresponding key.
  Future<bool> update(R key, T item) async {
    final bool exists = containsKey(key);
    if (!exists) return false;
    await _box?.put(_key(key), item);
    return true;
  }

  /// Adds multiple items at one shot with auto-increment keys.
  Future<void> addItems(List<T> items) async => await _box?.addAll(items);

  /// Adds multiple items with key-value pairs.
  Future<void> putItems(List<R> keys, List<T> values) async =>
      await _box?.putAll(
        <String, T>{
          for (int i = 0; i < keys.length; i++) _key(keys[i]): values[i]
        },
      );

  /// Returns all items in the box.
  List<T> allValues() => _box?.values.toList() ?? <T>[];

  /// Removes item matching with the given keys.
  Future<void> removeItem(R key) async => await _box?.delete(_key(key));

  /// Checks whether the given key exists in the box.
  bool containsKey(R key) => _box?.containsKey(_key(key)) ?? false;

  /// Returns all keys.
  List<dynamic> get keys => _box?.keys.toList() ?? <dynamic>[];

  String _key(R key) {
    if (key is Enum) {
      return key.name;
    } else if (key is String) {
      return key;
    } else {
      return key.toString();
    }
  }
}
