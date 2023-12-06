import 'package:isar/isar.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/migration.dart';
import 'package:path_provider/path_provider.dart';

late Isar isar;

class IsarInitializer {
  static Future<void> ensureInitialized() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MigrationSchema, GuardSchema],
      directory: directory.path,
    );
  }
}
