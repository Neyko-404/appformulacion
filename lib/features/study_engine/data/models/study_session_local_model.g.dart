// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_session_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStudySessionLocalModelCollection on Isar {
  IsarCollection<StudySessionLocalModel> get studySessionLocalModels =>
      this.collection();
}

const StudySessionLocalModelSchema = CollectionSchema(
  name: r'StudySessionLocalModel',
  id: 1102982386246484599,
  properties: {
    r'accumulatedFocusSeconds': PropertySchema(
      id: 0,
      name: r'accumulatedFocusSeconds',
      type: IsarType.long,
    ),
    r'cancelledAt': PropertySchema(
      id: 1,
      name: r'cancelledAt',
      type: IsarType.dateTime,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'courseId': PropertySchema(
      id: 3,
      name: r'courseId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'mode': PropertySchema(id: 5, name: r'mode', type: IsarType.string),
    r'ownerId': PropertySchema(id: 6, name: r'ownerId', type: IsarType.string),
    r'pausedAt': PropertySchema(
      id: 7,
      name: r'pausedAt',
      type: IsarType.dateTime,
    ),
    r'plannedDurationSeconds': PropertySchema(
      id: 8,
      name: r'plannedDurationSeconds',
      type: IsarType.long,
    ),
    r'plannedEndAt': PropertySchema(
      id: 9,
      name: r'plannedEndAt',
      type: IsarType.dateTime,
    ),
    r'sessionId': PropertySchema(
      id: 10,
      name: r'sessionId',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 11,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(id: 12, name: r'status', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _studySessionLocalModelEstimateSize,
  serialize: _studySessionLocalModelSerialize,
  deserialize: _studySessionLocalModelDeserialize,
  deserializeProp: _studySessionLocalModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'sessionId': IndexSchema(
      id: 6949518585047923839,
      name: r'sessionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sessionId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'ownerId': IndexSchema(
      id: -7594796109721319539,
      name: r'ownerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ownerId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'courseId': IndexSchema(
      id: -4937057111615935929,
      name: r'courseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'courseId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _studySessionLocalModelGetId,
  getLinks: _studySessionLocalModelGetLinks,
  attach: _studySessionLocalModelAttach,
  version: '3.3.2',
);

int _studySessionLocalModelEstimateSize(
  StudySessionLocalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.courseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.mode.length * 3;
  bytesCount += 3 + object.ownerId.length * 3;
  bytesCount += 3 + object.sessionId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _studySessionLocalModelSerialize(
  StudySessionLocalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accumulatedFocusSeconds);
  writer.writeDateTime(offsets[1], object.cancelledAt);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeString(offsets[3], object.courseId);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.mode);
  writer.writeString(offsets[6], object.ownerId);
  writer.writeDateTime(offsets[7], object.pausedAt);
  writer.writeLong(offsets[8], object.plannedDurationSeconds);
  writer.writeDateTime(offsets[9], object.plannedEndAt);
  writer.writeString(offsets[10], object.sessionId);
  writer.writeDateTime(offsets[11], object.startedAt);
  writer.writeString(offsets[12], object.status);
  writer.writeDateTime(offsets[13], object.updatedAt);
}

StudySessionLocalModel _studySessionLocalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StudySessionLocalModel();
  object.accumulatedFocusSeconds = reader.readLong(offsets[0]);
  object.cancelledAt = reader.readDateTimeOrNull(offsets[1]);
  object.completedAt = reader.readDateTimeOrNull(offsets[2]);
  object.courseId = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.id = id;
  object.mode = reader.readString(offsets[5]);
  object.ownerId = reader.readString(offsets[6]);
  object.pausedAt = reader.readDateTimeOrNull(offsets[7]);
  object.plannedDurationSeconds = reader.readLong(offsets[8]);
  object.plannedEndAt = reader.readDateTimeOrNull(offsets[9]);
  object.sessionId = reader.readString(offsets[10]);
  object.startedAt = reader.readDateTimeOrNull(offsets[11]);
  object.status = reader.readString(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  return object;
}

P _studySessionLocalModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _studySessionLocalModelGetId(StudySessionLocalModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _studySessionLocalModelGetLinks(
  StudySessionLocalModel object,
) {
  return [];
}

void _studySessionLocalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  StudySessionLocalModel object,
) {
  object.id = id;
}

extension StudySessionLocalModelQueryWhereSort
    on QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QWhere> {
  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StudySessionLocalModelQueryWhere
    on
        QueryBuilder<
          StudySessionLocalModel,
          StudySessionLocalModel,
          QWhereClause
        > {
  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  sessionIdEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'sessionId', value: [sessionId]),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  sessionIdNotEqualTo(String sessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [],
                upper: [sessionId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [sessionId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [sessionId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sessionId',
                lower: [],
                upper: [sessionId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  ownerIdEqualTo(String ownerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'ownerId', value: [ownerId]),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'courseId', value: [null]),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'courseId',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  courseIdEqualTo(String? courseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'courseId', value: [courseId]),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  courseIdNotEqualTo(String? courseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'courseId',
                lower: [],
                upper: [courseId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'courseId',
                lower: [courseId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'courseId',
                lower: [courseId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'courseId',
                lower: [],
                upper: [courseId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterWhereClause
  >
  statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension StudySessionLocalModelQueryFilter
    on
        QueryBuilder<
          StudySessionLocalModel,
          StudySessionLocalModel,
          QFilterCondition
        > {
  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  accumulatedFocusSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accumulatedFocusSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  accumulatedFocusSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accumulatedFocusSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  accumulatedFocusSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accumulatedFocusSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  accumulatedFocusSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accumulatedFocusSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  cancelledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'cancelledAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  cancelledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'cancelledAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  cancelledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cancelledAt', value: value),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  cancelledAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cancelledAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  cancelledAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cancelledAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  cancelledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cancelledAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  completedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  completedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'courseId'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'courseId'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'courseId',
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
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'courseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'courseId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'courseId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  courseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'courseId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mode',
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
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mode', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  modeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mode', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  ownerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownerId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  ownerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  pausedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pausedAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  pausedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pausedAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  pausedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pausedAt', value: value),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  pausedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pausedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  pausedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pausedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  pausedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pausedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'plannedDurationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedDurationSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedDurationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedDurationSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedDurationSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedDurationSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedEndAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'plannedEndAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedEndAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'plannedEndAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedEndAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'plannedEndAt', value: value),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedEndAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'plannedEndAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedEndAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'plannedEndAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  plannedEndAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'plannedEndAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sessionId',
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
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sessionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sessionId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sessionId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  sessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sessionId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  startedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startedAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  startedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startedAt'),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  startedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedAt', value: value),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  startedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  startedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  startedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
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
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
    StudySessionLocalModel,
    StudySessionLocalModel,
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
}

extension StudySessionLocalModelQueryObject
    on
        QueryBuilder<
          StudySessionLocalModel,
          StudySessionLocalModel,
          QFilterCondition
        > {}

extension StudySessionLocalModelQueryLinks
    on
        QueryBuilder<
          StudySessionLocalModel,
          StudySessionLocalModel,
          QFilterCondition
        > {}

extension StudySessionLocalModelQuerySortBy
    on QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QSortBy> {
  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByAccumulatedFocusSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedFocusSeconds', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByAccumulatedFocusSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedFocusSeconds', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByPausedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByPausedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByPlannedDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByPlannedDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByPlannedEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedEndAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByPlannedEndAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedEndAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension StudySessionLocalModelQuerySortThenBy
    on
        QueryBuilder<
          StudySessionLocalModel,
          StudySessionLocalModel,
          QSortThenBy
        > {
  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByAccumulatedFocusSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedFocusSeconds', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByAccumulatedFocusSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accumulatedFocusSeconds', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByPausedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByPausedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pausedAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByPlannedDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByPlannedDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByPlannedEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedEndAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByPlannedEndAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedEndAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenBySessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenBySessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionId', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension StudySessionLocalModelQueryWhereDistinct
    on QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct> {
  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByAccumulatedFocusSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accumulatedFocusSeconds');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancelledAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByCourseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByOwnerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByPausedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pausedAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByPlannedDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedDurationSeconds');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByPlannedEndAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedEndAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctBySessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudySessionLocalModel, StudySessionLocalModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension StudySessionLocalModelQueryProperty
    on
        QueryBuilder<
          StudySessionLocalModel,
          StudySessionLocalModel,
          QQueryProperty
        > {
  QueryBuilder<StudySessionLocalModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StudySessionLocalModel, int, QQueryOperations>
  accumulatedFocusSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accumulatedFocusSeconds');
    });
  }

  QueryBuilder<StudySessionLocalModel, DateTime?, QQueryOperations>
  cancelledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancelledAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, DateTime?, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, String?, QQueryOperations>
  courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<StudySessionLocalModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, String, QQueryOperations>
  modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mode');
    });
  }

  QueryBuilder<StudySessionLocalModel, String, QQueryOperations>
  ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }

  QueryBuilder<StudySessionLocalModel, DateTime?, QQueryOperations>
  pausedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pausedAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, int, QQueryOperations>
  plannedDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedDurationSeconds');
    });
  }

  QueryBuilder<StudySessionLocalModel, DateTime?, QQueryOperations>
  plannedEndAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedEndAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, String, QQueryOperations>
  sessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionId');
    });
  }

  QueryBuilder<StudySessionLocalModel, DateTime?, QQueryOperations>
  startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<StudySessionLocalModel, String, QQueryOperations>
  statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<StudySessionLocalModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
