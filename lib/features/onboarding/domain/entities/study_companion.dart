enum CompanionAppearance { indigo, amber, emerald }

final class StudyCompanion {
  const StudyCompanion({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.appearance,
    required this.createdAt,
  });

  final String id;
  final String ownerId;
  final String name;
  final CompanionAppearance appearance;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StudyCompanion &&
            other.id == id &&
            other.ownerId == ownerId &&
            other.name == name &&
            other.appearance == appearance &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, ownerId, name, appearance, createdAt);
}
