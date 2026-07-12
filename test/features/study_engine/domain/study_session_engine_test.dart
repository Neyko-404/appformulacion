import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';
import 'package:focusly/features/study_engine/domain/services/study_clock.dart';
import 'package:focusly/features/study_engine/domain/services/study_session_engine.dart';

void main() {
  late _FakeClock clock;
  late StudySessionEngine engine;
  setUp(() {
    clock = _FakeClock(DateTime.utc(2026, 7, 12, 10));
    engine = StudySessionEngine(clock);
  });

  test('creates and starts a timestamp-based session', () {
    final ready = engine.create(
      id: 'session-1',
      ownerId: 'user-1',
      courseId: null,
      duration: const Duration(minutes: 25),
    );
    expect(ready.status, StudySessionStatus.ready);
    expect(ready.courseId, isNull);
    final running = engine.start(ready);
    expect(running.plannedEndAt, clock.now().add(const Duration(minutes: 25)));
    expect(engine.remaining(running), const Duration(minutes: 25));
  });

  test('pause accumulates focus and resume uses a new end timestamp', () {
    var session = engine.start(
      engine.create(
        id: 'session-1',
        ownerId: 'user-1',
        duration: const Duration(minutes: 25),
      ),
    );
    clock.advance(const Duration(minutes: 5));
    session = engine.pause(session);
    expect(session.accumulatedFocusDuration, const Duration(minutes: 5));
    clock.advance(const Duration(minutes: 10));
    expect(engine.remaining(session), const Duration(minutes: 20));
    session = engine.resume(session);
    expect(session.plannedEndAt, clock.now().add(const Duration(minutes: 20)));
  });

  test('reconcile completes after expiration and invalid transitions fail', () {
    final ready = engine.create(
      id: 'session-1',
      ownerId: 'user-1',
      duration: const Duration(minutes: 15),
    );
    final running = engine.start(ready);
    clock.advance(const Duration(minutes: 16));
    final completed = engine.reconcile(running);
    expect(completed.status, StudySessionStatus.completed);
    expect(completed.completedAt, clock.now());
    expect(() => engine.resume(completed), throwsA(isA<StudySessionFailure>()));
  });

  test('cancel preserves elapsed focus and cannot complete later', () {
    final running = engine.start(
      engine.create(
        id: 'session-1',
        ownerId: 'user-1',
        duration: const Duration(minutes: 15),
      ),
    );
    clock.advance(const Duration(minutes: 3));
    final cancelled = engine.cancel(running);
    expect(cancelled.accumulatedFocusDuration, const Duration(minutes: 3));
    expect(cancelled.cancelledAt, clock.now());
    expect(
      () => engine.complete(cancelled),
      throwsA(isA<StudySessionFailure>()),
    );
  });
}

final class _FakeClock implements StudyClock {
  _FakeClock(this.value);
  DateTime value;
  @override
  DateTime now() => value;
  void advance(Duration duration) => value = value.add(duration);
}
