enum StudyMode { focus, freeStudy }

enum StudySessionStatus { ready, running, paused, completed, cancelled }

final class StudySession {
  const StudySession({
    required this.id,
    required this.ownerId,
    required this.mode,
    required this.status,
    required this.plannedDuration,
    required this.accumulatedFocusDuration,
    required this.createdAt,
    required this.updatedAt,
    this.courseId,
    this.startedAt,
    this.plannedEndAt,
    this.pausedAt,
    this.completedAt,
    this.cancelledAt,
  });
  final String id;
  final String ownerId;
  final String? courseId;
  final StudyMode mode;
  final StudySessionStatus status;
  final Duration plannedDuration;
  final Duration accumulatedFocusDuration;
  final DateTime? startedAt;
  final DateTime? plannedEndAt;
  final DateTime? pausedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive =>
      status == StudySessionStatus.running ||
      status == StudySessionStatus.paused;

  StudySession copyWith({
    StudySessionStatus? status,
    Duration? accumulatedFocusDuration,
    DateTime? startedAt,
    DateTime? plannedEndAt,
    bool clearPlannedEndAt = false,
    DateTime? pausedAt,
    bool clearPausedAt = false,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? updatedAt,
  }) => StudySession(
    id: id,
    ownerId: ownerId,
    courseId: courseId,
    mode: mode,
    status: status ?? this.status,
    plannedDuration: plannedDuration,
    accumulatedFocusDuration:
        accumulatedFocusDuration ?? this.accumulatedFocusDuration,
    startedAt: startedAt ?? this.startedAt,
    plannedEndAt: clearPlannedEndAt ? null : plannedEndAt ?? this.plannedEndAt,
    pausedAt: clearPausedAt ? null : pausedAt ?? this.pausedAt,
    completedAt: completedAt ?? this.completedAt,
    cancelledAt: cancelledAt ?? this.cancelledAt,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  bool operator ==(Object other) =>
      other is StudySession &&
      other.id == id &&
      other.ownerId == ownerId &&
      other.courseId == courseId &&
      other.mode == mode &&
      other.status == status &&
      other.plannedDuration == plannedDuration &&
      other.accumulatedFocusDuration == accumulatedFocusDuration &&
      other.startedAt == startedAt &&
      other.plannedEndAt == plannedEndAt &&
      other.pausedAt == pausedAt &&
      other.completedAt == completedAt &&
      other.cancelledAt == cancelledAt &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    courseId,
    mode,
    status,
    plannedDuration,
    accumulatedFocusDuration,
    startedAt,
    plannedEndAt,
    pausedAt,
    completedAt,
    cancelledAt,
    createdAt,
    updatedAt,
  );
}
