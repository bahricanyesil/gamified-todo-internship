import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/base/model/base_model.dart';
import '../../../core/helpers/hasher.dart';
import '../../managers/local-storage/hive_configs.dart';

part 'group.g.dart';

@HiveType(typeId: HiveConfigs.groups)

/// [Group] model is to store the information about a group.
class Group extends BaseModel<Group> with HiveObjectMixin {
  /// Default constructor for [Group].
  /// Overrides [toString], [hashCode] methods and [==] operator.
  Group({
    required this.title,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        title: BaseModel.getWithDefault(json['title'], ''),
        createdAt: BaseModel.getWithDefault(json['created_at'], DateTime.now()),
        updatedAt: BaseModel.getWithDefault(json['updated_at'], DateTime.now()),
        id: BaseModel.getWithDefault(json['id'], ''),
      );

  /// Mock object, dummy data for [Group].
  Group.mock({
    String? title,
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        title = title ?? "Sports";

  /// Copies the [Group].
  Group copyWith({String? title}) => Group(
        title: title ?? this.title,
        createdAt: createdAt,
        id: id,
        updatedAt: DateTime.now(),
      );

  /// Unique id of the group.
  @HiveField(0)
  final String id;

  /// The date when the group is created.
  @HiveField(1)
  final DateTime createdAt;

  /// The date when the group is lastly updated.
  @HiveField(2)
  DateTime updatedAt;

  /// The title of the task group.
  @HiveField(3)
  String title;

  @override
  String toString() => title;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Group &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.title == title &&
        other.id == id;
  }

  /// This hashCode part is inspired from Quiver package.
  /// Quiver package link: https://pub.dev/packages/quiver
  @override
  int get hashCode => Hasher.getHashCode(<String>[
        createdAt.toIso8601String(),
        updatedAt.toIso8601String(),
        title,
        id,
      ]);

  @override
  Group fromJson(Map<String, dynamic> json) => Group.fromJson(json);

  @override
  Map<String, dynamic> get toJson => <String, dynamic>{
        'title': title,
        'id': id,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
