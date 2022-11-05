import 'package:floor/floor.dart';

@Entity(primaryKeys: ['guard_id', 'tag_id'], tableName: 'guard_tags')
class GuardTag {
  @ColumnInfo(name: 'guard_id')
  final int guardId;
  @ColumnInfo(name: 'tag_id')
  final int tagId;

  GuardTag({required this.guardId, required this.tagId});

  GuardTag copyWith({int? guardId, int? tagId}) {
    return GuardTag(
      guardId: guardId ?? this.guardId,
      tagId: tagId ?? this.tagId,
    );
  }

  Map<String, dynamic> toJson() {
    return {'guard_id': guardId, 'tag_id': tagId};
  }
}
