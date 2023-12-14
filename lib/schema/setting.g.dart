// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingCollection on Isar {
  IsarCollection<Setting> get settings => this.collection();
}

const SettingSchema = CollectionSchema(
  name: r'settings',
  id: -5221820136678325216,
  properties: {
    r'created_at': PropertySchema(
      id: 0,
      name: r'created_at',
      type: IsarType.dateTime,
    ),
    r'main_password': PropertySchema(
      id: 1,
      name: r'main_password',
      type: IsarType.string,
    ),
    r'sync_strategy': PropertySchema(
      id: 2,
      name: r'sync_strategy',
      type: IsarType.long,
    ),
    r'updated_at': PropertySchema(
      id: 3,
      name: r'updated_at',
      type: IsarType.dateTime,
    ),
    r'web_dav_password': PropertySchema(
      id: 4,
      name: r'web_dav_password',
      type: IsarType.string,
    ),
    r'web_dav_url': PropertySchema(
      id: 5,
      name: r'web_dav_url',
      type: IsarType.string,
    ),
    r'web_dav_username': PropertySchema(
      id: 6,
      name: r'web_dav_username',
      type: IsarType.string,
    )
  },
  estimateSize: _settingEstimateSize,
  serialize: _settingSerialize,
  deserialize: _settingDeserialize,
  deserializeProp: _settingDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingGetId,
  getLinks: _settingGetLinks,
  attach: _settingAttach,
  version: '3.1.0+1',
);

int _settingEstimateSize(
  Setting object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mainPassword.length * 3;
  bytesCount += 3 + object.webDavPassword.length * 3;
  bytesCount += 3 + object.webDavUrl.length * 3;
  bytesCount += 3 + object.webDavUsername.length * 3;
  return bytesCount;
}

void _settingSerialize(
  Setting object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.mainPassword);
  writer.writeLong(offsets[2], object.syncStrategy);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeString(offsets[4], object.webDavPassword);
  writer.writeString(offsets[5], object.webDavUrl);
  writer.writeString(offsets[6], object.webDavUsername);
}

Setting _settingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Setting();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.mainPassword = reader.readString(offsets[1]);
  object.syncStrategy = reader.readLong(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  object.webDavPassword = reader.readString(offsets[4]);
  object.webDavUrl = reader.readString(offsets[5]);
  object.webDavUsername = reader.readString(offsets[6]);
  return object;
}

P _settingDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingGetId(Setting object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settingGetLinks(Setting object) {
  return [];
}

void _settingAttach(IsarCollection<dynamic> col, Id id, Setting object) {
  object.id = id;
}

extension SettingQueryWhereSort on QueryBuilder<Setting, Setting, QWhere> {
  QueryBuilder<Setting, Setting, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingQueryWhere on QueryBuilder<Setting, Setting, QWhereClause> {
  QueryBuilder<Setting, Setting, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Setting, Setting, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Setting, Setting, QAfterWhereClause> idBetween(
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

extension SettingQueryFilter
    on QueryBuilder<Setting, Setting, QFilterCondition> {
  QueryBuilder<Setting, Setting, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'main_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'main_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'main_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'main_password',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'main_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'main_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'main_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'main_password',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> mainPasswordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'main_password',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      mainPasswordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'main_password',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> syncStrategyEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sync_strategy',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> syncStrategyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sync_strategy',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> syncStrategyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sync_strategy',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> syncStrategyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sync_strategy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavPasswordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'web_dav_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavPasswordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'web_dav_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavPasswordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'web_dav_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavPasswordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'web_dav_password',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavPasswordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'web_dav_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavPasswordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'web_dav_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavPasswordContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'web_dav_password',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavPasswordMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'web_dav_password',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavPasswordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'web_dav_password',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavPasswordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'web_dav_password',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'web_dav_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'web_dav_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'web_dav_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'web_dav_url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'web_dav_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'web_dav_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'web_dav_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'web_dav_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'web_dav_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'web_dav_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUsernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'web_dav_username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavUsernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'web_dav_username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUsernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'web_dav_username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUsernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'web_dav_username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavUsernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'web_dav_username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUsernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'web_dav_username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUsernameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'web_dav_username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition> webDavUsernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'web_dav_username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'web_dav_username',
        value: '',
      ));
    });
  }

  QueryBuilder<Setting, Setting, QAfterFilterCondition>
      webDavUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'web_dav_username',
        value: '',
      ));
    });
  }
}

extension SettingQueryObject
    on QueryBuilder<Setting, Setting, QFilterCondition> {}

extension SettingQueryLinks
    on QueryBuilder<Setting, Setting, QFilterCondition> {}

extension SettingQuerySortBy on QueryBuilder<Setting, Setting, QSortBy> {
  QueryBuilder<Setting, Setting, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByMainPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'main_password', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByMainPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'main_password', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortBySyncStrategy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sync_strategy', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortBySyncStrategyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sync_strategy', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByWebDavPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_password', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByWebDavPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_password', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByWebDavUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_url', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByWebDavUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_url', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByWebDavUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_username', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> sortByWebDavUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_username', Sort.desc);
    });
  }
}

extension SettingQuerySortThenBy
    on QueryBuilder<Setting, Setting, QSortThenBy> {
  QueryBuilder<Setting, Setting, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByMainPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'main_password', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByMainPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'main_password', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenBySyncStrategy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sync_strategy', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenBySyncStrategyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sync_strategy', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByWebDavPassword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_password', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByWebDavPasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_password', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByWebDavUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_url', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByWebDavUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_url', Sort.desc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByWebDavUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_username', Sort.asc);
    });
  }

  QueryBuilder<Setting, Setting, QAfterSortBy> thenByWebDavUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'web_dav_username', Sort.desc);
    });
  }
}

extension SettingQueryWhereDistinct
    on QueryBuilder<Setting, Setting, QDistinct> {
  QueryBuilder<Setting, Setting, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'created_at');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByMainPassword(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'main_password',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctBySyncStrategy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sync_strategy');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updated_at');
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByWebDavPassword(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'web_dav_password',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByWebDavUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'web_dav_url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Setting, Setting, QDistinct> distinctByWebDavUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'web_dav_username',
          caseSensitive: caseSensitive);
    });
  }
}

extension SettingQueryProperty
    on QueryBuilder<Setting, Setting, QQueryProperty> {
  QueryBuilder<Setting, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Setting, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'created_at');
    });
  }

  QueryBuilder<Setting, String, QQueryOperations> mainPasswordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'main_password');
    });
  }

  QueryBuilder<Setting, int, QQueryOperations> syncStrategyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sync_strategy');
    });
  }

  QueryBuilder<Setting, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updated_at');
    });
  }

  QueryBuilder<Setting, String, QQueryOperations> webDavPasswordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'web_dav_password');
    });
  }

  QueryBuilder<Setting, String, QQueryOperations> webDavUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'web_dav_url');
    });
  }

  QueryBuilder<Setting, String, QQueryOperations> webDavUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'web_dav_username');
    });
  }
}
