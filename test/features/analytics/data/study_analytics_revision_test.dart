import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

void main() {
  final now = DateTime.utc(2026, 7, 12, 10);
  final running = StudySession(
    id: 'session-1',
    ownerId: 'user-1',
    mode: StudyMode.focus,
    status: StudySessionStatus.running,
    plannedDuration: const Duration(minutes: 25),
    accumulatedFocusDuration: Duration.zero,
    startedAt: now,
    plannedEndAt: now.add(const Duration(minutes: 25)),
    createdAt: now,
    updatedAt: now,
  );

  test('timer ticks do not change the persistent analytics revision', () {
    final before = calculateStudyAnalyticsRevision(
      sessions: [running],
      interruptionCounts: const {},
    );
    final after = calculateStudyAnalyticsRevision(
      sessions: [running],
      interruptionCounts: const {},
    );
    expect(after, before);
  });

  test('terminal status and relevant interruption count change revision', () {
    final runningRevision = calculateStudyAnalyticsRevision(
      sessions: [running],
      interruptionCounts: const {},
    );
    final completed = running.copyWith(
      status: StudySessionStatus.completed,
      accumulatedFocusDuration: const Duration(minutes: 25),
      completedAt: now.add(const Duration(minutes: 25)),
      clearPlannedEndAt: true,
      updatedAt: now.add(const Duration(minutes: 25)),
    );
    final completedRevision = calculateStudyAnalyticsRevision(
      sessions: [completed],
      interruptionCounts: const {},
    );
    final interruptionRevision = calculateStudyAnalyticsRevision(
      sessions: [completed],
      interruptionCounts: const {'session-1': 1},
    );
    expect(completedRevision, isNot(runningRevision));
    expect(interruptionRevision, isNot(completedRevision));
  });
}
