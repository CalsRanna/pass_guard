import 'package:isar/isar.dart';
import 'package:password_generator/schema/guard.dart';

part 'guard_template.g.dart';

@collection
@Name('guard_templates')
class GuardTemplate {
  Id id = Isar.autoIncrement;
  String name = '';
  List<Segment> segments = [];
  @Name('created_at')
  DateTime createdAt = DateTime.now();
  @Name('updated_at')
  DateTime updatedAt = DateTime.now();

  GuardTemplate();

  // fromJson
  factory GuardTemplate.fromJson(Map<String, dynamic> json) {
    final template = GuardTemplate();
    template.id = json['id'] ?? Isar.autoIncrement;
    template.name = json['name'];
    template.segments = (json['segments'] as List)
        .map((segment) => Segment.fromJson(segment))
        .toList();
    template.createdAt = json['created_at'] ?? DateTime.now();
    template.updatedAt = json['updated_at'] ?? DateTime.now();
    return template;
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'segments': segments.map((segment) => segment.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
