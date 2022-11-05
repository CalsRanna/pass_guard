import 'package:floor/floor.dart';
import 'package:password_generator/entity/tag.dart';

@dao
abstract class TagDao {
  @delete
  Future<void> deleteTag(Tag tag);

  @Query('select * from tags')
  Future<List<Tag>> getAllTags();

  @insert
  Future<void> insertTag(Tag tag);
}
