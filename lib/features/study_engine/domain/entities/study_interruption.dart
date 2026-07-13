enum StudyInterruptionReason { appBackgrounded, screenInterrupted, unknown }

final class StudyInterruption {
  StudyInterruption({
    required this.id,
    required this.startedAt,
    required this.reason,
    required this.createdAt,
    this.endedAt,
  }) {
    if (id.trim().isEmpty) throw ArgumentError.value(id, 'id');
    if (endedAt != null && !endedAt!.isAfter(startedAt)) {
      throw ArgumentError.value(endedAt, 'endedAt');
    }
  }

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final StudyInterruptionReason reason;
  final DateTime createdAt;

  bool get isOpen => endedAt == null;
  Duration get duration => endedAt?.difference(startedAt) ?? Duration.zero;

  StudyInterruption close(DateTime at) => StudyInterruption(
    id: id,
    startedAt: startedAt,
    endedAt: at,
    reason: reason,
    createdAt: createdAt,
  );

  @override
  bool operator ==(Object other) =>
      other is StudyInterruption &&
      other.id == id &&
      other.startedAt == startedAt &&
      other.endedAt == endedAt &&
      other.reason == reason &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, reason, createdAt);
}
