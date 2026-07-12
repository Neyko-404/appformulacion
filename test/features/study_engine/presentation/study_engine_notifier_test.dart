import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/study_engine/data/repositories/in_memory_study_session_repository.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_session_repository.dart';
import 'package:focusly/features/study_engine/domain/services/study_clock.dart';
import 'package:focusly/features/study_engine/presentation/notifiers/study_engine_notifier.dart';
import 'package:focusly/features/study_engine/presentation/state/study_engine_state.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';

void main() {
  test(
    'restores preference and controls a session with injected time',
    () async {
      final now = DateTime.utc(2026, 7, 12, 10);
      final clock = _FakeClock(now);
      final onboarding = InMemoryOnboardingRepository();
      await onboarding.saveOnboarding(
        profile: StudentProfile(
          userId: 'user-1',
          university: 'UNJFSC',
          career: 'Ingeniería',
          currentCycle: 4,
          primaryGoal: PrimaryGoal.concentration,
          preferredFocusMinutes: 40,
          createdAt: now,
          updatedAt: now,
        ),
        companion: StudyCompanion(
          id: 'cat-1',
          ownerId: 'user-1',
          name: 'Milo',
          appearance: CompanionAppearance.indigo,
          createdAt: now,
        ),
      );
      final repository = InMemoryStudySessionRepository();
      addTearDown(repository.dispose);
      final container = ProviderContainer.test(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'student@focusly.dev'),
              emailVerified: true,
            ),
          ),
          onboardingRepositoryProvider.overrideWithValue(onboarding),
          studySessionRepositoryProvider.overrideWithValue(repository),
          studyClockProvider.overrideWithValue(clock),
          activeCoursesProvider.overrideWithValue(
            const ActiveCoursesSnapshot(courses: [], isLoading: false),
          ),
        ],
      );
      addTearDown(container.dispose);
      final ready = Completer<void>();
      final subscription = container.listen(studyEngineNotifierProvider, (
        _,
        next,
      ) {
        if (!next.isInitializing && !ready.isCompleted) ready.complete();
      }, fireImmediately: true);
      addTearDown(subscription.close);
      await ready.future;
      final notifier = container.read(studyEngineNotifierProvider.notifier);
      expect(
        container.read(studyEngineNotifierProvider).selectedDuration,
        const Duration(minutes: 40),
      );

      notifier.selectDuration(const Duration(minutes: 15));
      await notifier.start();
      expect(
        (await repository.getActive('user-1'))?.status,
        StudySessionStatus.running,
      );
      clock.advance(const Duration(minutes: 3));
      await notifier.pause();
      expect(
        (await repository.getActive('user-1'))?.status,
        StudySessionStatus.paused,
      );
      await notifier.resume();
      await notifier.cancel();
      expect(await repository.getActive('user-1'), isNull);
      expect(await repository.recent('user-1'), hasLength(1));
      expect(
        container.read(studyEngineNotifierProvider).lastFinishedSession?.status,
        StudySessionStatus.cancelled,
      );
    },
  );

  test(
    'completed result remains visible and a new session clears it',
    () async {
      final harness = await _Harness.create(courses: [_course()]);
      addTearDown(harness.dispose);
      final notifier = harness.notifier;
      notifier.selectCourse('course-1');
      await notifier.start();
      await notifier.complete();

      final completed = harness.state.lastFinishedSession;
      expect(completed?.status, StudySessionStatus.completed);
      expect(harness.state.activeSession, isNull);
      expect(await harness.repository.getActive('user-1'), isNull);
      expect(
        (await harness.repository.recent('user-1')).single.status,
        StudySessionStatus.completed,
      );

      await notifier.start();
      expect(harness.state.lastFinishedSession, isNull);
      expect(harness.state.activeSession?.courseId, 'course-1');
    },
  );

  test('cancelled result is not presented as completed', () async {
    final harness = await _Harness.create();
    addTearDown(harness.dispose);
    await harness.notifier.start();
    await harness.notifier.cancel();
    expect(
      harness.state.lastFinishedSession?.status,
      StudySessionStatus.cancelled,
    );
    expect(harness.state.lastFinishedSession?.completedAt, isNull);
  });

  test(
    'only active owned courses can be associated; free remains valid',
    () async {
      final active = _course();
      final harness = await _Harness.create(courses: [active]);
      addTearDown(harness.dispose);

      harness.notifier.selectCourse(active.id);
      await harness.notifier.start();
      expect(harness.state.activeSession?.courseId, active.id);
      await harness.notifier.cancel();
      harness.notifier.clearFinishedResult();

      for (final invalidId in ['archived', 'deleted', 'other-user']) {
        harness.notifier.selectCourse(invalidId);
        await harness.notifier.start();
        expect(await harness.repository.getActive('user-1'), isNull);
        expect(harness.state.selectedCourseId, isNull);
        expect(harness.state.errorMessage, isNotNull);
      }

      harness.notifier.selectCourse(null);
      await harness.notifier.start();
      expect(harness.state.activeSession?.courseId, isNull);
    },
  );

  test(
    'stale course selection is cleared when public courses change',
    () async {
      final harness = await _Harness.create(
        coursesProvider: _mutableCoursesProvider,
      );
      addTearDown(harness.dispose);
      harness.notifier.selectCourse('course-1');

      harness.container.read(_mutableCoursesProvider.notifier).replace([]);
      await Future<void>.delayed(Duration.zero);

      expect(harness.state.selectedCourseId, isNull);
      expect(harness.state.errorMessage, isNotNull);
    },
  );

  test(
    'concurrent expiration reconciliations persist completion once',
    () async {
      final harness = await _Harness.create(countSaves: true);
      addTearDown(harness.dispose);
      harness.notifier.selectDuration(const Duration(minutes: 15));
      await harness.notifier.start();
      harness.clock.advance(const Duration(minutes: 15));

      await Future.wait(List.generate(8, (_) => harness.notifier.reconcile()));

      expect(harness.repository.completedSaves, 1);
      expect(
        harness.state.lastFinishedSession?.status,
        StudySessionStatus.completed,
      );
      expect(await harness.repository.getActive('user-1'), isNull);
    },
  );
}

Course _course() {
  final now = DateTime.utc(2026, 7, 12);
  return Course(
    id: 'course-1',
    ownerId: 'user-1',
    name: 'MatemÃ¡tica',
    visualIdentity: CourseVisualIdentity.ocean,
    status: CourseStatus.active,
    createdAt: now,
    updatedAt: now,
  );
}

final class _Harness {
  _Harness(this.container, this.repository, this.clock, this.subscription);

  final ProviderContainer container;
  final _CountingRepository repository;
  final _FakeClock clock;
  final ProviderSubscription<StudyEngineState> subscription;
  StudyEngineNotifier get notifier =>
      container.read(studyEngineNotifierProvider.notifier);
  StudyEngineState get state => container.read(studyEngineNotifierProvider);

  static Future<_Harness> create({
    List<Course> courses = const [],
    NotifierProvider<_MutableCoursesNotifier, List<Course>>? coursesProvider,
    bool countSaves = false,
  }) async {
    final clock = _FakeClock(DateTime.utc(2026, 7, 12, 10));
    final repository = _CountingRepository(countSaves: countSaves);
    final container = ProviderContainer(
      overrides: [
        publicAuthSessionProvider.overrideWithValue(
          const AuthSession.authenticated(
            user: AuthUser(id: 'user-1', email: 'student@focusly.dev'),
            emailVerified: true,
          ),
        ),
        onboardingRepositoryProvider.overrideWithValue(
          InMemoryOnboardingRepository(),
        ),
        studySessionRepositoryProvider.overrideWithValue(repository),
        studyClockProvider.overrideWithValue(clock),
        activeCoursesProvider.overrideWith((ref) {
          final values = coursesProvider == null
              ? courses
              : ref.watch(coursesProvider);
          return ActiveCoursesSnapshot(courses: values, isLoading: false);
        }),
      ],
    );
    final ready = Completer<void>();
    final subscription = container.listen(studyEngineNotifierProvider, (
      _,
      next,
    ) {
      if (!next.isInitializing && !ready.isCompleted) ready.complete();
    }, fireImmediately: true);
    await ready.future;
    return _Harness(container, repository, clock, subscription);
  }

  void dispose() {
    subscription.close();
    container.dispose();
    repository.dispose();
  }
}

final _mutableCoursesProvider =
    NotifierProvider<_MutableCoursesNotifier, List<Course>>(
      _MutableCoursesNotifier.new,
    );

final class _MutableCoursesNotifier extends Notifier<List<Course>> {
  @override
  List<Course> build() => [_course()];

  void replace(List<Course> courses) => state = courses;
}

final class _CountingRepository implements StudySessionRepository {
  _CountingRepository({required this.countSaves});
  final bool countSaves;
  final InMemoryStudySessionRepository _delegate =
      InMemoryStudySessionRepository();
  int completedSaves = 0;

  @override
  Future<void> save(StudySession session) {
    if (countSaves && session.status == StudySessionStatus.completed) {
      completedSaves++;
    }
    return _delegate.save(session);
  }

  @override
  Future<List<StudySession>> byCourse(String ownerId, String courseId) =>
      _delegate.byCourse(ownerId, courseId);
  @override
  Future<void> clearForTests(String ownerId) =>
      _delegate.clearForTests(ownerId);
  @override
  Future<StudySession?> getActive(String ownerId) =>
      _delegate.getActive(ownerId);
  @override
  Future<List<StudySession>> recent(String ownerId, {int limit = 30}) =>
      _delegate.recent(ownerId, limit: limit);
  @override
  Stream<StudySession?> watchActive(String ownerId) =>
      _delegate.watchActive(ownerId);
  void dispose() => _delegate.dispose();
}

final class _FakeClock implements StudyClock {
  _FakeClock(this.value);
  DateTime value;
  @override
  DateTime now() => value;
  void advance(Duration duration) => value = value.add(duration);
}
