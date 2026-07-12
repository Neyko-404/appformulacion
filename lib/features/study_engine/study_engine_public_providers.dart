import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';

final class ActiveStudySummary {
  const ActiveStudySummary({this.session, required this.remaining});
  final StudySession? session;
  final Duration remaining;
  bool get isRunning => session?.status == StudySessionStatus.running;
  bool get isPaused => session?.status == StudySessionStatus.paused;
}

final activeStudySummaryProvider = Provider<ActiveStudySummary>((ref) {
  final state = ref.watch(studyEngineNotifierProvider);
  return ActiveStudySummary(
    session: state.activeSession,
    remaining: state.remaining,
  );
});
