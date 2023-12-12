import 'package:isar/isar.dart';

part 'migration.g.dart';

/// A `Migration` class that represents a database migration record.
///
/// Each `Migration` object holds information about a specific database migration,
/// including its unique identifier, name, and the timestamps for when the migration
/// was created and last updated.
///
/// Fields:
///   - `id`: An auto-incrementing identifier for each migration.
///   - `name`: A string representing the name of the migration.
///   - `createdAt`: A `DateTime` indicating when the migration was created.
///   - `updatedAt`: A `DateTime` indicating when the migration was last updated.
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
