import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/authentication/data/repositories/in_memory_auth_repository.dart';
import 'package:focusly/features/authentication/domain/entities/auth_failure.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';

void main() {
  late InMemoryAuthRepository repository;

  setUp(() {
    repository = InMemoryAuthRepository(
      seedAccounts: const {'demo@focusly.dev': 'focusly-demo'},
    );
  });

  tearDown(() {
    repository.dispose();
  });

  test('starts unauthenticated', () async {
    expect(await repository.getCurrentUser(), isNull);
  });

  test('does not create a demo account automatically', () async {
    final emptyRepository = InMemoryAuthRepository();
    addTearDown(emptyRepository.dispose);

    await expectLater(
      emptyRepository.signIn(
        email: 'demo@focusly.dev',
        password: 'focusly-demo',
      ),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.code,
          'code',
          AuthFailureCode.invalidCredentials,
        ),
      ),
    );
  });

  test('registers a valid account and starts a session', () async {
    final user = await repository.signUp(
      email: 'new@focusly.dev',
      password: 'password123',
    );

    expect(user.email, 'new@focusly.dev');
    expect(await repository.getCurrentUser(), user);
  });

  test('rejects a duplicated email with a safe failure', () async {
    await repository.signUp(email: 'new@focusly.dev', password: 'password123');

    await expectLater(
      repository.signUp(email: 'NEW@focusly.dev', password: 'another-password'),
      throwsA(
        isA<AuthFailure>().having(
          (failure) => failure.code,
          'code',
          AuthFailureCode.emailAlreadyInUse,
        ),
      ),
    );
  });

  test('signs in with valid credentials', () async {
    final user = await repository.signIn(
      email: 'demo@focusly.dev',
      password: 'focusly-demo',
    );

    expect(user.email, 'demo@focusly.dev');
  });

  test('rejects invalid credentials without technical details', () async {
    await expectLater(
      repository.signIn(
        email: 'demo@focusly.dev',
        password: 'incorrect-password',
      ),
      throwsA(
        isA<AuthFailure>()
            .having(
              (failure) => failure.code,
              'code',
              AuthFailureCode.invalidCredentials,
            )
            .having(
              (failure) => failure.safeMessage,
              'safeMessage',
              'No pudimos iniciar sesión con esos datos.',
            ),
      ),
    );
  });

  test('signs out the current user', () async {
    await repository.signIn(
      email: 'demo@focusly.dev',
      password: 'focusly-demo',
    );

    await repository.signOut();

    expect(await repository.getCurrentUser(), isNull);
  });

  test(
    'session stream emits initial, signed-in and signed-out states',
    () async {
      final events = <AuthUser?>[];
      final initialEvent = Completer<void>();
      final subscription = repository.watchAuthState().listen((user) {
        events.add(user);
        if (!initialEvent.isCompleted) {
          initialEvent.complete();
        }
      });
      addTearDown(subscription.cancel);
      await initialEvent.future;

      await repository.signIn(
        email: 'demo@focusly.dev',
        password: 'focusly-demo',
      );
      await repository.signOut();

      expect(events, [isNull, isA<AuthUser>(), isNull]);
    },
  );

  test('password reset does not reveal whether an account exists', () async {
    await expectLater(
      repository.requestPasswordReset(email: 'demo@focusly.dev'),
      completes,
    );
    await expectLater(
      repository.requestPasswordReset(email: 'unknown@focusly.dev'),
      completes,
    );
  });
}
