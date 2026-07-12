import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';
import 'package:focusly/features/study_engine/domain/services/study_clock.dart';

final class StudySessionEngine {
  const StudySessionEngine(this.clock);
  final StudyClock clock;

  StudySession create({
    required String id,
    required String ownerId,
    required Duration duration,
    String? courseId,
    StudyMode mode = StudyMode.focus,
  }) {
    if (ownerId.trim().isEmpty || duration <= Duration.zero) {
      throw const StudySessionFailure(
        StudySessionFailureType.invalidData,
        'Los datos de la sesión no son válidos.',
      );
    }
    final now = clock.now();
    return StudySession(
      id: id,
      ownerId: ownerId,
      courseId: courseId,
      mode: mode,
      status: StudySessionStatus.ready,
      plannedDuration: duration,
      accumulatedFocusDuration: Duration.zero,
      createdAt: now,
      updatedAt: now,
    );
  }

  StudySession start(StudySession session) {
    _require(session, StudySessionStatus.ready);
    final now = clock.now();
    return session.copyWith(
      status: StudySessionStatus.running,
      startedAt: now,
      plannedEndAt: now.add(session.plannedDuration),
      updatedAt: now,
    );
  }

  Duration remaining(StudySession session) {
    if (session.status == StudySessionStatus.paused) {
      return _nonNegative(
        session.plannedDuration - session.accumulatedFocusDuration,
      );
    }
    final end = session.plannedEndAt;
    if (session.status != StudySessionStatus.running || end == null) {
      return Duration.zero;
    }
    return _nonNegative(end.difference(clock.now()));
  }

  Duration accumulated(StudySession session) =>
      session.status == StudySessionStatus.running
      ? session.plannedDuration - remaining(session)
      : session.accumulatedFocusDuration;

  StudySession pause(StudySession session) {
    _require(session, StudySessionStatus.running);
    final now = clock.now();
    return session.copyWith(
      status: StudySessionStatus.paused,
      accumulatedFocusDuration: accumulated(session),
      pausedAt: now,
      clearPlannedEndAt: true,
      updatedAt: now,
    );
  }

  StudySession resume(StudySession session) {
    _require(session, StudySessionStatus.paused);
    final now = clock.now();
    return session.copyWith(
      status: StudySessionStatus.running,
      plannedEndAt: now.add(remaining(session)),
      clearPausedAt: true,
      updatedAt: now,
    );
  }

  StudySession complete(StudySession session) {
    if (session.status != StudySessionStatus.running &&
        session.status != StudySessionStatus.paused) {
      throw StudySessionFailure.invalidTransition();
    }
    final now = clock.now();
    return session.copyWith(
      status: StudySessionStatus.completed,
      accumulatedFocusDuration: session.plannedDuration,
      completedAt: now,
      clearPlannedEndAt: true,
      clearPausedAt: true,
      updatedAt: now,
    );
  }

  StudySession cancel(StudySession session) {
    if (!session.isActive) throw StudySessionFailure.invalidTransition();
    final now = clock.now();
    return session.copyWith(
      status: StudySessionStatus.cancelled,
      accumulatedFocusDuration: accumulated(session),
      cancelledAt: now,
      clearPlannedEndAt: true,
      clearPausedAt: true,
      updatedAt: now,
    );
  }

  StudySession reconcile(StudySession session) {
    if (session.status == StudySessionStatus.running &&
        remaining(session) == Duration.zero) {
      return complete(session);
    }
    return session;
  }

  void _require(StudySession session, StudySessionStatus status) {
    if (session.status != status) throw StudySessionFailure.invalidTransition();
  }

  Duration _nonNegative(Duration value) =>
      value.isNegative ? Duration.zero : value;
}
