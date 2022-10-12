/// Base model for all of the models in the app.
abstract class BaseModel<T> {
  /// Converts a model to a json.
  Map<String, dynamic> get toJson;

  /// Parses and converts a map/json to the given model.
  T fromJson(Map<String, dynamic> json);

  @override
  String toString();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  /// Gets a field by its type.
  static R? getByType<R>(dynamic data) => data is R ? data : null;

  /// Gets a field by its type, difference from [getByType] is this will assign
  /// a default value to the field if it doesn't exist.
  static R getWithDefault<R>(dynamic data, R defaultValue) =>
      data is R ? data : defaultValue;

  /// Returns list of given object by taking from the embedded map and parsing.
  static List<R> embeddedListFromJson<R extends BaseModel<R>>(
      dynamic json, R model) {
    if (json is List<Map<String, dynamic>>) {
      return List<R>.from(
          json.map((Map<String, dynamic> e) => model.fromJson(e)));
    }
    return <R>[];
  }

  /// Converts a list of object to a list of json/map.
  static List<Map<String, dynamic>>? embeddedListToJson<R extends BaseModel<R>>(
      List<R>? list) {
    if (list is List<R>) {
      return List<Map<String, dynamic>>.from(
          list.map((R model) => model.toJson));
    }
    return <Map<String, dynamic>>[];
  }

  /// Parses and converts a json to the given model.
  static R embeddedModelFromJson<R extends BaseModel<R>>(
          dynamic json, R model) =>
      json is Map<String, dynamic> ? model.fromJson(json) : model;

  /// Parses and converts a model to a json/map.
  static Map<String, dynamic>? embeddedModelToJson<R extends BaseModel<R>>(
          R? model) =>
      model is R ? model.toJson : null;
}
