import 'package:isar/isar.dart';

part 'migration.g.dart';

@collection
@Name('migrations')
class Migration {
  Id id = Isar.autoIncrement;
  String name = '';
  @Name('created_at')
  DateTime createdAt = DateTime.now();
  @Name('updated_at')
  DateTime updatedAt = DateTime.now();
}
