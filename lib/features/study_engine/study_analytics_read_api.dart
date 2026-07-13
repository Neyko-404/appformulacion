import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_interruption_repository.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_session_repository.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';

/// Changes only when persisted data relevant to Analytics changes.
final studyAnalyticsRevisionProvider = Provider<int>((ref) {
  final state = ref.watch(studyEngineNotifierProvider);
  return calculateStudyAnalyticsRevision(
    sessions: [
      ...state.recentSessions,
      ?state.activeSession,
      ?state.lastFinishedSession,
    ],
    interruptionCounts: state.interruptionCounts,
  );
});

final studyAnalyticsReaderProvider = Provider<StudyAnalyticsReader>(
  (ref) => _RepositoryStudyAnalyticsReader(
    sessionRepository: ref.watch(studySessionRepositoryProvider),
    interruptionRepository: ref.watch(studyInterruptionRepositoryProvider),
  ),
);

final class _RepositoryStudyAnalyticsReader implements StudyAnalyticsReader {
  const _RepositoryStudyAnalyticsReader({
    required this.sessionRepository,
    required this.interruptionRepository,
  });

  final StudySessionRepository sessionRepository;
  final StudyInterruptionRepository interruptionRepository;

  @override
  Future<List<StudyAnalyticsRecord>> readAll(String ownerId) async {
    final history = await sessionRepository.recent(ownerId, limit: 100000);
    final active = await sessionRepository.getActive(ownerId);
    final sessions = [
      ?active,
      ...history.where((session) => session.id != active?.id),
    ];
    return Future.wait(
      sessions.map((session) async {
        final interruptions = await interruptionRepository.bySession(
          ownerId,
          session.id,
        );
        return StudyAnalyticsRecord(
          session: session,
          interruptions: List.unmodifiable(interruptions),
        );
      }),
    );
  }
}
