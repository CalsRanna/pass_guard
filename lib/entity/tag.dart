import 'package:floor/floor.dart';

@Entity(indices: [
  Index(unique: true, value: ['name'])
], tableName: 'tags')
class Tag {
  @PrimaryKey()
  final int? id;
  final String name;

  Tag({this.id, required this.name});

  Tag copyWith({int? id, String? name}) {
    return Tag(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
