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
}

@embedded
@Name('segments')
class Segment {
  String title = '';
  List<Field> fields = [];
}

@embedded
@Name('fields')
class Field {
  String key = '';
  String value = '';
  String type = '';
  String label = '';
}
