enum CourseVisualIdentity { ocean, forest, sunset, violet, amber, rose }

enum CourseStatus { active, archived }

final class Course {
  const Course({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.visualIdentity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.code,
    this.credits,
  });

  final String id;
  final String ownerId;
  final String name;
  final String? code;
  final int? credits;
  final CourseVisualIdentity visualIdentity;
  final CourseStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course copyWith({
    String? name,
    String? code,
    bool clearCode = false,
    int? credits,
    bool clearCredits = false,
    CourseVisualIdentity? visualIdentity,
    CourseStatus? status,
    DateTime? updatedAt,
  }) => Course(
    id: id,
    ownerId: ownerId,
    name: name ?? this.name,
    code: clearCode ? null : code ?? this.code,
    credits: clearCredits ? null : credits ?? this.credits,
    visualIdentity: visualIdentity ?? this.visualIdentity,
    status: status ?? this.status,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  bool operator ==(Object other) =>
      other is Course &&
      other.id == id &&
      other.ownerId == ownerId &&
      other.name == name &&
      other.code == code &&
      other.credits == credits &&
      other.visualIdentity == visualIdentity &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    name,
    code,
    credits,
    visualIdentity,
    status,
    createdAt,
    updatedAt,
  );
}
