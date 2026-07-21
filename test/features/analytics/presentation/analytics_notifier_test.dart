import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_analytics_read_api.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';
import 'package:focusly/features/study_engine/study_engine_public_providers.dart';

void main() {
  test(
    'dashboard and progress projections share one analytics snapshot',
    () async {
      final completedAt = DateTime(2026, 7, 12, 10);
      final repository = _Repository(
        records: [
          StudyAnalyticsRecord(
            session: StudySession(
              id: 'session-1',
              ownerId: 'user-1',
              mode: StudyMode.focus,
              status: StudySessionStatus.completed,
              plannedDuration: const Duration(minutes: 30),
              accumulatedFocusDuration: const Duration(minutes: 30),
              startedAt: completedAt.subtract(const Duration(minutes: 30)),
              completedAt: completedAt,
              createdAt: completedAt.subtract(const Duration(minutes: 30)),
              updatedAt: completedAt,
            ),
            interruptions: [
              StudyInterruption(
                id: 'interruption-1',
                startedAt: completedAt.subtract(const Duration(minutes: 20)),
                endedAt: completedAt.subtract(const Duration(minutes: 18)),
                reason: StudyInterruptionReason.appBackgrounded,
                createdAt: completedAt.subtract(const Duration(minutes: 20)),
              ),
            ],
          ),
        ],
      );
      final container = _container(repository);
      addTearDown(container.dispose);
      final ready = Completer<void>();
      final subscription = container.listen(analyticsNotifierProvider, (
        _,
        next,
      ) {
        if (!next.isLoading && next.summary != null && !ready.isCompleted) {
          ready.complete();
        }
      }, fireImmediately: true);
      addTearDown(subscription.close);
      await ready.future;

      final state = container.read(analyticsNotifierProvider);
      final public = container.read(todayAnalyticsProvider);
      final dashboard = await container.read(
        dashboardTodayAnalyticsProvider.future,
      );
      final companion = container.read(companionAnalyticsProvider);
      final goals = container.read(focusGoalsAnalyticsProvider);
      expect(state.summary?.daily.focusedDuration, const Duration(minutes: 30));
      expect(public.focusedDuration, state.summary?.daily.focusedDuration);
      expect(public.completedSessions, state.summary?.daily.completedSessions);
      expect(public.interruptionCount, state.summary?.daily.interruptionCount);
      expect(dashboard.focusedDuration, public.focusedDuration);
      expect(dashboard.completedSessions, public.completedSessions);
      expect(dashboard.interruptionCount, public.interruptionCount);
      expect(companion?.focusMinutesToday, 30);
      expect(companion?.completedSessionsToday, 1);
      expect(companion?.interruptionCountToday, 1);
      expect(companion?.activeDaysThisWeek, 1);
      expect(goals?.focusMinutesToday, 30);
      expect(goals?.completedSessionsThisWeek, 1);
      expect(goals?.activeDaysThisWeek, 1);
      expect(repository.calls, 1);
    },
  );

  test('source error becomes safe state', () async {
    final container = _container(_Repository(fail: true));
    addTearDown(container.dispose);
    final ready = Completer<void>();
    final subscription = container.listen(analyticsNotifierProvider, (_, next) {
      if (!next.isLoading && next.errorMessage != null && !ready.isCompleted) {
        ready.complete();
      }
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await ready.future;
    expect(container.read(analyticsNotifierProvider).errorMessage, isNotNull);
  });

  test('refresh prevents concurrent source loads', () async {
    final repository = _Repository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final subscription = container.listen(
      analyticsNotifierProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await Future<void>.value();
    await Future<void>.value();
    final notifier = container.read(analyticsNotifierProvider.notifier);
    await Future.wait([
      notifier.refresh(),
      notifier.refresh(),
      notifier.refresh(),
    ]);
    expect(repository.maxConcurrent, 1);
  });

  test('changing user rebuilds analytics with isolated owner id', () async {
    final repository = _Repository();
    final container = ProviderContainer(
      overrides: [
        publicAuthSessionProvider.overrideWith(
          (ref) => ref.watch(_sessionProvider),
        ),
        analyticsRepositoryProvider.overrideWithValue(repository),
        analyticsClockProvider.overrideWithValue(_Clock(DateTime(2026, 7, 12))),
        studyAnalyticsRevisionProvider.overrideWithValue(0),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      analyticsNotifierProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await Future<void>.value();
    await Future<void>.value();
    container.read(_sessionProvider.notifier).use('user-2');
    await repository.secondOwnerRead.future;
    expect(repository.ownerIds, containsAllInOrder(['user-1', 'user-2']));
  });

  test(
    'persistent session and interruption revisions refresh without ticks',
    () async {
      final repository = _Repository();
      final container = ProviderContainer(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(_session('user-1')),
          analyticsRepositoryProvider.overrideWithValue(repository),
          analyticsClockProvider.overrideWithValue(
            _Clock(DateTime(2026, 7, 12)),
          ),
          studyAnalyticsRevisionProvider.overrideWith(
            (ref) => ref.watch(_revisionProvider),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        analyticsNotifierProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      await repository.waitForCalls(1);

      container.read(_revisionProvider.notifier).set(1); // completed
      await repository.waitForCalls(2);
      container.read(_revisionProvider.notifier).set(1); // timer tick
      await Future<void>.value();
      expect(repository.calls, 2);

      container.read(_revisionProvider.notifier).set(2); // cancelled
      await repository.waitForCalls(3);
      container.read(_revisionProvider.notifier).set(3); // interruption
      await repository.waitForCalls(4);
      expect(repository.maxConcurrent, 1);
    },
  );

  test(
    'simultaneous persistent signals coalesce without concurrent loads',
    () async {
      final repository = _Repository();
      final container = ProviderContainer(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(_session('user-1')),
          analyticsRepositoryProvider.overrideWithValue(repository),
          analyticsClockProvider.overrideWithValue(
            _Clock(DateTime(2026, 7, 12)),
          ),
          studyAnalyticsRevisionProvider.overrideWith(
            (ref) => ref.watch(_revisionProvider),
          ),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        analyticsNotifierProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      await repository.waitForCalls(1);

      container.read(_revisionProvider.notifier)
        ..set(1)
        ..set(2)
        ..set(3);
      await repository.waitForCalls(2);
      await Future<void>.value();
      expect(repository.calls, 2);
      expect(repository.maxConcurrent, 1);
    },
  );
}

final _revisionProvider = NotifierProvider<_RevisionNotifier, int>(
  _RevisionNotifier.new,
);

final class _RevisionNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void set(int value) => state = value;
}

final _sessionProvider = NotifierProvider<_SessionNotifier, AuthSession>(
  _SessionNotifier.new,
);

final class _SessionNotifier extends Notifier<AuthSession> {
  @override
  AuthSession build() => _session('user-1');
  void use(String ownerId) => state = _session(ownerId);
}

AuthSession _session(String ownerId) => AuthSession.authenticated(
  user: AuthUser(id: ownerId, email: '$ownerId@focusly.dev'),
  emailVerified: true,
);

ProviderContainer _container(_Repository repository) => ProviderContainer(
  overrides: [
    publicAuthSessionProvider.overrideWithValue(
      const AuthSession.authenticated(
        user: AuthUser(id: 'user-1', email: 'test@focusly.dev'),
        emailVerified: true,
      ),
    ),
    analyticsRepositoryProvider.overrideWithValue(repository),
    analyticsClockProvider.overrideWithValue(_Clock(DateTime(2026, 7, 12))),
    studyAnalyticsRevisionProvider.overrideWithValue(0),
    activeCoursesProvider.overrideWithValue(
      const ActiveCoursesSnapshot(courses: [], isLoading: false),
    ),
    activeStudySummaryProvider.overrideWithValue(
      const ActiveStudySummary(remaining: Duration.zero),
    ),
  ],
);

final class _Clock implements AnalyticsClock {
  _Clock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

final class _Repository implements AnalyticsRepository {
  _Repository({this.fail = false, this.records = const []});
  final bool fail;
  final List<StudyAnalyticsRecord> records;
  int calls = 0;
  int concurrent = 0;
  int maxConcurrent = 0;
  final List<String> ownerIds = [];
  final Completer<void> secondOwnerRead = Completer<void>();
  final StreamController<int> _callController = StreamController<int>.broadcast(
    sync: true,
  );
  Future<void> waitForCalls(int value) => calls >= value
      ? Future<void>.value()
      : _callController.stream.firstWhere((calls) => calls >= value);
  @override
  Future<AnalyticsSourceSnapshot> read(String ownerId) async {
    calls++;
    _callController.add(calls);
    ownerIds.add(ownerId);
    if (ownerId == 'user-2' && !secondOwnerRead.isCompleted) {
      secondOwnerRead.complete();
    }
    concurrent++;
    if (concurrent > maxConcurrent) maxConcurrent = concurrent;
    await Future<void>.value();
    concurrent--;
    if (fail) throw StateError('source');
    return AnalyticsSourceSnapshot(records: records, courses: const []);
  }
}
