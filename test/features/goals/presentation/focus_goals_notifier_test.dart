import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/features/analytics/focus_goals_analytics_projection.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/goals/application/goals_providers.dart';
import 'package:focusly/features/goals/data/repositories/in_memory_focus_goal_repository.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';

void main() {
  const session = AuthSession.authenticated(
    user: AuthUser(id: 'user-1', email: 'student@focusly.dev'),
    emailVerified: true,
  );
  const analytics = FocusGoalsAnalyticsProjection(
    focusMinutesToday: 10,
    completedSessionsThisWeek: 2,
    activeDaysThisWeek: 1,
  );
  final now = DateTime.utc(2026, 7, 20);

  ProviderContainer containerFor(InMemoryFocusGoalRepository repository) {
    final container = ProviderContainer(
      overrides: [
        publicAuthSessionProvider.overrideWithValue(session),
        focusGoalsAnalyticsProvider.overrideWithValue(analytics),
        focusGoalRepositoryProvider.overrideWithValue(repository),
        focusGoalsClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('loads an empty configuration without persisting suggestions', () async {
    final repository = InMemoryFocusGoalRepository();
    final container = containerFor(repository);
    container.read(focusGoalsNotifierProvider);
    await container.read(focusGoalsNotifierProvider.notifier).refresh();

    final state = container.read(focusGoalsNotifierProvider);
    expect(state.isLoading, isFalse);
    expect(state.goal, isNull);
    expect(repository.saveCount, 0);
  });

  test(
    'saves configuration and derives progress without persisting it',
    () async {
      final repository = InMemoryFocusGoalRepository();
      final container = containerFor(repository);
      container.read(focusGoalsNotifierProvider);
      await container.read(focusGoalsNotifierProvider.notifier).refresh();

      final result = await container
          .read(focusGoalsNotifierProvider.notifier)
          .save(
            dailyMinutesTarget: 25,
            weeklyCompletedSessionsTarget: 3,
            weeklyActiveDaysTarget: null,
          );

      final state = container.read(focusGoalsNotifierProvider);
      expect(result, isTrue);
      expect(state.goal?.ownerId, 'user-1');
      expect(state.progress?.dailyMinutes.current, 10);
      expect(state.progress?.weeklySessions.current, 2);
      expect(repository.saveCount, 1);
    },
  );

  test('prevents concurrent saves', () async {
    final repository = InMemoryFocusGoalRepository(
      writeDelay: const Duration(milliseconds: 30),
    );
    final container = containerFor(repository);
    container.read(focusGoalsNotifierProvider);
    await container.read(focusGoalsNotifierProvider.notifier).refresh();
    final notifier = container.read(focusGoalsNotifierProvider.notifier);

    final first = notifier.save(
      dailyMinutesTarget: 25,
      weeklyCompletedSessionsTarget: null,
      weeklyActiveDaysTarget: null,
    );
    final second = notifier.save(
      dailyMinutesTarget: 30,
      weeklyCompletedSessionsTarget: null,
      weeklyActiveDaysTarget: null,
    );

    expect(await second, isFalse);
    expect(await first, isTrue);
    expect(repository.saveCount, 1);
  });

  test('exposes safe storage errors while retaining editable state', () async {
    final repository = InMemoryFocusGoalRepository(failWrites: true);
    final container = containerFor(repository);
    container.read(focusGoalsNotifierProvider);
    await container.read(focusGoalsNotifierProvider.notifier).refresh();

    expect(
      await container
          .read(focusGoalsNotifierProvider.notifier)
          .save(
            dailyMinutesTarget: 25,
            weeklyCompletedSessionsTarget: null,
            weeklyActiveDaysTarget: null,
          ),
      isFalse,
    );
    expect(container.read(focusGoalsNotifierProvider).errorMessage, isNotNull);
  });

  test('loaded goal belongs only to the authenticated owner', () async {
    final repository = InMemoryFocusGoalRepository(
      seedGoals: [
        FocusGoal(
          ownerId: 'user-2',
          dailyMinutesTarget: 60,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
    final container = containerFor(repository);
    container.read(focusGoalsNotifierProvider);
    await container.read(focusGoalsNotifierProvider.notifier).refresh();
    expect(container.read(focusGoalsNotifierProvider).goal, isNull);
  });

  test(
    'recalculates progress when the public Analytics projection changes',
    () async {
      final repository = InMemoryFocusGoalRepository(
        seedGoals: [
          FocusGoal(
            ownerId: 'user-1',
            dailyMinutesTarget: 25,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(session),
          focusGoalsAnalyticsProvider.overrideWith(
            (ref) => ref.watch(_analyticsProjectionProvider),
          ),
          focusGoalRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        focusGoalsNotifierProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      container.read(focusGoalsNotifierProvider);
      await container.read(focusGoalsNotifierProvider.notifier).refresh();
      expect(
        container
            .read(focusGoalsNotifierProvider)
            .progress
            ?.dailyMinutes
            .current,
        10,
      );

      container
          .read(_analyticsProjectionProvider.notifier)
          .use(
            const FocusGoalsAnalyticsProjection(
              focusMinutesToday: 30,
              completedSessionsThisWeek: 2,
              activeDaysThisWeek: 1,
            ),
          );
      await container.pump();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await container.pump();

      expect(
        container
            .read(focusGoalsNotifierProvider)
            .progress
            ?.dailyMinutes
            .current,
        30,
      );
      expect(repository.saveCount, 0);
    },
  );

  test(
    'discards an obsolete load after the authenticated user changes',
    () async {
      final repository = InMemoryFocusGoalRepository(
        seedGoals: [
          FocusGoal(
            ownerId: 'user-1',
            dailyMinutesTarget: 25,
            createdAt: now,
            updatedAt: now,
          ),
          FocusGoal(
            ownerId: 'user-2',
            dailyMinutesTarget: 60,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        readDelay: const Duration(milliseconds: 20),
      );
      final container = ProviderContainer(
        overrides: [
          publicAuthSessionProvider.overrideWith(
            (ref) => ref.watch(_mutableSessionProvider),
          ),
          focusGoalsAnalyticsProvider.overrideWithValue(analytics),
          focusGoalRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        focusGoalsNotifierProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      container.read(focusGoalsNotifierProvider);
      container
          .read(_mutableSessionProvider.notifier)
          .use(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-2', email: 'second@focusly.dev'),
              emailVerified: true,
            ),
          );
      await container.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await container.pump();

      expect(
        container.read(focusGoalsNotifierProvider).goal?.ownerId,
        'user-2',
      );
      expect(
        container.read(focusGoalsNotifierProvider).goal?.dailyMinutesTarget,
        60,
      );
    },
  );

  test('a save completion cannot replace the next user state', () async {
    final repository = InMemoryFocusGoalRepository(
      writeDelay: const Duration(milliseconds: 30),
    );
    final container = ProviderContainer(
      overrides: [
        publicAuthSessionProvider.overrideWith(
          (ref) => ref.watch(_mutableSessionProvider),
        ),
        focusGoalsAnalyticsProvider.overrideWithValue(analytics),
        focusGoalRepositoryProvider.overrideWithValue(repository),
        focusGoalsClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      focusGoalsNotifierProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    container.read(focusGoalsNotifierProvider);
    await container.read(focusGoalsNotifierProvider.notifier).refresh();
    final save = container
        .read(focusGoalsNotifierProvider.notifier)
        .save(
          dailyMinutesTarget: 25,
          weeklyCompletedSessionsTarget: null,
          weeklyActiveDaysTarget: null,
        );
    container
        .read(_mutableSessionProvider.notifier)
        .use(
          const AuthSession.authenticated(
            user: AuthUser(id: 'user-2', email: 'second@focusly.dev'),
            emailVerified: true,
          ),
        );
    await container.pump();

    expect(await save, isFalse);
    await Future<void>.delayed(Duration.zero);
    expect(
      container.read(focusGoalsNotifierProvider).goal?.ownerId,
      isNot('user-1'),
    );
  });
}

final _analyticsProjectionProvider =
    NotifierProvider<_MutableAnalytics, FocusGoalsAnalyticsProjection?>(
      _MutableAnalytics.new,
    );

final _mutableSessionProvider = NotifierProvider<_MutableSession, AuthSession>(
  _MutableSession.new,
);

final class _MutableAnalytics extends Notifier<FocusGoalsAnalyticsProjection?> {
  @override
  FocusGoalsAnalyticsProjection build() => const FocusGoalsAnalyticsProjection(
    focusMinutesToday: 10,
    completedSessionsThisWeek: 2,
    activeDaysThisWeek: 1,
  );

  void use(FocusGoalsAnalyticsProjection value) => state = value;
}

final class _MutableSession extends Notifier<AuthSession> {
  @override
  AuthSession build() => const AuthSession.authenticated(
    user: AuthUser(id: 'user-1', email: 'student@focusly.dev'),
    emailVerified: true,
  );

  void use(AuthSession value) => state = value;
}
