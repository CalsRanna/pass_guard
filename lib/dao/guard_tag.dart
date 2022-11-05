import 'package:floor/floor.dart';
import 'package:password_generator/entity/guard_tag.dart';

@dao
abstract class GuardTagDao {
  @Query('select * from guard_tags')
  Future<List<GuardTag>> getAllGuardTags();
}
