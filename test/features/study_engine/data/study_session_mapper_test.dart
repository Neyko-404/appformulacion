import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/data/mappers/study_session_mapper.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

void main() {
  const mapper = StudySessionMapper();
  final now = DateTime.utc(2026, 7, 12);
  final session = StudySession(
    id: 'domain-id',
    ownerId: 'user-1',
    courseId: 'course-1',
    mode: StudyMode.focus,
    status: StudySessionStatus.running,
    plannedDuration: const Duration(minutes: 25),
    accumulatedFocusDuration: const Duration(minutes: 5),
    startedAt: now,
    plannedEndAt: now.add(const Duration(minutes: 20)),
    createdAt: now,
    updatedAt: now,
  );
  test('round trip preserves durations, timestamps, and domain id', () {
    final local = mapper.toLocal(session)..id = 42;
    expect(mapper.toDomain(local), session);
    expect(local.sessionId, 'domain-id');
    expect(local.plannedDurationSeconds, 1500);
  });
  test('unknown enums and negative duration are rejected', () {
    final local = mapper.toLocal(session)..mode = 'unknown';
    expect(() => mapper.toDomain(local), throwsFormatException);
    local
      ..mode = 'focus'
      ..accumulatedFocusSeconds = -1;
    expect(() => mapper.toDomain(local), throwsFormatException);
  });
  test('identity and accumulated duration are validated', () {
    final local = mapper.toLocal(session)..sessionId = ' ';
    expect(() => mapper.toDomain(local), throwsFormatException);
    local
      ..sessionId = 'session-1'
      ..ownerId = '';
    expect(() => mapper.toDomain(local), throwsFormatException);
    local
      ..ownerId = 'user-1'
      ..accumulatedFocusSeconds = local.plannedDurationSeconds + 1;
    expect(() => mapper.toDomain(local), throwsFormatException);
  });
  test('status-specific timestamps are validated', () {
    final running = mapper.toLocal(session)..plannedEndAt = null;
    expect(() => mapper.toDomain(running), throwsFormatException);

    final paused = mapper.toLocal(
      session.copyWith(
        status: StudySessionStatus.paused,
        pausedAt: now,
        clearPlannedEndAt: true,
      ),
    );
    expect(mapper.toDomain(paused).status, StudySessionStatus.paused);
    paused.plannedEndAt = now;
    expect(() => mapper.toDomain(paused), throwsFormatException);

    final completed = mapper.toLocal(
      session.copyWith(
        status: StudySessionStatus.completed,
        completedAt: now,
        clearPlannedEndAt: true,
        clearPausedAt: true,
      ),
    );
    expect(mapper.toDomain(completed).status, StudySessionStatus.completed);
    completed.cancelledAt = now;
    expect(() => mapper.toDomain(completed), throwsFormatException);

    final cancelled = mapper.toLocal(
      session.copyWith(
        status: StudySessionStatus.cancelled,
        cancelledAt: now,
        clearPlannedEndAt: true,
        clearPausedAt: true,
      ),
    );
    expect(mapper.toDomain(cancelled).status, StudySessionStatus.cancelled);
    cancelled.completedAt = now;
    expect(() => mapper.toDomain(cancelled), throwsFormatException);
  });
}
