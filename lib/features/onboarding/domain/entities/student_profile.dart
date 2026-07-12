enum PrimaryGoal {
  organization,
  concentration,
  examPreparation,
  routine,
  memory,
}

final class StudentProfile {
  const StudentProfile({
    required this.userId,
    required this.university,
    required this.career,
    required this.currentCycle,
    required this.primaryGoal,
    required this.preferredFocusMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String userId;
  final String university;
  final String career;
  final int currentCycle;
  final PrimaryGoal primaryGoal;
  final int preferredFocusMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudentProfile copyWith({
    String? university,
    String? career,
    int? currentCycle,
    PrimaryGoal? primaryGoal,
    int? preferredFocusMinutes,
    DateTime? updatedAt,
  }) {
    return StudentProfile(
      userId: userId,
      university: university ?? this.university,
      career: career ?? this.career,
      currentCycle: currentCycle ?? this.currentCycle,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      preferredFocusMinutes:
          preferredFocusMinutes ?? this.preferredFocusMinutes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StudentProfile &&
            other.userId == userId &&
            other.university == university &&
            other.career == career &&
            other.currentCycle == currentCycle &&
            other.primaryGoal == primaryGoal &&
            other.preferredFocusMinutes == preferredFocusMinutes &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    userId,
    university,
    career,
    currentCycle,
    primaryGoal,
    preferredFocusMinutes,
    createdAt,
    updatedAt,
  );
}
