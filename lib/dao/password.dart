import 'package:floor/floor.dart';
import 'package:password_generator/entity/password.dart';

@dao
abstract class PasswordDao {
  @delete
  Future<void> deletePassword(Password password);

  @Query('delete from passwords')
  Future<void> deleteAllPasswords();

  @Query('select * from passwords where id = :id')
  Future<Password?> findPasswordById(int id);

  @Query('select * from passwords order by name')
  Future<List<Password>> getAllPasswords();

  @Query('select * from passwords where name like :text order by name')
  Future<List<Password>> getPasswordsLikeName(String text);

  @insert
  Future<void> insertPassword(Password password);

  @update
  Future<void> updatePassword(Password password);
}
