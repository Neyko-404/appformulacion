import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/dashboard/dashboard_providers.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';

const _initialSession = AuthSession.authenticated(
  user: AuthUser(id: 'user-1', email: 'gary@focusly.dev'),
  emailVerified: true,
);
final _sessionProvider = NotifierProvider<_SessionNotifier, AuthSession>(
  _SessionNotifier.new,
);

final class _SessionNotifier extends Notifier<AuthSession> {
  @override
  AuthSession build() => _initialSession;

  void set(AuthSession value) => state = value;
}

void main() {
  const session = _initialSession;
  final now = DateTime.utc(2026, 7, 12);

  Future<InMemoryOnboardingRepository> repositoryWithData() async {
    final repository = InMemoryOnboardingRepository();
    await repository.saveOnboarding(
      profile: StudentProfile(
        userId: 'user-1',
        university: 'UNJFSC',
        career: 'Ingeniería',
        currentCycle: 4,
        primaryGoal: PrimaryGoal.examPreparation,
        preferredFocusMinutes: 25,
        createdAt: now,
        updatedAt: now,
      ),
      companion: StudyCompanion(
        id: 'cat-1',
        ownerId: 'user-1',
        name: 'Kumo',
        appearance: CompanionAppearance.indigo,
        createdAt: now,
      ),
    );
    return repository;
  }

  test('loads profile and companion from OnboardingRepository', () async {
    final repository = await repositoryWithData();
    final container = ProviderContainer.test(
      overrides: [
        publicAuthSessionProvider.overrideWithValue(session),
        dashboardOnboardingRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final ready = Completer<void>();
    final subscription = container.listen(dashboardNotifierProvider, (_, next) {
      if (!next.isLoading && !ready.isCompleted) ready.complete();
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await ready.future;

    final state = container.read(dashboardNotifierProvider);
    expect(state.profile?.userId, 'user-1');
    expect(state.companion?.name, 'Kumo');
    expect(state.errorMessage, isNull);
  });

  test('missing session produces a safe error', () async {
    final container = ProviderContainer.test(
      overrides: [
        publicAuthSessionProvider.overrideWithValue(
          const AuthSession.unauthenticated(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final ready = Completer<void>();
    final subscription = container.listen(dashboardNotifierProvider, (_, next) {
      if (!next.isLoading && !ready.isCompleted) ready.complete();
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await ready.future;

    expect(
      container.read(dashboardNotifierProvider).errorMessage,
      contains('sesión válida'),
    );
  });

  test(
    'user change starts a fresh load and ignores the previous result',
    () async {
      final repository = _DelayedDashboardRepository(now);
      final container = ProviderContainer.test(
        overrides: [
          publicAuthSessionProvider.overrideWith(
            (ref) => ref.watch(_sessionProvider),
          ),
          dashboardOnboardingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        dashboardNotifierProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);

      container
          .read(_sessionProvider.notifier)
          .set(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-2', email: 'second@focusly.dev'),
              emailVerified: true,
            ),
          );
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(dashboardNotifierProvider).profile?.userId,
        'user-2',
      );
      expect(
        container.read(dashboardNotifierProvider).companion?.ownerId,
        'user-2',
      );

      repository.releaseFirstUser();
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(dashboardNotifierProvider).profile?.userId,
        'user-2',
      );
    },
  );
}

final class _DelayedDashboardRepository implements OnboardingRepository {
  _DelayedDashboardRepository(this.now);

  final DateTime now;
  final Completer<void> _firstUserGate = Completer<void>();

  void releaseFirstUser() => _firstUserGate.complete();

  Future<void> _wait(String userId) async {
    if (userId == 'user-1') await _firstUserGate.future;
  }

  @override
  Future<StudentProfile?> getProfile(String userId) async {
    await _wait(userId);
    return StudentProfile(
      userId: userId,
      university: 'Universidad',
      career: 'Ingeniería',
      currentCycle: 4,
      primaryGoal: PrimaryGoal.organization,
      preferredFocusMinutes: 25,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<StudyCompanion?> getCompanion(String userId) async {
    await _wait(userId);
    return StudyCompanion(
      id: 'cat-$userId',
      ownerId: userId,
      name: 'Milo',
      appearance: CompanionAppearance.indigo,
      createdAt: now,
    );
  }

  @override
  Future<bool> isCompleted(String userId) async => true;

  @override
  Future<void> saveOnboarding({
    required StudentProfile profile,
    required StudyCompanion companion,
  }) async {}

  @override
  Future<void> clear(String userId) async {}
}
