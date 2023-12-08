// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guard_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGuardTemplateCollection on Isar {
  IsarCollection<GuardTemplate> get guardTemplates => this.collection();
}

const GuardTemplateSchema = CollectionSchema(
  name: r'guard_templates',
  id: 6059033981490443693,
  properties: {
    r'created_at': PropertySchema(
      id: 0,
      name: r'created_at',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'segments': PropertySchema(
      id: 2,
      name: r'segments',
      type: IsarType.objectList,
      target: r'segments',
    ),
    r'updated_at': PropertySchema(
      id: 3,
      name: r'updated_at',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _guardTemplateEstimateSize,
  serialize: _guardTemplateSerialize,
  deserialize: _guardTemplateDeserialize,
  deserializeProp: _guardTemplateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'segments': SegmentSchema, r'fields': FieldSchema},
  getId: _guardTemplateGetId,
  getLinks: _guardTemplateGetLinks,
  attach: _guardTemplateAttach,
  version: '3.1.0+1',
);

int _guardTemplateEstimateSize(
  GuardTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.segments.length * 3;
  {
    final offsets = allOffsets[Segment]!;
    for (var i = 0; i < object.segments.length; i++) {
      final value = object.segments[i];
      bytesCount += SegmentSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _guardTemplateSerialize(
  GuardTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.name);
  writer.writeObjectList<Segment>(
    offsets[2],
    allOffsets,
    SegmentSchema.serialize,
    object.segments,
  );
  writer.writeDateTime(offsets[3], object.updatedAt);
}

GuardTemplate _guardTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GuardTemplate();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.segments = reader.readObjectList<Segment>(
        offsets[2],
        SegmentSchema.deserialize,
        allOffsets,
        Segment(),
      ) ??
      [];
  object.updatedAt = reader.readDateTime(offsets[3]);
  return object;
}

P _guardTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readObjectList<Segment>(
            offset,
            SegmentSchema.deserialize,
            allOffsets,
            Segment(),
          ) ??
          []) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _guardTemplateGetId(GuardTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _guardTemplateGetLinks(GuardTemplate object) {
  return [];
}

void _guardTemplateAttach(
    IsarCollection<dynamic> col, Id id, GuardTemplate object) {
  object.id = id;
}

extension GuardTemplateQueryWhereSort
    on QueryBuilder<GuardTemplate, GuardTemplate, QWhere> {
  QueryBuilder<GuardTemplate, GuardTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GuardTemplateQueryWhere
    on QueryBuilder<GuardTemplate, GuardTemplate, QWhereClause> {
  QueryBuilder<GuardTemplate, GuardTemplate, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GuardTemplateQueryFilter
    on QueryBuilder<GuardTemplate, GuardTemplate, QFilterCondition> {
  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'created_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      segmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      segmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      segmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      segmentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      segmentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      segmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updated_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GuardTemplateQueryObject
    on QueryBuilder<GuardTemplate, GuardTemplate, QFilterCondition> {
  QueryBuilder<GuardTemplate, GuardTemplate, QAfterFilterCondition>
      segmentsElement(FilterQuery<Segment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'segments');
    });
  }
}

extension GuardTemplateQueryLinks
    on QueryBuilder<GuardTemplate, GuardTemplate, QFilterCondition> {}

extension GuardTemplateQuerySortBy
    on QueryBuilder<GuardTemplate, GuardTemplate, QSortBy> {
  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }
}

extension GuardTemplateQuerySortThenBy
    on QueryBuilder<GuardTemplate, GuardTemplate, QSortThenBy> {
  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }
}

extension GuardTemplateQueryWhereDistinct
    on QueryBuilder<GuardTemplate, GuardTemplate, QDistinct> {
  QueryBuilder<GuardTemplate, GuardTemplate, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'created_at');
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GuardTemplate, GuardTemplate, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updated_at');
    });
  }
}

extension GuardTemplateQueryProperty
    on QueryBuilder<GuardTemplate, GuardTemplate, QQueryProperty> {
  QueryBuilder<GuardTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GuardTemplate, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'created_at');
    });
  }

  QueryBuilder<GuardTemplate, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<GuardTemplate, List<Segment>, QQueryOperations>
      segmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'segments');
    });
  }

  QueryBuilder<GuardTemplate, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updated_at');
    });
  }
}
