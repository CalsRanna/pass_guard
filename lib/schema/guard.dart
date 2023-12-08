import 'package:isar/isar.dart';

part 'guard.g.dart';

@collection
@Name('guards')
class Guard {
  Id id = Isar.autoIncrement;
  String title = '';
  List<Segment> segments = [];
  @Name('created_at')
  DateTime createdAt = DateTime.now();
  @Name('updated_at')
  DateTime updatedAt = DateTime.now();

  Guard();

  factory Guard.fromJson(Map<String, dynamic> json) {
    final guard = Guard();
    guard.title = json['title'] ?? '';
    guard.segments = (json['segments'] as List)
        .map((segment) => Segment.fromJson(segment))
        .toList();
    guard.createdAt = json['created_at'] ?? DateTime.now();
    guard.updatedAt = json['updated_at'] ?? DateTime.now();
    return guard;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'segments': segments.map((segment) => segment.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

@embedded
@Name('segments')
class Segment {
  String title = '';
  List<Field> fields = [];

  Segment();

  factory Segment.fromJson(Map<String, dynamic> json) {
    final segment = Segment();
    segment.title = json['title'];
    segment.fields =
        (json['fields'] as List).map((field) => Field.fromJson(field)).toList();
    return segment;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }
}

@embedded
@Name('fields')
class Field {
  String key = '';
  String value = '';
  String type = '';
  String label = '';

  Field();

  factory Field.fromJson(Map<String, dynamic> json) {
    final field = Field();
    field.key = json['key'];
    field.value = json['value'];
    field.type = json['type'];
    field.label = json['label'];
    return field;
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'type': type,
      'label': label,
    };
  }
}
