import 'package:creator/creator.dart';
import 'package:floor/floor.dart';
import 'package:password_generator/database/database.dart';

final databaseEmitter = Emitter<PasswordDatabase>((ref, emit) async {
  final database =
      await $FloorPasswordDatabase.databaseBuilder('db').addMigrations([
    Migration(2, 3, (db) async {
      await db
          .execute('alter table passwords add column comment text nullable');
    })
  ]).build();
  emit(database);
}, keepAlive: true, name: 'databaseEmitter');
