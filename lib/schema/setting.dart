import 'package:isar/isar.dart';

part 'setting.g.dart';

@collection
@Name('settings')
class Setting {
  Id id = Isar.autoIncrement;
  @Name('main_password')
  String mainPassword = '';
  @Name('web_dav_url')
  String webDavUrl = '';
  @Name('web_dav_username')
  String webDavUsername = '';
  @Name('web_dav_password')
  String webDavPassword = '';
  @Name('sync_strategy')
  int syncStrategy = 0;
  @Name('created_at')
  DateTime createdAt = DateTime.now();
  @Name('updated_at')
  DateTime updatedAt = DateTime.now();
}
