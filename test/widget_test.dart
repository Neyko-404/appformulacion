import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/app/app.dart';
import 'package:focusly/app/router/app_router.dart';
import 'package:focusly/app/theme/theme_mode_provider.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/authentication/presentation/providers/auth_providers.dart';

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

  testWidgets('verified session redirects to authenticated placeholder', (
    tester,
  ) async {
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

    expect(
      find.text('Autenticación completada. Onboarding pendiente.'),
      findsOneWidget,
    );
  });
}
