import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/app/router/app_router.dart';
import 'package:focusly/app/theme/theme_mode_provider.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/entities/onboarding_failure.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';

void main() {
  test('theme mode can change without persistence', () {
    final container = ProviderContainer.test();
    addTearDown(container.dispose);
    expect(container.read(themeModeProvider), ThemeMode.system);
    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  testWidgets('unauthenticated session redirects to login without loops', (
    tester,
  ) async {
    final repository = InMemoryAuthRepository();
    addTearDown(repository.dispose);
    final container = ProviderContainer.test(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Inicia sesión'), findsOneWidget);
    container.read(routerProvider).go('/unknown');
    await tester.pumpAndSettle();
    expect(find.text('Inicia sesión'), findsOneWidget);
  });

  testWidgets('unverified session redirects to verify email', (tester) async {
    final repository = InMemoryAuthRepository();
    await repository.signUp(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Verifica tu correo'), findsOneWidget);
  });

  testWidgets('verified session redirects to onboarding', (tester) async {
    final repository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
    await repository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Te damos la bienvenida'), findsOneWidget);
  });

  testWidgets('completed onboarding redirects to dashboard', (tester) async {
    final authRepository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
    await authRepository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    addTearDown(authRepository.dispose);
    final onboardingRepository = InMemoryOnboardingRepository();
    final now = DateTime.utc(2026, 7, 12);
    await onboardingRepository.saveOnboarding(
      profile: StudentProfile(
        userId: 'memory-1',
        university: 'UNJFSC',
        career: 'Ingeniería',
        currentCycle: 4,
        primaryGoal: PrimaryGoal.concentration,
        preferredFocusMinutes: 25,
        createdAt: now,
        updatedAt: now,
      ),
      companion: StudyCompanion(
        id: 'companion-memory-1',
        ownerId: 'memory-1',
        name: 'Milo',
        appearance: CompanionAppearance.indigo,
        createdAt: now,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          onboardingRepositoryProvider.overrideWithValue(onboardingRepository),
        ],
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kumo'), findsNothing);
    expect(find.text('Milo'), findsOneWidget);
    expect(find.text('Comenzar sesión'), findsOneWidget);
  });

  testWidgets('storage failure redirects to recovery instead of onboarding', (
    tester,
  ) async {
    final authRepository = InMemoryAuthRepository(
      seedAccounts: const {'student@focusly.dev': 'password123'},
    );
    await authRepository.signIn(
      email: 'student@focusly.dev',
      password: 'password123',
    );
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          onboardingRepositoryProvider.overrideWithValue(
            const _FailingOnboardingRepository(),
          ),
        ],
        child: const FocuslyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Te damos la bienvenida'), findsNothing);
    expect(find.text('Reintentar'), findsOneWidget);
    expect(
      find.text('No pudimos acceder a la configuración guardada.'),
      findsOneWidget,
    );
  });
}

final class _FailingOnboardingRepository implements OnboardingRepository {
  const _FailingOnboardingRepository();

  @override
  Future<bool> isCompleted(String userId) =>
      Future.error(OnboardingFailure.storage());

  @override
  Future<StudentProfile?> getProfile(String userId) async => null;

  @override
  Future<StudyCompanion?> getCompanion(String userId) async => null;

  @override
  Future<void> saveOnboarding({
    required StudentProfile profile,
    required StudyCompanion companion,
  }) async {}

  @override
  Future<void> clear(String userId) async {}
}
