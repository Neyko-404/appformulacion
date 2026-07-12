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

void main() {
  const session = AuthSession.authenticated(
    user: AuthUser(id: 'user-1', email: 'gary@focusly.dev'),
    emailVerified: true,
  );
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
}
