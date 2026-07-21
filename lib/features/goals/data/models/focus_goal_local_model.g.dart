// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_goal_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, experimental_member_use, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFocusGoalLocalModelCollection on Isar {
  IsarCollection<FocusGoalLocalModel> get focusGoalLocalModels =>
      this.collection();
}

const FocusGoalLocalModelSchema = CollectionSchema(
  name: r'FocusGoalLocalModel',
  id: 54011809876880516,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dailyMinutesTarget': PropertySchema(
      id: 1,
      name: r'dailyMinutesTarget',
      type: IsarType.long,
    ),
    r'ownerId': PropertySchema(id: 2, name: r'ownerId', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weeklyActiveDaysTarget': PropertySchema(
      id: 4,
      name: r'weeklyActiveDaysTarget',
      type: IsarType.long,
    ),
    r'weeklyCompletedSessionsTarget': PropertySchema(
      id: 5,
      name: r'weeklyCompletedSessionsTarget',
      type: IsarType.long,
    ),
  },

  estimateSize: _focusGoalLocalModelEstimateSize,
  serialize: _focusGoalLocalModelSerialize,
  deserialize: _focusGoalLocalModelDeserialize,
  deserializeProp: _focusGoalLocalModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'ownerId': IndexSchema(
      id: -7594796109721319539,
      name: r'ownerId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'ownerId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _focusGoalLocalModelGetId,
  getLinks: _focusGoalLocalModelGetLinks,
  attach: _focusGoalLocalModelAttach,
  version: '3.3.2',
);

int _focusGoalLocalModelEstimateSize(
  FocusGoalLocalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.ownerId.length * 3;
  return bytesCount;
}

void _focusGoalLocalModelSerialize(
  FocusGoalLocalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.dailyMinutesTarget);
  writer.writeString(offsets[2], object.ownerId);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeLong(offsets[4], object.weeklyActiveDaysTarget);
  writer.writeLong(offsets[5], object.weeklyCompletedSessionsTarget);
}

FocusGoalLocalModel _focusGoalLocalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FocusGoalLocalModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.dailyMinutesTarget = reader.readLongOrNull(offsets[1]);
  object.id = id;
  object.ownerId = reader.readString(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  object.weeklyActiveDaysTarget = reader.readLongOrNull(offsets[4]);
  object.weeklyCompletedSessionsTarget = reader.readLongOrNull(offsets[5]);
  return object;
}

P _focusGoalLocalModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _focusGoalLocalModelGetId(FocusGoalLocalModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _focusGoalLocalModelGetLinks(
  FocusGoalLocalModel object,
) {
  return [];
}

void _focusGoalLocalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  FocusGoalLocalModel object,
) {
  object.id = id;
}

extension FocusGoalLocalModelByIndex on IsarCollection<FocusGoalLocalModel> {
  Future<FocusGoalLocalModel?> getByOwnerId(String ownerId) {
    return getByIndex(r'ownerId', [ownerId]);
  }

  FocusGoalLocalModel? getByOwnerIdSync(String ownerId) {
    return getByIndexSync(r'ownerId', [ownerId]);
  }

  Future<bool> deleteByOwnerId(String ownerId) {
    return deleteByIndex(r'ownerId', [ownerId]);
  }

  bool deleteByOwnerIdSync(String ownerId) {
    return deleteByIndexSync(r'ownerId', [ownerId]);
  }

  Future<List<FocusGoalLocalModel?>> getAllByOwnerId(
    List<String> ownerIdValues,
  ) {
    final values = ownerIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'ownerId', values);
  }

  List<FocusGoalLocalModel?> getAllByOwnerIdSync(List<String> ownerIdValues) {
    final values = ownerIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'ownerId', values);
  }

  Future<int> deleteAllByOwnerId(List<String> ownerIdValues) {
    final values = ownerIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'ownerId', values);
  }

  int deleteAllByOwnerIdSync(List<String> ownerIdValues) {
    final values = ownerIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'ownerId', values);
  }

  Future<Id> putByOwnerId(FocusGoalLocalModel object) {
    return putByIndex(r'ownerId', object);
  }

  Id putByOwnerIdSync(FocusGoalLocalModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'ownerId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOwnerId(List<FocusGoalLocalModel> objects) {
    return putAllByIndex(r'ownerId', objects);
  }

  List<Id> putAllByOwnerIdSync(
    List<FocusGoalLocalModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'ownerId', objects, saveLinks: saveLinks);
  }
}

extension FocusGoalLocalModelQueryWhereSort
    on QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QWhere> {
  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FocusGoalLocalModelQueryWhere
    on QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QWhereClause> {
  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhereClause>
  ownerIdEqualTo(String ownerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'ownerId', value: [ownerId]),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterWhereClause>
  ownerIdNotEqualTo(String ownerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId',
                lower: [],
                upper: [ownerId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId',
                lower: [ownerId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId',
                lower: [ownerId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId',
                lower: [],
                upper: [ownerId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension FocusGoalLocalModelQueryFilter
    on
        QueryBuilder<
          FocusGoalLocalModel,
          FocusGoalLocalModel,
          QFilterCondition
        > {
  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  dailyMinutesTargetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dailyMinutesTarget'),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  dailyMinutesTargetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dailyMinutesTarget'),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  dailyMinutesTargetEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailyMinutesTarget', value: value),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  dailyMinutesTargetGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dailyMinutesTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  dailyMinutesTargetLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dailyMinutesTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  dailyMinutesTargetBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dailyMinutesTarget',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ownerId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ownerId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownerId', value: ''),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  ownerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerId', value: ''),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyActiveDaysTargetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'weeklyActiveDaysTarget'),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyActiveDaysTargetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'weeklyActiveDaysTarget'),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyActiveDaysTargetEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weeklyActiveDaysTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyActiveDaysTargetGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weeklyActiveDaysTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyActiveDaysTargetLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weeklyActiveDaysTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyActiveDaysTargetBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weeklyActiveDaysTarget',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyCompletedSessionsTargetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(
          property: r'weeklyCompletedSessionsTarget',
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyCompletedSessionsTargetIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'weeklyCompletedSessionsTarget',
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyCompletedSessionsTargetEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weeklyCompletedSessionsTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyCompletedSessionsTargetGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weeklyCompletedSessionsTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyCompletedSessionsTargetLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weeklyCompletedSessionsTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterFilterCondition>
  weeklyCompletedSessionsTargetBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weeklyCompletedSessionsTarget',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FocusGoalLocalModelQueryObject
    on
        QueryBuilder<
          FocusGoalLocalModel,
          FocusGoalLocalModel,
          QFilterCondition
        > {}

extension FocusGoalLocalModelQueryLinks
    on
        QueryBuilder<
          FocusGoalLocalModel,
          FocusGoalLocalModel,
          QFilterCondition
        > {}

extension FocusGoalLocalModelQuerySortBy
    on QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QSortBy> {
  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByDailyMinutesTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutesTarget', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByDailyMinutesTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutesTarget', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByWeeklyActiveDaysTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyActiveDaysTarget', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByWeeklyActiveDaysTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyActiveDaysTarget', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByWeeklyCompletedSessionsTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCompletedSessionsTarget', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  sortByWeeklyCompletedSessionsTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCompletedSessionsTarget', Sort.desc);
    });
  }
}

extension FocusGoalLocalModelQuerySortThenBy
    on QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QSortThenBy> {
  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByDailyMinutesTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutesTarget', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByDailyMinutesTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutesTarget', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByWeeklyActiveDaysTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyActiveDaysTarget', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByWeeklyActiveDaysTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyActiveDaysTarget', Sort.desc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByWeeklyCompletedSessionsTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCompletedSessionsTarget', Sort.asc);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QAfterSortBy>
  thenByWeeklyCompletedSessionsTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyCompletedSessionsTarget', Sort.desc);
    });
  }
}

extension FocusGoalLocalModelQueryWhereDistinct
    on QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QDistinct> {
  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QDistinct>
  distinctByDailyMinutesTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyMinutesTarget');
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QDistinct>
  distinctByOwnerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QDistinct>
  distinctByWeeklyActiveDaysTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyActiveDaysTarget');
    });
  }

  QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QDistinct>
  distinctByWeeklyCompletedSessionsTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyCompletedSessionsTarget');
    });
  }
}

extension FocusGoalLocalModelQueryProperty
    on QueryBuilder<FocusGoalLocalModel, FocusGoalLocalModel, QQueryProperty> {
  QueryBuilder<FocusGoalLocalModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FocusGoalLocalModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FocusGoalLocalModel, int?, QQueryOperations>
  dailyMinutesTargetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyMinutesTarget');
    });
  }

  QueryBuilder<FocusGoalLocalModel, String, QQueryOperations>
  ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }

  QueryBuilder<FocusGoalLocalModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<FocusGoalLocalModel, int?, QQueryOperations>
  weeklyActiveDaysTargetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyActiveDaysTarget');
    });
  }

  QueryBuilder<FocusGoalLocalModel, int?, QQueryOperations>
  weeklyCompletedSessionsTargetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyCompletedSessionsTarget');
    });
  }
}
