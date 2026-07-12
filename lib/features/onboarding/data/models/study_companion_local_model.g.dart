// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_companion_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStudyCompanionLocalModelCollection on Isar {
  IsarCollection<StudyCompanionLocalModel> get studyCompanionLocalModels =>
      this.collection();
}

const StudyCompanionLocalModelSchema = CollectionSchema(
  name: r'StudyCompanionLocalModel',
  id: 8761650790643842092,
  properties: {
    r'appearance': PropertySchema(
      id: 0,
      name: r'appearance',
      type: IsarType.string,
    ),
    r'companionId': PropertySchema(
      id: 1,
      name: r'companionId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'ownerId': PropertySchema(id: 4, name: r'ownerId', type: IsarType.string),
  },

  estimateSize: _studyCompanionLocalModelEstimateSize,
  serialize: _studyCompanionLocalModelSerialize,
  deserialize: _studyCompanionLocalModelDeserialize,
  deserializeProp: _studyCompanionLocalModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'companionId': IndexSchema(
      id: 7614647696974036121,
      name: r'companionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'companionId',
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
  },
  links: {},
  embeddedSchemas: {},

  getId: _studyCompanionLocalModelGetId,
  getLinks: _studyCompanionLocalModelGetLinks,
  attach: _studyCompanionLocalModelAttach,
  version: '3.3.2',
);

int _studyCompanionLocalModelEstimateSize(
  StudyCompanionLocalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appearance.length * 3;
  bytesCount += 3 + object.companionId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.ownerId.length * 3;
  return bytesCount;
}

void _studyCompanionLocalModelSerialize(
  StudyCompanionLocalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appearance);
  writer.writeString(offsets[1], object.companionId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.ownerId);
}

StudyCompanionLocalModel _studyCompanionLocalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StudyCompanionLocalModel();
  object.appearance = reader.readString(offsets[0]);
  object.companionId = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.name = reader.readString(offsets[3]);
  object.ownerId = reader.readString(offsets[4]);
  return object;
}

P _studyCompanionLocalModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _studyCompanionLocalModelGetId(StudyCompanionLocalModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _studyCompanionLocalModelGetLinks(
  StudyCompanionLocalModel object,
) {
  return [];
}

void _studyCompanionLocalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  StudyCompanionLocalModel object,
) {
  object.id = id;
}

extension StudyCompanionLocalModelQueryWhereSort
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QWhere
        > {
  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StudyCompanionLocalModelQueryWhere
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QWhereClause
        > {
  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterWhereClause
  >
  companionIdEqualTo(String companionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'companionId',
          value: [companionId],
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterWhereClause
  >
  companionIdNotEqualTo(String companionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companionId',
                lower: [],
                upper: [companionId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companionId',
                lower: [companionId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companionId',
                lower: [companionId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companionId',
                lower: [],
                upper: [companionId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
}

extension StudyCompanionLocalModelQueryFilter
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QFilterCondition
        > {
  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'appearance',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'appearance',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'appearance',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'appearance',
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'appearance',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'appearance',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'appearance',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'appearance',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appearance', value: ''),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  appearanceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'appearance', value: ''),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'companionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'companionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'companionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'companionId',
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'companionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'companionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'companionId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'companionId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'companionId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  companionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'companionId', value: ''),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
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
    StudyCompanionLocalModel,
    StudyCompanionLocalModel,
    QAfterFilterCondition
  >
  ownerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerId', value: ''),
      );
    });
  }
}

extension StudyCompanionLocalModelQueryObject
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QFilterCondition
        > {}

extension StudyCompanionLocalModelQueryLinks
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QFilterCondition
        > {}

extension StudyCompanionLocalModelQuerySortBy
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QSortBy
        > {
  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByAppearance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appearance', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByAppearanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appearance', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByCompanionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionId', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByCompanionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionId', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }
}

extension StudyCompanionLocalModelQuerySortThenBy
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QSortThenBy
        > {
  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByAppearance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appearance', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByAppearanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appearance', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByCompanionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionId', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByCompanionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companionId', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QAfterSortBy>
  thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }
}

extension StudyCompanionLocalModelQueryWhereDistinct
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QDistinct
        > {
  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QDistinct>
  distinctByAppearance({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appearance', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QDistinct>
  distinctByCompanionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StudyCompanionLocalModel, StudyCompanionLocalModel, QDistinct>
  distinctByOwnerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId', caseSensitive: caseSensitive);
    });
  }
}

extension StudyCompanionLocalModelQueryProperty
    on
        QueryBuilder<
          StudyCompanionLocalModel,
          StudyCompanionLocalModel,
          QQueryProperty
        > {
  QueryBuilder<StudyCompanionLocalModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StudyCompanionLocalModel, String, QQueryOperations>
  appearanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appearance');
    });
  }

  QueryBuilder<StudyCompanionLocalModel, String, QQueryOperations>
  companionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companionId');
    });
  }

  QueryBuilder<StudyCompanionLocalModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<StudyCompanionLocalModel, String, QQueryOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<StudyCompanionLocalModel, String, QQueryOperations>
  ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }
}
