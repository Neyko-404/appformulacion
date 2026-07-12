import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/data/repositories/in_memory_study_session_repository.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';

void main() {
  final now = DateTime.utc(2026, 7, 12);
  StudySession session(String id, String owner, StudySessionStatus status) =>
      StudySession(
        id: id,
        ownerId: owner,
        courseId: 'course-1',
        mode: StudyMode.focus,
        status: status,
        plannedDuration: const Duration(minutes: 25),
        accumulatedFocusDuration: status == StudySessionStatus.completed
            ? const Duration(minutes: 25)
            : Duration.zero,
        startedAt: now,
        plannedEndAt: status == StudySessionStatus.running
            ? now.add(const Duration(minutes: 25))
            : null,
        completedAt: status == StudySessionStatus.completed ? now : null,
        createdAt: now,
        updatedAt: now,
      );

  test(
    'allows one active, history, course query, and user isolation',
    () async {
      final repository = InMemoryStudySessionRepository();
      addTearDown(repository.dispose);
      await repository.save(
        session('one', 'user-1', StudySessionStatus.running),
      );
      expect((await repository.getActive('user-1'))?.id, 'one');
      await expectLater(
        repository.save(session('two', 'user-1', StudySessionStatus.running)),
        throwsA(isA<StudySessionFailure>()),
      );
      await repository.save(
        session('done', 'user-2', StudySessionStatus.completed),
      );
      expect(await repository.recent('user-1'), isEmpty);
      expect(await repository.recent('user-2'), hasLength(1));
      expect(await repository.byCourse('user-2', 'course-1'), hasLength(1));
    },
  );
}
