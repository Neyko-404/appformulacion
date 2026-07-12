// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStudentProfileLocalModelCollection on Isar {
  IsarCollection<StudentProfileLocalModel> get studentProfileLocalModels =>
      this.collection();
}

const StudentProfileLocalModelSchema = CollectionSchema(
  name: r'StudentProfileLocalModel',
  id: -8915543413571005588,
  properties: {
    r'career': PropertySchema(id: 0, name: r'career', type: IsarType.string),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentCycle': PropertySchema(
      id: 2,
      name: r'currentCycle',
      type: IsarType.long,
    ),
    r'preferredFocusMinutes': PropertySchema(
      id: 3,
      name: r'preferredFocusMinutes',
      type: IsarType.long,
    ),
    r'primaryGoal': PropertySchema(
      id: 4,
      name: r'primaryGoal',
      type: IsarType.string,
    ),
    r'university': PropertySchema(
      id: 5,
      name: r'university',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(id: 7, name: r'userId', type: IsarType.string),
  },

  estimateSize: _studentProfileLocalModelEstimateSize,
  serialize: _studentProfileLocalModelSerialize,
  deserialize: _studentProfileLocalModelDeserialize,
  deserializeProp: _studentProfileLocalModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _studentProfileLocalModelGetId,
  getLinks: _studentProfileLocalModelGetLinks,
  attach: _studentProfileLocalModelAttach,
  version: '3.3.2',
);

int _studentProfileLocalModelEstimateSize(
  StudentProfileLocalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.career.length * 3;
  bytesCount += 3 + object.primaryGoal.length * 3;
  bytesCount += 3 + object.university.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _studentProfileLocalModelSerialize(
  StudentProfileLocalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.career);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.currentCycle);
  writer.writeLong(offsets[3], object.preferredFocusMinutes);
  writer.writeString(offsets[4], object.primaryGoal);
  writer.writeString(offsets[5], object.university);
  writer.writeDateTime(offsets[6], object.updatedAt);
  writer.writeString(offsets[7], object.userId);
}

StudentProfileLocalModel _studentProfileLocalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StudentProfileLocalModel();
  object.career = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.currentCycle = reader.readLong(offsets[2]);
  object.id = id;
  object.preferredFocusMinutes = reader.readLong(offsets[3]);
  object.primaryGoal = reader.readString(offsets[4]);
  object.university = reader.readString(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  object.userId = reader.readString(offsets[7]);
  return object;
}

P _studentProfileLocalModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _studentProfileLocalModelGetId(StudentProfileLocalModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _studentProfileLocalModelGetLinks(
  StudentProfileLocalModel object,
) {
  return [];
}

void _studentProfileLocalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  StudentProfileLocalModel object,
) {
  object.id = id;
}

extension StudentProfileLocalModelQueryWhereSort
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QWhere
        > {
  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StudentProfileLocalModelQueryWhere
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QWhereClause
        > {
  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterWhereClause
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterWhereClause
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterWhereClause
  >
  userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterWhereClause
  >
  userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension StudentProfileLocalModelQueryFilter
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QFilterCondition
        > {
  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'career',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'career',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'career',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'career',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'career',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'career',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'career',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'career',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'career', value: ''),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  careerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'career', value: ''),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  currentCycleEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentCycle', value: value),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  currentCycleGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentCycle',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  currentCycleLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentCycle',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  currentCycleBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentCycle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  preferredFocusMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preferredFocusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  preferredFocusMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preferredFocusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  preferredFocusMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preferredFocusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  preferredFocusMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preferredFocusMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'primaryGoal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'primaryGoal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'primaryGoal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'primaryGoal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'primaryGoal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'primaryGoal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'primaryGoal',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'primaryGoal',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'primaryGoal', value: ''),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  primaryGoalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'primaryGoal', value: ''),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'university',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'university',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'university',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'university',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'university',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'university',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'university',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'university',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'university', value: ''),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  universityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'university', value: ''),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudentProfileLocalModel,
    StudentProfileLocalModel,
    QAfterFilterCondition
  >
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension StudentProfileLocalModelQueryObject
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QFilterCondition
        > {}

extension StudentProfileLocalModelQueryLinks
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QFilterCondition
        > {}

extension StudentProfileLocalModelQuerySortBy
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QSortBy
        > {
  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByCareer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'career', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByCareerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'career', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByCurrentCycle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCycle', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByCurrentCycleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCycle', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByPreferredFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredFocusMinutes', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByPreferredFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredFocusMinutes', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByPrimaryGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryGoal', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByPrimaryGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryGoal', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByUniversity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByUniversityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension StudentProfileLocalModelQuerySortThenBy
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QSortThenBy
        > {
  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByCareer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'career', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByCareerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'career', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByCurrentCycle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCycle', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByCurrentCycleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCycle', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByPreferredFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredFocusMinutes', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByPreferredFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredFocusMinutes', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByPrimaryGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryGoal', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByPrimaryGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryGoal', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByUniversity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByUniversityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'university', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension StudentProfileLocalModelQueryWhereDistinct
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QDistinct
        > {
  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByCareer({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'career', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByCurrentCycle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentCycle');
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByPreferredFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preferredFocusMinutes');
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByPrimaryGoal({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryGoal', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByUniversity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'university', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<StudentProfileLocalModel, StudentProfileLocalModel, QDistinct>
  distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension StudentProfileLocalModelQueryProperty
    on
        QueryBuilder<
          StudentProfileLocalModel,
          StudentProfileLocalModel,
          QQueryProperty
        > {
  QueryBuilder<StudentProfileLocalModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StudentProfileLocalModel, String, QQueryOperations>
  careerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'career');
    });
  }

  QueryBuilder<StudentProfileLocalModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<StudentProfileLocalModel, int, QQueryOperations>
  currentCycleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentCycle');
    });
  }

  QueryBuilder<StudentProfileLocalModel, int, QQueryOperations>
  preferredFocusMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredFocusMinutes');
    });
  }

  QueryBuilder<StudentProfileLocalModel, String, QQueryOperations>
  primaryGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryGoal');
    });
  }

  QueryBuilder<StudentProfileLocalModel, String, QQueryOperations>
  universityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'university');
    });
  }

  QueryBuilder<StudentProfileLocalModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<StudentProfileLocalModel, String, QQueryOperations>
  userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
