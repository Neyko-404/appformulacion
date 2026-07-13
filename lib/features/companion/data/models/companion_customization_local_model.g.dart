// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companion_customization_local_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, experimental_member_use, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCompanionCustomizationLocalModelCollection on Isar {
  IsarCollection<CompanionCustomizationLocalModel>
  get companionCustomizationLocalModels => this.collection();
}

const CompanionCustomizationLocalModelSchema = CollectionSchema(
  name: r'CompanionCustomizationLocalModel',
  id: -487978555369163877,
  properties: {
    r'displayName': PropertySchema(
      id: 0,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'ownerId': PropertySchema(id: 1, name: r'ownerId', type: IsarType.string),
    r'preferredExpressionStyle': PropertySchema(
      id: 2,
      name: r'preferredExpressionStyle',
      type: IsarType.string,
    ),
    r'selectedAvatar': PropertySchema(
      id: 3,
      name: r'selectedAvatar',
      type: IsarType.string,
    ),
    r'selectedTheme': PropertySchema(
      id: 4,
      name: r'selectedTheme',
      type: IsarType.string,
    ),
  },

  estimateSize: _companionCustomizationLocalModelEstimateSize,
  serialize: _companionCustomizationLocalModelSerialize,
  deserialize: _companionCustomizationLocalModelDeserialize,
  deserializeProp: _companionCustomizationLocalModelDeserializeProp,
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

  getId: _companionCustomizationLocalModelGetId,
  getLinks: _companionCustomizationLocalModelGetLinks,
  attach: _companionCustomizationLocalModelAttach,
  version: '3.3.2',
);

int _companionCustomizationLocalModelEstimateSize(
  CompanionCustomizationLocalModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.ownerId.length * 3;
  bytesCount += 3 + object.preferredExpressionStyle.length * 3;
  bytesCount += 3 + object.selectedAvatar.length * 3;
  bytesCount += 3 + object.selectedTheme.length * 3;
  return bytesCount;
}

void _companionCustomizationLocalModelSerialize(
  CompanionCustomizationLocalModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.displayName);
  writer.writeString(offsets[1], object.ownerId);
  writer.writeString(offsets[2], object.preferredExpressionStyle);
  writer.writeString(offsets[3], object.selectedAvatar);
  writer.writeString(offsets[4], object.selectedTheme);
}

CompanionCustomizationLocalModel _companionCustomizationLocalModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CompanionCustomizationLocalModel();
  object.displayName = reader.readString(offsets[0]);
  object.id = id;
  object.ownerId = reader.readString(offsets[1]);
  object.preferredExpressionStyle = reader.readString(offsets[2]);
  object.selectedAvatar = reader.readString(offsets[3]);
  object.selectedTheme = reader.readString(offsets[4]);
  return object;
}

P _companionCustomizationLocalModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _companionCustomizationLocalModelGetId(
  CompanionCustomizationLocalModel object,
) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _companionCustomizationLocalModelGetLinks(
  CompanionCustomizationLocalModel object,
) {
  return [];
}

void _companionCustomizationLocalModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CompanionCustomizationLocalModel object,
) {
  object.id = id;
}

extension CompanionCustomizationLocalModelByIndex
    on IsarCollection<CompanionCustomizationLocalModel> {
  Future<CompanionCustomizationLocalModel?> getByOwnerId(String ownerId) {
    return getByIndex(r'ownerId', [ownerId]);
  }

  CompanionCustomizationLocalModel? getByOwnerIdSync(String ownerId) {
    return getByIndexSync(r'ownerId', [ownerId]);
  }

  Future<bool> deleteByOwnerId(String ownerId) {
    return deleteByIndex(r'ownerId', [ownerId]);
  }

  bool deleteByOwnerIdSync(String ownerId) {
    return deleteByIndexSync(r'ownerId', [ownerId]);
  }

  Future<List<CompanionCustomizationLocalModel?>> getAllByOwnerId(
    List<String> ownerIdValues,
  ) {
    final values = ownerIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'ownerId', values);
  }

  List<CompanionCustomizationLocalModel?> getAllByOwnerIdSync(
    List<String> ownerIdValues,
  ) {
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

  Future<Id> putByOwnerId(CompanionCustomizationLocalModel object) {
    return putByIndex(r'ownerId', object);
  }

  Id putByOwnerIdSync(
    CompanionCustomizationLocalModel object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'ownerId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOwnerId(
    List<CompanionCustomizationLocalModel> objects,
  ) {
    return putAllByIndex(r'ownerId', objects);
  }

  List<Id> putAllByOwnerIdSync(
    List<CompanionCustomizationLocalModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'ownerId', objects, saveLinks: saveLinks);
  }
}

extension CompanionCustomizationLocalModelQueryWhereSort
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QWhere
        > {
  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CompanionCustomizationLocalModelQueryWhere
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QWhereClause
        > {
  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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

extension CompanionCustomizationLocalModelQueryFilter
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QFilterCondition
        > {
  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayName',
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'displayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preferredExpressionStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preferredExpressionStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preferredExpressionStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preferredExpressionStyle',
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'preferredExpressionStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'preferredExpressionStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'preferredExpressionStyle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'preferredExpressionStyle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preferredExpressionStyle',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  preferredExpressionStyleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'preferredExpressionStyle',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'selectedAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'selectedAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'selectedAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'selectedAvatar',
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'selectedAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'selectedAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'selectedAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'selectedAvatar',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'selectedAvatar', value: ''),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedAvatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'selectedAvatar', value: ''),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'selectedTheme',
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
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'selectedTheme',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'selectedTheme', value: ''),
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterFilterCondition
  >
  selectedThemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'selectedTheme', value: ''),
      );
    });
  }
}

extension CompanionCustomizationLocalModelQueryObject
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QFilterCondition
        > {}

extension CompanionCustomizationLocalModelQueryLinks
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QFilterCondition
        > {}

extension CompanionCustomizationLocalModelQuerySortBy
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QSortBy
        > {
  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortByPreferredExpressionStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredExpressionStyle', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortByPreferredExpressionStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredExpressionStyle', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortBySelectedAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedAvatar', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortBySelectedAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedAvatar', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortBySelectedTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  sortBySelectedThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.desc);
    });
  }
}

extension CompanionCustomizationLocalModelQuerySortThenBy
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QSortThenBy
        > {
  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenByPreferredExpressionStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredExpressionStyle', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenByPreferredExpressionStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredExpressionStyle', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenBySelectedAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedAvatar', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenBySelectedAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedAvatar', Sort.desc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenBySelectedTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.asc);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QAfterSortBy
  >
  thenBySelectedThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.desc);
    });
  }
}

extension CompanionCustomizationLocalModelQueryWhereDistinct
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QDistinct
        > {
  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QDistinct
  >
  distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QDistinct
  >
  distinctByOwnerId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QDistinct
  >
  distinctByPreferredExpressionStyle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'preferredExpressionStyle',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QDistinct
  >
  distinctBySelectedAvatar({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'selectedAvatar',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    CompanionCustomizationLocalModel,
    CompanionCustomizationLocalModel,
    QDistinct
  >
  distinctBySelectedTheme({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'selectedTheme',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension CompanionCustomizationLocalModelQueryProperty
    on
        QueryBuilder<
          CompanionCustomizationLocalModel,
          CompanionCustomizationLocalModel,
          QQueryProperty
        > {
  QueryBuilder<CompanionCustomizationLocalModel, int, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CompanionCustomizationLocalModel, String, QQueryOperations>
  displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<CompanionCustomizationLocalModel, String, QQueryOperations>
  ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }

  QueryBuilder<CompanionCustomizationLocalModel, String, QQueryOperations>
  preferredExpressionStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredExpressionStyle');
    });
  }

  QueryBuilder<CompanionCustomizationLocalModel, String, QQueryOperations>
  selectedAvatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedAvatar');
    });
  }

  QueryBuilder<CompanionCustomizationLocalModel, String, QQueryOperations>
  selectedThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedTheme');
    });
  }
}
