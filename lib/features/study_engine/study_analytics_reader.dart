import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

final class StudyAnalyticsRecord {
  const StudyAnalyticsRecord({
    required this.session,
    required this.interruptions,
  });

  final StudySession session;
  final List<StudyInterruption> interruptions;
}

abstract interface class StudyAnalyticsReader {
  Future<List<StudyAnalyticsRecord>> readAll(String ownerId);
}

int calculateStudyAnalyticsRevision({
  required Iterable<StudySession> sessions,
  required Map<String, int> interruptionCounts,
}) {
  final uniqueSessions = <String, StudySession>{
    for (final session in sessions) session.id: session,
  }.values.toList()..sort((a, b) => a.id.compareTo(b.id));
  final interruptionEntries = interruptionCounts.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return Object.hash(
    Object.hashAll(
      uniqueSessions.map(
        (session) => Object.hash(
          session.id,
          session.status,
          session.updatedAt,
          session.accumulatedFocusDuration,
          session.courseId,
        ),
      ),
    ),
    Object.hashAll(
      interruptionEntries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );
}
