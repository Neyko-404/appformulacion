import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/authentication_providers.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/onboarding/presentation/notifiers/onboarding_notifier.dart';
import 'package:focusly/features/onboarding/presentation/state/onboarding_state.dart';

void main() {
  final now = DateTime.utc(2026, 7, 12);

  Future<ProviderContainer> createContainer({
    OnboardingRepository? onboardingRepository,
  }) async {
    final authRepository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
    await authRepository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    final container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        onboardingRepositoryProvider.overrideWithValue(
          onboardingRepository ?? InMemoryOnboardingRepository(),
        ),
        onboardingClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(authRepository.dispose);

    final ready = Completer<void>();
    final subscription = container.listen(onboardingNotifierProvider, (
      previous,
      next,
    ) {
      if (!next.isInitializing && !ready.isCompleted) {
        ready.complete();
      }
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await ready.future;
    return container;
  }

  test('initializes at welcome with authenticated user', () async {
    final container = await createContainer();
    final state = container.read(onboardingNotifierProvider);
    expect(state.step, OnboardingStep.welcome);
    expect(state.userId, isNotNull);
    expect(state.isCompleted, isFalse);
  });

  test('session without user resolves to a safe state', () async {
    final authRepository = InMemoryAuthRepository();
    final container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        onboardingRepositoryProvider.overrideWithValue(
          InMemoryOnboardingRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(authRepository.dispose);

    final ready = Completer<void>();
    final subscription = container.listen(onboardingNotifierProvider, (
      previous,
      next,
    ) {
      if (!next.isInitializing && !ready.isCompleted) {
        ready.complete();
      }
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await ready.future;
    final state = container.read(onboardingNotifierProvider);
    expect(state.userId, isNull);
    expect(state.isInitializing, isFalse);
    expect(state.errorMessage, contains('sesión válida'));
  });

  test('changing user resets draft and does not leak previous data', () async {
    final authRepository = InMemoryAuthRepository(
      seedAccounts: const {
        'first@focusly.dev': 'password123',
        'second@focusly.dev': 'password456',
      },
    );
    await authRepository.signIn(
      email: 'first@focusly.dev',
      password: 'password123',
    );
    final container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        onboardingRepositoryProvider.overrideWithValue(
          InMemoryOnboardingRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(authRepository.dispose);
    container
        .read(onboardingNotifierProvider.notifier)
        .updateCareer('Dato privado del primer usuario');

    await authRepository.signOut();
    await authRepository.signIn(
      email: 'second@focusly.dev',
      password: 'password456',
    );
    await Future<void>.delayed(Duration.zero);

    final state = container.read(onboardingNotifierProvider);
    expect(state.userId, 'memory-2');
    expect(state.draft.career, isEmpty);
    expect(state.step, OnboardingStep.welcome);
    expect(state.isCompleted, isFalse);
  });

  test('exposes loading before repository initialization finishes', () async {
    final repository = _ControlledRepository(blockInitialization: true);
    final authRepository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
    await authRepository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    final container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        onboardingRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(authRepository.dispose);

    expect(container.read(onboardingNotifierProvider).isInitializing, isTrue);
    repository.initialization.complete(false);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(onboardingNotifierProvider).isInitializing, isFalse);
  });

  test('updates partial data and advances valid steps', () async {
    final container = await createContainer();
    final notifier = container.read(onboardingNotifierProvider.notifier);

    expect(notifier.next(), isTrue);
    notifier
      ..updateCareer('Ingeniería')
      ..updateCycle(4);
    expect(notifier.next(), isTrue);
    notifier.updateGoal(PrimaryGoal.concentration);
    expect(notifier.next(), isTrue);
    notifier.updateFocusMinutes(40);
    expect(notifier.next(), isTrue);
    notifier
      ..updateCompanionName('  Mi   gato  ')
      ..updateAppearance(CompanionAppearance.emerald);
    expect(notifier.next(), isTrue);

    expect(
      container.read(onboardingNotifierProvider).step,
      OnboardingStep.summary,
    );
  });

  test('blocks invalid step and allows going back', () async {
    final container = await createContainer();
    final notifier = container.read(onboardingNotifierProvider.notifier);
    notifier.next();

    expect(notifier.next(), isFalse);
    expect(
      container.read(onboardingNotifierProvider).validationMessage,
      isNotNull,
    );
    notifier.previous();
    expect(
      container.read(onboardingNotifierProvider).step,
      OnboardingStep.welcome,
    );
  });

  test('saves and completes onboarding', () async {
    final repository = InMemoryOnboardingRepository();
    final container = await createContainer(onboardingRepository: repository);
    final notifier = container.read(onboardingNotifierProvider.notifier);
    notifier
      ..updateCareer('Ingeniería')
      ..updateCycle(4)
      ..updateGoal(PrimaryGoal.routine)
      ..updateFocusMinutes(25)
      ..updateCompanionName('Milo')
      ..updateAppearance(CompanionAppearance.indigo);

    await notifier.complete();

    final state = container.read(onboardingNotifierProvider);
    expect(state.isCompleted, isTrue);
    expect(state.isSaving, isFalse);
    expect(await repository.isCompleted(state.userId!), isTrue);
    expect((await repository.getCompanion(state.userId!))?.name, 'Milo');
  });

  test('exposes a safe error when save fails', () async {
    final repository = _ControlledRepository(throwOnSave: true);
    final container = await createContainer(onboardingRepository: repository);
    final notifier = container.read(onboardingNotifierProvider.notifier);
    _fillValidDraft(notifier);

    await notifier.complete();

    final state = container.read(onboardingNotifierProvider);
    expect(state.isCompleted, isFalse);
    expect(state.isSaving, isFalse);
    expect(state.errorMessage, contains('No pudimos guardar'));
  });

  test('prevents concurrent saves', () async {
    final repository = _ControlledRepository(blockSave: true);
    final container = await createContainer(onboardingRepository: repository);
    final notifier = container.read(onboardingNotifierProvider.notifier);
    _fillValidDraft(notifier);

    final firstSave = notifier.complete();
    await Future<void>.delayed(Duration.zero);
    final secondSave = notifier.complete();
    expect(repository.saveCalls, 1);
    repository.saveCompletion.complete();
    await Future.wait([firstSave, secondSave]);
    expect(container.read(onboardingNotifierProvider).isCompleted, isTrue);
  });
}

void _fillValidDraft(OnboardingNotifier notifier) {
  notifier
    ..updateCareer('Ingeniería')
    ..updateCycle(4)
    ..updateGoal(PrimaryGoal.routine)
    ..updateFocusMinutes(25)
    ..updateCompanionName('Milo')
    ..updateAppearance(CompanionAppearance.indigo);
}

final class _ControlledRepository implements OnboardingRepository {
  _ControlledRepository({
    this.blockInitialization = false,
    this.blockSave = false,
    this.throwOnSave = false,
  });

  final bool blockInitialization;
  final bool blockSave;
  final bool throwOnSave;
  final initialization = Completer<bool>();
  final saveCompletion = Completer<void>();
  int saveCalls = 0;
  StudentProfile? profile;
  StudyCompanion? companion;

  @override
  Future<bool> isCompleted(String userId) {
    if (blockInitialization) return initialization.future;
    return Future.value(profile != null && companion != null);
  }

  @override
  Future<void> saveOnboarding({
    required StudentProfile profile,
    required StudyCompanion companion,
  }) async {
    saveCalls++;
    if (throwOnSave) throw StateError('internal detail');
    if (blockSave) await saveCompletion.future;
    this.profile = profile;
    this.companion = companion;
  }

  @override
  Future<StudentProfile?> getProfile(String userId) async => profile;

  @override
  Future<StudyCompanion?> getCompanion(String userId) async => companion;

  @override
  Future<void> clear(String userId) async {
    profile = null;
    companion = null;
  }
}
